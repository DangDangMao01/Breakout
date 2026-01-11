"""
命令行交互界面
提供简单的 CLI 与智能体交互
"""

import sys
import os
sys.path.append(os.path.dirname(__file__))

import argparse
import yaml
from core.llm_client import OllamaClient
from core.memory import MemorySystem
from agents.blender_agent import BlenderAgent
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def load_config(config_path: str = "config.yaml") -> dict:
    """加载配置文件"""
    with open(config_path, 'r', encoding='utf-8') as f:
        return yaml.safe_load(f)


def interactive_mode(agent, agent_name: str):
    """交互模式"""
    print(f"\n{'=' * 60}")
    print(f"{agent_name} 交互模式")
    print(f"{'=' * 60}")
    print("输入命令或问题，输入 'quit' 退出")
    print("输入 'clear' 清空对话历史")
    print("输入 'help' 查看帮助")
    print(f"{'=' * 60}\n")
    
    while True:
        try:
            user_input = input(f"{agent_name}> ").strip()
            
            if not user_input:
                continue
                
            if user_input.lower() == 'quit':
                print("再见！")
                break
                
            if user_input.lower() == 'clear':
                agent.llm.clear_history()
                print("✅ 对话历史已清空")
                continue
                
            if user_input.lower() == 'help':
                print("\n可用命令：")
                print("  quit  - 退出程序")
                print("  clear - 清空对话历史")
                print("  help  - 显示帮助")
                print("\n可用工具：")
                for tool_name in agent.tools.keys():
                    print(f"  - {tool_name}")
                print()
                continue
            
            # 执行命令
            result = agent.execute(user_input)
            
            if result.get("success"):
                print(f"✅ 执行成功")
                print(f"工具: {result.get('tool')}")
                print(f"结果: {result.get('result')}")
            else:
                # 如果不是工具调用，尝试对话
                response = agent.chat(user_input)
                print(f"\n{response}\n")
                
        except KeyboardInterrupt:
            print("\n\n再见！")
            break
        except Exception as e:
            logger.error(f"错误: {e}")
            print(f"❌ 错误: {e}")


def main():
    """主函数"""
    parser = argparse.ArgumentParser(description="DCC 智能体 CLI")
    parser.add_argument(
        "--agent",
        choices=["blender", "maya", "unity"],
        default="blender",
        help="选择智能体类型"
    )
    parser.add_argument(
        "--config",
        default="config.yaml",
        help="配置文件路径"
    )
    parser.add_argument(
        "--command",
        help="直接执行命令（非交互模式）"
    )
    
    args = parser.parse_args()
    
    # 加载配置
    try:
        config = load_config(args.config)
    except Exception as e:
        logger.error(f"加载配置失败: {e}")
        return
    
    # 初始化 LLM 客户端
    ollama_config = config.get("ollama", {})
    llm = OllamaClient(
        host=ollama_config.get("host", "http://localhost:11434"),
        model=ollama_config.get("model", "qwen2.5:32b")
    )
    
    # 检查连接
    if not llm.check_connection():
        print("❌ 无法连接到 Ollama 服务")
        print("请确保 Ollama 已启动: ollama serve")
        return
    
    # 创建智能体
    if args.agent == "blender":
        agent = BlenderAgent(llm)
        agent_name = "Blender Agent"
    elif args.agent == "maya":
        print("❌ Maya Agent 尚未实现")
        return
    elif args.agent == "unity":
        print("❌ Unity Agent 尚未实现")
        return
    else:
        print(f"❌ 未知的智能体类型: {args.agent}")
        return
    
    # 执行模式
    if args.command:
        # 单命令模式
        result = agent.execute(args.command)
        if result.get("success"):
            print(f"✅ 执行成功")
            print(f"工具: {result.get('tool')}")
            print(f"结果: {result.get('result')}")
        else:
            print(f"❌ 执行失败: {result.get('error')}")
    else:
        # 交互模式
        interactive_mode(agent, agent_name)


if __name__ == "__main__":
    main()
