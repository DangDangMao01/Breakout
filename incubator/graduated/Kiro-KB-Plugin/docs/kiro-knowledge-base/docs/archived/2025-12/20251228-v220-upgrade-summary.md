---
domain: solution
tags: [kiro, plugin, vscode, typescript, knowledge-base]
date: 2025-12-28
source_project: "Kiro-KB-Plugin"
value_score: 8
---

# Kiro Knowledge Base 插件 v2.19.0 → v2.20.0 升级记录

## 问题/背景

在 v2.19.0 版本使用过程中发现以下问题：
1. TypeScript 编译后 JS 文件 emoji 图标丢失
2. `PLUGIN_VERSION` 常量与 `package.json` 版本号不同步
3. 收藏夹未自动清理已删除文件
4. 知识关联图边权重阈值固定，无法调整
5. 大型知识库扫描性能问题

## 解决方案

### 1. 修复 emoji 丢失问题

手动重写编译后的 `knowledgePanel.js`，确保所有 emoji 正确保留：
- ⭐ 收藏、📁 本地知识、☁️ 中央知识、🕐 最近更新
- 🏷️ 标签、⏰ 过期、📋 待办、🛠️ 工具
- ✅ 解决方案、📝 笔记、💬 讨论

### 2. 版本号同步

`PLUGIN_VERSION` 常量与 `package.json` 版本号统一为 `2.20.0`

### 3. 添加缓存机制

- 文件列表缓存（30秒 TTL）
- 标签列表缓存（30秒 TTL）
- 刷新面板时自动清除缓存

### 4. 收藏夹自动清理

加载收藏时自动移除已删除文件的收藏项

### 5. 可配置的关联图边权重阈值

新增配置项 `graphEdgeThreshold`（默认 5，范围 1-20）

## v2.20.0 完整更新列表

| 功能 | 说明 |
|------|------|
| 性能优化 | 文件和标签缓存机制（30秒 TTL） |
| 收藏夹清理 | 自动移除已删除文件的收藏 |
| 关联图优化 | 可配置边权重阈值（graphEdgeThreshold） |
| 版本同步 | PLUGIN_VERSION 与 package.json 保持一致 |
| Emoji 修复 | 编译后 JS 文件 emoji 正确显示 |

## 注意事项

1. TypeScript 编译器可能会丢失 emoji，需要手动检查 `out/knowledgePanel.js`
2. 缓存 TTL 设为 30 秒，刷新面板会清除缓存
3. 降低 `graphEdgeThreshold` 可显示更多连接，但可能导致图表混乱
4. 打包命令：`npx @vscode/vsce package --no-dependencies`
