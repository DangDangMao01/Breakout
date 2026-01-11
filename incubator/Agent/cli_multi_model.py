"""
多模型 CLI - 支持切换不同的 AI 模型
"""

import sys
import os
sys.path.append(os.path.dirname(__file__))

import argparse
from core.llm_client import OllamaClient
from agents.web_enhanced_agent import WebEnhancedAgent
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class MultiModelCLI:
    """多模型 CLI"""
    
    def __init__(self, host="http://localhost:11434"):
        self.host = host
        self.current_model = None
        self.llm = None
        self.agent = None
        self.available_models = []
        
    def load_available_models(self):
        """加载可用模型列表"""
        try:
            import requests
            response = requests.get(f"{self.host}/api/tags", timeout=5)
            if response.status_code == 200:
                data = response.json()
                self.available_models = [m["name"] for m in data.get("models", [])]
                return True
        except Exception as e:
            logger.error(f"获取模型列表失败: {e}")
        return False
    
    def switch_model(self, model_name: str):
        """切换模型"""
        if model_name not in self.available_models:
            print(f"❌ 模型 '{model_name}' 不存在")
            print(f"可用模型: {', '.join(self.available_models)}")
            return False
        
        print(f"\n🔄 切换到模型: {model_name}")
        self.current_model = model_name
        
        # 重新创建 LLM 客户端
        self.llm = OllamaClient(host=self.host, model=model_name)
        
        # 重新创建智能体
        try:
            self.agent = WebEnhancedAgent(self.llm)
            print(f"✅ 模型切换成功")
            return True
        except Exception as e:
            logger.error(f"创建智能体失败: {e}")
            return False
    
    def show_models(self):
        """显示所有可用模型"""
        print("\n" + "=" * 60)
        print("可用模型列表")
        print("=" * 60)
        
        for i, model in enumerate(self.available_models, 1):
            current = "✓" if model == self.current_model else " "
            print(f"[{current}] {i}. {model}")
        
        print("=" * 60)
    
    def compare_models(self, question: str, models: list = None):
        """对比多个模型的回答"""
        if not models:
            models = self.available_models[:3]  # 默认对比前 3 个
        
        print("\n" + "=" * 60)
        print(f"问题: {question}")
        print("=" * 60)
        
        results = {}
        for model in models:
            print(f"\n🤖 {model} 的回答:")
            print("-" * 60)
            
            # 临时切换模型
            temp_llm = OllamaClient(host=self.host, model=model)
            try:
                answer = temp_llm.chat(question)
                results[model] = answer
                print(answer)
            except Exception as e:
                results[model] = f"错误: {e}"
                print(f"❌ {e}")
            
            print("-" * 60)
        
        return results
    
    def interactive_mode(self):
        """交互模式"""
        print(f"\n{'=' * 60}")
        print(f"多模型 AI 助手")
        print(f"{'=' * 60}")
        print("功能：")
        print("  - 支持多个 AI 模型")
        print("  - 随时切换模型")
        print("  - 对比不同模型的回答")
        print("  - 网络搜索增强")
        print(f"{'=' * 60}")
        print("\n命令：")
        print("  quit          - 退出程序")
        print("  models        - 显示所有模型")
        print("  switch <模型> - 切换模型")
        print("  compare <问题> - 对比多个模型")
        print("  search        - 切换搜索模式")
        print("  clear         - 清空历史")
        print("  help          - 显示帮助")
        print(f"{'=' * 60}\n")
        
        force_search = False
        
        while True:
            try:
                # 显示当前模型
                prompt = f"[{self.current_model}]> " if self.current_model else "AI> "
                user_input = input(prompt).strip()
                
                if not user_input:
                    continue
                
                # 命令处理
                if user_input.lower() == 'quit':
                    print("\n再见！👋")
                    break
                
                if user_input.lower() == 'models':
                    self.show_models()
                    continue
                
                if user_input.lower().startswith('switch '):
                    model_name = user_input[7:].strip()
                    self.switch_model(model_name)
                    continue
                
                if user_input.lower().startswith('compare '):
                    question = user_input[8:].strip()
                    self.compare_models(question)
                    continue
                
                if user_input.lower() == 'clear':
                    if self.llm:
                        self.llm.clear_history()
                        print("✅ 对话历史已清空")
                    continue
                
                if user_input.lower() == 'search':
                    force_search = not force_search
                    status = "开启" if force_search else "关闭"
                    print(f"✅ 强制搜索模式已{status}")
                    continue
                
                if user_input.lower() == 'help':
                    print("\n可用命令：")
                    print("  quit          - 退出程序")
                    print("  models        - 显示所有模型")
                    print("  switch <模型> - 切换模型（如: switch qwen2.5:7b）")
                    print("  compare <问题> - 对比多个模型的回答")
                    print("  search        - 切换强制搜索模式")
                    print("  clear         - 清空对话历史")
                    print("  help          - 显示帮助")
                    print()
                    continue
                
                # 检查是否选择了模型
                if not self.current_model:
                    print("⚠️ 请先选择模型")
                    print("使用 'models' 查看可用模型")
                    print("使用 'switch <模型名>' 切换模型")
                    continue
                
                # 回答问题
                print()
                if force_search:
                    result = self.agent._search_web(user_input)
                    if result.get("success"):
                        print(result["summary"])
                    else:
                        print(f"搜索失败，使用模型知识回答：\n{self.agent.chat(user_input)}")
                else:
                    answer = self.agent.answer_with_search(user_input)
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
    parser = argparse.ArgumentParser(description="多模型 AI 助手 CLI")
    parser.add_argument(
        "--host",
        default="http://localhost:11434",
        help="Ollama 服务地址"
    )
    parser.add_argument(
        "--model",
        help="默认模型"
    )
    
    args = parser.parse_args()
    
    print("=" * 60)
    print("初始化多模型 AI 助手...")
    print("=" * 60)
    
    # 创建 CLI
    cli = MultiModelCLI(host=args.host)
    
    # 加载可用模型
    print("\n检查 Ollama 连接...")
    if not cli.load_available_models():
        print("❌ 无法连接到 Ollama 服务")
        print("请确保 Ollama 已启动")
        return
    
    print(f"✅ 找到 {len(cli.available_models)} 个模型")
    
    # 选择默认模型
    if args.model:
        cli.switch_model(args.model)
    elif cli.available_models:
        # 自动选择第一个模型
        cli.switch_model(cli.available_models[0])
    else:
        print("❌ 没有可用的模型")
        print("请先下载模型: ollama pull qwen2.5:7b")
        return
    
    # 启动交互模式
    cli.interactive_mode()


if __name__ == "__main__":
    main()
