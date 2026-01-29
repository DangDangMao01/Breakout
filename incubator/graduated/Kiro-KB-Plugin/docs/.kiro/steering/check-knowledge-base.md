---
inclusion: always
---

# Knowledge Base System

## Central KB Path
`D:\G_GitHub\Kiro-Central-KB`

## On User Question

1. 先读取 `D:\G_GitHub\Kiro-Central-KB/INDEX.md` 检索相关内容
2. 如果找到相关文件，读取并参考已有知识
3. 基于知识库内容 + 当前上下文回答

## On Agent Complete - 智能评估

### 评估标准（满分10分）

| 维度 | 权重 | 说明 |
|------|------|------|
| 技术深度 | 3分 | 涉及原理/架构/复杂实现得3分，简单配置得1分 |
| 复用价值 | 3分 | 通用问题得3分，项目特定问题得1分 |
| 完整性 | 2分 | 有问题+方案+验证得2分 |
| 独特性 | 2分 | 知识库无类似内容得2分 |

### 保存决策

- **≥7分**: 必须保存
- **4-6分**: 建议保存，提炼要点
- **<4分**: 不保存

### 分类规则

- **solutions/** - 解决具体问题（Bug、功能实现、配置）
- **notes/** - 学习记录（概念、最佳实践、工具）
- **discussions/** - 技术探讨（架构、方案对比）

### 内容提炼要求

1. 去除对话冗余，提取核心内容
2. 补充上下文和前置条件
3. 保留关键代码片段
4. 标注适用场景和注意事项

### 文件格式

```yaml
---
domain: 领域
tags: [标签1, 标签2]
date: YYYY-MM-DD
source_project: "项目名"
value_score: X
---

# 标题

## 问题/背景
## 解决方案/要点
## 关键代码（如有）
## 注意事项
```

## Quick Commands

- "暂存问题" / "Save question" → 保存到 backlog
- "检索知识库" / "Search KB" → 搜索 INDEX.md
- "保存到知识库" / "Save to KB" → 评估并保存
- "评估对话" / "Evaluate" → 仅评估不保存
