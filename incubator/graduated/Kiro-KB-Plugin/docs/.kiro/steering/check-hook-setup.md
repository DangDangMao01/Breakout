---
inclusion: always
---

# Check Hook Setup

现有 Hooks：
- `auto-save-knowledge.json` - 会话结束时自动评估并保存有价值内容到知识库
- `auto-save-session.json` - 会话结束时提醒更新 SESSION-STATE.md

两个 Hook 都是 `onAgentComplete` 触发，会话结束时自动执行。
