# Kiro KB Hooks 模板

这些是预配置的 Kiro Agent Hooks 模板，用于自动化知识库管理。

## 安装方法

### 方法一：手动复制（推荐）

1. 将需要的 `.json` 文件复制到你项目的 `.kiro/hooks/` 目录
2. 修改文件中的 `{{CENTRAL_KB_PATH}}` 为你的实际知识库路径
3. 重启 Kiro 或刷新 Agent Hooks 面板

### 方法二：通过 Kiro UI 创建

1. 在 Kiro 侧边栏找到 "Agent Hooks" 面板
2. 点击 `+` 按钮
3. 输入描述（如 "auto save kb"），Kiro 会自动创建

## 模板说明

| 文件 | 触发时机 | 功能 |
|------|----------|------|
| `auto-save-knowledge.json` | 会话结束 | 智能评估（10分制）并保存有价值内容，自动向用户反馈结果 |
| `auto-search-kb.json` | 新会话开始 | 自动检索知识库相关内容 |
| `auto-update-index.json` | 知识库文件变更 | 自动更新 INDEX.md 索引 |
| `daily-review.json` | 手动触发 | 提醒回顾待办问题 |

## 配置说明

所有模板中的 `{{CENTRAL_KB_PATH}}` 需要替换为你的实际路径，例如：
- Windows: `D:\\G_GitHub\\Kiro-Central-KB`
- macOS/Linux: `/Users/yourname/KiroKnowledgeBase`

**注意：** Windows 路径需要使用双反斜杠 `\\`

## 触发类型说明

| 类型 | 说明 |
|------|------|
| `onAgentComplete` | Agent 执行完成后触发 |
| `onSessionCreate` | 新会话创建时触发 |
| `onFileEdit` | 文件编辑保存时触发 |
| `manual` | 用户手动点击触发 |

## 自定义 Hook

你可以基于这些模板创建自己的 Hook，修改 `message` 字段来定制 Agent 的行为。
