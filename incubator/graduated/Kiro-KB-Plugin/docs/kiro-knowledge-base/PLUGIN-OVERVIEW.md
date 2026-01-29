# Kiro Knowledge Base Plugin - 功能大纲

> 版本: 2.53.0  
> 更新日期: 2026-01-12

## 插件简介

Kiro Knowledge Base 是一个 VS Code/Kiro 扩展，用于自动保存和检索 Kiro 对话内容到中央知识库，实现跨项目的知识复用和 Token 节省。

**📊 功能统计**：73 个命令 | 10 个快捷键 | 17 个配置项

**📚 相关文档**：
- [功能总结](./FEATURES-SUMMARY-v2.45.0.md) - 快速查看功能清单、待完善功能、下一步计划
- [完整功能分析](./PLUGIN-FEATURES-ANALYSIS-v2.45.0.md) - 73个命令详解、使用频率分析、推荐工作流

---

## 最新功能 (v2.53.0)

### 🎯 动态知识架构
不再是固定的 solutions/notes/discussions 三个文件夹，而是根据你的工作方向动态创建领域目录。

**核心功能**：
- 🎯 **工作方向选择器** - 首次设置时选择工作方向（6个预设方向）
- 🔍 **领域检测器** - 保存知识时自动检测内容所属领域（16个领域）
- 📁 **动态目录管理** - 按需创建领域目录（tools/programming/design/ai/game-dev）
- 🔄 **新旧结构并存** - 向后兼容，旧文件保留，新结构可选

详见：[v2.53.0 发布说明](./RELEASE-NOTES-v2.53.0.md)

---

## v2.52.0 - 用户体验优化（2026-01-09）

### 🎯 用户体验优化版本
- **首次使用引导** - 启动时验证路径，无效就引导设置，3步完成配置
- **侧边栏简化** - 减少层级，最常用功能放前面，智能显示
- **自动化配置** - 能自动的就自动，减少手动操作
- **命名优化** - 让用户一看就懂
- **帮助系统** - 不懂的时候有地方找答案

详见：[v2.52.0 开发总结](./docs/v2.52.0-summary.md)

---

## 核心功能

### 1. Setup Knowledge Base (初始化设置)
- 设置中央知识库路径
- 自动创建目录结构 (discussions/solutions/notes/backlog)
- 生成 README.md 和 PROGRESS.md
- 配置全局 Steering 规则

### 2. Generate Index (生成索引) - v2.5.0 优化, v2.44.0 增强
- 扫描知识库所有 .md 文件（支持子目录递归）
- 提取 YAML front-matter 中的 domain 和 tags
- 提取文件标题（从 `# xxx` 提取）
- 提取日期（从 YAML 或文件名提取）
- 生成统计表格（各分类数量 + 待办统计）
- 生成最近更新列表（最新 10 个文件）
- 按领域分类生成 INDEX.md
- 按类型分类生成 INDEX.md
- 按时间倒序排列
- **v2.44.0 新增**：生成 PROJECT-INDEX.md（按项目分类的索引）
  - 从 YAML front-matter 提取 `source_project` 和 `source_project_type`
  - 按项目类型分组显示（🎮游戏/🔌插件/🌐Web/📱移动/⚙️后端/🤖AI/🛠️DevOps/📁其他）
  - 统计各项目类型的项目数和知识条目数
  - 每个项目显示最近 20 条知识（按日期倒序）

### 3. Sync to Central Repository (同步到中央仓库)
- 将当前项目的 knowledge-base 文件夹同步到中央仓库
- 自动添加项目名前缀避免文件名冲突
- 支持增量同步（只同步新文件）

### 4. Open Knowledge Base (打开知识库)
- 在新窗口中打开中央知识库
- 方便浏览和编辑知识内容
- 新增：查看待办问题选项

### 5. Smart Idle Reminder (智能空闲提醒) - v2.32.0 增强
- 追踪本次会话的编辑次数和工作时长
- 只有在有足够工作量时才提醒（至少编辑 20 次，工作 5 分钟）
- 显示会话统计信息（工作时长、编辑次数）
- 设置为 0 可禁用此功能
- **v2.32.0 新增配置项**：
  - `kiro-kb.reminder.enabled` - 是否启用空闲提醒（默认 true）
  - `kiro-kb.reminder.minEdits` - 触发提醒的最小编辑次数（默认 20）
  - `kiro-kb.reminder.minMinutes` - 触发提醒的最小工作时长（默认 5 分钟）

### 6. Error Reporting (错误报告)
- 自动捕获插件运行错误
- 用户可选择是否提交错误报告
- 错误报告保存到 error-reports/
- 可通过 Toggle Error Reporting 命令启用/禁用

### 7. Auto Detect & Sync (自动检测同步)
- 打开项目时自动检测本地 knowledge-base 文件夹
- 检测到新文件时提示同步
- 支持自动同步模式（无需确认）

### 8. Central KB Validation (中央知识库验证)
- 验证配置的路径是否为有效的知识库
- 检查必要目录结构
- 验证失败时提供重新设置选项

### 9. Central KB Check (中央知识库检查)
- 打开中央知识库时自动识别
- 统计缺少 YAML 元数据的文件
- 统计未分类的文件
- 提供智能整理选项

### 10. Auto Sync Option (自动同步选项)
- 配置项 `kiro-kb.autoSync` 控制同步模式
- 关闭（默认）：检测到新文件时提示用户确认
- 开启：自动同步，无需用户确认

### 11. Enhanced Steering Rules (增强 Steering 规则)
- Setup 命令自动创建全局 Steering 规则
- 同时创建工作区级别的知识库关联规则
- 支持问题暂存指令

### 12. Smart Organize (智能整理)
- 打开中央知识库时自动分析内容
- 检测缺少 YAML 元数据的文件
- 生成整理任务清单供 Kiro 执行

### 13. Related Files Detection (关联检测)
- 检测高度相关的文件对
- 关联条件：共同标签 ≥ 2 或相同领域且标题相似
- 生成关联文件分析报告

---

## v2.1.0 新增功能

### 14. Question Backlog (问题暂存系统)
- 暂存问题到待办队列
- 支持优先级标记（高/普通/低）
- 支持问题分类（Bug/功能/灵感/疑问）
- 三种暂存模式：local/central/auto

### 15. Backlog Management (待办管理)
- 查看待办问题列表
- 按优先级和时间排序
- 解决问题自动归档到 solutions/
- 删除问题保留 60 天后自动清理

### 16. Submit to Central (提交到中央)
- 将本地待办提交到中央知识库
- 支持单个提交和批量提交

### 17. Batch Analyze (批量分析)
- 生成批量分析任务文档
- 支持打开时自动询问分析

### 18. Multi-language Support (多语言支持)
- 支持中文和英文界面
- 通过命令切换语言
- 默认中文

### 19. Status Bar Display (状态栏显示)
- 状态栏显示待办数量
- 点击打开待办列表
- 无待办时自动隐藏

### 20. Auto Cleanup (自动清理)
- 删除的问题保留 60 天
- 60 天后检查是否有类似问题
- 无类似问题则彻底删除

---

## v2.2.0 新增功能

### 21. Smart Category Detection (智能分类检测)
- 根据问题关键词自动识别类型
- Bug 关键词：报错、崩溃、失败、不工作、异常...
- Feature 关键词：希望、能不能、想要、添加、实现...
- Idea 关键词：灵感、想法、创意、如果、或许...
- 用户可选择使用检测结果或手动选择

### 22. Smart Priority Detection (智能优先级检测)
- 根据问题关键词自动识别优先级
- 高优先级：紧急、马上、阻塞、严重、生产环境...
- 低优先级：有空、以后、可选、建议、不急...
- 用户可选择使用检测结果或手动选择

### 23. KB Related Search (知识库关联检测)
- 暂存问题时自动搜索知识库
- 匹配标题、内容、标签
- 找到相关内容时提示查看
- 避免重复提问

---

## v2.9.0 代码重构

### 24. i18n Module (国际化模块抽取)
- 从 extension.ts 抽取到独立的 `i18n.ts`
- 导出函数：`t()`, `setLanguage()`, `getLanguage()`, `isZh()`
- 类型导出：`Language`, `I18nKey`
- 支持参数替换：`t('syncComplete', 5)` → "✅ 已同步 5 个文件"

### 25. Types Module (类型定义模块)
- 从 extension.ts 抽取到独立的 `types.ts`
- 定义 15+ 类型：
  - `BacklogItem` - 待办项
  - `SmartAnalysisResult` - 智能分析结果
  - `RelatedFile` - 相关文件
  - `KBFileInfo` / `CentralKBFileInfo` - 知识库文件信息
  - `KBValidationResult` - 验证结果
  - `LogLevel` - 日志级别
  - `BacklogPriority` / `BacklogCategory` / `BacklogStatus` - 待办相关类型

### 26. Unit Tests (单元测试)
- 新增 `test/extension.test.ts`
- 测试覆盖：i18n、类型、智能分析、文件名生成、路径处理、日期计算
- 不依赖 VS Code API，可独立运行

---

## v2.10.0 代码重构

### 27. Utility Functions (工具函数模块)
- 新增 `scanMdFiles()` - 扫描指定目录下的 .md 文件，支持多文件夹
- 新增 `safeMove()` - 安全移动文件，跨盘符兼容（先 copy 后 delete）
- 新增 `getUniqueFileName()` - 生成唯一文件名，自动处理冲突
- 新增 `checkIsKnowledgeBaseStructure()` - 检查路径是否为知识库结构
- 新增 `ensureYamlFrontMatter()` - 自动为 Markdown 文件添加 YAML front-matter（domain/tags/date/source_project）
- 新增 `validateCentralKB()` - 验证中央知识库路径和结构

### 28. Constants Extraction (常量抽取)
- `BACKLOG_FOLDERS` - 待办文件夹列表 `['pending', 'draft']`
- `KB_FOLDERS` - 知识库文件夹列表 `['discussions', 'solutions', 'notes']`
- `SMART_KEYWORDS` - 智能检测关键词配置（类型化为 `SmartKeywords`）

### 29. Enhanced JSDoc (增强文档注释)
- 为所有工具函数添加完整的 JSDoc 注释
- 包含参数说明和返回值类型

---

## v2.11.0 新增功能

### 30. Template System (模板系统)
- 5 种内置模板：
  - `solution` - 解决方案模板
  - `bug-fix` - Bug 修复记录模板
  - `learning-note` - 学习笔记模板
  - `code-snippet` - 代码片段模板
  - `discussion` - 技术讨论模板
- 支持自定义模板：在本地 `knowledge-base/templates/` 或中央知识库 `templates/` 目录创建 `.md` 文件
- 模板优先级：本地项目模板 > 中央知识库模板（同名时本地优先）
- 模板变量支持：`{{title}}`、`{{description}}`、`{{date}}`、`{{project}}`、`{{tags}}`、`{{language}}`、`{{code}}`
- 命令：`Kiro KB: 从模板创建`、`Kiro KB: 管理模板`

### 31. KB Analysis Report (知识库分析报告)
- 统计总文件数、平均价值分、待办数量、涉及项目数、标签数量
- 按类型分布：discussions/solutions/notes 占比
- 按领域分布：domain 统计
- 按项目分布：source_project 统计（Top 10）
- 标签云：Top 20 标签及使用次数
- 最近更新：最新 10 个文件
- 待办统计：pending/draft/deleted 数量
- 智能建议：
  - 待办过多提醒
  - 平均价值分过低提醒
  - 未分类内容过多提醒
  - 标签使用不足提醒
- 命令：`Kiro KB: 生成分析报告`

---

## v2.13.0 代码优化

### 32. i18n Enhancement (国际化完善)
- 统一使用 `t()` 函数进行翻译
- 新增 20+ 翻译键
- 消除硬编码字符串

### 33. Local Template Support (本地模板支持)
- 支持本地项目 `knowledge-base/templates/` 目录
- 本地模板优先于中央知识库模板（同名时本地覆盖中央）
- 模板来源标识：local/central

### 34. Safe File Operations (安全文件操作)
- 新增 `safeWriteFile()` - 安全写入文件，自动创建目录
- 新增 `safeReadFile()` - 安全读取文件，带错误处理
- 新增 `safeDeleteFile()` - 安全删除文件，带错误处理

### 35. Quick Search Enhancement (快速搜索增强)
- 修复不扫描子目录的问题
- 递归扫描 discussions/solutions/notes 子目录

---

## v2.16.0 新增功能

### 41. Favorites (收藏夹)
- 收藏常用知识文件，快速访问
- 收藏夹优先显示在面板顶部
- 支持添加/移除收藏
- 收藏数据持久化存储

### 42. Tags Management (标签管理)
- 按标签浏览知识库内容
- 显示 Top 20 标签及对应文件数量
- 点击标签展开查看相关文件
- 从 YAML front-matter 自动提取标签

### 43. Stale Knowledge Detection (过期知识检测)
- 自动识别长时间未更新的知识
- 默认阈值：90 天未修改
- 可通过 `staleDays` 配置项自定义阈值
- 显示距离上次更新的天数

---

## v2.17.0 新增功能

### 44. Knowledge Graph (知识关联图) - v2.19.0 增强
- 可视化展示知识之间的关联关系
- 基于共同标签建立知识节点之间的连接
- 使用 vis-network 库渲染交互式图表
- 按文件夹类型着色（solutions=绿色, notes=蓝色, discussions=橙色）
- 支持缩放、拖拽、悬停查看详情
- **v2.19.0 新增工具栏：**
  - 🔍 搜索框：按标题/标签过滤节点
  - 📁 文件夹筛选：按 Solutions/Notes/Discussions 过滤
  - 🏷️ 标签筛选：按标签过滤节点
  - 🔄 重置/切换布局/适应窗口按钮
  - 📊 节点数和连接数统计
- **v2.19.0 新增交互功能：**
  - 📂 Open File：双击或右键打开对应文件
  - ℹ️ View Details：单击显示详情面板（标题/标签/预览）
  - 🤖 Ask Kiro：生成提示让 Kiro 补充和完善知识点
  - 🔍 Web Search：一键在浏览器中搜索相关内容
  - ➕ Create Related：基于当前节点创建关联知识文件（继承标签）
  - 🔗 Highlight Related：高亮关联节点
- 保持上下文：切换标签页后图表状态不丢失（retainContextWhenHidden）
- 命令：`Kiro KB: 知识关联图`

### 45. Export Knowledge (导出知识)
- 支持导出为多种格式：
  - Markdown (.md) - 合并为单个文档
  - HTML (.html) - 带样式的网页格式
  - JSON (.json) - 结构化数据格式
- 支持多选文件批量导出
- 自动添加导出时间戳
- 命令：`Kiro KB: 导出知识`

---

## v2.22.0 新增功能

### 51. Smart Capture with Classification (智能捕获集成分类)
- 智能捕获功能现已集成分类引擎
- **自动检测**：
  - 领域和子领域（如 `unity/shader`、`kiro/plugin`、`web/frontend`）
  - 知识类型（solution/tutorial/reference/troubleshooting/architecture/note）
  - 难度级别（beginner/intermediate/advanced/expert）
- **智能标签建议**：基于内容自动提取技术关键词并预填充
- **置信度显示**：显示分类置信度百分比，帮助用户判断准确性
- **标准化元数据**：生成完整的 YAML front-matter，包含：
  - `id` - 唯一标识符
  - `domain` / `type` / `difficulty` - 分类信息
  - `quality` - 质量评估（score/completeness/verified/review_count）
  - `lifecycle` - 生命周期（status/expiry_hint/review_interval）
- **内容类型更新**：移除 "代码片段"，新增 "参考文档" 和 "架构设计"

### 52. Smart Classify Commands (智能分类命令)
- **单文件分类** (`Kiro KB: 智能分类`)：
  - 对当前打开的 Markdown 文件进行智能分类
  - 显示分类结果：领域、类型、难度、置信度、建议标签
  - 支持应用分类结果到文件（更新或添加 YAML front-matter）
- **批量分类** (`Kiro KB: 批量分类`)：
  - 选择本地或中央知识库
  - 自动扫描未分类的文件（domain 为空或 "other"）
  - 显示进度条，支持取消操作
  - 批量更新文件的 YAML front-matter

---

## v2.24.0 新增功能

### 53. Quality Assessment System (质量评分系统)
- 新增 `QualityAssessor` 类，对知识条目进行多维度质量评估
- **5 个评估维度**：
  - 结构完整性 (25%)：检查 YAML front-matter、标题、章节结构、关键章节（背景/解决方案/注意事项）
  - 内容深度 (25%)：检查字数、代码块数量、列表项、链接/引用
  - 元数据完整性 (20%)：检查 domain、tags、date、source_project
  - 可读性 (15%)：检查段落长度、格式化（加粗、行内代码、表格）
  - 时效性 (15%)：基于 date 和 last_reviewed 计算内容新鲜度
- **等级评定**：A(≥8.5)/B(≥7)/C(≥5.5)/D(≥4)/F(<4)
- **自动生成改进建议**：针对低分维度提供具体改进建议
- **复查检测**：自动识别需要复查的知识（任何维度<4分或时效性<5分）
- **质量报告生成**：`generateReport()` 方法生成详细的质量评估报告（支持中英文）
- 导出单例 `qualityAssessor` 供其他模块使用

### 54. Knowledge Graph Builder (知识图谱构建器)
- 新增 `KnowledgeGraphBuilder` 类，构建知识节点之间的关联图谱
- **节点类型 (KnowledgeNode)**：
  - id、filePath、title - 基础信息
  - domain、subDomain、type - 分类信息
  - tags、date、quality - 元数据
- **边类型 (KnowledgeEdge)**：
  - domain - 同领域关联（权重 0.3，子领域相同额外 +0.15）
  - tag - 共享标签关联（每个标签权重 0.2，最高 0.6）
  - similarity - 标题相似度关联（阈值 0.25）
  - reference - 引用关联（预留）
- **图谱构建**：
  - `addNode()` / `addNodes()` - 添加知识节点
  - `buildEdges()` - 基于领域、标签、相似度构建边
  - `getGraph()` - 获取完整图谱（含统计信息）
- **智能推荐**：
  - `getRecommendations()` - 获取节点的相关推荐（基于边权重排序）
- **图谱分析**：
  - `findIsolatedNodes()` - 查找孤立节点（无连接）
  - `findCoreNodes()` - 查找核心节点（高连接度）
- **可视化**：
  - `generateMermaidCode()` - 生成 Mermaid 图谱代码（支持节点/边数量限制）
  - 按领域着色（🎮Unity/🤖Kiro/⚙️DevOps/🌐Web/🧠AI/💾Database）
- 导出单例 `graphBuilder` 供其他模块使用

---

## v2.21.0 新增功能

### 50. Intelligent Classification Engine (智能分类引擎)
- 新增 `classifier.ts` 模块，提供内容智能分类能力
- **领域检测 (Domain Detection)**：
  - 6 大领域：Unity 游戏开发、Kiro 工具链、开发运维、Web 开发、AI/机器学习、数据库
  - 20+ 子领域：Shader、性能优化、粒子系统、插件开发、Hooks 配置、Git、Docker、前端、后端、LLM 等
  - 基于关键词匹配，支持中英文
- **类型检测 (Type Detection)**：
  - 6 种知识类型：solution（解决方案）、tutorial（教程）、reference（参考）、troubleshooting（排错）、architecture（架构）、note（笔记）
  - 基于正则模式 + 关键词匹配
- **难度检测 (Difficulty Detection)**：
  - 4 个级别：beginner（入门）、intermediate（中级）、advanced（高级）、expert（专家）
- **标签建议 (Tag Suggestion)**：
  - 自动从内容提取技术关键词（50+ 技术栈）
  - 标签规范化映射（中英文统一、大小写统一）
- **元数据生成 (Metadata Generation)**：
  - 生成标准化 YAML front-matter
  - 包含：id、title、date、domain、type、difficulty、tags、source、quality、relations、lifecycle
- 导出单例 `classifier` 供其他模块使用

---

## v2.20.0 性能优化

### 48. File Cache Mechanism (文件缓存机制)
- 30秒缓存有效期，减少重复文件扫描
- 刷新面板时自动清除缓存
- 提升知识面板响应速度

### 49. Favorites Auto Cleanup (收藏夹自动清理)
- 加载收藏夹时自动检测无效收藏（文件已删除）
- 自动清理无效收藏项
- 保持收藏夹数据整洁

---

## v2.19.0 新增功能

### 47. Enhanced Knowledge Graph (增强版知识关联图)
- 新增交互式操作面板
- Open File：点击节点在侧边打开对应文件
- Ask Kiro：生成结构化提示，复制到剪贴板后粘贴给 Kiro 补充知识
- Web Search：一键打开浏览器搜索相关内容
- Create Related：基于当前节点快速创建关联知识文件（自动继承标签）
- Show Details：弹窗预览文件内容（前 500 字符）
- 图表状态保持：`retainContextWhenHidden: true`

---

## v2.18.0 新增功能

### 46. Git Sync (Git 同步)
- 集成 Git 操作，方便知识库版本管理
- 支持的操作：
  - Pull (拉取) - 从远程仓库获取最新内容
  - Push (推送) - 推送本地更改到远程
  - Commit & Push (提交并推送) - 一键完成 add、commit、push
  - Status (状态) - 查看当前分支和更改文件数
- 自动检测中央知识库是否为 Git 仓库
- 命令：`Kiro KB: Git 同步`、`Kiro KB: Git 推送`、`Kiro KB: Git 拉取`

---

## v2.15.0 新增功能

### 40. TreeView Knowledge Panel (知识面板侧边栏) - v2.44.0 增强
- 在活动栏显示知识库图标 (📚)
- **v2.33.0 新增概览节点 (📊)**：
  - 总知识数（本地/中央分布）
  - 本周更新数量
  - 待处理问题数量（可点击查看）
  - 需复查知识数量（可点击复查）
  - 健康度评分（🟢≥80% / 🟡≥60% / 🔴<60%）
- **v2.33.0 新增快捷操作节点 (⚡)**：
  - 📸 智能捕获 / 💡 暂存问题 / 🔍 快速搜索
  - 💡 智能推荐 / ☁️ 同步到中央 / 📑 生成索引
- **v2.33.0 新增健康度详情节点 (❤️)**：
  - 综合评分（0-100）
  - 过期占比 / 待办积压 / 本周活跃状态
  - 查看详细报告链接
- **v2.44.0 新增按项目浏览节点 (📁)**：
  - 按项目类型分组显示知识（🎮Unity/🔌插件/🌐Web/📱移动/⚙️后端/🤖AI/🛠️DevOps/📁其他）
  - 统计各类型的项目数和知识条目数
  - 展开类型后显示该类型下的所有项目
  - 展开项目后显示该项目的所有知识文件
  - 基于 YAML front-matter 中的 `source_project` 和 `source_project_type` 字段分组
- 本地知识 (📁) 和中央知识 (☁️) 分类展示
- 一键初始化本地知识库：本地 KB 不存在时显示"初始化本地知识库"选项，点击自动创建目录结构
- 最近更新：显示最新 10 个文件
- 待办统计：显示 pending/draft 数量
- 面板内搜索：按标题/文件名过滤
- 刷新按钮：实时更新知识库状态
- 右键删除：支持删除知识文件
- 设置节点 (⚙️)：快速访问插件配置项，点击可直接修改（v2.32.0 新增）
- 命令：`Kiro KB: 刷新知识面板`、`Kiro KB: 面板搜索`

---

## v2.14.0 新增功能

### 38. Smart Capture (智能捕获) - v2.22.0 增强
- 快速捕获内容到本地知识库
- **v2.22.0 集成智能分类引擎**：
  - 自动检测领域和子领域（如 `kiro/plugin`、`web/frontend`）
  - 自动检测知识类型（solution/tutorial/reference/architecture/note）
  - 自动检测难度级别（beginner/intermediate/advanced/expert）
  - 智能标签建议（基于内容提取技术关键词）
  - 显示分类置信度百分比
- 自动检测项目上下文（技术栈、Git 分支/提交信息）
- 生成标准化 YAML front-matter（含 id、quality、lifecycle 等字段）
- 命令：`Kiro KB: 智能捕获`

### 39. Knowledge Panel (知识面板)
- 侧边栏实时搜索知识库
- 支持本地知识 (📁) 和中央知识 (☁️) 分类显示
- 显示相关知识 (💡) 和最近知识 (🕐)
- 支持打开文件、复制代码片段
- 支持刷新、折叠/展开操作
- 命令：`Kiro KB: 知识面板`

---

## v2.12.0 新增功能

### 36. AI Summarize & Save (AI 总结并保存)
- 生成结构化的 AI 总结提示
- 支持选择内容类型：解决方案/学习笔记/技术讨论
- 自动生成 YAML front-matter 模板
- 提示内容复制到剪贴板，粘贴给 Kiro 执行
- 命令：`Kiro KB: AI总结保存`

### 37. Quick Search KB (快速搜索知识库)
- 快速搜索中央知识库所有内容
- 支持标题、标签、日期匹配
- 按日期倒序排列（最新在前）
- 显示文件夹图标区分类型
- 支持子目录递归扫描
- 命令：`Kiro KB: 快速搜索`

---

## 配置项

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `kiro-kb.centralPath` | string | "" | 中央知识库路径 |
| `kiro-kb.autoSave` | boolean | true | 自动保存开关 |
| `kiro-kb.autoSync` | boolean | false | 自动同步模式 |
| `kiro-kb.idleReminderMinutes` | number | 10 | 空闲提醒间隔(分钟)，0=禁用 |
| `kiro-kb.errorReportEnabled` | boolean | true | 错误报告功能开关 |
| `kiro-kb.backlogMode` | string | "auto" | 问题暂存模式：local/central/auto |
| `kiro-kb.autoAnalyze` | string | "manual" | Kiro分析时机：manual/onOpen/never |
| `kiro-kb.language` | string | "zh" | 界面语言：zh/en |
| `kiro-kb.reminderDays` | array | [7, 30] | 待办提醒天数 |
| `kiro-kb.staleDays` | number | 90 | 过期知识阈值天数 |
| `kiro-kb.gitAutoSync` | boolean | false | Git 自动同步开关 |
| `kiro-kb.graphEdgeThreshold` | number | 5 | 知识关联图边权重阈值（1-20，越低连接越多） |
| `kiro-kb.reminder.enabled` | boolean | true | 是否启用空闲提醒 |
| `kiro-kb.reminder.minEdits` | number | 20 | 触发提醒的最小编辑次数 |
| `kiro-kb.reminder.minMinutes` | number | 5 | 触发提醒的最小工作时长（分钟） |
| `kiro-kb.defaultExpandedSection` | string | "current" | 默认展开的面板区域：current/central/both（v2.49.0） |
| `kiro-kb.useDualPanelLayout` | boolean | true | 使用双区域面板布局（v2.49.0） |
| `kiro-kb.ollama.enabled` | boolean | false | 启用 Ollama 本地 AI 集成（v2.50.0 配置项已添加，功能暂未启用） |
| `kiro-kb.ollama.baseUrl` | string | "http://localhost:11434" | Ollama API 地址 |
| `kiro-kb.ollama.model` | string | "qwen2.5:3b" | 使用的 AI 模型（如 qwen2.5:3b, llama3.2:3b） |
| `kiro-kb.ollama.dailyReportTime` | string | "18:00" | 每日报告生成时间（HH:MM 格式） |
| `kiro-kb.ollama.weeklyReportDay` | number | 0 | 每周报告生成日（0=周日，6=周六） |

---

## 命令列表

| 命令 | Windows/Linux | Mac | 说明 |
|------|---------------|-----|------|
| `Kiro KB: 设置知识库` | - | - | 设置中央知识库路径 |
| `Kiro KB: 同步到中央仓库` | - | - | 同步本地知识到中央 |
| `Kiro KB: 生成索引` | - | - | 生成 INDEX.md |
| `Kiro KB: 打开知识库` | - | - | 打开中央知识库 |
| `Kiro KB: 切换错误报告` | - | - | 启用/禁用错误报告 |
| `Kiro KB: 暂存问题` | `Ctrl+Alt+Q` | `Cmd+Alt+Q` | 保存问题到待办 |
| `Kiro KB: 查看待办` | `Ctrl+Alt+B` | `Cmd+Alt+B` | 查看待办问题列表 |
| `Kiro KB: 提交到中央` | - | - | 提交本地待办到中央 |
| `Kiro KB: 分析待办问题` | - | - | 生成批量分析任务 |
| `Kiro KB: 切换语言` | - | - | 切换中文/英文 |
| `Kiro KB: 从模板创建` | `Ctrl+Alt+T` | `Cmd+Alt+T` | 使用模板创建知识条目 |
| `Kiro KB: 生成分析报告` | - | - | 生成知识库统计报告 |
| `Kiro KB: 管理模板` | - | - | 查看/创建自定义模板 |
| `Kiro KB: AI总结保存` | `Ctrl+Alt+S` | `Cmd+Alt+S` | 生成 AI 总结提示 |
| `Kiro KB: 快速搜索` | `Ctrl+Alt+K` | `Cmd+Alt+K` | 快速搜索知识库 |
| `Kiro KB: 范围搜索` | - | - | 指定范围搜索（local=项目内 / all=全局） |
| `Kiro KB: 智能捕获` | `Ctrl+Alt+C` | `Cmd+Alt+C` | 快速捕获内容到本地知识库 |
| `Kiro KB: 全局搜索` | `Ctrl+Alt+F` | `Cmd+Alt+F` | 搜索本地和中央知识库 |
| `Kiro KB: 刷新知识面板` | - | - | 刷新侧边栏知识面板 |
| `Kiro KB: 面板搜索` | - | - | 在知识面板中搜索 |
| `Kiro KB: 知识关联图` | - | - | 可视化知识关联 |
| `Kiro KB: 导出知识` | - | - | 导出为 MD/HTML/JSON |
| `Kiro KB: Git 同步` | - | - | Git 操作菜单 |
| `Kiro KB: Git 推送` | - | - | 推送到远程仓库 |
| `Kiro KB: Git 拉取` | - | - | 从远程仓库拉取 |
| `Kiro KB: 智能分类` | - | - | 对当前文件智能分类 |
| `Kiro KB: 批量分类` | - | - | 批量分类未分类文件 |
| `Kiro KB: 构建知识图谱` | - | - | 构建知识节点关联图谱 |
| `Kiro KB: 相关推荐` | - | - | 基于当前文件获取相关知识推荐 |
| `Kiro KB: 插入知识链接` | `Ctrl+Alt+L` | `Cmd+Alt+L` | 快速插入知识库文件链接 |
| `Kiro KB: 显示相关知识` | `Ctrl+Shift+Alt+R` | `Cmd+Shift+Alt+R` | 显示当前文件的相关知识推荐 |
| `Kiro KB: 分析知识缺口` | - | - | 分析知识库覆盖情况，识别知识缺口 |
| `Kiro KB: 健康度仪表盘` | - | - | 显示知识库健康度评估仪表盘 |
| `Kiro KB: 生成学习路径` | - | - | 基于主题生成学习路径 |
| `Kiro KB: 交互式知识图谱` | - | - | D3.js 力导向图可视化（支持搜索/过滤/拖拽） |
| `Kiro KB: 修复编码` | - | - | 为 Markdown 文件添加 UTF-8 BOM，解决跨设备中文乱码（v2.39.0 新增） |
| `Kiro KB: 显示反向链接` | - | - | 显示引用当前文件的所有知识（v2.41.0 新增） |
| `Kiro KB: 重建链接索引` | - | - | 重新扫描知识库构建链接索引（v2.41.0 新增） |
| `Kiro KB: 搜索统计` | - | - | 显示搜索习惯分析报告（v2.48.0 新增） |
| `Kiro KB: 生成日报` | - | - | 生成工作日报（需配置 Ollama）（v2.50.0 实现，暂未启用） |
| `Kiro KB: 生成周报` | - | - | 生成工作周报（需配置 Ollama）（v2.50.0 实现，暂未启用） |
| `Kiro KB: 测试 Ollama 连接` | - | - | 测试 Ollama 本地 AI 连接状态（v2.50.0 实现，暂未启用） |

> 自定义快捷键：`Ctrl+K Ctrl+S`（Mac: `Cmd+K Cmd+S`）打开设置，搜索 `kiro-kb`

---

## 知识库目录结构

```
KiroKnowledgeBase/
├── INDEX.md              # 自动生成的索引（按领域分类）
├── PROJECT-INDEX.md      # 自动生成的项目索引（按项目分类，v2.44.0 新增）
├── PROGRESS.md           # 进度追踪
├── README.md             # 说明文档
├── REPORT-YYYY-MM-DD.md  # 分析报告 (v2.11.0 新增)
├── discussions/          # 问题探讨
├── solutions/            # 解决方案
├── notes/                # 学习笔记
├── templates/            # 自定义模板 (v2.11.0 新增)
│   └── *.md              # 模板文件
└── backlog/              # 待办问题 (v2.1.0 新增)
    ├── pending/          # 待处理
    ├── draft/            # 已分析草稿
    ├── deleted/          # 已删除（保留60天）
    └── BACKLOG-INDEX.md  # 待办索引
```

---

## 问题文件格式

```yaml
---
id: q-20251224-001
date: 2025-12-24
status: pending          # pending/draft/resolved/deleted
priority: normal         # low/normal/high
priority_auto: false     # 是否自动计算
category: question       # bug/feature/idea/question
source_project: "项目名"
similar_count: 0
last_reminded: 2025-12-24
deleted_date: null
---

# 问题：XXX

问题描述...

---
## Kiro 分析 (草稿)

(待分析)

---
## 解决方案

(待解决)
```

---

## 优先级规则

1. 用户手动标记优先级
2. 未标记时，根据中央知识库中类似问题数量自动提升：
   - 类似问题 ≥ 3 → 高优先级
   - 类似问题 ≥ 2 → 普通优先级
   - 类似问题 < 2 → 低优先级

---

## 安装方式

1. 打开 VS Code/Kiro
2. 按 `Ctrl+Shift+X` 打开扩展面板
3. 点击右上角 `...` → `从 VSIX 安装`
4. 选择 `kiro-knowledge-base-2.1.0.vsix`
5. 重新加载窗口

---

## 使用流程

1. 安装插件后执行 `Kiro KB: 设置知识库`
2. 设置中央知识库路径
3. 日常使用中：
   - 想到问题但无法立即处理 → `暂存问题`
   - 查看待办 → 点击状态栏或执行 `查看待办`
   - 有新知识 → `同步到中央仓库`
4. 定期执行 `生成索引` 更新索引
5. Steering 规则会自动检索和提醒保存

---

## Hook 模板

插件提供预配置的 Kiro Hook 模板，位于 `hooks-templates/` 目录：

| 模板文件 | 触发时机 | 功能 |
|----------|----------|------|
| `auto-save-knowledge.json` | 会话结束 | 智能评估（10分制）并保存有价值内容，自动向用户反馈保存结果 |
| `auto-search-kb.json` | 新会话开始 | 自动检索知识库相关内容 |
| `auto-update-index.json` | 知识库文件变更 | 自动更新 INDEX.md 索引 |
| `daily-review.json` | 手动触发 | 提醒回顾待办问题 |

### 使用方法

**方法一：使用模板文件（推荐）**

1. 从 `hooks-templates/` 目录复制需要的 `.json` 文件到你项目的 `.kiro/hooks/`
2. 修改文件中的 `{{CENTRAL_KB_PATH}}` 为你的实际路径
3. 重启 Kiro 或刷新 Agent Hooks 面板

**方法二：通过 Kiro UI 创建**

1. 在 Kiro 侧边栏找到 "Agent Hooks" 面板
2. 点击 `+` 按钮
3. 输入描述让 Kiro 自动创建：
   - `auto save kb` - 自动保存知识
   - `auto search kb` - 自动检索知识库

### 路径配置说明

模板中的 `{{CENTRAL_KB_PATH}}` 需要替换为你的实际路径：
- Windows: `D:\\G_GitHub\\Kiro-Central-KB`（注意双反斜杠）
- macOS/Linux: `/Users/yourname/KiroKnowledgeBase`

---

## 单元测试

插件包含单元测试，位于 `extension/src/test/extension.test.ts`：

| 测试模块 | 覆盖内容 |
|----------|----------|
| i18n Module | 语言切换、翻译函数（无参数/带参数/多参数） |
| Type Definitions | BacklogItem、SmartAnalysisResult、KBValidationResult 类型验证 |
| Smart Analysis | 智能分类检测（Bug/Feature/Idea）、优先级检测（高/低） |
| File Name Generation | 待办 ID 格式验证（`q-YYYYMMDD-XXXX`） |
| Path Handling | 知识库结构验证（discussions/solutions/notes） |
| Date Calculations | 天数计算（今天=0，7天前=7） |

### 运行测试

```bash
cd extension
npm run compile
# 测试文件编译到 out/test/extension.test.js
```

---

## v2.33.0 新增功能

### 72. Sidebar Overview Node (侧边栏概览节点)
- 在知识面板顶部新增"📊 概览"节点
- **统计信息展示**：
  - 📚 总知识数：本地 + 中央知识总数（tooltip 显示分布）
  - 📈 本周更新：最近 7 天内更新的知识数量
  - 📋 待处理：待办问题数量（点击可查看待办列表）
  - ⚠️ 需复查：过期知识数量（点击可复查过期知识）
- **健康度评分**：
  - 综合评分 0-100%
  - 状态图标：🟢≥80% / 🟡≥60% / 🔴<60%
  - 点击可查看详细健康报告
- **健康度计算规则**：
  - 基础分 100 分
  - 过期知识占比扣分（每 10% 扣 5 分，最多扣 30 分）
  - 待办积压扣分（每 5 个扣 5 分，最多扣 20 分）
  - 本周无更新扣 10 分
  - 知识库太小（<10 篇）扣 10 分

### 73. Sidebar Quick Actions Node (侧边栏快捷操作节点)
- 在知识面板新增"⚡ 快捷操作"节点
- **快捷入口**：
  - 📸 智能捕获 (`Ctrl+Alt+C`)
  - 💡 暂存问题 (`Ctrl+Alt+Q`)
  - 🔍 快速搜索 (`Ctrl+Alt+K`)
  - 💡 智能推荐 (`Ctrl+Alt+R`)
  - ☁️ 同步到中央
  - 📑 生成索引
- 点击即可执行对应命令

### 74. Sidebar Health Details Node (侧边栏健康度详情节点)
- 在知识面板新增"❤️ 健康度"展开节点
- **详情指标**：
  - 📊 综合评分：X/100
  - 过期占比：🟢≤10% / 🟡≤30% / 🔴>30%
  - 待办积压：🟢≤5 / 🟡≤15 / 🔴>15
  - 本周活跃：🟢活跃 / 🔴不活跃
  - 📋 查看详细报告...（链接到健康度仪表盘）

---

## v2.32.0 新增功能 (计划)

### 66. TF-IDF Semantic Search Engine (TF-IDF 语义搜索引擎)
- 新增 `TFIDFSearchEngine` 类，提供比简单关键词匹配更精准的语义搜索
- **核心算法**：
  - TF (词频) 计算：归一化词频统计
  - IDF (逆文档频率) 计算：`log(N / df)` 衡量词的重要性
  - TF-IDF 相似度：查询与文档的加权匹配分数
- **中英文分词**：
  - 英文：按空格/标点分词，过滤短词
  - 中文：2-3 字 N-gram 切分
  - 停用词过滤：50+ 中英文常见停用词
- **文档索引管理**：
  - `addDocument()` - 添加单个文档到索引
  - `addDocuments()` - 批量添加文档
  - `rebuildIDF()` - 重建 IDF 索引
  - `clear()` - 清空索引
- **搜索功能**：
  - `search(query, limit)` - TF-IDF 搜索，返回匹配文档列表
  - 标题精确匹配加分
  - 领域匹配加分
  - 返回匹配词列表便于高亮
- **相似文档查找**：
  - `findSimilar(docId, limit)` - 基于余弦相似度查找相似文档
  - 返回相似度分数和共享关键词
- **索引统计**：
  - `getStats()` - 返回文档数、词汇数、平均文档长度
- 导出单例 `tfidfEngine` 供其他模块使用

### 67. Smart Link Suggestions (智能链接建议)
- 新增 Markdown 智能链接补全和相关知识提示功能
- **KnowledgeLinkCompletionProvider**：
  - 在 Markdown 文件中输入 `[[` 触发知识库链接补全
  - 自动搜索知识库文件，显示匹配的知识条目
  - 支持按标题、标签、领域过滤
  - 插入格式化的知识链接
- **KnowledgeHoverProvider**：
  - 悬停在知识链接上显示相关知识预览
  - 显示文件标题、标签、摘要等信息
  - 快速预览知识内容
- **新增命令**：
  - `Kiro KB: 插入知识链接` - 快速插入知识库文件链接
  - `Kiro KB: 显示相关知识` - 显示当前文件的相关知识推荐
- 触发字符：`[`, `[[`

### 68. Knowledge Gap Analyzer (知识缺口分析器)
- 新增 `KnowledgeGapAnalyzer` 类，分析知识库覆盖情况并识别知识缺口
- **领域期望主题定义**：
  - Unity：入门、Shader、性能优化、UI、物理、动画等 20+ 主题
  - Kiro：安装配置、Steering、Hooks、MCP、插件开发等主题
  - DevOps：CI/CD、Git、Docker、AWS 等主题
  - Web：前端、后端、全栈等主题
  - AI：LLM、Prompt 工程、RAG 等主题
  - Database：SQL、NoSQL、缓存策略等主题
- **缺口分析功能**：
  - `analyze()` - 分析知识文件列表，返回缺口分析报告
  - 按领域统计知识数量和覆盖率
  - 对比期望主题与已覆盖主题
  - 识别缺失主题并评估严重程度
- **缺口严重程度评估**：
  - `high` - 基础主题缺失且领域有内容
  - `medium` - 领域有较多内容但缺少某主题
  - `low` - 领域内容较少，缺口影响有限
- **报告生成**：
  - `generateReport()` - 生成详细的缺口分析报告（支持中英文）
  - 领域覆盖率表格（含进度条可视化）
  - 高/中优先级缺口列表
  - 智能建议（补充方向、低覆盖率领域提醒）
- **类型定义**：
  - `KnowledgeGap` - 知识缺口（领域、主题、严重程度、建议）
  - `DomainCoverage` - 领域覆盖统计
  - `GapAnalysisReport` - 缺口分析报告
- 导出单例 `gapAnalyzer` 供其他模块使用

### 69. Health Dashboard (知识库健康度仪表盘) - P8
- 新增 `HealthAnalyzer` 类，提供知识库整体健康度评估和可视化仪表盘
- **总体健康度**：
  - 0-100 分综合评分
  - A/B/C/D/F 等级评定
- **7 个关键指标监控**：
  - 知识总量：目标 ≥50 篇，状态 good/warning/critical
  - 月活跃度：目标 ≥10 篇/月，含趋势指示（↑/↓/稳定）
  - 高质量占比：A/B 级知识占比百分比
  - 平均质量分：0-10 分，目标 ≥7 分
  - 领域均衡度：基于变异系数计算，越均衡分数越高
  - 内容新鲜度：180 天内更新的内容占比
  - 标签丰富度：平均每篇知识的标签数量
- **活跃度统计**：
  - 最近 7 天/30 天/90 天新增数量
  - 周均新增数量
- **质量分布**：
  - A/B/C/D/F 各等级数量和占比
  - 平均质量分
- **领域/类型平衡分析**：
  - 各领域知识数量和占比
  - 各类型知识数量和占比
  - 主要领域识别
- **智能告警系统**：
  - `info` - 信息提示（如过期内容提醒）
  - `warning` - 警告（如 30 天无新增、低质量内容过多）
  - `error` - 严重问题（如健康度过低）
- **仪表盘报告生成**：
  - `generateReport()` - 生成详细的健康度报告（支持中英文）
  - 进度条可视化（█░ 格式）
  - 关键指标表格
  - 活跃度统计
  - 质量分布表格
  - 领域分布图
  - 告警与建议列表
- **类型定义**：
  - `HealthMetric` - 健康度指标（名称、数值、状态、趋势、描述）
  - `ActivityStats` - 活跃度统计
  - `QualityDistribution` - 质量分布
  - `HealthDashboard` - 完整仪表盘数据
- 导出单例 `healthAnalyzer` 供其他模块使用

---

## v2.45.0 新增功能

### 85. Learning Path Generator (学习路径生成器) ✅ 已实现
- 新增 `learningPath.ts` 模块，基于主题自动生成学习路径
- **LearningPathGenerator 类**：
  - `generate(topic, knowledgeFiles, options)` - 生成学习路径
  - `generateReport(learningPath)` - 生成 Markdown 报告
- **学习步骤 (LearningStep)**：
  - order - 步骤顺序
  - filePath/title - 文件路径和标题
  - domain - 所属领域
  - difficulty - 难度级别（beginner/intermediate/advanced/expert）
  - estimatedMinutes - 预计阅读时间
  - prerequisites - 前置知识依赖（标题列表）
  - keyPoints - 关键点列表（最多 8 个）
  - isCompleted - 完成状态（用于进度追踪）
- **学习路径 (LearningPath)**：
  - id/topic - 路径标识和主题
  - domain - 主要领域
  - description - 路径描述
  - totalSteps/totalMinutes - 总步骤数和总时间
  - difficulty - 整体难度（beginner/intermediate/advanced/mixed）
  - steps - 学习步骤列表
  - createdAt - 创建时间
- **核心功能**：
  - **筛选相关文件**：
    - 标题关键词匹配
    - 标签匹配
    - 领域匹配
    - 按日期排序（新的在前）
  - **难度分析**：
    - 关键词检测（入门/基础/高级/深入/原理/专家/架构等）
    - 标题权重更高（-2 到 +3 分）
    - 代码复杂度分析（>100 行 +2 分，>50 行 +1 分，<20 行 -1 分）
    - 4 级难度：beginner(≤-1)/intermediate(≤1)/advanced(≤3)/expert(>3)
  - **阅读时间估算**：
    - 中文 400 字/分钟
    - 英文 200 词/分钟
    - 代码块 2 分钟/块
    - 最少 5 分钟
  - **关键点提取**：
    - 从二级标题提取（最多 5 个）
    - 从列表项提取（最多 3 个）
    - 总计最多 8 个关键点
  - **前置知识依赖**：
    - 按难度排序（从易到难）
    - 难度递增时自动添加前置依赖
  - **整体难度判定**：
    - 单一难度 → 返回该难度
    - ≥3 种难度 → mixed
    - 包含 expert/advanced → advanced
    - 包含 intermediate → intermediate
    - 其他 → beginner
  - **选项支持**：
    - maxSteps - 限制最大步骤数
    - targetDifficulty - 只保留指定难度的步骤
- **报告生成**：
  - YAML front-matter（id/topic/domain/difficulty/total_steps/total_minutes/created_at）
  - 路径概览（主题/难度/步骤数/预计时间）
  - 学习步骤详情：
    - 难度 emoji（🌱入门/🌿进阶/🌳高级/🎯专家）
    - 文件路径/难度/时间
    - 关键点列表
    - 前置知识
  - 进度追踪表格（步骤/标题/状态）
  - 支持中英文
- **导出单例**：`learningPathGenerator` 供其他模块使用
- **使用场景**：
  - 新人学习某个技术栈
  - 系统学习某个领域知识
  - 复习和巩固知识体系
  - 知识库内容导航

---

## v2.44.0 新增功能

### 81. Save Location Picker (保存位置选择器)
- 保存知识时弹出位置选择对话框，支持多种保存目标
- **保存位置选项**：
  - `📁 当前项目知识库` - 保存到 `knowledge-base/{folder}/`
  - `☁️ 中央知识库 - 项目目录` - 保存到 `projects/{projectName}/{folder}/`
  - `🌐 中央知识库 - 通用目录` - 保存到中央 KB 根目录的 `{folder}/`
  - `📚 中央知识库 - 领域目录` - 保存到 `domains/{domain}/{folder}/`
- **领域选择**：
  - 扫描现有领域目录
  - 预定义领域：unity, kiro, web, backend, devops, ai-ml, tools
  - 支持自定义领域输入
- **知识层级标记**：
  - `project` - 项目级知识
  - `project-group` - 项目组/通用知识
  - `domain` - 领域级知识
- **新增函数**：
  - `showSaveLocationPicker(folder, suggestedLevel)` - 显示保存位置选择对话框
  - `selectDomain()` - 领域选择对话框

### 82. Duplicate Detection Before Save (保存前重复检测)
- 保存知识前自动检测是否存在相似内容，避免重复
- **检测范围**：
  - 本地知识库 (solutions/notes/discussions)
  - 中央知识库根目录
  - 中央知识库 projects 子目录
  - 中央知识库 domains 子目录
- **相似度算法**：
  - 基于标题的 Jaccard 相似度计算
  - 阈值：60% 以上视为相似
  - 中英文分词支持
- **用户交互**：
  - 发现相似知识时弹出警告
  - 显示相似度百分比和匹配标题
  - 选项：查看已有 / 仍然保存 / 取消
  - 查看已有后可再次选择是否继续保存
- **新增函数**：
  - `checkDuplicateBeforeSave(title, content)` - 重复检测
  - `calculateTitleSimilarity(title1, title2)` - 标题相似度计算

### 83. Project Type Classification (项目类型分类)
- 项目绑定增强，新增项目类型分类功能
- **ProjectType 类型定义**：
  - `unity-game` - Unity 游戏项目
  - `vscode-extension` - VSCode/Kiro 插件
  - `web-app` - Web 应用
  - `mobile-app` - 移动应用
  - `backend` - 后端服务
  - `ai-ml` - AI/ML 项目
  - `devops` - DevOps/工具
  - `other` - 其他
- **PROJECT_TYPE_LABELS 常量**：
  - 提供中英文显示名称
  - 格式：`{ zh: string; en: string }`
- **ProjectBinding 接口增强**：
  - 新增 `projectType: ProjectType` - 标识项目类型
  - 新增 `centralSaveMode: 'projects' | 'flat'` - 保存到中央时的目标目录模式
    - `projects` - 保存到 `projects/<projectName>/` 目录
    - `flat` - 保存到根目录下的 solutions/notes/discussions

### 84. Project Index Generation (项目索引生成)
- 项目绑定增强，新增项目类型分类功能
- **ProjectType 类型定义**：
  - `unity-game` - Unity 游戏项目
  - `vscode-extension` - VSCode/Kiro 插件
  - `web-app` - Web 应用
  - `mobile-app` - 移动应用
  - `backend` - 后端服务
  - `ai-ml` - AI/ML 项目
  - `devops` - DevOps/工具
  - `other` - 其他
- **PROJECT_TYPE_LABELS 常量**：
  - 提供中英文显示名称
  - 格式：`{ zh: string; en: string }`
- **ProjectBinding 接口增强**：
  - 新增 `projectType: ProjectType` - 标识项目类型
  - 新增 `centralSaveMode: 'projects' | 'flat'` - 保存到中央时的目标目录模式
    - `projects` - 保存到 `projects/<projectName>/` 目录
    - `flat` - 保存到根目录下的 solutions/notes/discussions
- 生成索引时自动创建 PROJECT-INDEX.md（按项目分类的索引）
- **索引内容**：
  - 项目统计表格：按项目类型统计项目数和知识条目数
  - 按项目类型分组：🎮游戏/🔌插件/🌐Web/📱移动/⚙️后端/🤖AI/🛠️DevOps/📁其他
  - 每个项目显示最近 20 条知识（按日期倒序）
  - 超过 20 条时显示"还有 N 条"提示
- **数据来源**：
  - 从 YAML front-matter 提取 `source_project` 字段
  - 从 YAML front-matter 提取 `source_project_type` 字段
  - 未分类项目归入"未分类"组
- **新增函数**：
  - `generateProjectIndex(allFiles)` - 生成按项目分类的索引文件

---

## v2.44.0 测试结果 ✅

**测试日期**: 2026-01-05  
**测试状态**: 通过  
**知识库规模**: 92 篇文档  
**综合评分**: 9.4/10

### 性能测试
- ✅ 重复检测性能：965ms < 2000ms 目标
- ✅ 扫描速度：95.3 篇/秒
- ✅ 用户体验：无感知延迟

### 功能验证
- ✅ 保存位置选择器：4 种位置选项全部可用
- ✅ 保存前重复检测：60% 相似度阈值，多目录扫描
- ✅ 项目类型分组视图：8 种类型，三级展开结构
- ✅ 侧边栏概览节点：5 项统计信息，健康度评分
- ✅ 快捷操作节点：7 个快捷入口
- ✅ 健康度详情节点：4 项详细指标

### 代码质量
- ✅ 模块化设计清晰
- ✅ 函数职责单一
- ✅ 类型定义完整
- ✅ 错误处理完善

### 发布建议
✅ **推荐立即发布**

**理由**:
1. 所有核心功能完整实现并通过验证
2. 性能测试结果优秀
3. 代码质量高，结构清晰
4. 无严重 Bug 或阻塞性问题
5. 用户体验良好

**详细报告**: [v2.44.0 测试结果报告](./docs/20260105-v2.44-test-results.md)

---

## v2.40.0 新增功能

### 80. Smart Title Generation (智能标题生成)
- 对话整理模块 (`conversationDigest.ts`) 标题生成增强
- **无意义前缀清理**：
  - `## TASK 1:` 等任务前缀
  - `[自动化]`、`Execute hook:`、`Creating hook:` 等 Hook 前缀
  - `**STATUS**: done` 等状态标记
  - `**USER QUERIES**`、`**DETAILS**` 等元数据标记
  - 代码块开头、引用块等 Markdown 格式
- **Markdown 格式清理**：
  - 标题标记 (`#`)
  - 加粗 (`**text**`)、斜体 (`*text*`)
  - 行内代码 (`` `code` ``)
  - 链接 (`[text](url)`)
- **问句转陈述句**：
  - 如何/怎么/怎样 → 方法
  - 为什么 → 原因
  - 什么是 → 介绍
  - 能不能/可以...吗 → 实现/方案
  - How to → Guide
  - What is → Introduction
  - Why → Explanation
- **智能标题提取**：
  - 当用户问题无意义时，从 AI 回答中提取标题
  - 优先提取第一个标题 (`# xxx`)
  - 其次提取第一句话
  - 最后提取第一行内容
- **智能截断**：
  - 最长 50 字符
  - 优先在标点处截断（逗号、顿号、分号等）
  - 避免断词，保持语义完整
- **Hook 执行识别**：
  - 自动识别 Hook 执行对话
  - 生成 `Hook: <hookName>` 格式标题
- **新增函数**：
  - `generateSmartTitle()` - 智能生成知识标题
  - `extractTitleFromBotResponse()` - 从 AI 回答提取标题
  - `convertQuestionToStatement()` - 问句转陈述句

---

## v2.48.0 新增功能

### 86. Smart Search Suggestions (智能搜索建议)
- 新增 `SearchHistory.getSuggestions()` 方法，基于历史记录提供智能搜索建议
- **多策略匹配算法**（按优先级依次匹配）：
  1. **精确前缀匹配**（优先级最高）- 查询是历史记录的开头
  2. **包含匹配**（优先级中）- 查询包含在历史记录中
  3. **分词匹配**（优先级低）- 中英文分词后的模糊匹配
- **中英文分词支持**：
  - 英文：正则提取单词 (`/[a-z]+/g`)
  - 中文：2-3 字 N-gram 切分
- **热门搜索统计**：
  - `getPopularSearches(count)` - 统计查询出现次数，按频率排序
  - 返回 Top N 热门搜索
- **无输入时显示热门搜索**：
  - 输入为空时自动返回 Top 5 热门搜索
  - 帮助用户快速访问常用查询
- **性能优化**：
  - 搜索建议生成 < 10ms（50条历史）
  - 使用 Set 自动去重
  - 限制返回最多 10 个建议
- **技术实现**：
  - `tokenize(text)` - 简单分词实现（英文单词 + 中文2-3字切分）
  - 优先级控制：只有前面策略不够时才用下一个策略
  - 避免低质量建议混入

### 87. Search Statistics Report (搜索统计报告)
- 新增 `Kiro KB: 搜索统计` 命令，显示搜索习惯分析报告
- **总体统计**：
  - 总搜索次数
  - 关键词搜索 vs 语义搜索分布（数量 + 百分比）
  - 平均结果数
- **热门搜索 Top 10**：
  - 按出现次数排序
  - 显示最常搜索的查询
- **最近搜索记录**：
  - 最近 10 次搜索
  - 显示搜索模式图标（🔍关键词 / 🤖语义）
  - 智能时间显示（刚刚/X分钟前/X小时前/X天前）
  - 显示结果数量
- **智能使用建议**：
  - 语义搜索使用率过低 → 建议尝试语义搜索
  - 搜索次数过少 → 建议多使用搜索功能
  - 热门搜索提示 → 建议添加到收藏夹
- **报告格式**：
  - Markdown 格式，表格 + 列表展示
  - 在虚拟文档中预览显示
  - 支持中英文
- **命令**：`Kiro KB: 搜索统计` / `Kiro KB: Search Statistics`

---

## v2.39.0 新增功能

### 79. Encoding Module (编码处理模块)
- 新增 `encoding.ts` 模块，统一编码处理，解决跨设备中文乱码问题
- **问题背景**：Windows 跨设备同步时，UTF-8 文件可能被错误识别为其他编码，导致中文乱码
- **解决方案**：
  - 写入时添加 UTF-8 BOM 标记
  - 读取时自动检测并转换编码
  - 提供编码修复命令
- **编码检测** (`detectEncoding`)：
  - 支持 UTF-8 BOM、UTF-8、UTF-16LE、UTF-16BE 检测
  - 基于 BOM 标记和字节序列验证
  - 返回编码类型：`'utf8-bom' | 'utf8' | 'utf16le' | 'utf16be' | 'unknown'`
- **安全读取** (`safeReadFileWithEncoding`)：
  - 自动检测文件编码
  - 根据编码类型正确解码内容
  - UTF-16BE 手动字节交换转换
  - 错误处理返回空字符串
- **安全写入** (`safeWriteFileWithEncoding`)：
  - 自动创建目录结构
  - 移除已有 BOM 避免重复
  - 可选添加 UTF-8 BOM（默认添加，Markdown 文件推荐）
  - 使用 Buffer 确保 BOM 正确写入
- **BOM 管理**：
  - `hasBom(filePath)` - 检查文件是否有 BOM
  - `addBomToFile(filePath)` - 为文件添加 UTF-8 BOM
- **批量修复**：
  - `fixEncodingInDirectory(dirPath, recursive)` - 批量修复目录下所有 Markdown 文件的编码
  - `countFilesWithoutBom(dirPath)` - 统计缺少 BOM 的文件数量
  - 自动跳过隐藏目录和 node_modules
- **新增命令**：`Kiro KB: 修复编码`
  - 支持选择本地知识库、中央知识库或全部修复
  - 显示需要修复的文件数量
  - 进度条显示修复进度
- **常量定义**：
  - `UTF8_BOM` - BOM 字符串标记 (`'\uFEFF'`)
  - `UTF8_BOM_BUFFER` - BOM 字节序列 (`Buffer.from([0xEF, 0xBB, 0xBF])`)

---

## v2.38.0 新增功能

### 78. Knowledge Organizer (知识整理助手)
- 新增 `knowledgeOrganizer.ts` 模块，分析知识库问题并生成整理提示
- **设计理念**：插件分析问题，生成结构化提示让 Kiro 执行整理操作
- **问题检测功能**：
  - **标题问题检测** (`detectTitleIssues`)：
    - `task-prefix` - 检测 `## TASK 1:` 等任务前缀
    - `hook-prefix` - 检测 `[自动化]`、`Execute hook:` 等前缀
    - `too-long` - 检测超过 60 字符的过长标题
    - `no-meaning` - 检测无意义标题（上传/读取/保存/同步/测试等）
  - **相似内容检测** (`detectSimilarGroups`)：
    - 按版本号分组（v2.xx 系列自动归类）
    - 基于关键词相似度分组（Jaccard 算法，阈值 0.6）
    - 生成合并标题建议
  - **低价值文件检测** (`detectLowValueFiles`)：
    - 内容过短（<200 字符）扣 2 分
    - 无标签扣 1 分
    - 标题无意义扣 2 分
    - 自动生成且内容少扣 1 分
    - 评分 ≤3 分标记为低价值
- **关键词提取**：
  - 30+ 技术关键词（typescript, react, unity, kiro, vscode 等）
  - 版本号提取（v1.0.0 格式）
  - 用于相似度计算
- **导出函数**：
  - `analyzeKnowledgeBase(kbPath)` - 分析知识库，返回 `OrganizeAnalysis`
  - `generateOrganizePrompt(analysis, kbPath)` - 生成整理提示（给 Kiro 执行）
  - `getOrganizeStatus(kbPath)` - 获取知识库整理状态摘要
- **生成的整理提示包含**：
  - 需要合并的文件（源文件列表 + 建议合并标题 + 操作说明）
  - 需要重命名的文件（当前标题 | 建议标题 | 问题类型 表格）
  - 建议删除的文件（文件路径 + 原因 + 评分）
- **类型定义**：
  - `KnowledgeFile` - 知识文件信息（path/title/content/tags/date/wordCount/category）
  - `TitleIssue` - 标题问题（file/issue/suggestedTitle）
  - `SimilarGroup` - 相似文件组（files/similarity/suggestedMergeTitle/reason）
  - `LowValueFile` - 低价值文件（file/reason/score）
  - `OrganizeAnalysis` - 分析结果（titleIssues/similarGroups/lowValueFiles/totalFiles/issueCount）

---

## v2.37.0 新增功能

### 77. Enhanced Conversation Digest (对话整理增强)
- 对话整理模块 (`conversationDigest.ts`) 功能增强
- **重复检测**：保存前检查知识库是否已有类似内容，避免重复保存
- **知识提炼**：将对话转化为结构化的问题→解决方案格式，提升知识可读性
- **问答匹配 API**：
  - `checkExistingKnowledge(question)` - 检查问题是否在知识库中已有答案
    - 扫描本地和中央知识库
    - 基于关键词相似度匹配（Jaccard 算法）
    - 返回 `{ found: boolean, matches: { title, path, similarity }[] }`
    - 相似度 ≥0.4 视为找到匹配
  - `showRelatedKnowledgeHint(question)` - 提问时显示相似知识提示
    - 自动弹出提示框显示最相似的知识条目
    - 用户可选择"查看"打开文件或"继续提问"

---

## v2.35.0 新增功能

### 76. Conversation Digest Module (对话整理模块)
- 新增 `conversationDigest.ts` 模块，智能整理 Kiro 对话到项目知识库
- **设计理念**：每次与 Kiro 的交互都是有价值的知识点
  - 用户的问题 = 小白会遇到的问题
  - Kiro 的回答 = 解决方案和操作步骤
- **三个触发时机**：
  - 首次打开项目：扫描历史对话，提示用户是否整理
  - 工作期间：后台监控，支持手动整理
  - 关闭项目时：提示用户整理本次会话内容
- **筛选模式选择**（执行整理命令时）：
  - 🔍 预览所有对话：显示所有对话供手动选择（minScore=1）
  - ⭐ 仅高价值 (≥5分)：自动筛选有价值的对话（默认）
  - 📝 中等价值 (≥3分)：包含更多对话
- **会话存储路径检测**：
  - 支持新版 `workspace-sessions` 结构（Base64 编码路径）
  - 兼容旧版 hash 目录结构（`.chat` 文件）
  - 精确匹配 + 模糊匹配（项目名）双重查找策略
- **对话分析功能**：
  - 自动解析会话文件，支持双格式：
    - 新版 `.json` 格式（workspace-sessions）：解析 `history` 数组
    - 旧版 `.chat` 格式：解析 `context` 数组
  - 提取用户问题和 AI 回复
  - 识别代码片段（最多 5 个）
  - 提取关键点（从列表项和步骤提取，最多 8 个）
- **智能分类**：
  - 基于关键词检测分类（solution/note/discussion）
  - 解决方案关键词：error, bug, fix, 错误, 修复, 解决, 报错, 失败, 不工作...
  - 讨论关键词：design, architecture, 设计, 架构, 方案, 讨论, 怎么做, 如何...
  - 学习类关键词：什么是, 怎么, 如何, 为什么, what, how, why, 学习, 理解...
  - Hook 执行对话归类为自动化/配置类知识（不再过滤，标记 automation/hook 标签）
- **技术标签提取**：
  - 自动识别 25+ 种技术关键词（typescript, python, react, unity, shader, kiro, npm, package, compile, build, 编译, 打包, 配置 等）
  - 去重并限制最多 8 个标签
- **价值评分系统**（对小白友好）：
  - 基础分 3 分（有问有答就有价值）
  - 内容丰富度：>300字符 +1 分，>1000字符 +2 分，>3000字符 +3 分
  - 有代码示例 +2 分（实操性强）
  - 多轮对话 (>6轮) +1 分（深入讨论）
  - 问题解决类 +1 分
  - 最高 10 分，默认阈值 5 分
- **整理状态管理**：
  - 状态文件：`.kiro/.kiro-kb-digest-state.json`
  - 记录上次整理时间和已整理会话 ID
  - 自动清理超过 1000 个的历史 ID
- **导出函数**：
  - `scanAndDigestConversations()` - 扫描并整理对话
  - `checkOnProjectOpen()` - 首次打开项目检查
  - `promptOnProjectClose()` - 关闭项目提示
  - `getConversationStats()` - 获取对话统计信息
- **生成文档格式**：
  - 标准 YAML front-matter（domain/tags/date/source_project/source/value_score）
  - 背景/问题、要点、关键代码、注意事项章节
  - 自动标注 `source: kiro-conversation`

---

## v2.34.0 新增功能

### 75. Enhanced Current Project Node (当前项目节点增强)
- 侧边栏"本地知识"改为"当前项目"，显示更直观
- **根节点显示**：
  - 显示项目名称：`🟢 当前项目: ProjectName`
  - 状态图标：🟢 正常 / 🟡 有未同步内容 / 🔴 有待处理问题
  - 未初始化时显示 `📁 ProjectName (点击初始化)`
- **展开后显示详细状态**：
  - 📋 待处理 (N) - backlog/pending 中的问题
  - 📝 草稿 (N) - backlog/draft 中的内容
  - ✅ 已解决 (N) - solutions 中的文件
  - 📒 笔记 (N) - notes 中的文件
  - 💬 讨论 (N) - discussions 中的文件
  - ☁️ 未同步 (N) - 点击可同步到中央
- **新增方法**：
  - `getProjectStats()` - 统计项目各类文件数量（total/pending/draft/unsynced）

---

### 71. Interactive Knowledge Graph (交互式知识图谱)
- 新增 `Kiro KB: 交互式知识图谱` 命令
- 使用 D3.js 力导向图实现交互式可视化
- **核心功能**：
  - 力导向布局：节点自动排列，支持拖拽调整位置
  - 缩放平移：鼠标滚轮缩放，拖拽画布平移
  - 节点着色：按领域自动着色（Unity=蓝色, Kiro=绿色, DevOps=橙色, Web=紫色, AI=粉色, Database=青色）
  - 节点大小：根据质量评分动态调整节点大小
  - 边权重：边的粗细反映关联强度
- **交互功能**：
  - 🔍 搜索过滤：按标题/标签实时过滤节点
  - 📁 领域筛选：下拉选择特定领域
  - 🔄 重置视图：一键恢复初始状态
  - 🏷️ 切换标签：显示/隐藏节点标签
  - 📂 点击打开：点击节点在侧边打开对应文件
- **悬停提示**：
  - 显示节点标题、领域、标签
  - 质量评分进度条可视化
- **统计信息**：实时显示节点数和边数
- 命令：`Kiro KB: 交互式知识图谱`

---

## v2.31.0 新增功能

### 63. Enhanced Project Binding (项目绑定增强)
- 使用 UUID 作为项目唯一标识，不随项目改名而变化
- **新增字段**：
  - `projectId` - UUID 格式的唯一项目标识
  - `projectName` - 项目显示名称（可变）
  - `defaultSaveLocation` - 默认保存位置配置（central/local/both）
- **新增函数**：
  - `generateUUID()` - 生成 UUID
  - `findCentralProjectById()` - 通过 projectId 查找中央项目
  - `getProjectBinding()` - 获取当前项目绑定信息
- 项目绑定配置结构升级，支持更灵活的项目管理

### 64. Smart Question Save Location (智能问题保存位置)
- 暂存问题时根据项目绑定的 `defaultSaveLocation` 决定保存位置
- **保存位置优先级**：
  1. 项目绑定的 `defaultSaveLocation` 设置（优先）
  2. 全局 `backlogMode` 配置（回退）
- **保存模式**：
  - `central` - 保存到绑定的中央项目 `backlog/pending/`
  - `local` - 保存到本地项目 `knowledge-base/backlog/pending/`
  - `both` - 同时保存到中央和本地（双份备份）
- 未绑定项目时自动回退到全局 `backlogMode` 设置

### 65. Smart Capture Location Support (智能捕获位置支持)
- `captureContent` 命令同样支持 `defaultSaveLocation` 配置
- 根据项目绑定配置决定保存到中央项目还是本地知识库
- 保存成功后显示保存位置提示（如 `[已保存到中央]`）

---

## v2.30.0 新增功能

### 60. Project Binding (项目绑定) - v2.31.0 增强
- 新增项目绑定功能：将本地项目与中央知识库项目关联
- **自动检测**：打开项目时自动检测是否有同名中央项目，提示绑定
- **手动绑定**：`Kiro KB: 绑定项目` 命令手动选择中央项目
- **绑定配置**：绑定信息保存在 `.kiro-kb-binding.json`
- **v2.31.0 增强**：
  - `projectId` - UUID 格式的唯一项目标识（不随项目改名变化）
  - `projectName` - 项目显示名称（可变）
  - `defaultSaveLocation` - 默认保存位置（central/local/both）
- 新增类型：`ProjectInfo`、`ProjectStatus`

### 61. Real-time Sync (实时同步)
- 本地知识库文件保存时自动同步到中央项目
- 绑定后，本地 `knowledge-base/` 下的文件保存时自动复制到中央项目
- 可在绑定配置中开关 `autoSync`
- 命令：`Kiro KB: 同步到中央项目`

### 62. Code Comment Extraction (代码注释提取)
- 新增 `Kiro KB: 提取代码注释` 命令
- 支持提取 TODO/FIXME/NOTE/HACK/BUG 注释
- 支持扫描当前文件或整个项目
- 支持 .ts/.js/.py/.cs/.java/.cpp/.go/.rs 等多种语言
- 生成 Markdown 报告并保存到本地知识库

---

## v2.29.0 新增功能

### 58. Project Grouping (项目分组)
- 在侧边栏按项目组织知识
- 支持在中央知识库 `projects/` 目录下创建项目文件夹
- 每个项目可包含 docs/solutions/notes/backlog 子目录
- 项目状态图标：🟢 活跃 / 🟡 暂停 / ✅ 完成 / 📦 归档
- 通过 `PROJECT.md` 文件定义项目元数据（名称、状态、描述）
- 侧边栏自动显示项目数量和文件统计
- 命令：`Kiro KB: 创建项目`、`Kiro KB: 打开项目`

### 59. Project Migration (项目迁移)
- 新增 `Kiro KB: 迁移到项目` 命令
- 自动检测 `notes/` 目录下以 `-docs` 结尾的文件夹
- 一键迁移到 `projects/` 目录结构
- 自动创建 PROJECT.md 元数据文件
- 保留原始路径信息便于追溯

---

## v2.28.0 新增功能

### 57. Enhanced Backlog with Project Context (待办问题项目上下文增强)
- 待办问题增强：显示来源项目信息，支持快速打开来源项目
- 待办列表显示来源项目名称 `[ProjectName]`
- 新增"打开来源项目"操作，快速跳转到问题产生的项目
- 便于跨项目问题追踪和上下文恢复
- **启动时自动检测**：
  - 打开项目时自动扫描中央知识库中与当前项目相关的未处理问题
  - 按优先级排序显示（高优先级优先）
  - 支持直接查看、处理或忽略

---

## v2.27.0 新增功能

### 55. Context Analyzer (上下文分析器)
- 新增 `ContextAnalyzer` 类，分析当前编辑文件/选中文本的上下文
- **文件类型检测**：
  - 支持 20+ 文件扩展名映射（.cs/.ts/.py/.shader/.sql/.ps1 等）
  - 自动识别代码/Markdown/配置/文本类型
  - 根据扩展名推断可能的领域（如 .cs → Unity, .ps1 → DevOps）
- **技术栈检测**：
  - 80+ 技术关键词映射（Unity/Kiro/DevOps/Web/AI/Database）
  - 支持代码模式识别（如 `using UnityEngine`、`import React`）
  - 自动提取内容中的技术关键词
- **领域推断**：
  - 综合文件扩展名、技术关键词、内容关键词
  - 计算置信度分数（0-1）
  - 支持子领域识别（如 `unity/shader`、`web/frontend`）
- 导出单例 `contextAnalyzer` 供其他模块使用

### 56. Smart Recommendation Engine (智能推荐引擎)
- 新增 `SmartRecommendationEngine` 类，基于上下文和历史生成知识推荐
- **访问历史追踪**：
  - 记录文件访问次数、最后访问时间、累计阅读时长
  - 支持历史数据持久化（loadHistory/getAccessHistory）
- **多维度推荐算法**：
  - 领域匹配：同领域知识获得基础分（权重 × 置信度）
  - 技术栈匹配：共享技术标签加分
  - 关键词匹配：标题/标签关键词匹配加分
  - 历史加权：访问频率 + 时间衰减（1天内+2分，7天内+1.5分，30天内+1分）
  - 质量加权：高质量知识获得额外分数
- **推荐类型标识**：
  - `context` - 基于当前上下文匹配
  - `history` - 基于访问历史推荐
  - `related` - 基于关联关系推荐
  - `popular` - 基于热门程度推荐
- **辅助功能**：
  - `getPopularKnowledge()` - 获取热门知识（按访问次数排序）
  - `getRecentKnowledge()` - 获取最近访问（按时间排序）
  - `clearHistory()` - 清除访问历史
- 导出单例 `recommendationEngine` 供其他模块使用

---

## 源码结构 (v2.39.0)

```
extension/src/
├── extension.ts      # 主入口，命令注册和核心逻辑
│   ├── 工具函数：scanMdFiles, safeMove, getUniqueFileName, 
│   │            checkIsKnowledgeBaseStructure, ensureYamlFrontMatter, validateCentralKB
│   └── 常量：BACKLOG_FOLDERS, KB_FOLDERS, SMART_KEYWORDS
├── classifier.ts     # 智能分类引擎（v2.21.0 新增）
│   ├── KnowledgeClassifier：领域/类型/难度检测 + 标签建议 + 元数据生成
│   ├── SimilarityDetector：重复/相似内容检测（Jaccard 相似度）
│   ├── TagManager：标签统计、规范化、合并建议
│   ├── QualityAssessor：质量评分系统（v2.24.0 新增）
│   │   └── 5维度评估：结构/深度/元数据/可读性/时效性
│   ├── KnowledgeGraphBuilder：知识图谱构建器（v2.24.0 新增）
│   │   └── 节点/边管理、推荐、孤立/核心节点分析、Mermaid 可视化
│   ├── ContextAnalyzer：上下文分析器（v2.27.0 新增）
│   │   └── 文件类型检测、技术栈识别、领域推断
│   ├── SmartRecommendationEngine：智能推荐引擎（v2.27.0 新增）
│   │   └── 访问历史追踪、多维度推荐算法、热门/最近知识
│   ├── TFIDFSearchEngine：TF-IDF 语义搜索引擎（v2.32.0 新增）
│   │   └── 中英文分词、TF-IDF 计算、余弦相似度、文档索引管理
│   ├── KnowledgeGapAnalyzer：知识缺口分析器（v2.32.0 新增）
│   │   └── 领域覆盖率分析、缺口检测、严重程度评估、报告生成
│   ├── HealthAnalyzer：知识库健康度分析器（v2.33.0 新增）
│   │   └── 7维度健康度评估、活跃度统计、质量分布、领域平衡、智能告警
│   ├── LearningPathGenerator：学习路径生成器（v2.34.0 新增）
│   │   └── 主题学习路径生成、难度分析、阅读时间估算、前置知识依赖、进度追踪
│   └── 导出单例：classifier, similarityDetector, tagManager, qualityAssessor, graphBuilder, contextAnalyzer, recommendationEngine, tfidfEngine, gapAnalyzer, healthAnalyzer, learningPathGenerator
├── conversationDigest.ts  # 对话整理模块（v2.37.0 增强）
│   ├── 路径检测：encodePathToBase64, getWorkspaceSessionPath（支持新旧两种存储结构）
│   ├── 对话解析：parseChatFile, getRecentSessions
│   ├── 内容分析：analyzeConversation（分类/标签/价值评分）
│   ├── 重复检测：保存前检查知识库是否已有类似内容（v2.37.0 新增）
│   ├── 知识提炼：将对话转化为结构化的问题→解决方案格式（v2.37.0 新增）
│   ├── 问答匹配：checkExistingKnowledge 检查问题是否已有答案（v2.37.0 新增）
│   ├── 相关提示：showRelatedKnowledgeHint 提问时显示相似知识（v2.37.0 新增）
│   ├── 文档生成：generateKnowledgeDocument
│   ├── 状态管理：getDigestState, saveDigestState
│   └── 导出函数：scanAndDigestConversations, checkOnProjectOpen, promptOnProjectClose, getConversationStats, checkExistingKnowledge, showRelatedKnowledgeHint
├── encoding.ts       # 编码处理模块（v2.39.0 新增）
│   ├── 编码检测：detectEncoding（UTF-8/UTF-8 BOM/UTF-16LE/UTF-16BE）
│   ├── 安全读取：safeReadFileWithEncoding（自动处理编码）
│   ├── 安全写入：safeWriteFileWithEncoding（带 UTF-8 BOM）
│   ├── BOM 管理：hasBom, addBomToFile
│   ├── 批量修复：fixEncodingInDirectory, countFilesWithoutBom
│   └── 常量：UTF8_BOM, UTF8_BOM_BUFFER
├── knowledgeOrganizer.ts  # 知识整理助手（v2.38.0 新增）
│   ├── 标题问题检测：detectTitleIssues
│   ├── 相似内容检测：detectSimilarGroups
│   ├── 低价值文件检测：detectLowValueFiles
│   └── 导出函数：analyzeKnowledgeBase, generateOrganizePrompt, getOrganizeStatus
├── knowledgePanel.ts # 知识面板 TreeView Provider
├── i18n.ts           # 国际化模块（中/英文翻译）
├── types.ts          # 类型定义（15+ 类型，含 SmartKeywords）
└── test/
    └── extension.test.ts  # 单元测试
```

---

## 技术限制

- VS Code 扩展无法直接访问 Kiro 对话内容
- 自动保存功能依赖 Steering 规则实现
- 扩展只能提供定时提醒和工具命令


---

## v2.50.0 新增功能 (开发中 - 暂未启用)

### 88. Ollama Local AI Integration (Ollama 本地 AI 集成)

**状态**: 核心模块已实现，但暂未在插件激活时初始化。需要手动调用或等待后续版本启用。
- 集成 Ollama 本地 AI，实现工作模式分析和智能报告生成
- **核心理念**：AI 是工具，知识是资产 - 所有知识外化存储为 Markdown + Git，AI 可随时替换
- **OllamaClient 模块** (`ollama.ts`)：
  - 连接管理：`connect()`, `isConnected()`
  - AI 生成：`generate(prompt, model?)`
  - 模型管理：`getAvailableModels()`, `verifyModel()`, `setModel()`
  - 错误处理：连接失败、超时重试（指数退避）、模型缺失提示
- **WorkPatternTracker 模块** (`workPatternTracker.ts`)：
  - 追踪文件访问、搜索操作、Git 提交、编辑时长
  - 提供工作快照：`getWorkSnapshot()`, `getDailySnapshot()`, `getWeeklySnapshot()`
  - 持久化存储：`.kiro/work-tracking.json`
  - 性能优化：追踪开销 < 10ms/事件
- **ReportGenerator 模块** (`reportGenerator.ts`)：
  - 日报生成：`generateDailyReport()` - 保存到 `work-patterns/daily/YYYY-MM-DD.md`
  - 周报生成：`generateWeeklyReport()` - 保存到 `work-patterns/weekly/YYYY-WXX.md`
  - Work Profile 管理：`updateProfile()`, `getProfile()` - 维护 `work-patterns/profile.yaml`
  - 报告内容：活动摘要、时间分布、文件访问、搜索模式、Git 活动、AI 洞察
- **新增命令**：
  - `Kiro KB: 生成日报` - 手动生成当日工作报告
  - `Kiro KB: 生成周报` - 手动生成本周工作总结
  - `Kiro KB: 测试 Ollama 连接` - 测试 Ollama 服务连接状态
- **自动触发**（计划）：
  - 每日下班时提示生成日报
  - 每周日晚提示生成周报
  - 可配置触发时间和自动化程度
- **配置项**（计划）：
  - `kiro-kb.ollama.enabled` - 启用/禁用 Ollama 功能
  - `kiro-kb.ollama.baseUrl` - Ollama 服务地址（默认 http://localhost:11434）
  - `kiro-kb.ollama.model` - 使用的模型（默认 llama3.2:3b）
  - `kiro-kb.ollama.dailyReportTime` - 日报生成时间
  - `kiro-kb.ollama.weeklyReportDay` - 周报生成日期
- **隐私保护**：
  - 所有处理本地化，无云 API 调用
  - 只存储聚合统计，不存储原始文件内容
  - 用户可查看/编辑/删除所有生成的报告
- **跨设备同步**：
  - 报告文件通过 Git 同步到中央知识库
  - Work Profile 随知识库迁移
  - 支持多设备工作模式追踪
- **推荐模型**：
  - Llama 3.2 3B - 通用分析，英文优化
  - Qwen 2.5 3B - 中文优化，适合中文用户
  - DeepSeek Coder - 代码分析专用
- **参考文档**：
  - 设计文档：`.kiro/specs/ollama-integration/design.md`
  - 需求文档：`.kiro/specs/ollama-integration/requirements.md`
  - 任务列表：`.kiro/specs/ollama-integration/tasks.md`
  - 安装指南：`.kiro/specs/ollama-integration/SETUP-GUIDE.md`

---

**插件版本**: v2.50.0-dev  
**最后更新**: 2026-01-08
