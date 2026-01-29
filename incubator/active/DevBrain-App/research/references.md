# DevBrain-App 参考资料

**整理日期**: 2026-01-29

---

## 📚 技术参考

### 超长记忆上下文

1. **Clawdbot**
   - 需要调研：技术原理、实现方式
   - 关键词：超长记忆、上下文管理

2. **Claude Code**
   - 需要调研：如何实现持久化上下文
   - 关键词：代码理解、项目上下文

3. **RAG (Retrieval-Augmented Generation)**
   - 论文：[Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks](https://arxiv.org/abs/2005.11401)
   - 技术：向量搜索 + LLM 生成

4. **MemGPT**
   - GitHub: [cpacker/MemGPT](https://github.com/cpacker/MemGPT)
   - 技术：分层记忆管理

### 向量数据库

1. **Chroma**
   - 官网: https://www.trychroma.com/
   - 特点：轻量级、本地优先、易用
   - 适合：个人用户、快速原型

2. **Pinecone**
   - 官网: https://www.pinecone.io/
   - 特点：云服务、高性能、可扩展
   - 适合：生产环境、大规模应用

3. **Weaviate**
   - 官网: https://weaviate.io/
   - 特点：开源、功能全面、支持多模态
   - 适合：复杂场景、自定义需求

4. **Qdrant**
   - 官网: https://qdrant.tech/
   - 特点：Rust 编写、高性能、开源
   - 适合：性能要求高的场景

### 知识图谱

1. **Neo4j**
   - 官网: https://neo4j.com/
   - 特点：成熟、功能强大、社区活跃
   - 适合：复杂关系、图查询

2. **ArangoDB**
   - 官网: https://www.arangodb.com/
   - 特点：多模型、灵活、性能好
   - 适合：混合场景

3. **NetworkX (Python)**
   - 官网: https://networkx.org/
   - 特点：轻量级、易用、适合原型
   - 适合：快速验证、小规模

### 桌面应用框架

1. **Electron**
   - 官网: https://www.electronjs.org/
   - 特点：成熟、生态丰富、跨平台
   - 缺点：体积大、性能一般

2. **Tauri**
   - 官网: https://tauri.app/
   - 特点：轻量级、性能好、Rust 编写
   - 优势：体积小、安全性高

3. **Flutter Desktop**
   - 官网: https://flutter.dev/desktop
   - 特点：跨平台、UI 美观、性能好
   - 适合：需要精美 UI 的应用

### 本地 AI

1. **Ollama**
   - 官网: https://ollama.ai/
   - 特点：易用、支持多模型、本地运行
   - 模型：Llama, Mistral, Qwen 等

2. **LM Studio**
   - 官网: https://lmstudio.ai/
   - 特点：GUI、易用、支持多模型
   - 适合：非技术用户

3. **llama.cpp**
   - GitHub: [ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp)
   - 特点：高性能、C++ 实现、跨平台
   - 适合：性能优化、嵌入式

---

## 🎨 设计参考

### 知识管理工具

1. **Notion**
   - 优点：UI 美观、功能强大
   - 学习：数据库设计、模板系统

2. **Obsidian**
   - 优点：本地优先、插件生态
   - 学习：知识图谱可视化、双向链接

3. **Logseq**
   - 优点：大纲式、开源
   - 学习：块级编辑、查询语言

### AI 工具

1. **Cursor**
   - 优点：深度集成、代码理解
   - 学习：AI 交互设计、上下文管理

2. **GitHub Copilot**
   - 优点：无缝集成、智能补全
   - 学习：AI 辅助编程

3. **Perplexity**
   - 优点：搜索 + AI、引用来源
   - 学习：信息检索、可信度

---

## 📖 理论基础

### AI 哲学

1. **意识涌现**
   - 参考：`research/ai-philosophy/ideas/20260128-AI的胎儿期与成长哲学.md`
   - 核心："我" 是知识积累的涌现

2. **神经网络式架构**
   - 参考：`research/ai-philosophy/ideas/20260128-AI系统的神经网络式架构思想.md`
   - 核心：模仿大脑的拓扑结构

3. **Training-Free GRPO**
   - 腾讯 AI Lab, 2025
   - 核心：经验积累系统

### 认知科学

1. **工作记忆 vs 长期记忆**
   - 理论：Baddeley 的工作记忆模型
   - 应用：分层记忆系统

2. **小世界网络**
   - 论文：Watts & Strogatz, 1998
   - 应用：知识图谱设计

3. **神经可塑性**
   - 理论：Hebbian Learning
   - 应用：Skills 自动生成

---

## 🔬 技术论文

### 必读

1. **Retrieval-Augmented Generation**
   - 作者：Lewis et al., 2020
   - 链接：https://arxiv.org/abs/2005.11401

2. **MemGPT: Towards LLMs as Operating Systems**
   - 作者：Packer et al., 2023
   - 链接：https://arxiv.org/abs/2310.08560

3. **LongMem: Augmenting Large Language Models with Long-Term Memory**
   - 作者：Wang et al., 2023
   - 链接：https://arxiv.org/abs/2306.07174

### 扩展阅读

1. **Vector Database Benchmarks**
   - 对比：Chroma, Pinecone, Weaviate, Qdrant
   - 指标：性能、易用性、成本

2. **Knowledge Graph Construction**
   - 方法：实体识别、关系抽取
   - 工具：spaCy, Stanford NLP

3. **Embedding Models**
   - OpenAI: text-embedding-ada-002
   - 开源：sentence-transformers
   - 对比：性能、成本、隐私

---

## 🌐 社区资源

### Reddit

- r/ChatGPT - ChatGPT 讨论
- r/LocalLLaMA - 本地 AI 讨论
- r/ObsidianMD - Obsidian 用户
- r/Notion - Notion 用户

### Discord

- Cursor Discord
- Ollama Discord
- LangChain Discord

### GitHub

- awesome-chatgpt-prompts
- awesome-local-llm
- awesome-knowledge-graph

---

## 📝 待调研

### 高优先级

1. **Clawdbot / Claude Code 技术原理**
   - 如何实现超长记忆？
   - 使用了什么技术栈？
   - 性能如何？

2. **向量数据库性能对比**
   - Chroma vs Pinecone vs Weaviate
   - 本地 vs 云服务
   - 成本分析

3. **本地 AI 能力边界**
   - Ollama 能做什么？
   - 性能如何？
   - 如何集成？

### 中优先级

1. **知识图谱构建方法**
   - 自动 vs 手动
   - 实体识别准确率
   - 关系抽取方法

2. **Embedding 模型选择**
   - OpenAI vs 开源
   - 多语言支持
   - 成本对比

3. **桌面应用框架选择**
   - Electron vs Tauri
   - 性能对比
   - 开发体验

---

## 🎯 下一步

1. **深入调研 Clawdbot / Claude Code**
   - 搜索技术文档
   - 分析实现原理
   - 评估可行性

2. **技术选型**
   - 向量数据库
   - 知识图谱
   - 桌面框架

3. **原型开发**
   - MVP 功能
   - 技术验证
   - 性能测试

---

**更新时间**: 2026-01-29  
**下次更新**: 待定
