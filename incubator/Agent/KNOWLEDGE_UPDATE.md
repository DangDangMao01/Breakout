# 让本地 AI 紧跟最新信息技术

> 解决本地 AI 模型知识过时的问题

## 问题

本地 AI 模型（如 Qwen 2.5）的知识是固定的，训练数据截止到 2023 年，无法获取最新信息。

## 解决方案

### 方案 1: RAG + 网络搜索 ⭐⭐⭐⭐⭐

**原理：** 当需要最新信息时，先搜索网络，然后让 AI 基于搜索结果回答。

**优势：**
- ✅ 实时性最强
- ✅ 完全免费
- ✅ 实现简单
- ✅ 信息准确

**实现：**

```python
from agents.web_enhanced_agent import WebEnhancedAgent

agent = WebEnhancedAgent(llm)

# 自动判断是否需要搜索
answer = agent.answer_with_search("Blender 4.0 有什么新功能？")
```

**使用场景：**
- 查询最新技术版本
- 获取实时价格信息
- 了解最新发布的产品
- 查找最新教程

---

### 方案 2: 定期更新知识库 ⭐⭐⭐⭐

**原理：** 定期从 RSS、技术博客等获取最新资讯，存入向量数据库。

**优势：**
- ✅ 自动化程度高
- ✅ 知识持续积累
- ✅ 可离线使用
- ✅ 响应速度快

**实现：**

```bash
# 手动更新
python workflows/auto_update_kb.py

# 或使用批处理
定时更新知识库.bat
```

**自动化（Windows 任务计划）：**

1. 打开"任务计划程序"
2. 创建基本任务
3. 触发器：每天早上 8:00
4. 操作：运行 `定时更新知识库.bat`

**订阅源配置：**

```python
TECH_NEWS_SOURCES = {
    "AI": [
        "https://www.reddit.com/r/MachineLearning/.rss",
        "https://huggingface.co/blog/feed.xml"
    ],
    "Blender": [
        "https://www.blender.org/feed/"
    ],
    "Unity": [
        "https://blog.unity.com/feed"
    ]
}
```

---

### 方案 3: RSS 订阅 + 自动摘要 ⭐⭐⭐⭐

**原理：** 订阅技术博客 RSS，AI 自动生成摘要并分类存储。

**优势：**
- ✅ 信息来源可靠
- ✅ 自动分类整理
- ✅ 可追溯来源
- ✅ 适合长期积累

**实现：**

```python
from tools.web_search_tools import fetch_rss_feeds

# 获取 AI 领域最新文章
articles = fetch_rss_feeds("AI", max_items=10)

# AI 自动总结
for article in articles:
    summary = llm.chat(f"总结这篇文章: {article['title']}")
```

---

### 方案 4: 微调模型 ⭐⭐

**原理：** 用最新数据微调模型，更新知识。

**优势：**
- ✅ 知识融入模型
- ✅ 无需外部工具

**劣势：**
- ❌ 成本高（需要 GPU 算力）
- ❌ 技术难度大
- ❌ 更新周期长
- ❌ 不适合频繁更新

**不推荐理由：** 对于个人用户，成本和难度都太高。

---

## 推荐配置

### 基础配置（免费）

```bash
# 1. 安装依赖
pip install -r requirements-web.txt

# 2. 测试搜索功能
python examples/web_search_example.py
```

### 进阶配置（可选）

**使用 Serper API（Google 搜索）：**

1. 注册：https://serper.dev/
2. 获取 API Key（免费 2500 次/月）
3. 配置：

```python
# 在 config.yaml 中添加
web_search:
  provider: "serper"
  api_key: "your_api_key_here"
```

---

## 使用示例

### 示例 1: 查询最新信息

```python
from agents.web_enhanced_agent import WebEnhancedAgent

agent = WebEnhancedAgent(llm)

# 问题会自动触发搜索
questions = [
    "Blender 4.0 有什么新功能？",
    "2026年最新的 AI 模型有哪些？",
    "Unity 6 什么时候发布？"
]

for q in questions:
    answer = agent.answer_with_search(q)
    print(answer)
```

### 示例 2: 获取技术资讯

```python
# 获取 AI 领域最新资讯
result = agent._get_tech_news("AI")
print(result["summary"])

# 获取 Blender 最新资讯
result = agent._get_tech_news("Blender")
print(result["summary"])
```

### 示例 3: 自动更新知识库

```bash
# 每天运行一次，自动更新
python workflows/auto_update_kb.py
```

---

## 工作流程

```
用户提问
    ↓
判断是否需要最新信息
    ↓
需要 → 网络搜索 → 获取结果 → LLM 总结 → 返回答案
    ↓
不需要 → 直接使用模型知识 → 返回答案
```

---

## 技术栈

| 组件 | 工具 | 说明 |
|------|------|------|
| 搜索引擎 | DuckDuckGo | 免费，无需 API Key |
| 备选搜索 | Serper API | Google 搜索，2500次/月免费 |
| RSS 解析 | feedparser | 解析技术博客订阅 |
| 网页抓取 | BeautifulSoup | 提取网页文本 |
| 向量存储 | ChromaDB | 存储和检索知识 |

---

## 常见问题

### Q1: 搜索速度慢怎么办？

**解决方案：**
- 使用缓存机制
- 限制搜索结果数量
- 使用更快的搜索 API

### Q2: 如何保证信息准确性？

**解决方案：**
- 多个来源交叉验证
- 优先使用官方网站
- 标注信息来源和时间

### Q3: 如何避免重复搜索？

**解决方案：**
- 使用向量数据库缓存结果
- 设置缓存过期时间（如 24 小时）
- 相似问题直接返回缓存

### Q4: 网络搜索失败怎么办？

**解决方案：**
- 降级到模型原有知识
- 提示用户信息可能过时
- 尝试备用搜索源

---

## 最佳实践

### 1. 搜索触发条件

```python
# 自动判断是否需要搜索
keywords = ["最新", "现在", "目前", "2024", "2025", "2026", 
            "实时", "当前", "新版本", "发布"]

needs_search = any(keyword in question for keyword in keywords)
```

### 2. 结果缓存

```python
# 缓存搜索结果 24 小时
cache_key = f"search_{query_hash}"
if cache_key in cache and not expired:
    return cache[cache_key]
```

### 3. 信息来源标注

```python
# 总是标注信息来源
answer = f"""
根据最新搜索结果（{datetime.now().strftime('%Y-%m-%d')}）：

{summary}

来源：
1. {source1}
2. {source2}
"""
```

---

## 进阶功能

### 1. 自动订阅管理

```python
# 添加新的订阅源
TECH_NEWS_SOURCES["MyTopic"] = [
    "https://example.com/feed.xml"
]
```

### 2. 智能摘要

```python
# 根据用户兴趣定制摘要
prompt = f"""
用户关注：{user_interests}
请从以下文章中提取相关信息：
{articles}
"""
```

### 3. 知识图谱

```python
# 构建技术知识图谱
# 实体：技术、版本、发布日期
# 关系：发布、更新、依赖
```

---

## 相关文档

- [Web Enhanced Agent 实现](agents/web_enhanced_agent.py)
- [搜索工具集](tools/web_search_tools.py)
- [自动更新工作流](workflows/auto_update_kb.py)

---

*创建日期: 2026-01-11*
*最后更新: 2026-01-11*
