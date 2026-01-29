# Design Document: Dual KB Panel Separation

## Overview

本设计实现 Kiro Knowledge Base 插件侧边栏面板的双区域分离功能，将"当前项目知识库"和"中央知识库"的功能在界面上明确区分。

### 设计目标

1. **清晰的功能分区**: 用户能够一眼识别当前项目和中央知识库的功能
2. **高效的知识访问**: 根据使用场景快速定位到相应的功能区域
3. **无缝的用户体验**: 保持现有功能的同时，提供更好的组织结构
4. **向后兼容**: 不破坏现有用户的使用习惯和数据

### 核心设计理念

- **分而治之**: 将局部（项目级）和全局（跨项目）功能分离
- **渐进增强**: 在现有 TreeView 结构上扩展，而非重写
- **智能默认**: 根据用户配置自动调整显示内容
- **性能优先**: 确保大量知识条目下的流畅体验

## Architecture

### 整体架构

```
┌─────────────────────────────────────────┐
│     Knowledge Base Sidebar Panel        │
├─────────────────────────────────────────┤
│                                         │
│  📁 当前项目 (Current Project)          │
│  ├─ 💬 对话整理 (N 待整理)              │
│  ├─ 🔍 项目内搜索                       │
│  ├─ 🔗 插入链接 (M 个文件)              │
│  └─ 🔧 整理知识库                       │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  ☁️ 中央知识库 (Central KB)             │
│  ├─ 🔍 全局搜索                         │
│  ├─ 💡 搜索建议                         │
│  │   ├─ Unity Shader 优化               │
│  │   ├─ VSCode 插件开发                 │
│  │   └─ ...                             │
│  ├─ 📊 搜索统计                         │
│  ├─ 🔥 热门知识 (Top 10)                │
│  │   ├─ 知识条目 1 (访问 50 次)         │
│  │   ├─ 知识条目 2 (访问 35 次)         │
│  │   └─ ...                             │
│  └─ 📁 按项目浏览                       │
│      ├─ 🎮 Unity 游戏 (3 项目)          │
│      ├─ 🔌 VSCode 插件 (2 项目)         │
│      └─ ...                             │
│                                         │
└─────────────────────────────────────────┘
```

### 模块关系

```
┌──────────────────────────────────────────────┐
│           KnowledgePanelProvider             │
│  (TreeDataProvider<KnowledgeTreeItem>)       │
├──────────────────────────────────────────────┤
│                                              │
│  getRootNodes()                              │
│    ├─> getCurrentProjectSection()            │
│    │     ├─> getDigestNodes()                │
│    │     ├─> getProjectSearchNode()          │
│    │     ├─> getLinkableFiles()              │
│    │     └─> getOrganizeNode()               │
│    │                                          │
│    └─> getCentralKBSection()                 │
│          ├─> getGlobalSearchNode()           │
│          ├─> getSearchSuggestionsNodes()     │
│          ├─> getSearchStatsNode()            │
│          ├─> getPopularKnowledgeNodes()      │
│          └─> getProjectGroupsNodes()         │
│                                              │
└──────────────────────────────────────────────┘
         │                    │
         │                    │
         ▼                    ▼
┌─────────────────┐  ┌──────────────────┐
│  SearchHistory  │  │  AccessTracker   │
│                 │  │  (新增模块)       │
│  - suggestions  │  │  - trackAccess() │
│  - statistics   │  │  - getPopular()  │
└─────────────────┘  └──────────────────┘
```

### 数据流

```
用户操作
   │
   ├─> 打开侧边栏
   │     │
   │     └─> getRootNodes()
   │           ├─> 检查配置（centralPath）
   │           ├─> 生成"当前项目"区域
   │           └─> 生成"中央知识库"区域（如果配置）
   │
   ├─> 点击"项目内搜索"
   │     │
   │     └─> 触发搜索命令（scope: 'local'）
   │           └─> 搜索本地知识库
   │
   ├─> 点击"全局搜索"
   │     │
   │     └─> 触发搜索命令（scope: 'all'）
   │           └─> 搜索所有知识库
   │
   ├─> 点击搜索建议
   │     │
   │     └─> 执行建议的查询
   │           └─> 记录到搜索历史
   │
   └─> 点击热门知识
         │
         └─> 打开知识文件
               └─> 记录访问次数
```

## Components and Interfaces

### 1. KnowledgePanelProvider (扩展)

现有的 TreeDataProvider，需要扩展以支持双区域布局。

```typescript
export class KnowledgePanelProvider implements vscode.TreeDataProvider<KnowledgeTreeItem> {
    // 现有属性
    private _onDidChangeTreeData: vscode.EventEmitter<KnowledgeTreeItem | undefined | void>;
    private centralPath: string;
    private searchQuery: string;
    private favorites: FavoriteItem[];
    private context: vscode.ExtensionContext;
    
    // 新增属性
    private currentProjectExpanded: boolean = true;   // 当前项目区域展开状态
    private centralKBExpanded: boolean = false;       // 中央知识库区域展开状态
    private accessTracker: AccessTracker;             // 访问追踪器
    
    // 修改的方法
    getRootNodes(): KnowledgeTreeItem[] {
        const nodes: KnowledgeTreeItem[] = [];
        
        // 1. 当前项目区域
        const currentProjectNode = this.getCurrentProjectSection();
        if (currentProjectNode) {
            nodes.push(currentProjectNode);
        }
        
        // 2. 中央知识库区域（如果配置）
        if (this.centralPath && fs.existsSync(this.centralPath)) {
            const centralKBNode = this.getCentralKBSection();
            nodes.push(centralKBNode);
        }
        
        return nodes;
    }
    
    // 新增方法
    private getCurrentProjectSection(): KnowledgeTreeItem | null {
        const ws = vscode.workspace.workspaceFolders?.[0];
        if (!ws) return null;
        
        const projectName = path.basename(ws.uri.fsPath);
        const localKB = path.join(ws.uri.fsPath, 'knowledge-base');
        const stats = this.getProjectStats(ws.uri.fsPath);
        
        const node = new KnowledgeTreeItem(
            `📁 ${isZh() ? '当前项目' : 'Current Project'}: ${projectName}`,
            this.currentProjectExpanded 
                ? vscode.TreeItemCollapsibleState.Expanded 
                : vscode.TreeItemCollapsibleState.Collapsed,
            'root-current-project',
            localKB,
            'local'
        );
        
        node.tooltip = isZh() 
            ? '当前项目的知识管理功能' 
            : 'Knowledge management for current project';
        
        return node;
    }
    
    private getCentralKBSection(): KnowledgeTreeItem {
        const fileCount = this.countFiles(this.centralPath, ['solutions', 'notes', 'discussions']);
        
        const node = new KnowledgeTreeItem(
            `☁️ ${isZh() ? '中央知识库' : 'Central KB'} (${fileCount})`,
            this.centralKBExpanded 
                ? vscode.TreeItemCollapsibleState.Expanded 
                : vscode.TreeItemCollapsibleState.Collapsed,
            'root-central-kb',
            this.centralPath,
            'central'
        );
        
        node.tooltip = isZh() 
            ? '跨项目的全局知识管理' 
            : 'Global knowledge management across projects';
        
        return node;
    }
    
    // 获取子节点时的路由
    getChildren(element?: KnowledgeTreeItem): KnowledgeTreeItem[] {
        if (!element) {
            return this.getRootNodes();
        }
        
        switch (element.nodeType) {
            case 'root-current-project':
                return this.getCurrentProjectChildren();
            case 'root-central-kb':
                return this.getCentralKBChildren();
            // ... 其他现有的 case
        }
    }
    
    private getCurrentProjectChildren(): KnowledgeTreeItem[] {
        const nodes: KnowledgeTreeItem[] = [];
        
        // 1. 对话整理
        const digestStats = this.getDigestStats();
        if (digestStats.valuable > 0) {
            const digestNode = new KnowledgeTreeItem(
                `💬 ${isZh() ? '对话整理' : 'Conversations'} (${digestStats.valuable} ${isZh() ? '待整理' : 'pending'})`,
                vscode.TreeItemCollapsibleState.None,
                'action-item'
            );
            digestNode.command = { command: 'kiro-kb.digestConversations', title: 'Digest' };
            nodes.push(digestNode);
        }
        
        // 2. 项目内搜索
        const searchNode = new KnowledgeTreeItem(
            `🔍 ${isZh() ? '项目内搜索' : 'Search in Project'}`,
            vscode.TreeItemCollapsibleState.None,
            'action-item'
        );
        searchNode.command = { 
            command: 'kiro-kb.searchWithScope', 
            title: 'Search',
            arguments: ['local']
        };
        nodes.push(searchNode);
        
        // 3. 插入链接
        const linkCount = this.getLocalKnowledgeFiles().length;
        if (linkCount > 0) {
            const linkNode = new KnowledgeTreeItem(
                `🔗 ${isZh() ? '插入链接' : 'Insert Link'} (${linkCount})`,
                vscode.TreeItemCollapsibleState.Collapsed,
                'root-links-local'
            );
            nodes.push(linkNode);
        }
        
        // 4. 整理知识库
        const organizeNode = new KnowledgeTreeItem(
            `🔧 ${isZh() ? '整理知识库' : 'Organize KB'}`,
            vscode.TreeItemCollapsibleState.None,
            'action-item'
        );
        organizeNode.command = { command: 'kiro-kb.organizeKnowledge', title: 'Organize' };
        nodes.push(organizeNode);
        
        return nodes;
    }
    
    private getCentralKBChildren(): KnowledgeTreeItem[] {
        const nodes: KnowledgeTreeItem[] = [];
        
        // 1. 全局搜索
        const globalSearchNode = new KnowledgeTreeItem(
            `🔍 ${isZh() ? '全局搜索' : 'Global Search'}`,
            vscode.TreeItemCollapsibleState.None,
            'action-item'
        );
        globalSearchNode.command = { 
            command: 'kiro-kb.searchWithScope', 
            title: 'Search',
            arguments: ['all']
        };
        nodes.push(globalSearchNode);
        
        // 2. 搜索建议
        const suggestionsNode = new KnowledgeTreeItem(
            `💡 ${isZh() ? '搜索建议' : 'Search Suggestions'}`,
            vscode.TreeItemCollapsibleState.Collapsed,
            'root-search-suggestions'
        );
        nodes.push(suggestionsNode);
        
        // 3. 搜索统计
        const statsNode = new KnowledgeTreeItem(
            `📊 ${isZh() ? '搜索统计' : 'Search Statistics'}`,
            vscode.TreeItemCollapsibleState.None,
            'action-item'
        );
        statsNode.command = { command: 'kiro-kb.showSearchStats', title: 'Stats' };
        nodes.push(statsNode);
        
        // 4. 热门知识
        const popularNode = new KnowledgeTreeItem(
            `🔥 ${isZh() ? '热门知识' : 'Popular Knowledge'}`,
            vscode.TreeItemCollapsibleState.Collapsed,
            'root-popular-knowledge'
        );
        nodes.push(popularNode);
        
        // 5. 按项目浏览
        const projectGroupsNode = new KnowledgeTreeItem(
            `📁 ${isZh() ? '按项目浏览' : 'Browse by Project'}`,
            vscode.TreeItemCollapsibleState.Collapsed,
            'root-project-groups'
        );
        nodes.push(projectGroupsNode);
        
        return nodes;
    }
}
```

### 2. AccessTracker (新增模块)

追踪知识文件的访问次数，用于生成热门知识列表。

```typescript
/**
 * 访问追踪器 - 记录知识文件的访问次数
 */
export class AccessTracker {
    private static readonly STORAGE_KEY = 'kiro-kb.accessHistory';
    private static readonly MAX_HISTORY = 1000;
    
    constructor(private context: vscode.ExtensionContext) {}
    
    /**
     * 记录文件访问
     */
    async trackAccess(filePath: string): Promise<void> {
        const history = await this.getHistory();
        const normalized = path.normalize(filePath);
        
        // 查找或创建记录
        let record = history.find(h => h.path === normalized);
        if (record) {
            record.count++;
            record.lastAccess = Date.now();
        } else {
            record = {
                path: normalized,
                count: 1,
                firstAccess: Date.now(),
                lastAccess: Date.now()
            };
            history.push(record);
        }
        
        // 限制历史记录数量
        if (history.length > AccessTracker.MAX_HISTORY) {
            // 按访问次数排序，移除最少访问的
            history.sort((a, b) => a.count - b.count);
            history.splice(0, history.length - AccessTracker.MAX_HISTORY);
        }
        
        await this.context.globalState.update(AccessTracker.STORAGE_KEY, history);
    }
    
    /**
     * 获取热门知识
     */
    async getPopular(count: number = 10): Promise<AccessRecord[]> {
        const history = await this.getHistory();
        
        // 按访问次数排序
        history.sort((a, b) => b.count - a.count);
        
        // 过滤掉不存在的文件
        const existing = history.filter(h => fs.existsSync(h.path));
        
        return existing.slice(0, count);
    }
    
    /**
     * 获取访问历史
     */
    private async getHistory(): Promise<AccessRecord[]> {
        return this.context.globalState.get<AccessRecord[]>(AccessTracker.STORAGE_KEY, []);
    }
    
    /**
     * 清除历史
     */
    async clear(): Promise<void> {
        await this.context.globalState.update(AccessTracker.STORAGE_KEY, []);
    }
}

interface AccessRecord {
    path: string;
    count: number;
    firstAccess: number;
    lastAccess: number;
}
```

### 3. 搜索命令扩展

扩展现有的搜索命令以支持范围参数。

```typescript
/**
 * 带范围的搜索命令
 */
async function searchWithScope(scope: 'local' | 'all'): Promise<void> {
    // 显示搜索模式选择
    const mode = await vscode.window.showQuickPick([
        {
            label: `🔍 ${isZh() ? '关键词搜索' : 'Keyword Search'}`,
            description: isZh() ? '精确匹配文件名和内容' : 'Exact match in filename and content',
            value: 'keyword'
        },
        {
            label: `🤖 ${isZh() ? '语义搜索' : 'Semantic Search'}`,
            description: isZh() ? '基于 TF-IDF 的智能搜索' : 'TF-IDF based intelligent search',
            value: 'semantic'
        }
    ], {
        placeHolder: isZh() ? '选择搜索模式' : 'Select search mode'
    });
    
    if (!mode) return;
    
    // 获取搜索查询
    const query = await vscode.window.showInputBox({
        prompt: isZh() 
            ? `输入搜索关键词 (${scope === 'local' ? '仅当前项目' : '所有知识库'})` 
            : `Enter search query (${scope === 'local' ? 'current project only' : 'all knowledge bases'})`,
        placeHolder: isZh() ? '搜索...' : 'Search...'
    });
    
    if (!query) return;
    
    // 执行搜索
    const results = await performSearch(query, mode.value as 'keyword' | 'semantic', scope);
    
    // 记录搜索历史
    await searchHistory.add(query, mode.value as 'keyword' | 'semantic', results.length);
    
    // 显示结果
    await showSearchResults(results, query, scope);
}

/**
 * 执行搜索
 */
async function performSearch(
    query: string, 
    mode: 'keyword' | 'semantic', 
    scope: 'local' | 'all'
): Promise<SearchResult[]> {
    let files: KnowledgeFileInfo[] = [];
    
    if (scope === 'local') {
        // 仅搜索当前项目
        files = knowledgePanelProvider.getLocalKnowledgeFiles();
    } else {
        // 搜索所有知识库
        files = knowledgePanelProvider.getAllKnowledgeFiles();
    }
    
    // 根据模式执行搜索
    if (mode === 'keyword') {
        return keywordSearch(query, files);
    } else {
        return semanticSearch(query, files);
    }
}
```

## Data Models

### KnowledgeTreeItem 扩展

需要添加新的节点类型以支持双区域布局。

```typescript
export type KnowledgeNodeType = 
    // 现有类型
    | 'root-local' 
    | 'root-central' 
    | 'root-recent' 
    | 'root-backlog' 
    | 'root-favorites' 
    | 'root-tags' 
    | 'root-stale' 
    | 'root-projects' 
    | 'root-project-groups' 
    | 'root-settings' 
    | 'root-stats' 
    | 'root-quickactions' 
    | 'root-health' 
    | 'root-digest' 
    | 'root-links' 
    // 新增类型
    | 'root-current-project'      // 当前项目区域根节点
    | 'root-central-kb'            // 中央知识库区域根节点
    | 'root-search-suggestions'    // 搜索建议根节点
    | 'root-popular-knowledge'     // 热门知识根节点
    | 'root-links-local'           // 本地链接根节点
    | 'search-suggestion-item'     // 搜索建议条目
    | 'popular-knowledge-item'     // 热门知识条目
    // ... 其他现有类型
    | 'folder' 
    | 'file' 
    | 'empty';
```

### AccessRecord

访问记录数据结构。

```typescript
interface AccessRecord {
    path: string;          // 文件路径（规范化）
    count: number;         // 访问次数
    firstAccess: number;   // 首次访问时间戳
    lastAccess: number;    // 最后访问时间戳
}
```

### SearchResult 扩展

搜索结果需要包含来源信息。

```typescript
interface SearchResult {
    filePath: string;
    title: string;
    folder: string;
    score: number;
    snippet?: string;
    source: 'local' | 'central';  // 新增：知识来源
}
```

### PanelState

面板状态配置。

```typescript
interface PanelState {
    currentProjectExpanded: boolean;  // 当前项目区域展开状态
    centralKBExpanded: boolean;       // 中央知识库区域展开状态
    defaultExpandedSection: 'current' | 'central' | 'both';  // 默认展开的区域
}
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*


### Property Reflection

在编写属性之前，我需要审查 prework 中识别的所有可测试属性，消除冗余：

**识别的属性分组**:

1. **节点结构属性** (1.1, 1.2, 1.3, 2.1-2.4, 3.1-3.5): 这些都是测试特定节点的存在性
   - 可以合并为：面板结构完整性属性
   
2. **命令绑定属性** (2.5, 3.6, 4.1, 4.2, 5.2, 6.2): 测试节点的命令配置
   - 可以合并为：命令参数正确性属性
   
3. **数量限制属性** (5.1, 6.1): 测试返回节点的数量限制
   - 保持独立，因为它们测试不同的功能
   
4. **图标和提示属性** (7.1, 7.2, 7.4): 测试节点的视觉属性
   - 可以合并为：节点元数据完整性属性
   
5. **条件渲染属性** (8.1, 8.2): 测试基于配置的渲染
   - 可以合并为：配置驱动渲染属性
   
6. **状态持久化属性** (1.5): 独立属性
   
7. **搜索结果属性** (4.5): 独立属性
   
8. **节点映射属性** (10.5): 独立属性

**消除冗余后的核心属性**:
- Property 1: 双区域结构完整性（合并 1.1, 1.2, 1.3）
- Property 2: 当前项目功能节点完整性（合并 2.1-2.4）
- Property 3: 中央知识库功能节点完整性（合并 3.1-3.5）
- Property 4: 搜索命令范围正确性（合并 2.5, 3.6, 4.1, 4.2）
- Property 5: 搜索建议数量限制（5.1）
- Property 6: 热门知识排序和数量限制（6.1, 6.4）
- Property 7: 节点视觉属性完整性（合并 7.1, 7.2, 7.4）
- Property 8: 配置驱动的条件渲染（合并 8.1, 8.2）
- Property 9: 区域折叠状态持久化（1.5）
- Property 10: 搜索结果来源标注（4.5）
- Property 11: 命令绑定正确性（5.2, 6.2）
- Property 12: 项目切换时自动刷新（9.5）
- Property 13: 节点类型向后兼容映射（10.5）

### Correctness Properties

基于 prework 分析，以下是本功能的核心正确性属性：

#### Property 1: 双区域结构完整性

*For any* 有效的工作区配置，当调用 getRootNodes() 时，返回的节点数组应该包含"当前项目"区域节点，并且当 centralPath 配置存在时，还应该包含"中央知识库"区域节点。

**Validates: Requirements 1.1, 8.1, 8.2**

#### Property 2: 当前项目功能节点完整性

*For any* 当前项目区域节点，当调用 getChildren() 获取其子节点时，返回的节点列表应该包含所有必需的功能节点：对话整理（如果有待整理对话）、项目内搜索、插入链接（如果有本地知识文件）、整理知识库。

**Validates: Requirements 1.2, 2.1, 2.2, 2.3, 2.4**

#### Property 3: 中央知识库功能节点完整性

*For any* 中央知识库区域节点，当调用 getChildren() 获取其子节点时，返回的节点列表应该包含所有必需的功能节点：全局搜索、搜索建议、搜索统计、热门知识、按项目浏览。

**Validates: Requirements 1.3, 3.1, 3.2, 3.3, 3.4, 3.5**

#### Property 4: 搜索命令范围正确性

*For any* 搜索触发节点，其 command 属性中的 arguments 数组应该包含正确的搜索范围参数：从"当前项目"区域触发的搜索应该传递 'local' 参数，从"中央知识库"区域触发的搜索应该传递 'all' 参数。

**Validates: Requirements 2.5, 3.6, 4.1, 4.2**

#### Property 5: 搜索建议数量限制

*For any* 搜索建议节点，当调用 getChildren() 获取其子节点时，返回的建议节点数量应该不超过 5 个。

**Validates: Requirements 5.1**

#### Property 6: 热门知识排序和数量限制

*For any* 热门知识节点，当调用 getChildren() 获取其子节点时，返回的知识节点应该按访问次数降序排列，数量不超过 10 个，并且每个节点的 description 或 label 应该包含访问次数信息。

**Validates: Requirements 6.1, 6.4**

#### Property 7: 节点视觉属性完整性

*For any* 区域根节点（当前项目或中央知识库），其 iconPath 和 tooltip 属性应该正确设置：当前项目区域应该使用文件夹图标（📁）并包含项目名称，中央知识库区域应该使用云图标（☁️）并包含文件数量。

**Validates: Requirements 7.1, 7.2, 7.4**

#### Property 8: 配置驱动的条件渲染

*For any* 配置状态，getRootNodes() 的返回结果应该正确反映配置：当 centralPath 未配置或不存在时，只返回当前项目区域节点；当 centralPath 配置且存在时，返回两个区域节点。

**Validates: Requirements 8.1, 8.2**

#### Property 9: 区域折叠状态持久化

*For any* 区域节点，当用户改变其折叠状态后，该状态应该被保存，并且在下次调用 getRootNodes() 时，该节点的 collapsibleState 应该反映保存的状态。

**Validates: Requirements 1.5**

#### Property 10: 搜索结果来源标注

*For any* 搜索操作返回的 SearchResult 对象，其 source 字段应该正确标注知识来源：来自当前项目 knowledge-base 目录的结果应该标注为 'local'，来自中央知识库的结果应该标注为 'central'。

**Validates: Requirements 4.5**

#### Property 11: 命令绑定正确性

*For any* 可点击的功能节点（搜索建议、热门知识等），其 command 属性应该正确配置，包含有效的命令名称和必要的参数。

**Validates: Requirements 5.2, 6.2**

#### Property 12: 项目切换时自动刷新

*For any* 工作区切换事件，面板应该自动触发 refresh() 方法，确保显示的内容与当前工作区匹配。

**Validates: Requirements 9.5**

#### Property 13: 节点类型向后兼容映射

*For any* 现有的节点类型（如 root-links, root-digest），在新的双区域结构中应该能够正确映射到对应的区域（当前项目或中央知识库），保持功能可访问性。

**Validates: Requirements 10.5**

## Error Handling

### 配置错误处理

1. **中央路径无效**
   - 检测：在 getRootNodes() 中检查 centralPath 是否存在
   - 处理：仅显示当前项目区域，不显示错误
   - 用户提示：在设置节点中提示用户配置中央路径

2. **本地知识库不存在**
   - 检测：检查 knowledge-base 目录是否存在
   - 处理：在当前项目区域显示初始化提示节点
   - 用户操作：点击初始化节点创建知识库结构

3. **访问历史数据损坏**
   - 检测：在 AccessTracker.getHistory() 中捕获 JSON 解析错误
   - 处理：返回空数组，记录警告日志
   - 恢复：自动重建访问历史

### 搜索错误处理

1. **搜索历史为空**
   - 检测：searchHistory.getAll() 返回空数组
   - 处理：在搜索建议节点下显示"暂无搜索历史"提示
   - 用户体验：不影响其他功能

2. **热门知识为空**
   - 检测：accessTracker.getPopular() 返回空数组
   - 处理：在热门知识节点下显示"暂无访问记录"提示
   - 用户体验：不影响其他功能

3. **搜索执行失败**
   - 检测：performSearch() 抛出异常
   - 处理：捕获异常，显示错误通知
   - 日志：记录详细错误信息到输出通道
   - 恢复：允许用户重试搜索

### 性能错误处理

1. **大量知识文件**
   - 检测：getAllKnowledgeFiles() 返回超过 1000 个文件
   - 处理：在 getLinkableFiles() 和 getPopularKnowledgeNodes() 中限制显示数量
   - 优化：使用分页或虚拟滚动（未来优化）

2. **节点展开超时**
   - 检测：getChildren() 执行时间超过 1 秒
   - 处理：显示加载提示，异步加载子节点
   - 日志：记录性能警告

### 兼容性错误处理

1. **旧版本数据迁移**
   - 检测：检查 globalState 中的数据版本
   - 处理：自动迁移旧格式数据到新格式
   - 备份：迁移前备份原始数据

2. **命令不存在**
   - 检测：命令执行时捕获 "command not found" 错误
   - 处理：显示友好的错误提示，建议重新加载窗口
   - 日志：记录缺失的命令名称

## Testing Strategy

### 测试方法

本功能采用**双重测试策略**：单元测试验证具体示例和边界情况，属性测试验证通用正确性。

#### 单元测试

单元测试专注于：
- 具体的配置场景（有/无中央路径）
- 边界情况（空列表、单个元素）
- 错误处理路径
- 特定的用户交互流程

**示例单元测试**：
```typescript
describe('KnowledgePanelProvider', () => {
    it('should show only current project when centralPath is not configured', () => {
        const provider = new KnowledgePanelProvider();
        provider.centralPath = '';
        
        const nodes = provider.getRootNodes();
        
        expect(nodes).toHaveLength(1);
        expect(nodes[0].nodeType).toBe('root-current-project');
    });
    
    it('should show both sections when centralPath is configured', () => {
        const provider = new KnowledgePanelProvider();
        provider.centralPath = '/path/to/central';
        
        const nodes = provider.getRootNodes();
        
        expect(nodes).toHaveLength(2);
        expect(nodes[0].nodeType).toBe('root-current-project');
        expect(nodes[1].nodeType).toBe('root-central-kb');
    });
    
    it('should show empty message when no search history', async () => {
        const provider = new KnowledgePanelProvider();
        const searchHistory = new SearchHistory(context);
        await searchHistory.clear();
        
        const suggestions = provider.getSearchSuggestionsNodes();
        
        expect(suggestions).toHaveLength(1);
        expect(suggestions[0].label).toContain('暂无搜索历史');
    });
});
```

#### 属性测试

属性测试使用 **fast-check** 库（TypeScript/JavaScript 的 PBT 库），每个测试运行 **100 次迭代**。

**配置**：
```typescript
import * as fc from 'fast-check';

// 配置：每个属性测试运行 100 次
const testConfig = { numRuns: 100 };
```

**属性测试示例**：

```typescript
describe('Property Tests', () => {
    // Feature: dual-kb-panel-separation, Property 1: 双区域结构完整性
    it('should always include current project section in root nodes', () => {
        fc.assert(
            fc.property(
                fc.record({
                    centralPath: fc.option(fc.string(), { nil: '' }),
                    centralExists: fc.boolean()
                }),
                (config) => {
                    const provider = new KnowledgePanelProvider();
                    provider.centralPath = config.centralPath || '';
                    
                    // Mock fs.existsSync
                    jest.spyOn(fs, 'existsSync').mockReturnValue(config.centralExists);
                    
                    const nodes = provider.getRootNodes();
                    
                    // 应该总是包含当前项目节点
                    const hasCurrentProject = nodes.some(n => n.nodeType === 'root-current-project');
                    expect(hasCurrentProject).toBe(true);
                    
                    // 如果配置了中央路径且存在，应该包含中央知识库节点
                    const hasCentralKB = nodes.some(n => n.nodeType === 'root-central-kb');
                    if (config.centralPath && config.centralExists) {
                        expect(hasCentralKB).toBe(true);
                    }
                }
            ),
            testConfig
        );
    });
    
    // Feature: dual-kb-panel-separation, Property 4: 搜索命令范围正确性
    it('should set correct search scope in command arguments', () => {
        fc.assert(
            fc.property(
                fc.constantFrom('current-project', 'central-kb'),
                (sectionType) => {
                    const provider = new KnowledgePanelProvider();
                    
                    let children: KnowledgeTreeItem[];
                    if (sectionType === 'current-project') {
                        children = provider.getCurrentProjectChildren();
                    } else {
                        children = provider.getCentralKBChildren();
                    }
                    
                    // 查找搜索节点
                    const searchNode = children.find(n => 
                        n.label.includes('搜索') || n.label.includes('Search')
                    );
                    
                    if (searchNode && searchNode.command) {
                        const scope = searchNode.command.arguments?.[0];
                        
                        if (sectionType === 'current-project') {
                            expect(scope).toBe('local');
                        } else {
                            expect(scope).toBe('all');
                        }
                    }
                }
            ),
            testConfig
        );
    });
    
    // Feature: dual-kb-panel-separation, Property 5: 搜索建议数量限制
    it('should limit search suggestions to 5 items', () => {
        fc.assert(
            fc.property(
                fc.array(fc.string(), { minLength: 0, maxLength: 20 }),
                async (queries) => {
                    const searchHistory = new SearchHistory(context);
                    await searchHistory.clear();
                    
                    // 添加随机数量的搜索历史
                    for (const query of queries) {
                        await searchHistory.add(query, 'keyword');
                    }
                    
                    const provider = new KnowledgePanelProvider();
                    const suggestions = await provider.getSearchSuggestionsNodes();
                    
                    // 建议数量不应超过 5（不包括空提示节点）
                    const actualSuggestions = suggestions.filter(n => 
                        n.nodeType === 'search-suggestion-item'
                    );
                    expect(actualSuggestions.length).toBeLessThanOrEqual(5);
                }
            ),
            testConfig
        );
    });
    
    // Feature: dual-kb-panel-separation, Property 6: 热门知识排序和数量限制
    it('should sort popular knowledge by access count and limit to 10', () => {
        fc.assert(
            fc.property(
                fc.array(
                    fc.record({
                        path: fc.string(),
                        count: fc.integer({ min: 1, max: 100 })
                    }),
                    { minLength: 0, maxLength: 50 }
                ),
                async (accessRecords) => {
                    const accessTracker = new AccessTracker(context);
                    await accessTracker.clear();
                    
                    // 模拟访问记录
                    for (const record of accessRecords) {
                        for (let i = 0; i < record.count; i++) {
                            await accessTracker.trackAccess(record.path);
                        }
                    }
                    
                    const popular = await accessTracker.getPopular(10);
                    
                    // 数量不超过 10
                    expect(popular.length).toBeLessThanOrEqual(10);
                    
                    // 按访问次数降序排列
                    for (let i = 0; i < popular.length - 1; i++) {
                        expect(popular[i].count).toBeGreaterThanOrEqual(popular[i + 1].count);
                    }
                }
            ),
            testConfig
        );
    });
    
    // Feature: dual-kb-panel-separation, Property 10: 搜索结果来源标注
    it('should correctly tag search results with source', () => {
        fc.assert(
            fc.property(
                fc.array(
                    fc.record({
                        path: fc.string(),
                        isLocal: fc.boolean()
                    }),
                    { minLength: 1, maxLength: 20 }
                ),
                (files) => {
                    const results: SearchResult[] = files.map(f => ({
                        filePath: f.path,
                        title: 'Test',
                        folder: 'solutions',
                        score: 1.0,
                        source: f.isLocal ? 'local' : 'central'
                    }));
                    
                    // 验证每个结果都有正确的 source 标注
                    for (const result of results) {
                        expect(['local', 'central']).toContain(result.source);
                    }
                }
            ),
            testConfig
        );
    });
});
```

### 测试覆盖目标

- **单元测试覆盖率**: ≥ 80%
- **属性测试覆盖率**: 所有核心属性（13 个）
- **集成测试**: 关键用户流程（搜索、浏览、链接插入）

### 测试工具

- **单元测试框架**: Jest
- **属性测试库**: fast-check
- **Mock 工具**: jest.mock, jest.spyOn
- **VSCode 测试**: @vscode/test-electron

### 测试执行

```bash
# 运行所有测试
npm test

# 运行单元测试
npm run test:unit

# 运行属性测试
npm run test:property

# 生成覆盖率报告
npm run test:coverage
```

### 持续集成

- 每次 PR 自动运行所有测试
- 测试失败阻止合并
- 覆盖率报告自动生成并评论到 PR

---

**设计完成日期**: 2026-01-07  
**设计版本**: v1.0  
**目标版本**: v2.49.0
