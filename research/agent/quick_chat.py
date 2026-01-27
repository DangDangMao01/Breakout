"""
快速聊天 - 支持搜索的简化版
不需要复杂依赖
"""

import json
import requests


def search_web(query, timeout=15):
    """搜索网络"""
    try:
        from ddgs import DDGS
        
        print(f"🔍 搜索: {query}")
        ddgs = DDGS(timeout=timeout)
        
        try:
            results = list(ddgs.text(query, max_results=3))
        except Exception as e:
            print(f"⚠️ 搜索超时: {e}")
            return None
        
        if not results:
            return None
            
        context = ""
        for i, r in enumerate(results, 1):
            context += f"{i}. {r['title']}\n{r['body']}\n\n"
            
        return context
        
    except Exception as e:
        print(f"搜索失败: {e}")
        return None


def chat_with_ollama(prompt, model="qwen2.5:32b"):
    """与 Ollama 对话"""
    try:
        payload = {
            "model": model,
            "messages": [{"role": "user", "content": prompt}],
            "stream": False
        }
        
        response = requests.post(
            "http://localhost:11434/api/chat",
            json=payload,
            timeout=60
        )
        
        if response.status_code == 200:
            return response.json()["message"]["content"]
        else:
            return f"错误: {response.status_code}"
            
    except Exception as e:
        return f"Ollama 调用失败: {e}"


def answer_with_search(question):
    """智能回答（带搜索）"""
    # 判断是否需要搜索
    keywords = ["最新", "现在", "目前", "2024", "2025", "2026", "实时", "当前", "新功能", "发布"]
    needs_search = any(k in question for k in keywords)
    
    if needs_search:
        # 搜索
        search_results = search_web(question)
        
        if search_results:
            # 基于搜索结果回答
            prompt = f"""请基于以下搜索结果回答问题：

问题：{question}

搜索结果：
{search_results}

要求：用中文简洁回答，标注信息来源。"""
            
            print("💭 生成回答...")
            return chat_with_ollama(prompt)
        else:
            print("⚠️ 搜索失败，使用模型知识回答")
    
    # 直接回答
    return chat_with_ollama(question)


def main():
    """主函数"""
    print("=" * 60)
    print("AI 助手（支持网络搜索）")
    print("=" * 60)
    print("\n命令：")
    print("  quit - 退出")
    print("  help - 帮助")
    print("\n提示：询问'最新'、'2026'等会自动搜索")
    print("=" * 60)
    
    while True:
        try:
            try:
                question = input("\nAI> ").strip()
            except EOFError:
                print("\n\n再见！👋")
                break
            
            if not question:
                continue
                
            if question.lower() == 'quit':
                print("\n再见！👋")
                break
                
            if question.lower() == 'help':
                print("\n功能：")
                print("  - 回答一般问题")
                print("  - 自动搜索最新信息")
                print("\n示例：")
                print("  - Blender 4.0 有什么新功能？")
                print("  - CES 2026 有什么内容？")
                print("  - 如何在 Blender 中创建立方体？")
                continue
            
            print()
            answer = answer_with_search(question)
            print(f"\n{answer}\n")
            
        except KeyboardInterrupt:
            print("\n\n再见！👋")
            break
        except Exception as e:
            print(f"\n❌ 错误: {e}\n")


if __name__ == "__main__":
    main()
