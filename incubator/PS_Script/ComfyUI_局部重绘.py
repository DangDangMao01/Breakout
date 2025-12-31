"""
ComfyUI + Photoshop 局部重绘脚本
在 PS 中选择区域 -> 生成蒙版 -> 发送到 ComfyUI inpainting -> 导回 PS
"""
import json
import urllib.request
import urllib.parse
import os
import time
import uuid

COMFYUI_URL = "http://127.0.0.1:8188"

def export_ps_document_and_mask():
    """从 PS 导出当前文档和选区蒙版"""
    import photoshop.api as ps
    app = ps.Application()
    doc = app.activeDocument
    
    temp_dir = os.environ['TEMP']
    image_path = os.path.join(temp_dir, f'ps_image_{uuid.uuid4().hex}.png')
    mask_path = os.path.join(temp_dir, f'ps_mask_{uuid.uuid4().hex}.png')
    
    # 保存原始文档
    js_save_image = f'''
    var doc = app.activeDocument;
    var file = new File("{image_path.replace(os.sep, '/')}");
    var opts = new PNGSaveOptions();
    opts.compression = 6;
    doc.saveAs(file, opts, true, Extension.LOWERCASE);
    '''
    app.doJavaScript(js_save_image)
    
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
    result = app.doJavaScript(js_save_mask)
    
    if "no_selection" in str(result):
        print("错误：请先在 PS 中用选区工具选择要重绘的区域")
        return None, None
    
    # 读取文件
    with open(image_path, 'rb') as f:
        image_data = f.read()
    with open(mask_path, 'rb') as f:
        mask_data = f.read()
    
    # 清理临时文件
    os.remove(image_path)
    os.remove(mask_path)
    
    return image_data, mask_data

def upload_image(image_data, filename):
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
    """提交工作流"""
    data = json.dumps({"prompt": workflow}).encode()
    req = urllib.request.Request(
        f'{COMFYUI_URL}/prompt',
        data=data,
        headers={'Content-Type': 'application/json'}
    )
    try:
        response = urllib.request.urlopen(req)
        return json.loads(response.read().decode())
    except urllib.error.HTTPError as e:
        error_body = e.read().decode()
        print(f"ComfyUI 错误: {error_body}")
        raise

def get_history(prompt_id):
    """获取历史"""
    req = urllib.request.Request(f'{COMFYUI_URL}/history/{prompt_id}')
    response = urllib.request.urlopen(req)
    return json.loads(response.read().decode())

def get_image(filename, subfolder="", folder_type="output"):
    """获取图片"""
    params = urllib.parse.urlencode({
        "filename": filename,
        "subfolder": subfolder,
        "type": folder_type
    })
    req = urllib.request.Request(f'{COMFYUI_URL}/view?{params}')
    response = urllib.request.urlopen(req)
    return response.read()

def import_to_ps_as_layer(image_data, layer_name="AI Inpaint"):
    """将图片作为新图层导入 PS"""
    import photoshop.api as ps
    
    temp_path = os.path.join(os.environ['TEMP'], f'comfy_inpaint_{uuid.uuid4().hex}.png')
    with open(temp_path, 'wb') as f:
        f.write(image_data)
    
    app = ps.Application()
    doc = app.activeDocument
    
    # 使用 ExtendScript 将图片作为新图层放入
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
    
    "done";
    '''
    app.doJavaScript(js_code)
    
    os.remove(temp_path)
    print(f"已导入为新图层: {layer_name}")

def inpaint_workflow(image_name, mask_name, prompt, denoise=0.85):
    """Inpainting 工作流 - 使用 VAEEncodeForInpaint"""
    workflow = {
        "1": {
            "class_type": "CheckpointLoaderSimple",
            "inputs": {
                "ckpt_name": "全能 dreamshaper_8.safetensors"
            }
        },
        "2": {
            "class_type": "LoadImage",
            "inputs": {
                "image": image_name,
                "upload": "image"
            }
        },
        "3": {
            "class_type": "LoadImage",
            "inputs": {
                "image": mask_name,
                "upload": "image"
            }
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
                "grow_mask_by": 6
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
                "text": "bad quality, blurry, ugly, deformed, worst quality",
                "clip": ["1", 1]
            }
        },
        "8": {
            "class_type": "KSampler",
            "inputs": {
                "seed": int(time.time()),
                "steps": 25,
                "cfg": 7,
                "sampler_name": "euler_ancestral",
                "scheduler": "normal",
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
                "filename_prefix": "Inpaint",
                "images": ["9", 0]
            }
        }
    }
    return workflow

def inpaint(prompt, denoise=0.8):
    """执行局部重绘"""
    print("正在从 PS 获取图片和选区...")
    
    # 获取图片和蒙版
    image_data, mask_data = export_ps_document_and_mask()
    if image_data is None:
        return
    
    print("上传图片到 ComfyUI...")
    image_name = upload_image(image_data, "inpaint_image.png")
    mask_name = upload_image(mask_data, "inpaint_mask.png")
    
    print(f"开始重绘: {prompt}")
    workflow = inpaint_workflow(image_name, mask_name, prompt, denoise)
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
    
    # 获取结果
    outputs = history[prompt_id]['outputs']
    for node_id, output in outputs.items():
        if 'images' in output:
            for img in output['images']:
                image_data = get_image(img['filename'], img.get('subfolder', ''))
                import_to_ps_as_layer(image_data, f"Inpaint - {prompt[:20]}")
                print("局部重绘完成！")
                return

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        prompt = " ".join(sys.argv[1:])
        inpaint(prompt)
    else:
        print("局部重绘使用方法:")
        print("1. 在 PS 中用选区工具（矩形、套索等）选择要重绘的区域")
        print("2. 运行: python comfyui_inpaint.py <提示词>")
        print("")
        print("示例: python comfyui_inpaint.py a beautiful flower")
