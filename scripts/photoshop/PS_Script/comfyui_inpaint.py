"""
ComfyUI + Photoshop 局部重绘脚本 v2.0
在 PS 中选择区域 -> 生成蒙版 -> 发送到 ComfyUI inpainting -> 导回 PS

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

class ComfyUIInpaint:
    """ComfyUI 局部重绘"""
    
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
    
    def export_ps_document_and_mask(self):
        """从 PS 导出当前文档和选区蒙版"""
        if not self.ps_app:
            return None, None
        
        doc = self.ps_app.activeDocument
        temp_dir = os.environ['TEMP']
        image_path = os.path.join(temp_dir, f'ps_image_{uuid.uuid4().hex}.png')
        mask_path = os.path.join(temp_dir, f'ps_mask_{uuid.uuid4().hex}.png')
        
        try:
            # 保存原始文档
            js_save_image = f'''
            var doc = app.activeDocument;
            var file = new File("{image_path.replace(os.sep, '/')}");
            var opts = new PNGSaveOptions();
            opts.compression = 6;
            doc.saveAs(file, opts, true, Extension.LOWERCASE);
            "success";
            '''
            self.ps_app.doJavaScript(js_save_image)
            
            # 从选区创建蒙版（白色=重绘区域，黑色=保留区域）
            js_save_mask = f'''
            var doc = app.activeDocument;
            var maskFile = new File("{mask_path.replace(os.sep, '/')}");
            
            // 检查是否有选区
            try {{
                var bounds = doc.selection.bounds;
                var b0 = bounds[0].value;
                var b1 = bounds[1].value;
                var b2 = bounds[2].value;
                var b3 = bounds[3].value;
                
                // 创建新文档作为蒙版
                var maskDoc = app.documents.add(doc.width, doc.height, doc.resolution, "mask", NewDocumentMode.GRAYSCALE);
                
                // 填充黑色背景
                var black = new SolidColor();
                black.gray.gray = 0;
                maskDoc.selection.selectAll();
                maskDoc.selection.fill(black);
                maskDoc.selection.deselect();
                
                // 用白色填充选区区域
                var white = new SolidColor();
                white.gray.gray = 100;
                
                // 重新创建选区（基于原始选区的边界）
                maskDoc.selection.select([[b0, b1], [b2, b1], [b2, b3], [b0, b3]]);
                maskDoc.selection.fill(white);
                maskDoc.selection.deselect();
                
                // 保存蒙版
                var maskOpts = new PNGSaveOptions();
                maskDoc.saveAs(maskFile, maskOpts, true, Extension.LOWERCASE);
                maskDoc.close(SaveOptions.DONOTSAVECHANGES);
                
                app.activeDocument = doc;
                "success";
            }} catch(e) {{
                "no_selection: " + e.message;
            }}
            '''
            result = self.ps_app.doJavaScript(js_save_mask)
            
            if "no_selection" in str(result):
                print("错误: 请先在 PS 中用选区工具选择要重绘的区域")
                return None, None
            
            # 读取文件
            with open(image_path, 'rb') as f:
                image_data = f.read()
            with open(mask_path, 'rb') as f:
                mask_data = f.read()
            
            return image_data, mask_data
            
        except Exception as e:
            print(f"导出失败: {e}")
            return None, None
        finally:
            # 清理临时文件
            for path in [image_path, mask_path]:
                if os.path.exists(path):
                    try:
                        os.remove(path)
                    except:
                        pass
    
    def export_mask_from_layer(self, mask_layer_name=None):
        """从指定图层导出蒙版（可选方式）"""
        if not self.ps_app:
            return None, None
        
        doc = self.ps_app.activeDocument
        temp_dir = os.environ['TEMP']
        image_path = os.path.join(temp_dir, f'ps_image_{uuid.uuid4().hex}.png')
        mask_path = os.path.join(temp_dir, f'ps_mask_{uuid.uuid4().hex}.png')
        
        try:
            # 如果指定了蒙版图层名称
            if mask_layer_name:
                js_code = f'''
                var doc = app.activeDocument;
                var imageFile = new File("{image_path.replace(os.sep, '/')}");
                var maskFile = new File("{mask_path.replace(os.sep, '/')}");
                
                // 保存当前状态
                var originalLayer = doc.activeLayer;
                
                // 隐藏蒙版图层，保存图片
                var maskLayer = null;
                for (var i = 0; i < doc.layers.length; i++) {{
                    if (doc.layers[i].name == "{mask_layer_name}") {{
                        maskLayer = doc.layers[i];
                        break;
                    }}
                }}
                
                if (maskLayer) {{
                    var wasVisible = maskLayer.visible;
                    maskLayer.visible = false;
                    
                    // 保存图片（不含蒙版图层）
                    var opts = new PNGSaveOptions();
                    doc.saveAs(imageFile, opts, true, Extension.LOWERCASE);
                    
                    // 只显示蒙版图层，保存蒙版
                    for (var i = 0; i < doc.layers.length; i++) {{
                        doc.layers[i].visible = (doc.layers[i] == maskLayer);
                    }}
                    doc.saveAs(maskFile, opts, true, Extension.LOWERCASE);
                    
                    // 恢复图层可见性
                    maskLayer.visible = wasVisible;
                    for (var i = 0; i < doc.layers.length; i++) {{
                        doc.layers[i].visible = true;
                    }}
                    
                    doc.activeLayer = originalLayer;
                    "success";
                }} else {{
                    "layer_not_found";
                }}
                '''
                result = self.ps_app.doJavaScript(js_code)
                
                if "layer_not_found" in str(result):
                    print(f"错误: 找不到图层 '{mask_layer_name}'")
                    return None, None
            
            # 读取文件
            with open(image_path, 'rb') as f:
                image_data = f.read()
            with open(mask_path, 'rb') as f:
                mask_data = f.read()
            
            return image_data, mask_data
            
        except Exception as e:
            print(f"导出失败: {e}")
            return None, None
        finally:
            for path in [image_path, mask_path]:
                if os.path.exists(path):
                    try:
                        os.remove(path)
                    except:
                        pass
    
    def upload_image(self, image_data, filename):
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
        except:
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
    
    def import_to_ps_as_layer(self, image_data, layer_name="AI Inpaint"):
        """将图片作为新图层导入 PS"""
        if not self.ps_app:
            return False
        
        temp_path = os.path.join(os.environ['TEMP'], f'comfy_inpaint_{uuid.uuid4().hex}.png')
        
        try:
            with open(temp_path, 'wb') as f:
                f.write(image_data)
            
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
            self.ps_app.doJavaScript(js_code)
            
            os.remove(temp_path)
            print(f"✓ 已导入为新图层: {layer_name}")
            return True
            
        except Exception as e:
            print(f"导入 PS 失败: {e}")
            if os.path.exists(temp_path):
                os.remove(temp_path)
            return False
    
    def build_inpaint_workflow(self, image_name, mask_name, prompt, denoise=None, model=None):
        """构建 Inpainting 工作流"""
        gen = self.settings["generation"]
        inpaint = self.settings["inpaint"]
        
        denoise = denoise if denoise is not None else inpaint["denoise"]
        model = model or self.settings["models"]["default"]
        negative = self.settings["negative_prompt"]
        grow_mask = inpaint["grow_mask_by"]
        
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
                "class_type": "LoadImage",
                "inputs": {"image": mask_name, "upload": "image"}
            },
            "11": {
                "class_type": "ImageToMask",
                "inputs": {
                    "image": ["3", 0],
                    "channel": "red"
                }
            },
            "4": {
                "class_type": "VAEEncodeForInpaint",
                "inputs": {
                    "pixels": ["2", 0],
                    "vae": ["1", 2],
                    "mask": ["11", 0],
                    "grow_mask_by": grow_mask
                }
            },
            "6": {
                "class_type": "CLIPTextEncode",
                "inputs": {
                    "text": prompt,
                    "clip": ["1", 1]
                }
            },
            "7": {
                "class_type": "CLIPTextEncode",
                "inputs": {
                    "text": negative,
                    "clip": ["1", 1]
                }
            },
            "8": {
                "class_type": "KSampler",
                "inputs": {
                    "seed": int(time.time() * 1000) % (2**32),
                    "steps": gen["steps"],
                    "cfg": gen["cfg"],
                    "sampler_name": gen["sampler"],
                    "scheduler": gen["scheduler"],
                    "denoise": denoise,
                    "model": ["1", 0],
                    "positive": ["6", 0],
                    "negative": ["7", 0],
                    "latent_image": ["4", 0]
                }
            },
            "9": {
                "class_type": "VAEDecode",
                "inputs": {
                    "samples": ["8", 0],
                    "vae": ["1", 2]
                }
            },
            "10": {
                "class_type": "SaveImage",
                "inputs": {
                    "filename_prefix": "PS_Inpaint",
                    "images": ["9", 0]
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
                print()
                
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
    
    def inpaint(self, prompt, denoise=None, model=None, import_to_ps=True):
        """执行局部重绘"""
        if not self.ensure_connection():
            return None
        
        print("📷 从 PS 获取图片和选区...")
        image_data, mask_data = self.export_ps_document_and_mask()
        if image_data is None:
            return None
        
        print("⬆️ 上传图片...")
        image_name = self.upload_image(image_data, f"inpaint_image_{uuid.uuid4().hex[:8]}.png")
        mask_name = self.upload_image(mask_data, f"inpaint_mask_{uuid.uuid4().hex[:8]}.png")
        
        if not image_name or not mask_name:
            return None
        
        print(f"📝 提示词: {prompt}")
        print(f"🎨 重绘强度: {denoise or self.settings['inpaint']['denoise']}")
        
        workflow = self.build_inpaint_workflow(image_name, mask_name, prompt, denoise, model)
        result = self.queue_prompt(workflow)
        
        if not result or 'prompt_id' not in result:
            print("提交失败")
            return None
        
        prompt_id = result['prompt_id']
        print(f"🚀 任务已提交: {prompt_id[:8]}...")
        
        output_data = self.wait_and_get_result(prompt_id)
        
        if output_data and import_to_ps:
            layer_name = f"Inpaint - {prompt[:20]}..." if len(prompt) > 20 else f"Inpaint - {prompt}"
            self.import_to_ps_as_layer(output_data, layer_name)
        
        return output_data
    
    def inpaint_from_layer(self, prompt, mask_layer_name, denoise=None, model=None, import_to_ps=True):
        """使用指定图层作为蒙版进行局部重绘"""
        if not self.ensure_connection():
            return None
        
        print(f"📷 从 PS 获取图片，使用图层 '{mask_layer_name}' 作为蒙版...")
        image_data, mask_data = self.export_mask_from_layer(mask_layer_name)
        if image_data is None:
            return None
        
        print("⬆️ 上传图片...")
        image_name = self.upload_image(image_data, f"inpaint_image_{uuid.uuid4().hex[:8]}.png")
        mask_name = self.upload_image(mask_data, f"inpaint_mask_{uuid.uuid4().hex[:8]}.png")
        
        if not image_name or not mask_name:
            return None
        
        print(f"📝 提示词: {prompt}")
        
        workflow = self.build_inpaint_workflow(image_name, mask_name, prompt, denoise, model)
        result = self.queue_prompt(workflow)
        
        if not result or 'prompt_id' not in result:
            print("提交失败")
            return None
        
        prompt_id = result['prompt_id']
        print(f"🚀 任务已提交: {prompt_id[:8]}...")
        
        output_data = self.wait_and_get_result(prompt_id)
        
        if output_data and import_to_ps:
            layer_name = f"Inpaint - {prompt[:20]}..."
            self.import_to_ps_as_layer(output_data, layer_name)
        
        return output_data


def main():
    """主函数"""
    inpainter = ComfyUIInpaint()
    
    if len(sys.argv) < 2:
        print("=" * 50)
        print("ComfyUI + Photoshop 局部重绘脚本 v2.0")
        print("=" * 50)
        print()
        print("用法:")
        print("  python comfyui_inpaint.py <提示词> [重绘强度]")
        print("  python comfyui_inpaint.py --layer <图层名> <提示词>")
        print("  python comfyui_inpaint.py status  # 检查连接状态")
        print()
        print("使用选区方式:")
        print("  1. 在 PS 中用选区工具（矩形、套索等）选择要重绘的区域")
        print("  2. 运行: python comfyui_inpaint.py \"a beautiful flower\"")
        print()
        print("使用图层蒙版方式:")
        print("  1. 在 PS 中创建一个图层，用白色绘制要重绘的区域")
        print("  2. 运行: python comfyui_inpaint.py --layer \"蒙版图层\" \"提示词\"")
        print()
        print("示例:")
        print("  python comfyui_inpaint.py \"a red rose\" 0.8")
        print("  python comfyui_inpaint.py --layer \"Mask\" \"blue sky\"")
        return
    
    if sys.argv[1].lower() == "status":
        connected, info = inpainter.connection.check_connection()
        if connected:
            print(f"✓ ComfyUI 已连接: {inpainter.url}")
        else:
            print(f"✗ {info}")
        return
    
    if sys.argv[1] == "--layer":
        if len(sys.argv) < 4:
            print("请提供图层名和提示词")
            return
        mask_layer = sys.argv[2]
        prompt = sys.argv[3]
        denoise = float(sys.argv[4]) if len(sys.argv) > 4 else None
        inpainter.inpaint_from_layer(prompt, mask_layer, denoise)
    else:
        prompt = sys.argv[1]
        denoise = float(sys.argv[2]) if len(sys.argv) > 2 else None
        inpainter.inpaint(prompt, denoise)


if __name__ == "__main__":
    main()
