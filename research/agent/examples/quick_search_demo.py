"""
快速搜索演示
展示搜索增强的效果
"""

print("=" * 60)
print("搜索增强功能演示")
print("=" * 60)

# 步骤 1: 测试搜索
print("\n[步骤 1] 测试网络搜索...")
print("-" * 60)

try:
    try:
        from ddgs import DDGS
    except ImportError:
        from duckduckgo_search import DDGS
    
    query = "Blender 4.0 新功能"
    print(f"搜索: {query}")
    
    ddgs = DDGS()
    results = list(ddgs.text(query, max_results=3))
        
    print(f"\n✅ 搜索成功！找到 {len(results)} 个结果：\n")
    
    search_context = ""
    for i, result in enumerate(results, 1):
        print(f"{i}. {result['title']}")
        print(f"   {result['href']}")
        print(f"   {result['body'][:100]}...")
        print()
        
        search_context += f"{i}. {result['title']}\n{result['body']}\n\n"
        
except ImportError:
    print("❌ 需要安装: pip install duckduckgo-search")
    exit(1)
except Exception as e:
    print(f"❌ 搜索失败: {e}")
    exit(1)

# 步骤 2: 让 Ollama 基于搜索结果回答
print("\n[步骤 2] 让 Ollama 基于搜索结果回答...")
print("-" * 60)

try:
    import requests
    
    prompt = f"""请基于以下搜索结果，用中文简洁回答：Blender 4.0 有什么新功能？

搜索结果：
{search_context}

要求：
1. 提取关键新功能
2. 用简洁的语言总结
3. 标注信息来源"""

    payload = {
        "model": "qwen2.5:32b",
        "messages": [
            {"role": "user", "content": prompt}
        ],
        "stream": False
    }
    
    print("正在生成回答...\n")
    
    response = requests.post(
        "http://localhost:11434/api/chat",
        json=payload,
        timeout=60
    )
    
    if response.status_code == 200:
        answer = response.json()["message"]["content"]
        print("✅ Ollama 回答：")
        print("-" * 60)
        print(answer)
        print("-" * 60)
    else:
        print(f"❌ Ollama 调用失败: {response.status_code}")
        
except Exception as e:
    print(f"❌ Ollama 调用失败: {e}")
    print("\n请确保 Ollama 正在运行")

# 步骤 3: 对比
print("\n\n[步骤 3] 效果对比")
print("=" * 60)
print("\n❌ 没有搜索（直接问 Ollama）：")
print("   '我无法提供关于 Blender 4.0 的具体信息...'")
print("\n✅ 有搜索（搜索 + Ollama）：")
print("   '根据最新搜索结果，Blender 4.0 的新功能包括...'")
print("   （带来源、带时间、准确可靠）")

print("\n" + "=" * 60)
print("演示完成！")
print("=" * 60)
print("\n现在你的本地 AI 可以获取最新信息了！🎉")
