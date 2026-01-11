"""
网络搜索工具
让本地 AI 能够获取最新信息
"""

import requests
from typing import List, Dict, Optional
import logging

logger = logging.getLogger(__name__)


def search_duckduckgo(query: str, max_results: int = 5, timeout: int = 15) -> List[Dict]:
    """
    使用 DuckDuckGo 搜索（免费，无需 API Key）
    
    Args:
        query: 搜索关键词
        max_results: 最大结果数
        timeout: 超时时间（秒）
        
    Returns:
        搜索结果列表
    """
    try:
        try:
            from ddgs import DDGS
        except ImportError:
            from duckduckgo_search import DDGS
        
        results = []
        ddgs = DDGS(timeout=timeout)
        
        # 使用 try-except 包裹搜索，避免超时导致程序崩溃
        try:
            search_results = ddgs.text(query, max_results=max_results)
            for r in search_results:
                results.append({
                    "title": r.get("title", ""),
                    "url": r.get("href", ""),
                    "snippet": r.get("body", ""),
                    "source": "DuckDuckGo"
                })
        except Exception as search_error:
            logger.warning(f"搜索超时或失败: {search_error}")
            # 返回空列表，让调用者处理
            return []
            
        return results
        
    except ImportError:
        logger.error("需要安装 duckduckgo-search: pip install duckduckgo-search")
        return []
    except Exception as e:
        logger.error(f"搜索失败: {e}")
        return []


def search_serper(query: str, api_key: str, max_results: int = 5) -> List[Dict]:
    """
    使用 Serper API 搜索（需要 API Key，但有免费额度）
    https://serper.dev/
    
    Args:
        query: 搜索关键词
        api_key: Serper API Key
        max_results: 最大结果数
        
    Returns:
        搜索结果列表
    """
    try:
        url = "https://google.serper.dev/search"
        headers = {
            "X-API-KEY": api_key,
            "Content-Type": "application/json"
        }
        payload = {
            "q": query,
            "num": max_results
        }
        
        response = requests.post(url, json=payload, headers=headers, timeout=10)
        response.raise_for_status()
        
        data = response.json()
        results = []
        
        for item in data.get("organic", []):
            results.append({
                "title": item.get("title", ""),
                "url": item.get("link", ""),
                "snippet": item.get("snippet", ""),
                "source": "Google"
            })
            
        return results
        
    except Exception as e:
        logger.error(f"Serper 搜索失败: {e}")
        return []


def fetch_webpage(url: str, max_length: int = 5000) -> str:
    """
    获取网页内容
    
    Args:
        url: 网页 URL
        max_length: 最大内容长度
        
    Returns:
        网页文本内容
    """
    try:
        from bs4 import BeautifulSoup
        
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        }
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # 移除脚本和样式
        for script in soup(["script", "style"]):
            script.decompose()
            
        # 获取文本
        text = soup.get_text()
        
        # 清理空白
        lines = (line.strip() for line in text.splitlines())
        chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
        text = '\n'.join(chunk for chunk in chunks if chunk)
        
        return text[:max_length]
        
    except ImportError:
        logger.error("需要安装 beautifulsoup4: pip install beautifulsoup4")
        return ""
    except Exception as e:
        logger.error(f"获取网页失败: {e}")
        return ""


def search_and_summarize(query: str, llm_client, max_results: int = 3, timeout: int = 15) -> Dict:
    """
    搜索并总结最新信息
    
    Args:
        query: 搜索查询
        llm_client: LLM 客户端
        max_results: 最大结果数
        timeout: 搜索超时时间（秒）
        
    Returns:
        包含搜索结果和总结的字典
    """
    # 1. 搜索
    logger.info(f"开始搜索: {query}")
    results = search_duckduckgo(query, max_results, timeout=timeout)
    
    if not results:
        logger.warning(f"搜索无结果: {query}")
        return {
            "success": False,
            "error": "搜索失败或无结果（可能是网络超时）",
            "suggestion": "请稍后重试，或使用模型原有知识回答"
        }
    
    # 2. 构建上下文
    context = f"关于 '{query}' 的最新搜索结果：\n\n"
    for i, result in enumerate(results, 1):
        context += f"{i}. {result['title']}\n"
        context += f"   来源: {result['url']}\n"
        context += f"   摘要: {result['snippet']}\n\n"
    
    # 3. 让 LLM 总结
    prompt = f"""请基于以下搜索结果，详细总结关于 '{query}' 的最新信息：

{context}

要求：
1. 详细提取每个来源的关键信息，不要遗漏重要细节
2. 按主题分类整理信息（如果有多个主题）
3. 明确标注每条信息的来源链接
4. 如果有数据、日期、人名、公司名等具体信息，务必包含
5. 保持客观准确，用中文回答
6. 总结要全面详细，至少 200 字以上

请用以下格式回答：

## 主要内容

[详细描述主要信息]

## 关键要点

- 要点1：[详细说明]（来源：[URL]）
- 要点2：[详细说明]（来源：[URL]）
- ...

## 补充信息

[其他相关细节]
"""
    
    try:
        summary = llm_client.chat(prompt)
    except Exception as e:
        logger.error(f"LLM 总结失败: {e}")
        # 如果 LLM 失败，返回原始搜索结果
        summary = context
    
    return {
        "success": True,
        "query": query,
        "results": results,
        "summary": summary
    }


# 技术资讯源配置
TECH_NEWS_SOURCES = {
    "AI": [
        "https://www.reddit.com/r/MachineLearning/.rss",
        "https://www.reddit.com/r/artificial/.rss",
        "https://huggingface.co/blog/feed.xml"
    ],
    "Blender": [
        "https://www.blender.org/feed/",
        "https://blenderartists.org/latest.rss"
    ],
    "Unity": [
        "https://blog.unity.com/feed"
    ],
    "GameDev": [
        "https://www.gamedeveloper.com/rss.xml"
    ]
}


def fetch_rss_feeds(category: str = "AI", max_items: int = 10) -> List[Dict]:
    """
    获取 RSS 订阅源的最新文章
    
    Args:
        category: 类别（AI/Blender/Unity/GameDev）
        max_items: 最大文章数
        
    Returns:
        文章列表
    """
    try:
        import feedparser
        
        feeds = TECH_NEWS_SOURCES.get(category, [])
        articles = []
        
        for feed_url in feeds:
            try:
                feed = feedparser.parse(feed_url)
                for entry in feed.entries[:max_items]:
                    articles.append({
                        "title": entry.get("title", ""),
                        "url": entry.get("link", ""),
                        "summary": entry.get("summary", ""),
                        "published": entry.get("published", ""),
                        "source": feed.feed.get("title", "")
                    })
            except Exception as e:
                logger.error(f"解析 RSS 失败 {feed_url}: {e}")
                
        return articles[:max_items]
        
    except ImportError:
        logger.error("需要安装 feedparser: pip install feedparser")
        return []
    except Exception as e:
        logger.error(f"获取 RSS 失败: {e}")
        return []
