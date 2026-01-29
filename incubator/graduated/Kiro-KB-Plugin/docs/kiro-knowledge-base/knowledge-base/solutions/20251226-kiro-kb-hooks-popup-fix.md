---
domain: kiro-plugin
tags: [hooks, popup, fix, configuration]
date: 2025-12-26
source_project: "Kiro-KB-Plugin"
value_score: 7
---

# Kiro KB 插件 Hooks 弹窗问题修复

## 问题/背景

Kiro KB 插件在使用过程中频繁弹出对话框，影响正常开发操作。

## 原因分析

检查 `.kiro/hooks/` 目录发现两个自动触发的 hooks：

| Hook | 触发条件 | 问题 |
|------|----------|------|
| `auto-save-knowledge.json` | `onAgentComplete` | 每次对话结束都会触发评估弹窗 |
| `auto-search-kb.json` | `onSessionCreate` | 每次新会话都会发消息 |

## 解决方案

将这两个 hooks 改为手动触发模式：

```json
// auto-save-knowledge.json
{
  "name": "自动保存知识",
  "enabled": false,
  "trigger": {
    "type": "manual",
    "label": "📊 评估并保存对话"
  }
}

// auto-search-kb.json  
{
  "name": "自动检索知识库",
  "enabled": false,
  "trigger": {
    "type": "onSessionCreate"
  }
}
```

## 关键点

1. `onAgentComplete` 触发器会在每次 agent 完成时触发，不适合频繁操作
2. 知识库检索功能已通过 steering 规则实现，不需要额外 hook
3. 手动触发模式更可控，需要时在 Agent Hooks 面板点击即可

## 注意事项

- Hooks 的 `enabled: false` 可以禁用自动触发
- 改为 `"type": "manual"` 后需要手动点击触发
- Steering 规则是更好的自动化方式，不会产生弹窗干扰
