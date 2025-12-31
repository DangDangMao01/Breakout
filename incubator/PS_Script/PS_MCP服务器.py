"""
Photoshop MCP Server
通过 photoshop-python-api 连接 Photoshop
"""
import json
import sys
from typing import Any

try:
    import photoshop.api as ps
except ImportError:
    print("请先安装: pip install photoshop-python-api", file=sys.stderr)
    sys.exit(1)

def get_app():
    """获取 Photoshop 应用实例"""
    try:
        return ps.Application()
    except Exception as e:
        return None

def get_document_info():
    """获取当前文档信息"""
    app = get_app()
    if not app:
        return {"error": "无法连接 Photoshop，请确保 PS 已打开"}
    
    try:
        doc = app.activeDocument
        return {
            "name": doc.name,
            "width": doc.width,
            "height": doc.height,
            "resolution": doc.resolution,
            "mode": str(doc.mode),
            "layers_count": len(doc.layers)
        }
    except Exception as e:
        return {"error": f"没有打开的文档: {str(e)}"}

def list_layers():
    """列出所有图层"""
    app = get_app()
    if not app:
        return {"error": "无法连接 Photoshop"}
    
    try:
        doc = app.activeDocument
        layers = []
        for layer in doc.layers:
            layers.append({
                "name": layer.name,
                "visible": layer.visible,
                "opacity": layer.opacity
            })
        return {"layers": layers}
    except Exception as e:
        return {"error": str(e)}

def create_layer(name="New Layer"):
    """创建新图层"""
    app = get_app()
    if not app:
        return {"error": "无法连接 Photoshop"}
    
    try:
        doc = app.activeDocument
        new_layer = doc.artLayers.add()
        new_layer.name = name
        return {"success": True, "layer_name": name}
    except Exception as e:
        return {"error": str(e)}

def execute_action(action_code):
    """执行 ExtendScript 代码"""
    app = get_app()
    if not app:
        return {"error": "无法连接 Photoshop"}
    
    try:
        result = app.doJavaScript(action_code)
        return {"success": True, "result": str(result)}
    except Exception as e:
        return {"error": str(e)}

# MCP 协议处理
def handle_request(request):
    method = request.get("method", "")
    params = request.get("params", {})
    
    if method == "tools/list":
        return {
            "tools": [
                {"name": "get_document_info", "description": "获取当前文档信息"},
                {"name": "list_layers", "description": "列出所有图层"},
                {"name": "create_layer", "description": "创建新图层"},
                {"name": "execute_script", "description": "执行 ExtendScript 代码"}
            ]
        }
    elif method == "tools/call":
        tool_name = params.get("name", "")
        args = params.get("arguments", {})
        
        if tool_name == "get_document_info":
            return get_document_info()
        elif tool_name == "list_layers":
            return list_layers()
        elif tool_name == "create_layer":
            return create_layer(args.get("name", "New Layer"))
        elif tool_name == "execute_script":
            return execute_action(args.get("code", ""))
    
    return {"error": "Unknown method"}

def main():
    """主循环 - 读取 stdin，输出到 stdout"""
    while True:
        try:
            line = sys.stdin.readline()
            if not line:
                break
            
            request = json.loads(line)
            response = handle_request(request)
            
            print(json.dumps(response), flush=True)
        except json.JSONDecodeError:
            continue
        except Exception as e:
            print(json.dumps({"error": str(e)}), flush=True)

if __name__ == "__main__":
    # 测试模式
    if len(sys.argv) > 1 and sys.argv[1] == "test":
        print("测试 Photoshop 连接...")
        result = get_document_info()
        print(json.dumps(result, indent=2, ensure_ascii=False))
    else:
        main()
