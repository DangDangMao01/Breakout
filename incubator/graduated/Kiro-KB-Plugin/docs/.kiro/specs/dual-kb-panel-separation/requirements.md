# Requirements Document

## Introduction

本功能旨在在 Kiro Knowledge Base 插件的侧边栏面板中，明确区分"当前项目知识库"和"中央知识库"两个功能区域，使用户能够清晰地识别和操作不同层级的知识内容。

当前项目知识库专注于局部、专业、垂直的开发工作，而中央知识库则用于全局、统筹、横向的知识管理。通过界面区分，用户可以更高效地管理和检索不同范围的知识。

## Glossary

- **Knowledge_Panel**: 侧边栏知识面板，显示知识库内容的 TreeView 组件
- **Current_Project_KB**: 当前项目知识库，存储在项目本地 `knowledge-base/` 目录下的知识
- **Central_KB**: 中央知识库，存储在用户配置的中央路径下的跨项目知识
- **Section**: 面板中的功能区域，用于分组显示不同类型的功能
- **Search_History**: 搜索历史记录模块，记录用户的搜索行为
- **Search_Suggestions**: 基于历史记录的智能搜索建议功能

## Requirements

### Requirement 1: 双区域面板布局

**User Story:** 作为用户，我希望在侧边栏面板中看到明确分隔的两个区域，以便区分当前项目和中央知识库的功能。

#### Acceptance Criteria

1. WHEN 用户打开 Knowledge Base 侧边栏 THEN THE System SHALL 显示两个独立的可折叠区域："📁 当前项目"和"☁️ 中央知识库"
2. WHEN 用户展开"当前项目"区域 THEN THE System SHALL 显示项目相关的功能节点（对话整理、项目内搜索、插入链接、整理知识库）
3. WHEN 用户展开"中央知识库"区域 THEN THE System SHALL 显示全局功能节点（全局搜索、搜索建议、搜索统计、热门知识、跨项目浏览）
4. WHEN 两个区域同时存在 THEN THE System SHALL 确保它们在视觉上有明显的分隔
5. WHEN 用户折叠某个区域 THEN THE System SHALL 保持该区域的折叠状态直到用户再次展开

### Requirement 2: 当前项目区域功能

**User Story:** 作为开发者，我希望在"当前项目"区域快速访问项目相关的知识管理功能，以便专注于当前项目的开发工作。

#### Acceptance Criteria

1. WHEN 用户查看"当前项目"区域 THEN THE System SHALL 显示"💬 对话整理"节点，展示待整理的对话数量
2. WHEN 用户查看"当前项目"区域 THEN THE System SHALL 显示"🔍 项目内搜索"节点，提供快速搜索入口
3. WHEN 用户查看"当前项目"区域 THEN THE System SHALL 显示"🔗 插入链接"节点，列出项目内可链接的知识文件
4. WHEN 用户查看"当前项目"区域 THEN THE System SHALL 显示"🔧 整理知识库"节点，提供知识整理功能
5. WHEN 用户点击"项目内搜索"节点 THEN THE System SHALL 打开搜索界面并自动限定搜索范围为当前项目

### Requirement 3: 中央知识库区域功能

**User Story:** 作为知识管理者，我希望在"中央知识库"区域访问全局知识管理功能，以便进行跨项目的知识检索和管理。

#### Acceptance Criteria

1. WHEN 用户查看"中央知识库"区域 THEN THE System SHALL 显示"🔍 全局搜索"节点，提供跨项目搜索入口
2. WHEN 用户查看"中央知识库"区域 THEN THE System SHALL 显示"💡 搜索建议"节点，展示基于历史的智能建议
3. WHEN 用户查看"中央知识库"区域 THEN THE System SHALL 显示"📊 搜索统计"节点，提供搜索统计报告入口
4. WHEN 用户查看"中央知识库"区域 THEN THE System SHALL 显示"🔥 热门知识"节点，列出最常访问的知识条目
5. WHEN 用户查看"中央知识库"区域 THEN THE System SHALL 显示"📁 按项目浏览"节点，提供跨项目知识浏览功能
6. WHEN 用户点击"全局搜索"节点 THEN THE System SHALL 打开搜索界面并搜索所有知识库（本地+中央）

### Requirement 4: 搜索功能集成

**User Story:** 作为用户，我希望搜索功能能够根据触发位置自动调整搜索范围，以便更精准地找到所需知识。

#### Acceptance Criteria

1. WHEN 用户从"当前项目"区域触发搜索 THEN THE System SHALL 默认搜索范围为当前项目知识库
2. WHEN 用户从"中央知识库"区域触发搜索 THEN THE System SHALL 默认搜索范围为所有知识库
3. WHEN 用户在搜索界面 THEN THE System SHALL 允许用户手动切换搜索范围
4. WHEN 用户使用快捷键 Ctrl+Alt+K THEN THE System SHALL 打开全局搜索（保持现有行为）
5. WHEN 搜索完成 THEN THE System SHALL 在结果中标注知识来源（当前项目/中央知识库）

### Requirement 5: 搜索建议与统计

**User Story:** 作为用户，我希望在中央知识库区域直接访问搜索建议和统计功能，以便更高效地利用历史搜索数据。

#### Acceptance Criteria

1. WHEN 用户展开"搜索建议"节点 THEN THE System SHALL 显示最近 5 条搜索建议
2. WHEN 用户点击某个搜索建议 THEN THE System SHALL 自动执行该搜索查询
3. WHEN 用户点击"搜索统计"节点 THEN THE System SHALL 打开搜索统计报告
4. WHEN 搜索建议为空 THEN THE System SHALL 显示"暂无搜索历史"提示
5. WHEN 用户在搜索建议节点上右键 THEN THE System SHALL 提供"清除历史"选项

### Requirement 6: 热门知识展示

**User Story:** 作为用户，我希望在中央知识库区域看到热门知识条目，以便快速访问常用知识。

#### Acceptance Criteria

1. WHEN 用户展开"热门知识"节点 THEN THE System SHALL 显示访问次数最多的前 10 条知识
2. WHEN 用户点击热门知识条目 THEN THE System SHALL 打开对应的知识文件
3. WHEN 热门知识列表为空 THEN THE System SHALL 显示"暂无访问记录"提示
4. WHEN 热门知识条目显示 THEN THE System SHALL 包含访问次数标注
5. WHEN 用户在热门知识节点上右键 THEN THE System SHALL 提供"刷新统计"选项

### Requirement 7: 视觉区分与用户体验

**User Story:** 作为用户，我希望两个区域在视觉上有明显区分，以便快速识别功能所属范围。

#### Acceptance Criteria

1. WHEN 用户查看面板 THEN THE System SHALL 为"当前项目"区域使用 📁 图标
2. WHEN 用户查看面板 THEN THE System SHALL 为"中央知识库"区域使用 ☁️ 图标
3. WHEN 用户查看面板 THEN THE System SHALL 在两个区域之间保持视觉分隔
4. WHEN 用户悬停在区域标题上 THEN THE System SHALL 显示该区域的功能说明
5. WHEN 用户首次打开面板 THEN THE System SHALL 默认展开"当前项目"区域，折叠"中央知识库"区域

### Requirement 8: 配置与兼容性

**User Story:** 作为用户，我希望新的双区域布局能够兼容现有配置，并提供必要的设置选项。

#### Acceptance Criteria

1. WHEN 用户未配置中央知识库路径 THEN THE System SHALL 仅显示"当前项目"区域
2. WHEN 用户配置了中央知识库路径 THEN THE System SHALL 显示两个区域
3. WHEN 用户的项目没有本地知识库 THEN THE System SHALL 在"当前项目"区域显示初始化提示
4. WHEN 用户升级到新版本 THEN THE System SHALL 保持现有的收藏、标签等数据不变
5. WHEN 用户在设置中 THEN THE System SHALL 提供"默认展开区域"配置选项

### Requirement 9: 性能与响应

**User Story:** 作为用户，我希望面板加载和交互响应迅速，不影响开发体验。

#### Acceptance Criteria

1. WHEN 用户打开侧边栏 THEN THE System SHALL 在 500ms 内完成面板初始化
2. WHEN 用户展开/折叠区域 THEN THE System SHALL 在 100ms 内完成动画
3. WHEN 用户点击节点 THEN THE System SHALL 在 200ms 内响应操作
4. WHEN 面板包含大量知识条目 THEN THE System SHALL 使用分页或虚拟滚动优化性能
5. WHEN 用户切换项目 THEN THE System SHALL 自动刷新面板内容

### Requirement 10: 向后兼容

**User Story:** 作为现有用户，我希望升级后原有的快捷键和命令仍然可用，不影响我的使用习惯。

#### Acceptance Criteria

1. WHEN 用户使用 Ctrl+Alt+K THEN THE System SHALL 保持原有的全局搜索行为
2. WHEN 用户使用 Ctrl+Alt+Q THEN THE System SHALL 保持原有的暂存问题行为
3. WHEN 用户使用 Ctrl+Alt+C THEN THE System SHALL 保持原有的智能捕获行为
4. WHEN 用户使用命令面板 THEN THE System SHALL 保持所有现有命令可用
5. WHEN 用户访问原有的面板节点 THEN THE System SHALL 将其映射到新的区域结构中
