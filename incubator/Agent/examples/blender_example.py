"""
Blender Agent 使用示例
演示如何使用智能体控制 Blender
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from core.llm_client import OllamaClient
from agents.blender_agent import BlenderAgent
import logging

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)


def main():
    """主函数"""
    print("=" * 60)
    print("Blender Agent 示例")
    print("=" * 60)
    
    # 1. 初始化 LLM 客户端
    print("\n[1] 初始化 Ollama 客户端...")
    llm = OllamaClient(
        host="http://localhost:11434",
        model="qwen2.5:32b"
    )
    
    # 检查连接
    if not llm.check_connection():
        print("❌ 无法连接到 Ollama 服务")
        print("请确保 Ollama 已启动: ollama serve")
        return
    print("✅ Ollama 连接成功")
    
    # 列出可用模型
    models = llm.list_models()
    print(f"可用模型: {', '.join(models) if models else '无'}")
    
    # 2. 创建 Blender 智能体
    print("\n[2] 创建 Blender 智能体...")
    agent = BlenderAgent(llm)
    print("✅ 智能体创建成功")
    
    # 3. 执行示例命令
    print("\n[3] 执行示例命令...")
    
    commands = [
        "创建一个立方体",
        "给立方体添加细分修改器，级别设为2",
        "设置立方体为红色材质",
        "列出场景中所有对象"
    ]
    
    for i, cmd in enumerate(commands, 1):
        print(f"\n命令 {i}: {cmd}")
        print("-" * 40)
        
        result = agent.execute(cmd)
        
        if result.get("success"):
            print(f"✅ 执行成功")
            print(f"工具: {result.get('tool')}")
            print(f"结果: {result.get('result')}")
        else:
            print(f"❌ 执行失败")
            print(f"错误: {result.get('error')}")
    
    # 4. 对话模式
    print("\n[4] 对话模式示例...")
    print("-" * 40)
    
    questions = [
        "Blender 中如何创建破碎动画？",
        "细分修改器的作用是什么？"
    ]
    
    for q in questions:
        print(f"\n问题: {q}")
        answer = agent.chat(q)
        print(f"回答: {answer[:200]}...")  # 只显示前200字符
    
    print("\n" + "=" * 60)
    print("示例完成")
    print("=" * 60)


if __name__ == "__main__":
    main()
