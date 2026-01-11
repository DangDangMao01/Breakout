"""
增强型智能体 - 支持网络搜索
能够获取最新信息的智能体
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from core.agent_base import AgentBase
from core.llm_client import OllamaClient
from tools import web_search_tools
import logging

logger = logging.getLogger(__name__)


class WebEnhancedAgent(AgentBase):
    """支持网络搜索的增强型智能体"""
    
    def __init__(self, llm_client: OllamaClient):
        super().__init__(name="WebEnhancedAgent", llm_client=llm_client)
        
    def _default_system_prompt(self) -> str:
        return """你是一个增强型 AI 助手，具备以下能力：

1. 回答一般问题（基于训练数据）
2. 搜索最新信息（通过网络搜索）
3. 获取技术资讯（通过 RSS 订阅）

当用户询问最新信息、实时数据、或你不确定的内容时，你应该使用搜索工具。

使用搜索的场景：
- "最新的..."
- "2024年..."、"2025年..."、"2026年..."
- "现在..."、"目前..."
- 技术版本、价格、发布日期等实时信息

保持专业、准确，并注明信息来源。"""
        
    def _register_tools(self):
        """注册工具"""
        self.register_tool("search_web", self._search_web)
        self.register_tool("get_tech_news", self._get_tech_news)
        self.register_tool("fetch_webpage", self._fetch_webpage)
        
    def _search_web(self, query: str) -> Dict:
        """搜索网络并总结"""
        return web_search_tools.search_and_summarize(query, self.llm)
        
    def _get_tech_news(self, category: str = "AI") -> Dict:
        """获取技术资讯"""
        articles = web_search_tools.fetch_rss_feeds(category, max_items=5)
        
        if not articles:
            return {
                "success": False,
                "error": "获取资讯失败"
            }
            
        # 构建摘要
        summary = f"{category} 领域最新资讯：\n\n"
        for i, article in enumerate(articles, 1):
            summary += f"{i}. {article['title']}\n"
            summary += f"   来源: {article['source']}\n"
            summary += f"   链接: {article['url']}\n"
            if article.get('published'):
                summary += f"   发布: {article['published']}\n"
            summary += "\n"
            
        return {
            "success": True,
            "category": category,
            "articles": articles,
            "summary": summary
        }
        
    def _fetch_webpage(self, url: str) -> Dict:
        """获取网页内容"""
        content = web_search_tools.fetch_webpage(url)
        
        if not content:
            return {
                "success": False,
                "error": "获取网页失败"
            }
            
        return {
            "success": True,
            "url": url,
            "content": content[:2000]  # 限制长度
        }
        
    def answer_with_search(self, question: str) -> str:
        """
        智能回答：自动判断是否需要搜索
        """
        # 判断是否需要搜索
        keywords = ["最新", "现在", "目前", "2024", "2025", "2026", "实时", "当前"]
        needs_search = any(keyword in question for keyword in keywords)
        
        if needs_search:
            logger.info(f"检测到需要搜索: {question}")
            result = self._search_web(question)
            
            if result.get("success"):
                return result["summary"]
            else:
                return f"搜索失败，基于已有知识回答：\n\n{self.chat(question)}"
        else:
            return self.chat(question)


# 示例使用
if __name__ == "__main__":
    # 初始化
    llm = OllamaClient(host="http://localhost:11434", model="qwen2.5:32b")
    agent = WebEnhancedAgent(llm)
    
    # 测试问题
    questions = [
        "Blender 4.0 有什么新功能？",  # 需要搜索
        "如何在 Blender 中创建立方体？",  # 不需要搜索
        "2026年最新的 AI 模型有哪些？",  # 需要搜索
    ]
    
    for q in questions:
        print(f"\n问题: {q}")
        print("-" * 60)
        answer = agent.answer_with_search(q)
        print(answer)
