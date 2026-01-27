"""
简单的搜索测试
不依赖复杂的库，直接测试搜索功能
"""

import json
import urllib.request
import urllib.parse


def simple_search(query):
    """
    使用简单的方式搜索（不需要额外库）
    """
    print(f"\n正在搜索: {query}")
    print("=" * 60)
    
    try:
        # 使用 DuckDuckGo 的即时答案 API
        encoded_query = urllib.parse.quote(query)
        url = f"https://api.duckduckgo.com/?q={encoded_query}&format=json"
        
        print(f"请求 URL: {url}")
        
        response = urllib.request.urlopen(url, timeout=10)
        data = json.loads(response.read().decode())
        
        # 提取结果
        abstract = data.get("Abstract", "")
        abstract_url = data.get("AbstractURL", "")
        related = data.get("RelatedTopics", [])
        
        print("\n搜索结果：")
        print("-" * 60)
        
        if abstract:
            print(f"\n摘要: {abstract}")
            print(f"来源: {abstract_url}")
        
        if related:
            print(f"\n相关主题（前5个）:")
            for i, topic in enumerate(related[:5], 1):
                if isinstance(topic, dict) and "Text" in topic:
                    print(f"{i}. {topic['Text']}")
                    if "FirstURL" in topic:
                        print(f"   链接: {topic['FirstURL']}")
        
        if not abstract and not related:
            print("未找到即时答案，尝试其他搜索方式...")
            return False
            
        return True
        
    except Exception as e:
        print(f"搜索失败: {e}")
        return False


def test_ollama_with_context(query, search_results):
    """
    测试 Ollama 基于搜索结果回答
    """
    print("\n\n让 Ollama 基于搜索结果回答...")
    print("=" * 60)
    
    try:
        import json
        import urllib.request
        
        # 构建提示词
        prompt = f"""请基于以下搜索结果回答问题：

问题：{query}

搜索结果：
{search_results}

请用中文简洁回答，并注明信息来源。"""
        
        # 调用 Ollama
        payload = {
            "model": "qwen2.5:32b",
            "messages": [
                {"role": "user", "content": prompt}
            ],
            "stream": False
        }
        
        req = urllib.request.Request(
            "http://localhost:11434/api/chat",
            data=json.dumps(payload).encode(),
            headers={"Content-Type": "application/json"}
        )
        
        print("正在生成回答...")
        response = urllib.request.urlopen(req, timeout=60)
        result = json.loads(response.read().decode())
        
        answer = result.get("message", {}).get("content", "")
        print(f"\nOllama 回答：\n{answer}")
        
        return True
        
    except Exception as e:
        print(f"Ollama 调用失败: {e}")
        return False


def main():
    """主函数"""
    print("=" * 60)
    print("搜索功能测试")
    print("=" * 60)
    
    # 测试问题
    test_queries = [
        "Blender 4.0",
        "CES 2026",
        "Python 3.14"
    ]
    
    for query in test_queries:
        success = simple_search(query)
        
        if success:
            print("\n✅ 搜索成功！")
        else:
            print("\n❌ 搜索失败")
        
        print("\n" + "=" * 60)
        
        # 只测试第一个
        break
    
    print("\n提示：")
    print("1. 如果搜索成功，说明网络连接正常")
    print("2. 接下来可以安装完整的搜索库：pip install duckduckgo-search")
    print("3. 然后运行完整示例：python examples/web_search_example.py")


if __name__ == "__main__":
    main()
