"""
ComfyUI + Photoshop 联动脚本
从 PS 获取图片 -> 发送到 ComfyUI 生成 -> 导入回 PS
"""
import json
import urllib.request
import urllib.parse
import base64
import io
import os
import time
import uuid

COMFYUI_URL = "http://127.0.0.1:8188"

def get_ps_active_layer_image():
    """从 PS 获取当前图层图片"""
    import photoshop.api as ps
    app = ps.Application()
    doc = app.activeDocument
    
    # 保存临时文件
    temp_path = os.path.join(os.environ['TEMP'], f'ps_temp_{uuid.uuid4().hex}.png')
    
    # 导出当前文档为 PNG
    options = ps.PNGSaveOptions()
    doc.saveAs(temp_path, options, True)
    
    with open(temp_path, 'rb') as f:
        image_data = f.read()
    
    os.remove(temp_path)
    return image_data

def upload_image_to_comfyui(image_data, filename="input.png"):
    """上传图片到 ComfyUI"""
    boundary = '----WebKitFormBoundary' + uuid.uuid4().hex
    
    body = (
        f'--{boundary}\r\n'
        f'Content-Disposition: form-data; name="image"; filename="{filename}"\r\n'
        f'Content-Type: image/png\r\n\r\n'
    ).encode() + image_data + f'\r\n--{boundary}--\r\n'.encode()
    
    req = urllib.request.Request(
        f'{COMFYUI_URL}/upload/image',
        data=body,
        headers={'Content-Type': f'multipart/form-data; boundary={boundary}'}
    )
    
    response = urllib.request.urlopen(req)
    result = json.loads(response.read().decode())
    return result.get('name', filename)

def queue_prompt(workflow):
    """提交工作流到 ComfyUI"""
    data = json.dumps({"prompt": workflow}).encode()
    req = urllib.request.Request(
        f'{COMFYUI_URL}/prompt',
        data=data,
        headers={'Content-Type': 'application/json'}
    )
    response = urllib.request.urlopen(req)
    return json.loads(response.read().decode())

def get_history(prompt_id):
    """获取生成历史"""
    req = urllib.request.Request(f'{COMFYUI_URL}/history/{prompt_id}')
    response = urllib.request.urlopen(req)
    return json.loads(response.read().decode())

def get_image(filename, subfolder="", folder_type="output"):
    """从 ComfyUI 获取生成的图片"""
    params = urllib.parse.urlencode({
        "filename": filename,
        "subfolder": subfolder,
        "type": folder_type
    })
    req = urllib.request.Request(f'{COMFYUI_URL}/view?{params}')
    response = urllib.request.urlopen(req)
    return response.read()

def import_image_to_ps(image_data):
    """将图片导入到 PS 作为新图层"""
    import photoshop.api as ps
    
    # 保存临时文件
    temp_path = os.path.join(os.environ['TEMP'], f'comfy_output_{uuid.uuid4().hex}.png')
    with open(temp_path, 'wb') as f:
        f.write(image_data)
    
    app = ps.Application()
    
    # 打开生成的图片
    desc = ps.ActionDescriptor()
    desc.putPath(app.charIDToTypeID("null"), temp_path)
    app.executeAction(app.charIDToTypeID("Opn "), desc)
    
    # 复制到原文档
    # ... 或者直接作为新文档打开
    
    print(f"图片已导入: {temp_path}")
    return temp_path

def simple_txt2img(prompt, width=512, height=512):
    """简单的文生图工作流"""
    workflow = {
        "3": {
            "class_type": "KSampler",
            "inputs": {
                "seed": int(time.time()),
                "steps": 20,
                "cfg": 7,
                "sampler_name": "euler",
                "scheduler": "normal",
                "denoise": 1,
                "model": ["4", 0],
                "positive": ["6", 0],
                "negative": ["7", 0],
                "latent_image": ["5", 0]
            }
        },
        "4": {
            "class_type": "CheckpointLoaderSimple",
            "inputs": {
                "ckpt_name": "全能 dreamshaper_8.safetensors"
            }
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
                "text": "bad quality, blurry",
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
                "filename_prefix": "ComfyUI",
                "images": ["8", 0]
            }
        }
    }
    return workflow

def generate_and_import(prompt, width=512, height=512):
    """生成图片并导入 PS"""
    print(f"正在生成: {prompt}")
    
    # 提交工作流
    workflow = simple_txt2img(prompt, width, height)
    result = queue_prompt(workflow)
    prompt_id = result['prompt_id']
    print(f"任务已提交: {prompt_id}")
    
    # 等待完成
    while True:
        history = get_history(prompt_id)
        if prompt_id in history:
            break
        time.sleep(1)
        print("等待生成...")
    
    # 获取输出图片
    outputs = history[prompt_id]['outputs']
    for node_id, output in outputs.items():
        if 'images' in output:
            for img in output['images']:
                image_data = get_image(img['filename'], img.get('subfolder', ''))
                import_image_to_ps(image_data)
                print("生成完成！")
                return

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        prompt = " ".join(sys.argv[1:])
        generate_and_import(prompt)
    else:
        print("用法: python comfyui_ps_bridge.py <提示词>")
        print("示例: python comfyui_ps_bridge.py a beautiful landscape")
