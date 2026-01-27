"""
自动更新知识库工作流
定期获取最新技术资讯并更新到知识库
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from core.llm_client import OllamaClient
from core.memory import MemorySystem
from tools import web_search_tools
from datetime import datetime
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class KnowledgeBaseUpdater:
    """知识库自动更新器"""
    
    def __init__(self, llm_client: OllamaClient, kb_path: str = "E:/Git_file/Kiro-Central-KB"):
        self.llm = llm_client
        self.kb_path = kb_path
        self.memory = MemorySystem()
        
    def update_tech_news(self, categories: list = ["AI", "Blender", "Unity"]):
        """
        更新技术资讯
        
        Args:
            categories: 要更新的类别列表
        """
        print("=" * 60)
        print("开始更新技术资讯")
        print("=" * 60)
        
        for category in categories:
            print(f"\n[{category}] 获取最新资讯...")
            
            # 1. 获取 RSS 订阅
            articles = web_search_tools.fetch_rss_feeds(category, max_items=5)
            
            if not articles:
                print(f"  ❌ {category} 无新资讯")
                continue
                
            print(f"  ✅ 获取到 {len(articles)} 条资讯")
            
            # 2. 让 LLM 总结
            context = f"{category} 领域最新资讯：\n\n"
            for i, article in enumerate(articles, 1):
                context += f"{i}. {article['title']}\n"
                context += f"   {article['summary'][:200]}...\n\n"
                
            prompt = f"""请总结以下 {category} 领域的最新资讯，提取关键信息：

{context}

要求：
1. 提取技术要点
2. 标注重要更新
3. 保持简洁
"""
            
            summary = self.llm.chat(prompt)
            
            # 3. 保存到记忆系统
            self.memory.add_memory(
                content=f"{category} 最新资讯 ({datetime.now().strftime('%Y-%m-%d')}): {summary}",
                category="tech_news",
                metadata={
                    "category": category,
                    "date": datetime.now().isoformat(),
                    "source": "RSS"
                }
            )
            
            print(f"  ✅ 已保存到记忆系统")
            
            # 4. 保存到知识库文件（可选）
            self._save_to_kb_file(category, articles, summary)
            
    def _save_to_kb_file(self, category: str, articles: list, summary: str):
        """保存到知识库文件"""
        try:
            date_str = datetime.now().strftime("%Y-%m-%d")
            filename = f"{self.kb_path}/notes/{date_str}-{category.lower()}-news.md"
            
            content = f"""---
date: {date_str}
category: tech-news/{category.lower()}
tags: [{category.lower()}, news, auto-generated]
---

# {category} 技术资讯 - {date_str}

## AI 总结

{summary}

## 原始资讯

"""
            
            for i, article in enumerate(articles, 1):
                content += f"### {i}. {article['title']}\n\n"
                content += f"- 来源: {article.get('source', 'Unknown')}\n"
                content += f"- 链接: {article['url']}\n"
                content += f"- 发布: {article.get('published', 'Unknown')}\n\n"
                content += f"{article.get('summary', '')}\n\n"
                content += "---\n\n"
                
            with open(filename, 'w', encoding='utf-8') as f:
                f.write(content)
                
            print(f"  ✅ 已保存到文件: {filename}")
            
        except Exception as e:
            logger.error(f"保存文件失败: {e}")
            
    def search_and_update(self, queries: list):
        """
        搜索特定主题并更新知识库
        
        Args:
            queries: 搜索查询列表
        """
        print("\n" + "=" * 60)
        print("搜索并更新知识库")
        print("=" * 60)
        
        for query in queries:
            print(f"\n搜索: {query}")
            
            # 搜索
            results = web_search_tools.search_duckduckgo(query, max_results=3)
            
            if not results:
                print(f"  ❌ 无搜索结果")
                continue
                
            # 构建上下文
            context = ""
            for result in results:
                context += f"标题: {result['title']}\n"
                context += f"内容: {result['snippet']}\n\n"
                
            # LLM 总结
            prompt = f"""请总结关于 '{query}' 的最新信息：

{context}

要求简洁准确，提取关键点。"""
            
            summary = self.llm.chat(prompt)
            
            # 保存到记忆
            self.memory.add_memory(
                content=f"关于 '{query}' 的最新信息: {summary}",
                category="search_result",
                metadata={
                    "query": query,
                    "date": datetime.now().isoformat(),
                    "sources": [r['url'] for r in results]
                }
            )
            
            print(f"  ✅ 已更新到知识库")
            print(f"  摘要: {summary[:100]}...")


def main():
    """主函数"""
    # 初始化
    llm = OllamaClient(host="http://localhost:11434", model="qwen2.5:32b")
    updater = KnowledgeBaseUpdater(llm)
    
    # 1. 更新技术资讯
    updater.update_tech_news(categories=["AI", "Blender", "Unity", "GameDev"])
    
    # 2. 搜索特定主题
    queries = [
        "Blender 4.0 新功能",
        "Unity 6 发布日期",
        "最新的 AI 绘画模型"
    ]
    updater.search_and_update(queries)
    
    print("\n" + "=" * 60)
    print("✅ 知识库更新完成")
    print("=" * 60)


if __name__ == "__main__":
    main()
