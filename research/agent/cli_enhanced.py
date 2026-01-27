"""
增强版命令行交互界面
支持网络搜索功能
"""

import sys
import os
sys.path.append(os.path.dirname(__file__))

import argparse
try:
    import yaml
except ImportError:
    yaml = None
from core.llm_client import OllamaClient
from agents.web_enhanced_agent import WebEnhancedAgent
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def load_config(config_path: str = "config.yaml") -> dict:
    """加载配置文件"""
    if yaml is None:
        return {}
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            return yaml.safe_load(f)
    except:
        return {}


def interactive_mode(agent):
    """交互模式"""
    print(f"\n{'=' * 60}")
    print(f"增强型 AI 助手（支持网络搜索）")
    print(f"{'=' * 60}")
    print("功能：")
    print("  - 回答一般问题")
    print("  - 自动搜索最新信息")
    print("  - 获取技术资讯")
    print(f"{'=' * 60}")
    print("\n命令：")
    print("  quit   - 退出程序")
    print("  clear  - 清空对话历史")
    print("  search - 强制搜索模式")
    print("  news   - 获取技术资讯")
    print("  help   - 显示帮助")
    print(f"{'=' * 60}\n")
    
    force_search = False
    
    while True:
        try:
            user_input = input("AI> ").strip()
            
            if not user_input:
                continue
                
            # 命令处理
            if user_input.lower() == 'quit':
                print("\n再见！👋")
                break
                
            if user_input.lower() == 'clear':
                agent.llm.clear_history()
                print("✅ 对话历史已清空")
                continue
                
            if user_input.lower() == 'search':
                force_search = not force_search
                status = "开启" if force_search else "关闭"
                print(f"✅ 强制搜索模式已{status}")
                continue
                
            if user_input.lower().startswith('news'):
                parts = user_input.split()
                category = parts[1] if len(parts) > 1 else "AI"
                print(f"\n获取 {category} 领域最新资讯...")
                result = agent._get_tech_news(category)
                if result.get("success"):
                    print(result["summary"])
                else:
                    print(f"❌ {result.get('error')}")
                continue
                
            if user_input.lower() == 'help':
                print("\n可用命令：")
                print("  quit   - 退出程序")
                print("  clear  - 清空对话历史")
                print("  search - 切换强制搜索模式")
                print("  news [类别] - 获取技术资讯")
                print("    类别: AI, Blender, Unity, GameDev")
                print("  help   - 显示帮助")
                print("\n提示：")
                print("  - 询问'最新'、'2026'等关键词会自动触发搜索")
                print("  - 开启强制搜索模式后，所有问题都会搜索")
                print()
                continue
            
            # 回答问题
            print()
            if force_search:
                # 强制搜索
                result = agent._search_web(user_input)
                if result.get("success"):
                    print(result["summary"])
                else:
                    print(f"搜索失败，使用模型知识回答：\n{agent.chat(user_input)}")
            else:
                # 智能判断
                answer = agent.answer_with_search(user_input)
                print(answer)
            print()
                
        except KeyboardInterrupt:
            print("\n\n再见！👋")
            break
        except Exception as e:
            logger.error(f"错误: {e}")
            print(f"\n❌ 错误: {e}\n")


def main():
    """主函数"""
    parser = argparse.ArgumentParser(description="增强型 AI 助手 CLI")
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
    
    print("=" * 60)
    print("初始化增强型 AI 助手...")
    print("=" * 60)
    
    # 加载配置
    config = load_config(args.config)
    
    # 初始化 LLM 客户端
    ollama_config = config.get("ollama", {})
    llm = OllamaClient(
        host=ollama_config.get("host", "http://localhost:11434"),
        model=ollama_config.get("model", "qwen2.5:32b")
    )
    
    # 检查连接
    print("\n检查 Ollama 连接...")
    if not llm.check_connection():
        print("❌ 无法连接到 Ollama 服务")
        print("请确保 Ollama 已启动")
        return
    print("✅ Ollama 连接成功")
    
    # 检查模型
    models = llm.list_models()
    if models:
        print(f"✅ 可用模型: {', '.join(models)}")
    
    # 创建增强型智能体
    print("\n创建增强型智能体...")
    try:
        agent = WebEnhancedAgent(llm)
        print("✅ 智能体创建成功")
        print("✅ 网络搜索功能已启用")
    except Exception as e:
        print(f"❌ 创建智能体失败: {e}")
        return
    
    # 执行模式
    if args.command:
        # 单命令模式
        print(f"\n问题: {args.command}")
        answer = agent.answer_with_search(args.command)
        print(f"\n回答:\n{answer}")
    else:
        # 交互模式
        interactive_mode(agent)


if __name__ == "__main__":
    main()
