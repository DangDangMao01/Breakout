---
domain: kiro
tags: [kiro-kb, plugin, architecture, 项目知识]
date: 2026-01-04
status: active
---

# Kiro Knowledge Base 插件 - 项目知识总结

> 两周开发经验提炼，避免重复踩坑

---

## 🏗️ 项目架构

```
kiro-knowledge-base/
├── extension/                 # 插件源码
│   ├── src/
│   │   ├── extension.ts       # 入口 + 命令注册 + 工具函数
│   │   ├── types.ts           # 类型定义
│   │   ├── i18n.ts            # 国际化
│   │   ├── classifier.ts      # 智能分类引擎（含所有智能模块）
│   │   │   ├── KnowledgeClassifier    # P0: 领域/类型/难度检测
│   │   │   ├── SimilarityDetector     # P1: 相似内容检测
│   │   │   ├── TagManager             # P1: 标签管理
│   │   │   ├── QualityAssessor        # P2: 质量评估
│   │   │   ├── KnowledgeGraphBuilder  # P3: 知识图谱
│   │   │   ├── LifecycleManager       # P4: 生命周期管理
│   │   │   ├── ContextAnalyzer        # P5: 上下文分析
│   │   │   ├── SmartRecommendationEngine # P5: 智能推荐
│   │   │   ├── TFIDFSearchEngine      # P6: 语义搜索
│   │   │   ├── KnowledgeGapAnalyzer   # P7: 缺口分析
│   │   │   ├── HealthAnalyzer         # P8: 健康度仪表盘
│   │   │   └── LearningPathGenerator  # P9: 学习路径
│   │   ├── knowledgeOrganizer.ts # 知识整理助手 (v2.38.0)
│   │   ├── knowledgePanel.ts  # 侧边栏 TreeView
│   │   ├── conversationDigest.ts # 对话整理
│   │   └── test/
│   │       └── extension.test.ts # 单元测试
│   ├── package.json           # 插件清单
│   └── tsconfig.json
├── hooks-templates/           # Agent Hooks 模板
├── docs/                      # 开发文档
├── tests/                     # 测试用例
└── scripts/                   # 构建脚本
```

---

## 🔑 核心模块说明

### 1. extension.ts - 入口文件

**职责：**
- 注册所有命令
- 初始化 TreeView
- 启动后台任务（空闲提醒、自动检测）
- 管理插件生命周期

**关键函数：**
```typescript
activate(context)     // 插件激活
deactivate()          // 插件停用
registerCommands()    // 注册命令
initTreeView()        // 初始化侧边栏
```

### 2. classifier.ts - 智能分类引擎 (P0)

**功能：**
- 领域检测（Unity/Kiro/DevOps/Web/AI/Database）
- 类型检测（solution/tutorial/reference/troubleshooting）
- 难度检测（beginner/intermediate/advanced/expert）
- 标签建议

**使用：**
```typescript
import { classifier } from './classifier';

const result = classifier.classify(content, filename);
// result: { domain, type, difficulty, confidence, suggestedTags }
```

### 3. qualityAssessor.ts - 质量评估 (P2)

**5 个评估维度：**
1. 结构完整性 (25%) - 标题层级、代码块、列表
2. 内容深度 (25%) - 字数、段落、技术术语
3. 元数据完整性 (20%) - YAML front-matter
4. 可读性 (15%) - 句子长度、格式
5. 时效性 (15%) - 更新日期

**使用：**
```typescript
import { qualityAssessor } from './qualityAssessor';

const assessment = qualityAssessor.assess(content, metadata);
// assessment: { score, grade, dimensions, suggestions, needsReview }
```

### 4. conversationDigest.ts - 对话整理 (v2.35.0)

**核心理念：**
- 用户的问题 = 小白会遇到的问题
- Kiro 的回答 = 解决方案

**价值评分规则：**
- 基础分 3 分（有问有答就有价值）
- 内容丰富度：>300字符 +1，>1000字符 +2，>3000字符 +3
- 有代码示例 +2
- 多轮对话 (>6轮) +1
- 问题解决类 +1
- 最高 10 分

---

## ⚠️ 常见踩坑点

### 1. TreeView 刷新问题

**问题：** 修改数据后界面不更新

**解决：**
```typescript
// 必须触发事件
this._onDidChangeTreeData.fire(undefined);  // 刷新全部
this._onDidChangeTreeData.fire(item);       // 刷新单个节点
```

### 2. 配置读取时机

**问题：** 配置变更后不生效

**解决：**
```typescript
// 监听配置变化
vscode.workspace.onDidChangeConfiguration(e => {
  if (e.affectsConfiguration('kiro-kb')) {
    reloadConfig();
  }
});
```

### 3. 文件路径问题

**问题：** Windows 中文路径、跨盘符操作

**解决：**
```typescript
// 使用 vscode.Uri 而非字符串
const uri = vscode.Uri.file(path);
await vscode.workspace.fs.readFile(uri);

// 跨盘符复制
await vscode.workspace.fs.copy(srcUri, destUri, { overwrite: true });
```

### 4. 异步操作竞态

**问题：** 快速点击导致数据错乱

**解决：**
```typescript
let isProcessing = false;

async function safeOperation() {
  if (isProcessing) return;
  isProcessing = true;
  try {
    await doWork();
  } finally {
    isProcessing = false;
  }
}
```

### 5. WebView 状态丢失

**问题：** 切换标签页后 WebView 重置

**解决：**
```typescript
const panel = vscode.window.createWebviewPanel(
  'myWebview', 'Title', vscode.ViewColumn.One,
  { retainContextWhenHidden: true }  // 关键配置
);
```

### 6. 打包后资源丢失

**问题：** 开发正常，打包后找不到文件

**解决：**
```typescript
// 使用 extensionUri
const resourcePath = vscode.Uri.joinPath(
  context.extensionUri, 
  'resources', 
  'file.json'
);
```

---

## 📋 开发流程

### 添加新命令

1. `package.json` 添加命令定义
2. `extension.ts` 注册命令处理函数
3. 如需菜单，添加 `menus` 配置
4. 更新 `README.md` 文档

### 添加新配置项

1. `package.json` 的 `configuration` 添加属性
2. `types.ts` 更新类型定义
3. 使用处读取配置
4. 更新文档

### 发布新版本

```bash
# 1. 更新版本号
npm version patch/minor/major

# 2. 编译
npm run compile

# 3. 打包
vsce package

# 4. 测试安装
# 在新窗口安装 .vsix 测试

# 5. 更新文档
# README.md 更新日志
```

---

## 🔧 调试技巧

### 查看日志

```typescript
// 使用输出通道
const output = vscode.window.createOutputChannel('Kiro KB');
output.appendLine('Debug info');
output.show();
```

### 断点调试

1. 按 F5 启动调试
2. 在 Extension Development Host 窗口测试
3. 在源码设置断点

### 检查配置

```typescript
// 打印当前配置
const config = vscode.workspace.getConfiguration('kiro-kb');
console.log(JSON.stringify(config, null, 2));
```

---

## 📊 版本里程碑

| 版本 | 核心功能 |
|------|----------|
| v1.x | 基础同步、错误捕获 |
| v2.0-2.10 | 问题暂存、模板系统 |
| v2.11-2.20 | 侧边栏、收藏夹、关联图 |
| v2.21-2.30 | 智能分类、质量评估、项目绑定 |
| v2.31-2.38 | 健康度仪表盘、学习路径、对话整理、知识整理助手 |
| v2.39-2.43 | 编码修复、智能标题、双向链接、知识提炼 |

---

## 🔗 相关文档

- [PLUGIN-OVERVIEW.md](../../PLUGIN-OVERVIEW.md) - 功能大纲
- [README.md](../../extension/README.md) - 用户文档

---

*最后更新：2026-01-04*
