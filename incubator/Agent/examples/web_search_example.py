"""
网络搜索增强示例
演示如何让本地 AI 获取最新信息
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from core.llm_client import OllamaClient
from agents.web_enhanced_agent import WebEnhancedAgent
import logging

logging.basicConfig(level=logging.INFO)


def main():
    """主函数"""
    print("=" * 60)
    print("网络搜索增强示例")
    print("=" * 60)
    
    # 1. 初始化
    print("\n[1] 初始化智能体...")
    llm = OllamaClient(host="http://localhost:11434", model="qwen2.5:32b")
    agent = WebEnhancedAgent(llm)
    print("✅ 智能体初始化完成")
    
    # 2. 测试普通问题（不需要搜索）
    print("\n[2] 测试普通问题...")
    question = "如何在 Blender 中创建立方体？"
    print(f"问题: {question}")
    answer = agent.answer_with_search(question)
    print(f"回答: {answer[:200]}...")
    
    # 3. 测试需要搜索的问题
    print("\n[3] 测试最新信息查询...")
    question = "Blender 4.0 有什么新功能？"
    print(f"问题: {question}")
    answer = agent.answer_with_search(question)
    print(f"回答: {answer}")
    
    # 4. 获取技术资讯
    print("\n[4] 获取 AI 领域最新资讯...")
    result = agent._get_tech_news("AI")
    if result.get("success"):
        print(result["summary"])
    
    print("\n" + "=" * 60)
    print("示例完成")
    print("=" * 60)


if __name__ == "__main__":
    main()
