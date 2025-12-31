# Kiro Knowledge Base Plugin - 功能大纲

> 版本: 2.4.0  
> 更新日期: 2025-12-25

## 插件简介

Kiro Knowledge Base 是一个 VS Code/Kiro 扩展，用于自动保存和检索 Kiro 对话内容到中央知识库，实现跨项目的知识复用和 Token 节省。

---

## 核心功能

### 1. Setup Knowledge Base (初始化设置)
- 设置中央知识库路径
- 自动创建目录结构 (discussions/solutions/notes/backlog)
- 生成 README.md 和 PROGRESS.md
- 配置全局 Steering 规则

### 2. Generate Index (生成索引)
- 扫描知识库所有 .md 文件
- 提取 YAML front-matter 中的 domain 和 tags
- 按领域分类生成 INDEX.md
- 便于快速查找相关内容

### 3. Sync to Central Repository (同步到中央仓库)
- 将当前项目的 knowledge-base 文件夹同步到中央仓库
- 自动添加项目名前缀避免文件名冲突
- 支持增量同步（只同步新文件）

### 4. Open Knowledge Base (打开知识库)
- 在新窗口中打开中央知识库
- 方便浏览和编辑知识内容
- 新增：查看待办问题选项

### 5. Smart Idle Reminder (智能空闲提醒)
- 追踪本次会话的编辑次数和工作时长
- 只有在有足够工作量时才提醒（至少编辑 20 次，工作 5 分钟）
- 显示会话统计信息（工作时长、编辑次数）
- 设置为 0 可禁用此功能

### 6. Error Reporting (错误报告)
- 自动捕获插件运行错误
- 用户可选择是否提交错误报告
- 错误报告保存到 error-reports/
- 可通过 Toggle Error Reporting 命令启用/禁用

### 7. Auto Detect & Sync (自动检测同步)
- 打开项目时自动检测本地 knowledge-base 文件夹
- 检测到新文件时提示同步
- 支持自动同步模式（无需确认）

### 8. Central KB Validation (中央知识库验证)
- 验证配置的路径是否为有效的知识库
- 检查必要目录结构
- 验证失败时提供重新设置选项

### 9. Central KB Check (中央知识库检查)
- 打开中央知识库时自动识别
- 统计缺少 YAML 元数据的文件
- 统计未分类的文件
- 提供智能整理选项

### 10. Auto Sync Option (自动同步选项)
- 配置项 `kiro-kb.autoSync` 控制同步模式
- 关闭（默认）：检测到新文件时提示用户确认
- 开启：自动同步，无需用户确认

### 11. Enhanced Steering Rules (增强 Steering 规则)
- Setup 命令自动创建全局 Steering 规则
- 同时创建工作区级别的知识库关联规则
- 支持问题暂存指令

### 12. Smart Organize (智能整理)
- 打开中央知识库时自动分析内容
- 检测缺少 YAML 元数据的文件
- 生成整理任务清单供 Kiro 执行

### 13. Related Files Detection (关联检测)
- 检测高度相关的文件对
- 关联条件：共同标签 ≥ 2 或相同领域且标题相似
- 生成关联文件分析报告

---

## v2.1.0 新增功能

### 14. Question Backlog (问题暂存系统)
- 暂存问题到待办队列
- 支持优先级标记（高/普通/低）
- 支持问题分类（Bug/功能/灵感/疑问）
- 三种暂存模式：local/central/auto

### 15. Backlog Management (待办管理)
- 查看待办问题列表
- 按优先级和时间排序
- 解决问题自动归档到 solutions/
- 删除问题保留 60 天后自动清理

### 16. Submit to Central (提交到中央)
- 将本地待办提交到中央知识库
- 支持单个提交和批量提交

### 17. Batch Analyze (批量分析)
- 生成批量分析任务文档
- 支持打开时自动询问分析

### 18. Multi-language Support (多语言支持)
- 支持中文和英文界面
- 通过命令切换语言
- 默认中文

### 19. Status Bar Display (状态栏显示)
- 状态栏显示待办数量
- 点击打开待办列表
- 无待办时自动隐藏

### 20. Auto Cleanup (自动清理)
- 删除的问题保留 60 天
- 60 天后检查是否有类似问题
- 无类似问题则彻底删除

---

## v2.2.0 新增功能

### 21. Smart Category Detection (智能分类检测)
- 根据问题关键词自动识别类型
- Bug 关键词：报错、崩溃、失败、不工作、异常...
- Feature 关键词：希望、能不能、想要、添加、实现...
- Idea 关键词：灵感、想法、创意、如果、或许...
- 用户可选择使用检测结果或手动选择

### 22. Smart Priority Detection (智能优先级检测)
- 根据问题关键词自动识别优先级
- 高优先级：紧急、马上、阻塞、严重、生产环境...
- 低优先级：有空、以后、可选、建议、不急...
- 用户可选择使用检测结果或手动选择

### 23. KB Related Search (知识库关联检测)
- 暂存问题时自动搜索知识库
- 匹配标题、内容、标签
- 找到相关内容时提示查看
- 避免重复提问

---

## 配置项

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `kiro-kb.centralPath` | string | "" | 中央知识库路径 |
| `kiro-kb.autoSave` | boolean | true | 自动保存开关 |
| `kiro-kb.autoSync` | boolean | false | 自动同步模式 |
| `kiro-kb.idleReminderMinutes` | number | 10 | 空闲提醒间隔(分钟)，0=禁用 |
| `kiro-kb.errorReportEnabled` | boolean | true | 错误报告功能开关 |
| `kiro-kb.backlogMode` | string | "auto" | 问题暂存模式：local/central/auto |
| `kiro-kb.autoAnalyze` | string | "manual" | Kiro分析时机：manual/onOpen/never |
| `kiro-kb.language` | string | "zh" | 界面语言：zh/en |
| `kiro-kb.reminderDays` | array | [7, 30] | 待办提醒天数 |

---

## 命令列表

| 命令 | 说明 |
|------|------|
| `Kiro KB: 设置知识库` | 设置中央知识库路径 |
| `Kiro KB: 同步到中央仓库` | 同步本地知识到中央 |
| `Kiro KB: 生成索引` | 生成 INDEX.md |
| `Kiro KB: 打开知识库` | 打开中央知识库 |
| `Kiro KB: 切换错误报告` | 启用/禁用错误报告 |
| `Kiro KB: 暂存问题` | 保存问题到待办 |
| `Kiro KB: 查看待办` | 查看待办问题列表 |
| `Kiro KB: 提交到中央` | 提交本地待办到中央 |
| `Kiro KB: 分析待办问题` | 生成批量分析任务 |
| `Kiro KB: 切换语言` | 切换中文/英文 |

---

## 知识库目录结构

```
KiroKnowledgeBase/
├── INDEX.md              # 自动生成的索引
├── PROGRESS.md           # 进度追踪
├── README.md             # 说明文档
├── discussions/          # 问题探讨
├── solutions/            # 解决方案
├── notes/                # 学习笔记
└── backlog/              # 待办问题 (v2.1.0 新增)
    ├── pending/          # 待处理
    ├── draft/            # 已分析草稿
    ├── deleted/          # 已删除（保留60天）
    └── BACKLOG-INDEX.md  # 待办索引
```

---

## 问题文件格式

```yaml
---
id: q-20251224-001
date: 2025-12-24
status: pending          # pending/draft/resolved/deleted
priority: normal         # low/normal/high
priority_auto: false     # 是否自动计算
category: question       # bug/feature/idea/question
source_project: "项目名"
similar_count: 0
last_reminded: 2025-12-24
deleted_date: null
---

# 问题：XXX

问题描述...

---
## Kiro 分析 (草稿)

(待分析)

---
## 解决方案

(待解决)
```

---

## 优先级规则

1. 用户手动标记优先级
2. 未标记时，根据中央知识库中类似问题数量自动提升：
   - 类似问题 ≥ 3 → 高优先级
   - 类似问题 ≥ 2 → 普通优先级
   - 类似问题 < 2 → 低优先级

---

## 安装方式

1. 打开 VS Code/Kiro
2. 按 `Ctrl+Shift+X` 打开扩展面板
3. 点击右上角 `...` → `从 VSIX 安装`
4. 选择 `kiro-knowledge-base-2.1.0.vsix`
5. 重新加载窗口

---

## 使用流程

1. 安装插件后执行 `Kiro KB: 设置知识库`
2. 设置中央知识库路径
3. 日常使用中：
   - 想到问题但无法立即处理 → `暂存问题`
   - 查看待办 → 点击状态栏或执行 `查看待办`
   - 有新知识 → `同步到中央仓库`
4. 定期执行 `生成索引` 更新索引
5. Steering 规则会自动检索和提醒保存

---

## 技术限制

- VS Code 扩展无法直接访问 Kiro 对话内容
- 自动保存功能依赖 Steering 规则实现
- 扩展只能提供定时提醒和工具命令
