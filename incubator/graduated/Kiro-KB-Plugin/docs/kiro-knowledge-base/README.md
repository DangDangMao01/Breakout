# Kiro Knowledge Base Plugin

> 版本 2.53.0 | 动态知识架构 - 让知识库随你的工作方向成长

自动保存和检索 Kiro 对话知识的插件。

## 🔄 v3.0.0 进行中 - 大重构（2026-01-13）

**重构目标**：模块化、精简、易维护

**核心变化**：
- 📦 代码规模：extension.ts 11,308行 → 模块化（200行主入口）
- 🎯 命令数量：40+ → 21个（6个核心 + 15个辅助）
- 🎨 面板统一：2套面板 → 1套统一面板
- 🧩 模块化：所有功能拆分为独立模块

**当前进度**：Phase 3 完成（60%）- 侧边栏重新设计、精简命令完成

详见：[v3.0.0 发布说明](./RELEASE-NOTES-v3.0.0.md)

---

## ✅ v2.53.0 已完成 - 动态知识架构（2026-01-12）

**核心更新**：根据你的工作方向动态创建领域目录

**主要功能**：
- 🎯 **工作方向选择器** - 首次设置时选择工作方向（游戏开发/游戏美术/前端/后端/AI/工具开发）
- 🔍 **领域检测器** - 保存知识时自动检测内容所属领域（16个领域，关键词匹配）
- 📁 **动态目录管理** - 按需创建领域目录（tools/programming/design/ai/game-dev）
- 🔄 **新旧结构并存** - 向后兼容，旧文件保留，新结构可选

**核心模块**：domainDetector.ts, dynamicStructure.ts, userDirectionSelector.ts

**文档链接**：
- [v2.53.0 发布说明](./RELEASE-NOTES-v2.53.0.md) - 完整功能介绍
- [v2.53.0 开发日志](./docs/v2.53.0-development-log.md) - 开发过程记录
- [v2.53.0 会话总结](./docs/v2.53.0-session-summary.md) - 开发总结
- [v2.53.0 测试清单](./docs/v2.53.0-test-checklist.md) - 测试结果
- [功能架构图](./docs/FEATURE-ARCHITECTURE.md) - 功能分类和简化建议
- [功能详细清单](./docs/FEATURE-DETAILED-LIST.md) - 40个命令完整列表

---

## ✅ v2.52.0 已完成 - 用户体验优化（2026-01-09）

**核心目标**：让插件好用，不管是新用户还是老用户

**主要功能**：
- 🎯 **首次使用引导** - 启动时验证路径，自动检测知识库位置，3步完成设置
- 📚 **侧边栏简化** - 减少层级，最常用功能放前面，智能显示
- 🤖 **自动化配置** - 零配置启动，一键初始化，智能修复
- 📝 **命名优化** - 更简洁直观的命名，清晰的 Tooltip
- ❓ **帮助系统** - 快速开始指南、常见问题 FAQ、智能提示

**核心模块**：setupWizard.ts, helpSystem.ts, simplifiedPanel.ts

**文档链接**：
- [v2.52.0 快速集成指南](./docs/v2.52.0-quick-integration.md) - 5分钟完成集成
- [v2.52.0 实施指南](./docs/v2.52.0-implementation-guide.md) - 完整实施步骤
- [v2.52.0 UX 改进计划](./docs/v2.52.0-ux-improvement-plan.md) - 详细设计方案
- [v2.52.0 跨设备解决方案](./docs/v2.52.0-cross-device-solution.md) - 跨平台/跨设备问题完整解决方案
- [v2.52.0 首次设置向导实现](./docs/20260109-v2.52.0-setup-wizard-implementation.md) - 技术实现总结
- [v2.52.0 开发总结](./docs/v2.52.0-summary.md) - 完成情况和下一步计划

---

## 📦 v2.51.0 - 文档浏览优化（2026-01-09）

**核心更新**：
- 📚 **知识库文档重构** - 按分类分组，智能去重，点击打开文件
- 🕐 **相对时间显示** - 刚刚/X分钟前/X小时前/X天前
- 🔗 **智能插入链接** - 点击打开文件，右键插入链接

**文档链接**：
- [v2.51.0 发布说明](./RELEASE-NOTES-v2.51.0.md) - 完整功能介绍
- [v2.49.1 发布说明](./RELEASE-NOTES-v2.49.1.md) - 智能插入链接确认
- [v2.49.0 发布说明](./RELEASE-NOTES-v2.49.0.md) - 双区域面板布局
- [📋 下一步行动清单](./NEXT-STEPS.md) - 当前任务、开发计划
- [🗺️ 开发路线图](../DEVELOPMENT-ROADMAP.md) - Phase 1-4 完整开发计划
- [🔄 跨设备开发工作流](../CROSS-DEVICE-WORKFLOW.md) - 多设备切换指南
- [🔄 跨设备上下文恢复](../CROSS-DEVICE-CONTEXT-RECOVERY.md) - 快速恢复提示词和场景指南

**Steering 规则**（自动化跨设备开发）：
- `.kiro/steering/auto-context-recovery.md` - 自动上下文恢复
- `.kiro/steering/development-decisions.md` - 开发决策记录规范
- `.kiro/steering/kiro-kb-development-context.md` - 项目开发上下文 🆕
- `.kiro/steering/check-knowledge-base.md` - 知识库检索规则

## 🌟 v2.49.1 核心功能

### 🔗 智能插入链接确认系统
在侧边栏点击"插入链接"时，自动分析链接相关性！

**工作流程**：
```
用户点击"插入链接"
    ↓
分析相关性（4个维度）
    ↓
相关性 ≥ 60分 → ✅ 直接插入
相关性 < 60分 → ⚠️ 显示确认对话框
    ↓
用户选择：
  - ✅ 仍然插入
  - 💡 查看更相关的链接（Top 3）
  - ❌ 取消
```

**相关性分析**：
- 📊 标签匹配（30分）
- 🏷️ 领域匹配（20分）
- 🔍 关键词匹配（30分）
- 📝 标题相似度（20分）

**配置选项**：
```json
{
  "kiro-kb.enableSmartLinkConfirm": true,  // 启用智能确认
  "kiro-kb.linkRelevanceThreshold": 60     // 相关性阈值
}
```

---

## 🌟 v2.49.0 核心功能

### 📁 双区域面板布局
侧边栏明确分离"当前项目"和"中央知识库"，功能组织更清晰！

**当前项目区域**：
- 💬 对话整理 - 整理 Kiro 对话到项目知识库
- 🔍 项目内搜索 - 仅搜索本地知识库
- 📚 知识库文档 - 按分类浏览本地知识文件
- 🔧 整理知识库 - 知识库维护工具

**中央知识库区域**：
- 🔍 全局搜索 - 搜索本地 + 中央知识库
- 💡 搜索建议 - 最近 5 条搜索建议
- 📊 搜索统计 - 搜索习惯分析
- 🔥 热门知识 - 访问次数最多的前 10 条
- 📁 按项目浏览 - 按项目分类浏览

### 🔍 搜索功能增强
项目内搜索 vs 全局搜索，来源标注清晰！

**使用方法**：
```
1. 点击 "🔍 项目内搜索" - 仅搜索本地知识库
2. 点击 "🔍 全局搜索" - 搜索本地 + 中央知识库
3. 或使用命令面板：Kiro KB: 搜索知识库
4. 搜索结果显示来源标注（📁 本地 / ☁️ 中央）
```

**特性**：
- 🎯 明确的搜索范围（项目内 vs 全局）
- 📍 清晰的来源标注（📁 本地 / ☁️ 中央）
- 💡 智能搜索建议（最近 5 条）
- 📊 搜索统计分析

### 🔥 热门知识推荐
自动追踪访问次数，智能推荐热门知识！

**使用方法**：
```
1. 点击侧边栏 "🔥 热门知识" 节点
2. 查看访问次数最多的前 10 条知识
3. 点击即可打开文件
```

**特性**：
- 📊 自动追踪文件访问次数
- 🔥 智能推荐热门知识（最多 10 个）
- 📈 访问次数统计和排序
- 🔥 无输入时显示热门搜索
- 📊 智能去重和排序

### 📊 搜索统计报告
全面的搜索统计，了解你的搜索习惯！

**使用方法**：
```
1. 按 Ctrl+Shift+P 打开命令面板
2. 输入 "search statistics"
3. 查看详细统计报告
```

**报告内容**：
- 📈 总体统计（总次数、模式分布、平均结果数）
- 🔥 热门搜索 Top 10
- 🕐 最近搜索记录
- 💡 智能使用建议

---

## 🤖 v2.50.0 Ollama 本地 AI 集成 (⏸️ 暂时搁置)

使用本地 AI 分析工作模式，生成智能工作报告！

**⚠️ 状态**: 因 Kiro IDE 网络请求限制，此功能暂时搁置。详见 [Bug 研究文档](./docs/v2.50.0-ollama-bug-research.md)。

**注意**: 核心模块已实现（`ollama.ts`, `workPatternTracker.ts`, `reportGenerator.ts`），但因 Kiro IDE 对 localhost 网络请求的限制，暂无法在插件中启用。

### 🚀 快速开始

**5 分钟快速上手** → [Ollama 集成快速开始指南](./docs/20260108-ollama-quick-start.md)

**前提条件**：
1. 安装 Ollama：https://ollama.ai
2. 下载模型：`ollama pull qwen2.5:3b`
3. 启用集成：设置 `kiro-kb.ollama.enabled = true`

**核心功能**：
- 📊 **智能日报** - AI 分析每日工作，生成结构化报告
- 📈 **智能周报** - 汇总一周工作模式，识别趋势和模式
- 🎯 **工作画像** - 构建个人工作习惯和技术栈画像
- 🔒 **隐私优先** - 所有处理本地化，无云端上传

**使用方法**：
```
1. 按 Ctrl+Shift+P 打开命令面板
2. 输入 "Kiro KB: 生成日报"
3. 等待 AI 分析（约 30 秒）
4. 查看生成的报告
```

**报告位置**：
- 日报：`{中央知识库}/work-patterns/daily/YYYY-MM-DD.md`
- 周报：`{中央知识库}/work-patterns/weekly/YYYY-WXX.md`
- 画像：`{中央知识库}/work-patterns/profile.yaml`

**配置选项**：
- `kiro-kb.ollama.enabled` - 启用/禁用 Ollama 集成
- `kiro-kb.ollama.baseUrl` - Ollama API 地址（默认 `http://localhost:11434`）
- `kiro-kb.ollama.model` - 使用的 AI 模型（默认 `qwen2.5:3b`）

**相关文档**：
- [🚀 快速开始指南](./docs/20260108-ollama-quick-start.md) - 详细使用说明
- [📋 Phase 1 完成总结](./docs/20260108-phase1-completion-summary.md) - 实现状态
- [🔧 安装配置指南](./.kiro/specs/ollama-integration/SETUP-GUIDE.md) - 安装步骤
- [📐 设计文档](./.kiro/specs/ollama-integration/design.md) - 架构设计
- [📝 需求文档](./.kiro/specs/ollama-integration/requirements.md) - 功能需求
- [🔄 跨设备工作流](../CROSS-DEVICE-WORKFLOW.md) - 多设备切换指南
- [🔄 跨设备上下文恢复](../CROSS-DEVICE-CONTEXT-RECOVERY.md) - 快速恢复提示词

**当前状态**：
- ✅ Ollama 客户端集成
- ✅ 基础报告生成
- ✅ 配置管理
- ⏳ 工作追踪（待完善）
- ⏳ 自动触发（待实现）

---

## 🤖 v2.46.0 TF-IDF 语义搜索
## 🤖 v2.46.0 TF-IDF 语义搜索
比关键词搜索更智能的语义搜索，理解你的搜索意图！

**使用方法**：
```
1. 按 Ctrl+Alt+K 打开快速搜索
2. 选择 "🤖 语义搜索 (TF-IDF)"
3. 输入自然语言查询（如："Unity Shader 优化技巧"）
4. 查看按相关度排序的结果
```

**特性**：
- 🧠 理解搜索意图，不只是关键词匹配
- 📊 相关度评分，结果按相关性排序
- 🎯 支持自然语言查询
- ⚡ 快速索引，秒级响应
- 🌐 中英文混合搜索
- 🏷️ 智能停用词过滤

**测试指南**：
- v2.48.0: [TEST-GUIDE-v2.48.0.md](./TEST-GUIDE-v2.48.0.md) - 搜索建议 + 统计报告测试
- v2.46.0: [TEST-GUIDE-v2.46.0.md](./TEST-GUIDE-v2.46.0.md) - TF-IDF 语义搜索测试

### 🔗 智能链接建议（计划中）
输入 `[[` 自动补全知识库链接，快速建立知识关联！

### 📊 知识缺口分析器（计划中）
分析知识库覆盖情况，识别知识盲区，提供学习建议！

---

## ⌨️ 快捷键速查

| 功能 | Windows/Linux | Mac |
|------|---------------|-----|
| 暂存问题 | `Ctrl+Alt+Q` | `Cmd+Alt+Q` |
| AI 总结保存 | `Ctrl+Alt+S` | `Cmd+Alt+S` |
| 快速搜索 | `Ctrl+Alt+K` | `Cmd+Alt+K` |
| 从模板创建 | `Ctrl+Alt+T` | `Cmd+Alt+T` |
| 查看待办 | `Ctrl+Alt+B` | `Cmd+Alt+B` |
| 智能捕获 | `Ctrl+Alt+C` | `Cmd+Alt+C` |
| 全局搜索 | `Ctrl+Alt+F` | `Cmd+Alt+F` |
| 插入知识链接 | `Ctrl+Alt+L` | `Cmd+Alt+L` |
| 显示相关知识 | `Ctrl+Shift+Alt+R` | `Cmd+Shift+Alt+R` |

自定义快捷键：`Ctrl+K Ctrl+S`（Mac: `Cmd+K Cmd+S`）打开设置，搜索 `kiro-kb`

## 功能

- 📚 **学习路径生成器** - 根据主题自动生成结构化学习路径（v2.45.0 新增）
- 📊 **健康度仪表盘** - 7个关键指标评估知识库健康状况（v2.45.0 增强）
- 自动保存有价值的对话内容
- 智能检索历史解决方案
- 跨项目知识同步
- 进度追踪
- 🔗 双向链接系统
- 🎨 智能分类
- 💬 对话整理

## 💡 AI 能力边界

Kiro KB 明确区分两类知识，采用不同处理策略：

**✅ 技术知识（Type A）- AI 很强**
- 编程语言、框架、算法
- 系统架构、设计模式
- 工具使用、调试技巧
- **AI 能力**：深度分析、生成代码、解答问题、提供学习路径

**⚠️ 市场数据（Type B）- AI 有限**
- 市场规模、增长率、用户画像
- 行业趋势、竞品分析
- 最新数据、未来预测
- **AI 能力**：辅助整理、提取数据、追踪趋势（但不能替代付费报告）

**核心原则**：诚实 > 万能。我们明确告知 AI 的能力边界，不做虚假承诺。

详见：[AI 的局限性：技术知识 vs 数据知识](./knowledge-base/discussions/20260108-ai-limitations-technical-vs-data-knowledge.md)

## 安装

**开发版本：v2.47.0-dev** ([开发计划](./docs/20260105-v2.47.0-development-plan.md))

⚠️ **注意**：这是开发版本，正在实现新功能，尚未完成。建议等待正式发布。

**方式一：运行安装脚本（推荐）**
```powershell
powershell -ExecutionPolicy Bypass -File ".\scripts\install-knowledge-base.ps1"
```

**方式二：双击运行**
```
双击 Kiro-KB-Setup.bat
```

**方式三：手动安装 VSIX**
1. 下载 `kiro-knowledge-base-2.53.0.vsix`（最新版）
2. VS Code/Kiro 中按 `Ctrl+Shift+X` 打开扩展面板
3. 点击 `...` → `从 VSIX 安装`
4. 选择下载的文件并重新加载

**测试新功能**：安装后查看 [v2.53.0 发布说明](./RELEASE-NOTES-v2.53.0.md) 了解新功能

**注意：** 安装后会配置全局 Steering 规则，新项目打开后 Kiro 自动生效，无需重复安装。

## 📁 项目结构

```
kiro-kb-plugin/
├── extension/            # 插件源代码
│   ├── src/             # TypeScript 源码
│   └── package.json     # 插件配置
├── docs/                # 当前版本文档（9个）
│   ├── v2.52.0-*.md    # v2.52.0 相关文档
│   ├── 功能操作指南.md
│   ├── feature-request-trae-support.md
│   └── archived/        # 历史文档归档（60个）
│       ├── 2025-12/    # 2025年12月文档（13个）
│       ├── 2026-01/    # 2026年1月文档
│       │   ├── v2.44-v2.47/  # v2.44-v2.47（10个）
│       │   ├── v2.47-v2.48/  # v2.47-v2.48（2个）
│       │   ├── v2.49/        # v2.49（1个）
│       │   ├── ollama/       # Ollama 集成（10个）
│       │   ├── Kiro官方功能建议-跨设备AI上下文同步.md
│       │   └── RECOVERY-SUMMARY-20260109.md
│       ├── release-notes/    # 旧版本发布说明（11个）
│       ├── test-guides/      # 测试指南（7个）
│       ├── v2.52.0/          # v2.52.0 临时文档（4个）
│       └── DOCS-CLEANUP-SUMMARY.md  # 文档整理总结
├── scripts/             # PowerShell 脚本
├── tests/               # 测试文件
├── hooks-templates/     # Agent Hooks 模板
├── README.md            # 项目说明（本文件）
├── CHANGELOG.md         # 变更日志
├── PLUGIN-OVERVIEW.md   # 插件概览
├── NEXT-STEPS.md        # 下一步计划
├── SESSION-2026-01-09.md  # 最新会话记录
└── RELEASE-NOTES-v2.52.0.md  # 最新发布说明
```

### 📚 文档说明

**文档整理完成**（2026-01-09）：
- ✅ 文档数量减少 76%（83个 → 20个）
- ✅ 归档 60 个历史文档
- ✅ 删除 2 个临时截图
- 详见：[文档整理总结](./docs/archived/DOCS-CLEANUP-SUMMARY.md)

**当前文档**（保留在主目录）：
- 最新 2 个版本的发布说明（v2.51.0, v2.52.0）
- 当前版本的开发文档（v2.52.0，共 9 个）
- 功能操作指南和特性请求

**历史文档**（归档在 `docs/archived/`）：
- 按时间归档：2025-12/, 2026-01/
- 按类型归档：release-notes/, test-guides/
- 按版本归档：v2.44-v2.47/, v2.49/, ollama/, v2.52.0/

**查找历史文档**：
```bash
# 查看所有归档文档
ls docs/archived/

# 查看特定版本的发布说明
ls docs/archived/release-notes/

# 查看 Ollama 集成相关文档
ls docs/archived/2026-01/ollama/

# 查看 v2.49 开发文档
ls docs/archived/2026-01/v2.49/

# 查看测试指南
ls docs/archived/test-guides/
```

## 脚本说明

| 脚本 | 功能 |
|------|------|
| install-knowledge-base.ps1 | 一键安装 |
| sync-to-central.ps1 | 同步到中央库 |
| generate-index.ps1 | 生成索引 |
| init-knowledge-base.ps1 | 初始化新项目 |
| report-test-issue.ps1 | 测试问题回传 |
| setup-new-device.ps1 | 新设备配置 |
| setup-mcp-filesystem.ps1 | 配置 MCP filesystem 允许目录 |

## Agent Hooks 配置

安装插件后，建议配置 Agent Hooks 实现自动化：

### 快速配置

1. 复制 `hooks-templates/` 中的 `.json` 文件到项目的 `.kiro/hooks/`
2. 修改 `{{CENTRAL_KB_PATH}}` 为你的知识库路径
3. 重启 Kiro

### 可用模板

| 模板 | 功能 |
|------|------|
| auto-save-knowledge.json | 会话结束智能评估（10分制）并保存 |
| auto-search-kb.json | 新会话自动检索 |
| auto-update-index.json | 文件变更更新索引 |
| daily-review.json | 每日回顾提醒 |

详细说明见 `hooks-templates/README.md`

## 开发状态

🧪 测试中
