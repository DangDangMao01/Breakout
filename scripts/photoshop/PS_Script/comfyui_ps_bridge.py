"""
ComfyUI + Photoshop 联动脚本 v2.0
从 PS 获取图片 -> 发送到 ComfyUI 生成 -> 导入回 PS

改进功能:
- 配置文件支持
- 错误处理和连接检测
- 进度反馈
- 多模型支持
- 更好的 PS 图层导入
"""
import json
import urllib.request
import urllib.parse
import urllib.error
import os
import time
import uuid
import sys

from comfyui_utils import (
    ComfyUIConnection, 
    ProgressTracker, 
    load_settings, 
    print_progress_bar
)

class ComfyUIBridge:
    """ComfyUI 桥接器"""
    
    def __init__(self):
        self.settings = load_settings()
        self.url = self.settings["comfyui"]["url"]
        self.connection = ComfyUIConnection(self.url)
        self._ps_app = None
    
    def ensure_connection(self):
        """确保 ComfyUI 已连接"""
        connected, info = self.connection.check_connection()
        if not connected:
            print(f"错误: {info}")
            print("请确保 ComfyUI 已启动")
            return False
        return True
    
    @property
    def ps_app(self):
        """获取 PS 应用实例"""
        if self._ps_app is None:
            try:
                import photoshop.api as ps
                self._ps_app = ps.Application()
            except ImportError:
                print("错误: 未安装 photoshop-python-api")
                print("请运行: pip install photoshop-python-api")
                return None
            except Exception as e:
                print(f"错误: 无法连接到 Photoshop - {e}")
                return None
        return self._ps_app
    
    def get_ps_document_image(self):
        """从 PS 获取当前文档图片"""
        if not self.ps_app:
            return None
            
        doc = self.ps_app.activeDocument
        temp_path = os.path.join(os.environ['TEMP'], f'ps_temp_{uuid.uuid4().hex}.png')
        
        try:
            # 使用 ExtendScript 导出
            js_code = f'''
            var doc = app.activeDocument;
            var file = new File("{temp_path.replace(os.sep, '/')}");
            var opts = new PNGSaveOptions();
            opts.compression = 6;
            doc.saveAs(file, opts, true, Extension.LOWERCASE);
            "success";
            '''
            self.ps_app.doJavaScript(js_code)
            
            with open(temp_path, 'rb') as f:
                image_data = f.read()
            
            os.remove(temp_path)
            return image_data
            
        except Exception as e:
            print(f"导出 PS 文档失败: {e}")
            if os.path.exists(temp_path):
                os.remove(temp_path)
            return None
    
    def upload_image(self, image_data, filename="input.png"):
        """上传图片到 ComfyUI"""
        boundary = '----WebKitFormBoundary' + uuid.uuid4().hex
        
        body = (
            f'--{boundary}\r\n'
            f'Content-Disposition: form-data; name="image"; filename="{filename}"\r\n'
            f'Content-Type: image/png\r\n\r\n'
        ).encode() + image_data + f'\r\n--{boundary}--\r\n'.encode()
        
        try:
            req = urllib.request.Request(
                f'{self.url}/upload/image',
                data=body,
                headers={'Content-Type': f'multipart/form-data; boundary={boundary}'}
            )
            response = urllib.request.urlopen(req, timeout=30)
            result = json.loads(response.read().decode())
            return result.get('name', filename)
        except Exception as e:
            print(f"上传图片失败: {e}")
            return None
    
    def queue_prompt(self, workflow):
        """提交工作流"""
        data = json.dumps({"prompt": workflow}).encode()
        
        try:
            req = urllib.request.Request(
                f'{self.url}/prompt',
                data=data,
                headers={'Content-Type': 'application/json'}
            )
            response = urllib.request.urlopen(req, timeout=30)
            return json.loads(response.read().decode())
        except urllib.error.HTTPError as e:
            error_body = e.read().decode()
            print(f"ComfyUI 错误: {error_body}")
            return None
        except Exception as e:
            print(f"提交工作流失败: {e}")
            return None
    
    def get_history(self, prompt_id):
        """获取历史"""
        try:
            req = urllib.request.Request(f'{self.url}/history/{prompt_id}')
            response = urllib.request.urlopen(req, timeout=10)
            return json.loads(response.read().decode())
        except Exception as e:
            return {}
    
    def get_image(self, filename, subfolder="", folder_type="output"):
        """获取图片"""
        params = urllib.parse.urlencode({
            "filename": filename,
            "subfolder": subfolder,
            "type": folder_type
        })
        try:
            req = urllib.request.Request(f'{self.url}/view?{params}')
            response = urllib.request.urlopen(req, timeout=30)
            return response.read()
        except Exception as e:
            print(f"获取图片失败: {e}")
            return None
    
    def import_to_ps_as_layer(self, image_data, layer_name="AI Generated"):
        """将图片作为新图层导入 PS"""
        if not self.ps_app:
            return False
        
        temp_path = os.path.join(os.environ['TEMP'], f'comfy_output_{uuid.uuid4().hex}.png')
        
        try:
            with open(temp_path, 'wb') as f:
                f.write(image_data)
            
            doc = self.ps_app.activeDocument
            
            # 使用 ExtendScript 导入为新图层
            js_code = f'''
            var doc = app.activeDocument;
            var file = new File("{temp_path.replace(os.sep, '/')}");
            
            // 打开生成的图片
            var newDoc = app.open(file);
            newDoc.selection.selectAll();
            newDoc.selection.copy();
            newDoc.close(SaveOptions.DONOTSAVECHANGES);
            
            // 粘贴到原文档
            app.activeDocument = doc;
            var newLayer = doc.paste();
            newLayer.name = "{layer_name}";
            
            // 移动到顶部
            newLayer.move(doc.layers[0], ElementPlacement.PLACEBEFORE);
            
            "success";
            '''
            result = self.ps_app.doJavaScript(js_code)
            
            os.remove(temp_path)
            print(f"✓ 已导入为新图层: {layer_name}")
            return True
            
        except Exception as e:
            print(f"导入 PS 失败: {e}")
            if os.path.exists(temp_path):
                os.remove(temp_path)
            return False
    
    def build_txt2img_workflow(self, prompt, width=None, height=None, model=None):
        """构建文生图工作流"""
        gen = self.settings["generation"]
        
        width = width or gen["default_width"]
        height = height or gen["default_height"]
        model = model or self.settings["models"]["default"]
        negative = self.settings["negative_prompt"]
        
        workflow = {
            "3": {
                "class_type": "KSampler",
                "inputs": {
                    "seed": int(time.time() * 1000) % (2**32),
                    "steps": gen["steps"],
                    "cfg": gen["cfg"],
                    "sampler_name": gen["sampler"],
                    "scheduler": gen["scheduler"],
                    "denoise": 1,
                    "model": ["4", 0],
                    "positive": ["6", 0],
                    "negative": ["7", 0],
                    "latent_image": ["5", 0]
                }
            },
            "4": {
                "class_type": "CheckpointLoaderSimple",
                "inputs": {"ckpt_name": model}
            },
            "5": {
                "class_type": "EmptyLatentImage",
                "inputs": {
                    "width": width,
                    "height": height,
                    "batch_size": 1
                }
            },
            "6": {
                "class_type": "CLIPTextEncode",
                "inputs": {
                    "text": prompt,
                    "clip": ["4", 1]
                }
            },
            "7": {
                "class_type": "CLIPTextEncode",
                "inputs": {
                    "text": negative,
                    "clip": ["4", 1]
                }
            },
            "8": {
                "class_type": "VAEDecode",
                "inputs": {
                    "samples": ["3", 0],
                    "vae": ["4", 2]
                }
            },
            "9": {
                "class_type": "SaveImage",
                "inputs": {
                    "filename_prefix": "PS_Bridge",
                    "images": ["8", 0]
                }
            }
        }
        return workflow
    
    def build_img2img_workflow(self, image_name, prompt, denoise=0.75, model=None):
        """构建图生图工作流"""
        gen = self.settings["generation"]
        model = model or self.settings["models"]["default"]
        negative = self.settings["negative_prompt"]
        
        workflow = {
            "1": {
                "class_type": "CheckpointLoaderSimple",
                "inputs": {"ckpt_name": model}
            },
            "2": {
                "class_type": "LoadImage",
                "inputs": {"image": image_name, "upload": "image"}
            },
            "3": {
                "class_type": "VAEEncode",
                "inputs": {
                    "pixels": ["2", 0],
                    "vae": ["1", 2]
                }
            },
            "4": {
                "class_type": "CLIPTextEncode",
                "inputs": {
                    "text": prompt,
                    "clip": ["1", 1]
                }
            },
            "5": {
                "class_type": "CLIPTextEncode",
                "inputs": {
                    "text": negative,
                    "clip": ["1", 1]
                }
            },
            "6": {
                "class_type": "KSampler",
                "inputs": {
                    "seed": int(time.time() * 1000) % (2**32),
                    "steps": gen["steps"],
                    "cfg": gen["cfg"],
                    "sampler_name": gen["sampler"],
                    "scheduler": gen["scheduler"],
                    "denoise": denoise,
                    "model": ["1", 0],
                    "positive": ["4", 0],
                    "negative": ["5", 0],
                    "latent_image": ["3", 0]
                }
            },
            "7": {
                "class_type": "VAEDecode",
                "inputs": {
                    "samples": ["6", 0],
                    "vae": ["1", 2]
                }
            },
            "8": {
                "class_type": "SaveImage",
                "inputs": {
                    "filename_prefix": "PS_Img2Img",
                    "images": ["7", 0]
                }
            }
        }
        return workflow
    
    def wait_and_get_result(self, prompt_id, timeout=300):
        """等待生成完成并获取结果"""
        tracker = ProgressTracker(self.url, prompt_id)
        tracker.start(callback=lambda p, s, m: print_progress_bar(p, s, m))
        
        start_time = time.time()
        while time.time() - start_time < timeout:
            history = self.get_history(prompt_id)
            if prompt_id in history:
                tracker.stop()
                print()  # 换行
                
                # 获取输出图片
                outputs = history[prompt_id].get('outputs', {})
                for node_id, output in outputs.items():
                    if 'images' in output:
                        for img in output['images']:
                            image_data = self.get_image(
                                img['filename'], 
                                img.get('subfolder', '')
                            )
                            if image_data:
                                return image_data
                return None
            time.sleep(0.5)
        
        tracker.stop()
        print("\n超时: 生成时间过长")
        return None
    
    def txt2img(self, prompt, width=512, height=512, model=None, import_to_ps=True):
        """文生图"""
        if not self.ensure_connection():
            return None
        
        print(f"📝 提示词: {prompt}")
        print(f"📐 尺寸: {width}x{height}")
        
        workflow = self.build_txt2img_workflow(prompt, width, height, model)
        result = self.queue_prompt(workflow)
        
        if not result or 'prompt_id' not in result:
            print("提交失败")
            return None
        
        prompt_id = result['prompt_id']
        print(f"🚀 任务已提交: {prompt_id[:8]}...")
        
        image_data = self.wait_and_get_result(prompt_id)
        
        if image_data and import_to_ps:
            layer_name = f"AI - {prompt[:25]}..." if len(prompt) > 25 else f"AI - {prompt}"
            self.import_to_ps_as_layer(image_data, layer_name)
        
        return image_data
    
    def img2img(self, prompt, denoise=0.75, model=None, import_to_ps=True):
        """图生图 - 使用当前 PS 文档"""
        if not self.ensure_connection():
            return None
        
        print("📷 从 PS 获取图片...")
        image_data = self.get_ps_document_image()
        if not image_data:
            print("无法获取 PS 文档")
            return None
        
        print("⬆️ 上传图片...")
        image_name = self.upload_image(image_data, f"ps_input_{uuid.uuid4().hex[:8]}.png")
        if not image_name:
            return None
        
        print(f"📝 提示词: {prompt}")
        print(f"🎨 重绘强度: {denoise}")
        
        workflow = self.build_img2img_workflow(image_name, prompt, denoise, model)
        result = self.queue_prompt(workflow)
        
        if not result or 'prompt_id' not in result:
            print("提交失败")
            return None
        
        prompt_id = result['prompt_id']
        print(f"🚀 任务已提交: {prompt_id[:8]}...")
        
        output_data = self.wait_and_get_result(prompt_id)
        
        if output_data and import_to_ps:
            layer_name = f"Img2Img - {prompt[:20]}..." if len(prompt) > 20 else f"Img2Img - {prompt}"
            self.import_to_ps_as_layer(output_data, layer_name)
        
        return output_data
    
    def list_models(self):
        """列出可用模型"""
        models = self.connection.get_available_models()
        if models:
            print("可用模型:")
            for i, m in enumerate(models, 1):
                default = " (默认)" if m == self.settings["models"]["default"] else ""
                print(f"  {i}. {m}{default}")
        else:
            print("无法获取模型列表")
        return models


def main():
    """主函数"""
    bridge = ComfyUIBridge()
    
    if len(sys.argv) < 2:
        print("=" * 50)
        print("ComfyUI + Photoshop 联动脚本 v2.0")
        print("=" * 50)
        print()
        print("用法:")
        print("  python comfyui_ps_bridge.py txt2img <提示词> [宽度] [高度]")
        print("  python comfyui_ps_bridge.py img2img <提示词> [重绘强度]")
        print("  python comfyui_ps_bridge.py models  # 列出可用模型")
        print("  python comfyui_ps_bridge.py status  # 检查连接状态")
        print()
        print("示例:")
        print("  python comfyui_ps_bridge.py txt2img \"a beautiful landscape\" 768 512")
        print("  python comfyui_ps_bridge.py img2img \"oil painting style\" 0.6")
        return
    
    command = sys.argv[1].lower()
    
    if command == "status":
        connected, info = bridge.connection.check_connection()
        if connected:
            print(f"✓ ComfyUI 已连接: {bridge.url}")
            queue = bridge.connection.get_queue_status()
            print(f"  队列: {queue.get('running', 0)} 运行中, {queue.get('pending', 0)} 等待中")
        else:
            print(f"✗ {info}")
    
    elif command == "models":
        bridge.list_models()
    
    elif command == "txt2img":
        if len(sys.argv) < 3:
            print("请提供提示词")
            return
        prompt = sys.argv[2]
        width = int(sys.argv[3]) if len(sys.argv) > 3 else 512
        height = int(sys.argv[4]) if len(sys.argv) > 4 else 512
        bridge.txt2img(prompt, width, height)
    
    elif command == "img2img":
        if len(sys.argv) < 3:
            print("请提供提示词")
            return
        prompt = sys.argv[2]
        denoise = float(sys.argv[3]) if len(sys.argv) > 3 else 0.75
        bridge.img2img(prompt, denoise)
    
    else:
        # 兼容旧版: 直接传提示词
        prompt = " ".join(sys.argv[1:])
        bridge.txt2img(prompt)


if __name__ == "__main__":
    main()
