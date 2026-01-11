"""
测试 Ollama 连接
快速验证 Ollama 是否正常工作
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from core.llm_client import OllamaClient
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def main():
    """主函数"""
    print("=" * 60)
    print("Ollama 连接测试")
    print("=" * 60)
    
    # 1. 创建客户端
    print("\n[1] 创建 Ollama 客户端...")
    client = OllamaClient(
        host="http://localhost:11434",
        model="qwen2.5:32b"
    )
    print("✅ 客户端创建成功")
    
    # 2. 检查连接
    print("\n[2] 检查 Ollama 服务...")
    if client.check_connection():
        print("✅ Ollama 服务运行正常")
    else:
        print("❌ 无法连接到 Ollama 服务")
        print("\n请检查：")
        print("  1. Ollama 是否已安装")
        print("  2. Ollama 服务是否启动 (运行: ollama serve)")
        print("  3. 端口 11434 是否被占用")
        return
    
    # 3. 列出模型
    print("\n[3] 列出可用模型...")
    models = client.list_models()
    
    if models:
        print(f"✅ 找到 {len(models)} 个模型:")
        for model in models:
            print(f"  - {model}")
    else:
        print("❌ 未找到任何模型")
        print("\n请下载模型：")
        print("  ollama pull qwen2.5:32b")
        print("  或")
        print("  ollama pull llama3.1:70b")
        return
    
    # 4. 测试对话
    print("\n[4] 测试对话功能...")
    test_prompt = "你好，请用一句话介绍你自己。"
    print(f"提示: {test_prompt}")
    
    try:
        response = client.chat(test_prompt, temperature=0.7)
        print(f"✅ 回复: {response}")
    except Exception as e:
        print(f"❌ 对话失败: {e}")
        return
    
    # 5. 测试流式输出
    print("\n[5] 测试流式输出...")
    test_prompt = "从1数到5"
    print(f"提示: {test_prompt}")
    print("回复: ", end="", flush=True)
    
    try:
        for chunk in client.chat(test_prompt, stream=True):
            print(chunk, end="", flush=True)
        print()
        print("✅ 流式输出正常")
    except Exception as e:
        print(f"\n❌ 流式输出失败: {e}")
        return
    
    # 6. 总结
    print("\n" + "=" * 60)
    print("✅ 所有测试通过！Ollama 工作正常")
    print("=" * 60)
    print("\n下一步：")
    print("  1. 运行记忆系统示例: python examples/memory_example.py")
    print("  2. 运行 Blender 智能体示例: python examples/blender_example.py")


if __name__ == "__main__":
    main()
