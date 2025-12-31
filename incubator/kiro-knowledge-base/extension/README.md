# Kiro Knowledge Base

> 版本 2.4.0 | Version 2.4.0

自动保存和检索 Kiro 对话到中央知识库，实现跨项目知识复用。

Auto-save and retrieve Kiro conversations to a central knowledge base for cross-project knowledge reuse.

---

## 功能概览 / Features Overview

### 🔧 自动功能 (安装后自动启用) / Auto Features

| 功能 | 说明 |
|------|------|
| 📂 自动检测同步 | 打开项目时检测本地知识库，提示同步到中央 |
| 📋 待办问题提醒 | 状态栏显示待办数量，打开时提醒处理 |
| ⏰ 智能空闲提醒 | 工作一段时间后提醒保存有价值内容 |
| 🔍 知识库验证 | 自动验证中央知识库路径和结构 |
| 🧹 自动清理 | 删除的问题保留60天后自动清理 |

### 🎛️ 手动功能 (需用户触发) / Manual Features

| 命令 | 说明 |
|------|------|
| `Kiro KB: 设置知识库` | 设置中央知识库路径，创建目录结构 |
| `Kiro KB: 同步到中央仓库` | 将本地知识库同步到中央 |
| `Kiro KB: 生成索引` | 生成 INDEX.md 索引文件 |
| `Kiro KB: 打开知识库` | 打开中央知识库 |
| `Kiro KB: 暂存问题` | 保存问题到待办队列 |
| `Kiro KB: 查看待办` | 查看和处理待办问题 |
| `Kiro KB: 提交到中央` | 将本地待办提交到中央知识库 |
| `Kiro KB: 分析待办问题` | 生成批量分析任务 |
| `Kiro KB: 切换语言` | 切换中文/英文界面 |

---

## 配置项 / Settings

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| `kiro-kb.centralPath` | "" | 中央知识库路径 |
| `kiro-kb.autoSync` | false | 自动同步模式（无需确认） |
| `kiro-kb.backlogMode` | "auto" | 问题暂存模式：local/central/auto |
| `kiro-kb.autoAnalyze` | "manual" | Kiro分析时机：manual/onOpen/never |
| `kiro-kb.language` | "zh" | 界面语言：zh/en |
| `kiro-kb.idleReminderMinutes` | 10 | 空闲提醒间隔（分钟），0=禁用 |
| `kiro-kb.reminderDays` | [7, 30] | 待办提醒天数 [警告, 严重] |
| `kiro-kb.errorReportEnabled` | true | 启用错误报告 |

### 配置说明 / Settings Guide

**backlogMode 问题暂存模式：**

| 模式 | 说明 | 适用场景 |
|------|------|----------|
| `local` | 问题只保存到当前项目的 `knowledge-base/backlog/` | 项目相关问题，不想污染中央库 |
| `central` | 问题直接保存到中央知识库的 `backlog/pending/` | 通用问题，希望集中管理 |
| `auto` | 保存到本地，打开项目时提醒是否提交到中央 | 推荐！灵活选择 |

**如何修改暂存模式：**
1. 按 `Ctrl+,` 打开设置
2. 搜索 `kiro-kb.backlogMode`
3. 选择 `local`、`central` 或 `auto`

**autoAnalyze Kiro分析时机：**

| 模式 | 说明 |
|------|------|
| `manual` | 手动执行 `Kiro KB: 分析待办问题` 触发 |
| `onOpen` | 打开中央知识库时自动询问是否批量分析 |
| `never` | 从不自动分析，完全手动控制 |

---

## 问题暂存系统 / Question Backlog System

### 使用流程 / How to Use

**暂存问题：**
1. 按 `Ctrl+Shift+P`，执行 `Kiro KB: 暂存问题`
2. 输入问题描述（如："如何优化这个算法？"）
3. 选择优先级：🔴高 / 🟡普通 / 🟢低
4. 选择类型：🐛Bug / ✨功能 / 💡灵感 / ❓疑问
5. 完成！问题已保存

**处理待办：**
1. 点击状态栏 `📋 待办: X` 或执行 `Kiro KB: 查看待办`
2. 选择要处理的问题
3. 选择操作：
   - ✅ 解决 → 归档到 solutions/
   - 🤖 让 Kiro 分析 → 获取 AI 建议
   - ☁️ 提交到中央 → 移到中央知识库
   - 🗑️ 删除 → 保留 60 天后清理

### 生命周期 / Lifecycle

```
创建 → pending → draft → resolved → archived (solutions/)
         ↓
      deleted → 60天后自动清理
```

### 优先级规则 / Priority Rules

1. 用户手动标记优先级
2. 未标记时，根据中央知识库中类似问题数量自动提升：
   - 类似问题 ≥ 3 → 高优先级
   - 类似问题 ≥ 2 → 普通优先级
   - 类似问题 < 2 → 低优先级

### 排序规则 / Sort Order

1. 先按优先级：高 → 普通 → 低
2. 同优先级按时间：旧 → 新

---

## 快速开始 / Quick Start

1. 安装插件 / Install extension
2. 按 `Ctrl+Shift+P`，执行 `Kiro KB: 设置知识库`
3. 输入中央知识库路径（如 `D:\KiroKnowledgeBase`）
4. 开始使用！

### 日常使用 / Daily Usage

- **暂存问题**：想到问题但无法立即处理时，执行 `Kiro KB: 暂存问题`
- **查看待办**：点击状态栏的待办图标，或执行 `Kiro KB: 查看待办`
- **同步知识**：项目中有新知识时，执行 `Kiro KB: 同步到中央仓库`

---

## 目录结构 / Directory Structure

```
KiroKnowledgeBase/
├── INDEX.md              # 索引文件
├── PROGRESS.md           # 进度追踪
├── README.md             # 说明文档
├── discussions/          # 问题探讨
├── solutions/            # 解决方案
├── notes/                # 学习笔记
└── backlog/              # 待办问题
    ├── pending/          # 待处理
    ├── draft/            # 已分析草稿
    ├── deleted/          # 已删除（保留60天）
    └── BACKLOG-INDEX.md  # 待办索引
```

---

## 问题反馈 / Feedback

- GitHub: https://github.com/DangDangMao01/Kiro_work
- Email: dangdangshijie@gmail.com

---

## 更新日志 / Changelog

### v2.4.0 (2025-12-25)
- ✨ 每日提醒功能（reminder_mode: daily）
- 🔔 打开 Kiro 时自动检测并提醒每日待思考的想法

### v2.3.0 (2025-12-25)
- ✨ 状态栏添加 💡 快速记录按钮
- ✨ 快捷键 `Ctrl+Alt+Q` 快速暂存问题

### v2.2.1 (2025-12-25)
- 🐛 修复本地待办保存路径问题（改为 pending/ 子目录）
- 🐛 修复 viewBacklog 扫描本地待办的路径问题

### v2.2.0 (2025-12-24)
- ✨ 智能分类检测（自动识别 Bug/Feature/Idea）
- ✨ 智能优先级检测（自动识别紧急/普通/低优先级）
- ✨ 知识库关联检测（暂存时搜索相关内容）

### v2.1.0 (2025-12-24)
- ✨ 新增问题暂存系统（待办队列）
- ✨ 新增多语言支持（中文/英文）
- ✨ 新增状态栏待办显示
- ✨ 新增问题优先级和分类
- ✨ 新增自动清理过期删除问题
- ✨ 新增批量分析功能

### v2.0.0 (2025-12-24)
- ✨ 智能整理功能
- ✨ 关联文件检测

### v1.9.0 (2025-12-24)
- ✨ 增强 Steering 规则

### v1.8.3 (2025-12-24)
- ✨ 自动同步/手动同步选项
