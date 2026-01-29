# Kiro KB v3.0 重构计划

> 2026-01-12 创建
> 
> **问题**：代码臃肿（extension.ts 11,308 行），功能重复混乱（40+ 命令），维护困难
> 
> **目标**：精简、清晰、可维护

## 📊 当前状态分析

### 代码规模
- `extension.ts`: **11,308 行** ❌ 太大了
- 40+ 个命令 ❌ 太多了
- 2 套面板代码（KnowledgePanelProvider + SimplifiedPanelProvider）❌ 重复了

### 核心问题
1. **功能重复**：两套面板，不知道用哪个
2. **代码混乱**：所有功能都塞在 extension.ts
3. **维护困难**：AI 无法一次性读完代码
4. **用户困惑**：40+ 命令，不知道用哪个

### 已知 Bug
- v2.53.0 侧边栏没有显示"领域分类"节点
- **根因**：修改了 SimplifiedPanelProvider，但插件用的是 KnowledgePanelProvider

## 🎯 重构目标

### 1. 精简命令（40+ → 6 个核心）

**核心命令**（用户常用）：
- `kiro-kb.setup` - 设置知识库
- `kiro-kb.saveQuestion` - 暂存问题（Ctrl+Alt+Q）
- `kiro-kb.searchWithScope` - 搜索知识库（Ctrl+Alt+K）
- `kiro-kb.sync` - 同步到中央
- `kiro-kb.showHelp` - 帮助
- `kiro-kb.digestConversations` - 整理对话（Kiro IDE 专属）

**辅助功能**（通过侧边栏或设置访问）：
- 标签管理
- 质量评估
- 知识图谱
- Git 同步
- 等等...

**移除功能**（实验性、未完成、重复）：
- 项目绑定相关（未完成）
- 知识缺口分析（实验性）
- 学习路径生成（实验性）
- 重复的导出/搜索命令

### 2. 统一面板（2 套 → 1 套）

**保留**：SimplifiedPanelProvider（v2.52.0 新版）
- 更简洁
- 层级更少
- 智能显示

**移除**：KnowledgePanelProvider（旧版）
- 功能重复
- 代码冗余

### 3. 拆分 extension.ts（11,308 行 → 模块化）

**建议结构**：
```
extension/src/
├── extension.ts          (主入口，200-300 行)
├── commands/             (命令处理)
│   ├── setup.ts
│   ├── save.ts
│   ├── search.ts
│   ├── sync.ts
│   └── digest.ts
├── panels/               (面板)
│   └── simplifiedPanel.ts
├── core/                 (核心功能)
│   ├── knowledgeBase.ts
│   ├── indexGenerator.ts
│   └── fileScanner.ts
├── features/             (辅助功能)
│   ├── tags.ts
│   ├── quality.ts
│   ├── graph.ts
│   └── git.ts
├── utils/                (工具函数)
│   ├── file.ts
│   ├── yaml.ts
│   └── validation.ts
└── types.ts              (类型定义)
```

## 📋 重构步骤（明天执行）

### Phase 1: 分析和备份（30 分钟）✅ 已完成
1. ✅ 统计代码规模（已完成：11,308 行）
2. ✅ 列出所有命令（已完成：40+ 个）
3. ✅ 分析命令使用频率（已完成：见 FEATURE-DETAILED-LIST.md）
4. ✅ 备份当前版本（Git tag: v2.53.0-before-refactor）
5. ✅ 创建统一面板基础结构（panels/knowledgePanel.ts）
6. ✅ 创建模块化目录结构（commands/, core/, features/, utils/）
7. ✅ 创建精简主入口（extension.v3.ts）

### Phase 2: 精简命令（1 小时）⏳ 进行中
1. ⏳ 创建命令分类表（保留/移除/合并）
2. ⏳ 从 package.json 移除不需要的命令
3. ⏳ 从 extension.ts 移除对应的注册代码
4. ⏳ 测试核心命令是否正常

### Phase 3: 统一面板（30 分钟）
1. [ ] 确认 SimplifiedPanelProvider 功能完整
2. [ ] 修改 extension.ts，改用 SimplifiedPanelProvider
3. [ ] 删除 knowledgePanel.ts
4. [ ] 测试侧边栏功能

### Phase 4: 拆分 extension.ts（2 小时）
1. [ ] 创建目录结构（commands/, core/, features/, utils/）
2. [ ] 提取命令处理函数到 commands/
3. [ ] 提取核心功能到 core/
4. [ ] 提取辅助功能到 features/
5. [ ] 提取工具函数到 utils/
6. [ ] 更新 extension.ts 导入

### Phase 5: 测试和验证（30 分钟）
1. [ ] 编译测试
2. [ ] 功能测试（核心命令）
3. [ ] 打包测试
4. [ ] 更新文档

## 🎨 用户体验改进

### 侧边栏（SimplifiedPanelProvider）
```
📚 Knowledge Base
├─ 🔍 搜索              (点击打开搜索)
├─ 📚 浏览              (展开)
│  ├─ ✅ 问题解决 (31)
│  ├─ 💬 技术探讨 (16)
│  └─ 📒 学习笔记 (18)
├─ 🎯 领域分类          (v2.53.0 新增)
│  ├─ 🛠️ tools
│  ├─ 💻 programming
│  ├─ 🤖 ai
│  └─ ...
├─ 🕐 最近 (10)
├─ 🏷️ 标签 (88)
├─ ❓ 帮助
└─ ⚙️ 设置
```

### 命令面板（Ctrl+Shift+P）
```
Kiro KB: 设置知识库
Kiro KB: 搜索知识库 (Ctrl+Alt+K)
Kiro KB: 暂存问题 (Ctrl+Alt+Q)
Kiro KB: 同步到中央
Kiro KB: 整理对话 (Kiro IDE)
Kiro KB: 帮助
```

## 📝 文档更新

需要更新的文档：
- [ ] README.md - 更新功能列表
- [ ] CHANGELOG.md - 记录重构变更
- [ ] SESSION-STATE.md - 更新当前状态
- [ ] FEATURE-ARCHITECTURE.md - 更新架构图
- [ ] FEATURE-DETAILED-LIST.md - 更新功能清单

## ⚠️ 风险和注意事项

1. **向后兼容**：用户可能在用某些命令
   - 解决：保留核心命令，移除实验性功能
   
2. **数据迁移**：面板切换可能影响收藏夹等
   - 解决：SimplifiedPanelProvider 已支持收藏夹
   
3. **测试覆盖**：重构后需要全面测试
   - 解决：按 Phase 5 的测试清单执行

## 🚀 预期效果

### 代码质量
- extension.ts: 11,308 行 → **300 行**
- 命令数量: 40+ → **6 个核心**
- 面板代码: 2 套 → **1 套**

### 用户体验
- 命令面板更清爽
- 侧边栏更简洁
- 功能更聚焦

### 开发效率
- AI 可以完整读取代码
- 模块化，易于维护
- 清晰的职责划分

## 📅 时间安排

**明天（2026-01-13）**：
- 上午：Phase 1-3（分析、精简、统一面板）
- 下午：Phase 4-5（拆分代码、测试验证）
- 预计总时间：4-5 小时

**版本号**：v3.0.0（大版本重构）

---

## 💭 反思

**为什么会变成这样？**
1. 功能不断叠加，没有及时重构
2. 实验性功能没有及时清理
3. 缺少模块化设计

**如何避免再次臃肿？**
1. 新功能先在独立模块开发
2. 定期清理实验性功能
3. 保持 extension.ts 简洁（只做注册）
4. 每个版本控制新增功能数量

**核心原则**：
> 少即是多。专注核心价值，而不是功能堆砌。
