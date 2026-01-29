---
domain: solution
tags: [vscode-extension, typescript, kiro, knowledge-base, plugin-development]
date: 2026-01-04
source_project: "Kiro-KB-Plugin"
value_score: 9
---

# Kiro Knowledge Base 插件开发指南

## 项目概述

VSCode/Kiro 扩展插件，用于管理项目知识库和中央知识库，支持知识的自动整理、分类、检索和跨项目复用。

## 核心架构

### 1. 双层知识库结构
- **当前项目知识库** (`knowledge-base/`): 项目特定知识，避免重复问题
- **中央知识库** (`D:\G_GitHub\Kiro-Central-KB`): 跨项目复用，通用知识

### 2. 核心模块

| 模块 | 文件 | 功能 |
|------|------|------|
| 入口 | `extension.ts` | 插件激活、命令注册 |
| 侧边栏 | `knowledgePanel.ts` | TreeView 数据提供 |
| 对话整理 | `conversationDigest.ts` | 解析 Kiro 对话历史 |
| 知识整理 | `knowledgeOrganizer.ts` | 分析知识库问题 |
| 中央KB | `centralKnowledge.ts` | 中央知识库操作 |

## 关键技术点

### 1. VSCode Extension API

```typescript
// TreeView 注册
vscode.window.createTreeView('knowledgeBaseView', {
    treeDataProvider: provider,
    showCollapseAll: true
});

// 命令注册
vscode.commands.registerCommand('kb.command', handler);

// 配置读取
vscode.workspace.getConfiguration('kiroKnowledgeBase');
```

### 2. Kiro 对话文件解析

对话历史位置：`~/.kiro/workspace-sessions/{workspaceId}/`

```typescript
// 新版 .json 格式
interface SessionData {
    history: Array<{
        message: {
            role: 'user' | 'assistant';
            content: string | ContentBlock[];
        }
    }>;
}
```

### 3. 知识文件格式

```yaml
---
domain: solution | note | discussion
tags: [tag1, tag2]
date: YYYY-MM-DD
source_project: "项目名"
value_score: 1-10
---

# 标题

## 问题/背景
## 解决方案
## 关键代码
## 注意事项
```

## 常见问题解决

### Q1: 打包后功能缺失
**原因**: `package.json` 中未声明 `contributes`
**解决**: 确保 views、commands、configuration 都在 contributes 中声明

### Q2: TreeView 不显示
**原因**: viewsContainers 和 views 配置不匹配
**解决**: 检查 id 是否一致，确保 when 条件正确

### Q3: 跨设备项目绑定丢失
**原因**: 使用了设备相关的路径
**解决**: 使用 UUID 绑定，存储在 `.kiro-kb-binding.json`

### Q4: 对话解析失败
**原因**: content 格式可能是 string 或 array
**解决**: 同时处理两种格式

## 版本演进要点

| 版本 | 核心功能 |
|------|----------|
| v2.27.x | 侧边栏工具栏增强 |
| v2.30.x | 测试用例完善 |
| v2.31.x | UUID 项目绑定 |
| v2.34.x | 重命名"本地知识"为"当前项目" |
| v2.37.x | 对话整理 + 重复检测 |
| v2.38.x | 知识整理助手 |
| v2.39.x | UTF-8 编码自动修复 |
| v2.40.x | 智能标题生成 |
| v2.41.x | 知识双向链接 |
| v2.44.x | 保存位置选择 + 重复检测增强 |

## 开发流程

1. 修改源码 (`src/`)
2. 编译: `npm run compile`
3. 打包: `npm run package`
4. 安装测试: 右键 .vsix → Install Extension

## 常见踩坑点

### TreeView 刷新问题
```typescript
// 必须触发事件
this._onDidChangeTreeData.fire(undefined);  // 刷新全部
```

### TreeView 三级分组实现
详见：[[20260105-vscode-treeview-hierarchical-grouping-implementation]]
- 项目类型分组 → 项目列表 → 文件列表
- 动态统计和性能优化
- 元数据提取和缓存机制

### 配置变更不生效
```typescript
vscode.workspace.onDidChangeConfiguration(e => {
  if (e.affectsConfiguration('kiro-kb')) reloadConfig();
});
```

### Windows 路径问题
```typescript
// 使用 vscode.Uri 而非字符串
const uri = vscode.Uri.file(path);
await vscode.workspace.fs.readFile(uri);
```

### 异步竞态
```typescript
let isProcessing = false;
async function safeOperation() {
  if (isProcessing) return;
  isProcessing = true;
  try { await doWork(); } finally { isProcessing = false; }
}
```

### 打包后资源丢失
```typescript
// 使用 extensionUri
const resourcePath = vscode.Uri.joinPath(context.extensionUri, 'resources', 'file.json');
```

## 调试技巧

```typescript
// 输出通道
const output = vscode.window.createOutputChannel('Kiro KB');
output.appendLine('Debug info');
output.show();
```

## 注意事项

- 插件应该**指引 Kiro 去做**，而非插件自己做或用户手动让 Kiro 做
- 知识需要**提炼**而非记录原始对话
- 中央知识库需要更强大的归纳系统，构建知识网络
