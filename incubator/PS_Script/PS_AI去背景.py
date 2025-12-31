"""
去背景脚本 - 从 PS 获取图片，去除背景，导回 PS
使用 rembg 库
"""
import os
import uuid

def remove_background_from_ps():
    """从 PS 获取当前图层，去除背景，作为新图层导入"""
    try:
        from rembg import remove
    except ImportError:
        print("请先安装 rembg: pip install rembg[gpu]")
        return
    
    import photoshop.api as ps
    from PIL import Image
    import io
    
    app = ps.Application()
    doc = app.activeDocument
    
    temp_dir = os.environ['TEMP']
    input_path = os.path.join(temp_dir, f'ps_input_{uuid.uuid4().hex}.png')
    output_path = os.path.join(temp_dir, f'ps_nobg_{uuid.uuid4().hex}.png')
    
    print("正在从 PS 导出图片...")
    
    # 导出当前文档
    js_export = f'''
    var doc = app.activeDocument;
    var file = new File("{input_path.replace(os.sep, '/')}");
    var opts = new PNGSaveOptions();
    doc.saveAs(file, opts, true, Extension.LOWERCASE);
    "done";
    '''
    app.doJavaScript(js_export)
    
    print("正在去除背景...")
    
    # 读取图片并去背景
    with open(input_path, 'rb') as f:
        input_data = f.read()
    
    output_data = remove(input_data)
    
    # 保存结果
    with open(output_path, 'wb') as f:
        f.write(output_data)
    
    print("正在导入到 PS...")
    
    # 导入回 PS 作为新图层
    js_import = f'''
    var doc = app.activeDocument;
    var file = new File("{output_path.replace(os.sep, '/')}");
    
    // 打开去背景后的图片
    var newDoc = app.open(file);
    newDoc.selection.selectAll();
    newDoc.selection.copy();
    newDoc.close(SaveOptions.DONOTSAVECHANGES);
    
    // 粘贴到原文档
    app.activeDocument = doc;
    var newLayer = doc.paste();
    newLayer.name = "去背景结果";
    
    "done";
    '''
    app.doJavaScript(js_import)
    
    # 清理临时文件
    os.remove(input_path)
    os.remove(output_path)
    
    print("去背景完成！已添加为新图层")

if __name__ == "__main__":
    remove_background_from_ps()
