"""
简单的 Ollama 测试脚本
不依赖任何第三方库，只使用 Python 标准库
"""

import json
import urllib.request
import urllib.error


def test_ollama():
    """测试 Ollama 连接"""
    print("=" * 60)
    print("Ollama 简单测试")
    print("=" * 60)
    
    host = "http://localhost:11434"
    
    # 1. 检查服务
    print("\n[1] 检查 Ollama 服务...")
    try:
        response = urllib.request.urlopen(f"{host}/api/tags", timeout=5)
        data = json.loads(response.read().decode())
        print("✅ Ollama 服务运行正常")
        
        # 2. 列出模型
        print("\n[2] 已安装的模型:")
        models = data.get("models", [])
        if models:
            for model in models:
                name = model.get("name", "unknown")
                size = model.get("size", 0) / (1024**3)  # 转换为 GB
                print(f"  - {name} ({size:.1f} GB)")
        else:
            print("  未找到任何模型")
            return
            
        # 3. 测试对话
        print("\n[3] 测试对话功能...")
        model_name = models[0].get("name")
        print(f"使用模型: {model_name}")
        
        # 准备请求
        payload = {
            "model": model_name,
            "messages": [
                {"role": "user", "content": "你好，请用一句话介绍你自己"}
            ],
            "stream": False
        }
        
        req = urllib.request.Request(
            f"{host}/api/chat",
            data=json.dumps(payload).encode(),
            headers={"Content-Type": "application/json"}
        )
        
        print("发送请求...")
        response = urllib.request.urlopen(req, timeout=60)
        result = json.loads(response.read().decode())
        
        reply = result.get("message", {}).get("content", "")
        print(f"\n✅ 回复: {reply}")
        
        # 4. 总结
        print("\n" + "=" * 60)
        print("✅ 所有测试通过！Ollama 工作正常")
        print("=" * 60)
        print("\n下一步:")
        print("  1. 安装完整依赖: pip install -r requirements.txt")
        print("  2. 运行完整示例: python examples/blender_example.py")
        
    except urllib.error.URLError as e:
        print(f"❌ 无法连接到 Ollama 服务")
        print(f"错误: {e}")
        print("\n请检查:")
        print("  1. Ollama 是否已安装")
        print("  2. Ollama 服务是否启动")
        print("  3. 端口 11434 是否被占用")
        
    except Exception as e:
        print(f"❌ 测试失败: {e}")


if __name__ == "__main__":
    test_ollama()
