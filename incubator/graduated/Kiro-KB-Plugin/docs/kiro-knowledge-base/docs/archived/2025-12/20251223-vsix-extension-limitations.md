---
date: 2025-12-23
domain: kiro
tags: [vsix, extension, limitations, auto-save]
status: reference
---

# VSIX 扩展功能限制

## 发现的问题

用户希望扩展能在 10 分钟无操作时自动保存对话内容。

## 技术限制

**VS Code 扩展无法直接访问 Kiro 的对话内容** - 这是 Kiro 内部数据。

## 当前扩展功能

- Setup（初始化）
- Sync（手动同步）
- Generate Index（生成索引）
- Open Knowledge Base（打开知识库）

## 可行方案

自动保存功能需要依赖 **Steering 规则**（Kiro 可以访问对话），扩展只能：
1. 设置定时提醒
2. 触发 Steering 规则执行保存

## 结论

- 扩展负责：配置、同步、索引
- Steering 规则负责：对话内容保存
- 两者配合实现完整功能
