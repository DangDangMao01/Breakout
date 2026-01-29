---
domain: solution
tags: [vscode, treeview, ui, hierarchical, grouping, typescript]
date: 2026-01-05
source_project: "kiro-knowledge-base"
value_score: 8
---

# VSCode TreeView 实现三级分组展示

## 问题/背景

在 VSCode 侧边栏中展示大量数据时，需要合理的分组和层级结构：
- 一级：项目类型分组（Unity、VSCode插件、Web应用等）
- 二级：具体项目
- 三级：项目下的文件

**需求**：
1. 动态统计各类型的项目数和文件数
2. 支持三级展开/折叠
3. 显示图标和统计信息
4. 点击文件可打开
5. 性能优化（缓存机制）

## 解决方案

### 核心架构

使用 VSCode 的 `TreeDataProvider` API 实现自定义树形视图：

```typescript
class KnowledgePanelProvider implements vscode.TreeDataProvider<KnowledgeTreeItem> {
    private _onDidChangeTreeData = new vscode.EventEmitter<KnowledgeTreeItem | undefined>();
    readonly onDidChangeTreeData = this._onDidChangeTreeData.event;
    
    // 刷新视图
    refresh(): void {
        this._onDidChangeTreeData.fire(undefined);
    }
    
    // 获取树节点
    getTreeItem(element: KnowledgeTreeItem): vscode.TreeItem {
        return element;
    }
    
    // 获取子节点
    getChildren(element?: KnowledgeTreeItem): Thenable<KnowledgeTreeItem[]> {
        if (!element) {
            // 根节点
            return Promise.resolve(this.getRootNodes());
        }
        
        // 子节点
        return Promise.resolve(this.getChildNodes(element));
    }
}
```

## 关键代码

### 1. 项目类型分组

```typescript
/**
 * 获取项目类型分组节点
 */
private getProjectTypeGroups(): KnowledgeTreeItem[] {
    const stats = this.getProjectGroupStats();
    const items: KnowledgeTreeItem[] = [];
    
    // 项目类型映射
    const typeIcons: Record<string, string> = {
        'unity-game': '🎮',
        'vscode-extension': '🔌',
        'web-app': '🌐',
        'mobile-app': '📱',
        'backend': '⚙️',
        'ai-ml': '🤖',
        'devops': '🛠️',
        'other': '📁'
    };
    
    const typeLabels: Record<string, { zh: string; en: string }> = {
        'unity-game': { zh: 'Unity 游戏', en: 'Unity Games' },
        'vscode-extension': { zh: 'VSCode/Kiro 插件', en: 'VSCode/Kiro Extensions' },
        'web-app': { zh: 'Web 应用', en: 'Web Apps' },
        'mobile-app': { zh: '移动应用', en: 'Mobile Apps' },
        'backend': { zh: '后端服务', en: 'Backend Services' },
        'ai-ml': { zh: 'AI/ML 项目', en: 'AI/ML Projects' },
        'devops': { zh: 'DevOps/工具', en: 'DevOps/Tools' },
        'other': { zh: '其他', en: 'Other' }
    };
    
    // 按文件数量排序
    const sortedTypes = Array.from(stats.byType.entries())
        .sort((a, b) => b[1].files - a[1].files);
    
    for (const [type, data] of sortedTypes) {
        const icon = typeIcons[type] || '📁';
        const label = isZh() ? typeLabels[type]?.zh : typeLabels[type]?.en;
        const projectCount = data.projects.length;
        const fileCount = data.files;
        
        const item = new KnowledgeTreeItem(
            `${icon} ${label} (${projectCount} ${isZh() ? '项目' : 'projects'}, ${fileCount} ${isZh() ? '条' : 'items'})`,
            vscode.TreeItemCollapsibleState.Collapsed,
            'projectType'
        );
        
        item.contextValue = 'projectType';
        item.tooltip = `${label}: ${projectCount} ${isZh() ? '个项目' : 'projects'}, ${fileCount} ${isZh() ? '条知识' : 'items'}`;
        item.metadata = { projectType: type };
        
        items.push(item);
    }
    
    return items;
}
```

### 2. 获取项目列表

```typescript
/**
 * 获取指定类型下的项目列表
 */
private getProjectsByType(projectType: string): KnowledgeTreeItem[] {
    const stats = this.getProjectGroupStats();
    const typeData = stats.byType.get(projectType);
    
    if (!typeData) return [];
    
    const items: KnowledgeTreeItem[] = [];
    
    // 统计每个项目的文件数
    const projectFileCounts = new Map<string, number>();
    
    // 扫描所有知识文件
    const allFiles = this.scanAllKnowledgeFiles();
    
    for (const file of allFiles) {
        const metadata = this.extractMetadata(file);
        if (metadata.source_project_type === projectType) {
            const project = metadata.source_project || 'unknown';
            projectFileCounts.set(project, (projectFileCounts.get(project) || 0) + 1);
        }
    }
    
    // 按文件数排序
    const sortedProjects = Array.from(projectFileCounts.entries())
        .sort((a, b) => b[1] - a[1]);
    
    for (const [project, fileCount] of sortedProjects) {
        const item = new KnowledgeTreeItem(
            `📂 ${project} (${fileCount})`,
            vscode.TreeItemCollapsibleState.Collapsed,
            'project'
        );
        
        item.contextValue = 'project';
        item.tooltip = `${project}: ${fileCount} ${isZh() ? '条知识' : 'items'}`;
        item.metadata = { 
            projectName: project,
            projectType: projectType
        };
        
        items.push(item);
    }
    
    return items;
}
```

### 3. 获取项目下的文件

```typescript
/**
 * 获取指定项目下的文件列表
 */
private getFilesByProject(projectName: string, projectType?: string): KnowledgeTreeItem[] {
    const allFiles = this.scanAllKnowledgeFiles();
    const items: KnowledgeTreeItem[] = [];
    
    for (const file of allFiles) {
        const metadata = this.extractMetadata(file);
        
        // 匹配项目名和类型
        if (metadata.source_project === projectName) {
            if (projectType && metadata.source_project_type !== projectType) {
                continue;
            }
            
            const fileName = path.basename(file, '.md');
            const item = new KnowledgeTreeItem(
                `📄 ${fileName}`,
                vscode.TreeItemCollapsibleState.None,
                'knowledgeFile'
            );
            
            item.contextValue = 'knowledgeFile';
            item.tooltip = metadata.title || fileName;
            item.command = {
                command: 'kiro-kb.openKnowledgeFile',
                title: 'Open File',
                arguments: [file]
            };
            item.metadata = { filePath: file };
            
            items.push(item);
        }
    }
    
    // 按日期排序（新的在前）
    items.sort((a, b) => {
        const dateA = this.extractMetadata(a.metadata.filePath).date || '';
        const dateB = this.extractMetadata(b.metadata.filePath).date || '';
        return dateB.localeCompare(dateA);
    });
    
    return items;
}
```

### 4. 统计信息收集

```typescript
/**
 * 获取项目分组统计信息
 */
private getProjectGroupStats(): {
    totalProjects: number;
    totalFiles: number;
    byType: Map<string, { projects: string[]; files: number }>;
} {
    const byType = new Map<string, { projects: string[]; files: number }>();
    const projectSet = new Set<string>();
    
    const allFiles = this.scanAllKnowledgeFiles();
    
    for (const file of allFiles) {
        const metadata = this.extractMetadata(file);
        const projectType = metadata.source_project_type || 'other';
        const projectName = metadata.source_project || 'unknown';
        
        projectSet.add(projectName);
        
        if (!byType.has(projectType)) {
            byType.set(projectType, { projects: [], files: 0 });
        }
        
        const typeData = byType.get(projectType)!;
        
        if (!typeData.projects.includes(projectName)) {
            typeData.projects.push(projectName);
        }
        
        typeData.files++;
    }
    
    return {
        totalProjects: projectSet.size,
        totalFiles: allFiles.length,
        byType
    };
}
```

### 5. 元数据提取

```typescript
/**
 * 从文件中提取 YAML front-matter
 */
private extractMetadata(filePath: string): {
    title?: string;
    domain?: string;
    tags?: string[];
    date?: string;
    source_project?: string;
    source_project_type?: string;
} {
    try {
        const content = fs.readFileSync(filePath, 'utf8');
        
        // 提取 YAML front-matter
        const yamlMatch = content.match(/^---\n([\s\S]*?)\n---/);
        if (!yamlMatch) return {};
        
        const yamlContent = yamlMatch[1];
        const metadata: any = {};
        
        // 简单解析 YAML
        const lines = yamlContent.split('\n');
        for (const line of lines) {
            const match = line.match(/^(\w+):\s*(.+)$/);
            if (match) {
                const key = match[1];
                let value: any = match[2].trim();
                
                // 处理数组
                if (value.startsWith('[') && value.endsWith(']')) {
                    value = value.slice(1, -1).split(',').map(v => v.trim());
                }
                
                // 处理字符串
                if (typeof value === 'string') {
                    value = value.replace(/^["']|["']$/g, '');
                }
                
                metadata[key] = value;
            }
        }
        
        // 提取标题
        if (!metadata.title) {
            const titleMatch = content.match(/^#\s+(.+)$/m);
            if (titleMatch) {
                metadata.title = titleMatch[1].trim();
            }
        }
        
        return metadata;
    } catch {
        return {};
    }
}
```

### 6. 子节点路由

```typescript
/**
 * 获取子节点
 */
private getChildNodes(element: KnowledgeTreeItem): KnowledgeTreeItem[] {
    const type = element.contextValue;
    
    switch (type) {
        case 'projectType':
            // 项目类型 → 项目列表
            return this.getProjectsByType(element.metadata.projectType);
            
        case 'project':
            // 项目 → 文件列表
            return this.getFilesByProject(
                element.metadata.projectName,
                element.metadata.projectType
            );
            
        default:
            return [];
    }
}
```

## 注意事项

### 1. 性能优化

**缓存机制**：
```typescript
private fileCache: Map<string, any> = new Map();
private cacheExpiry: number = 30 * 1000; // 30秒
private lastScanTime: number = 0;

private scanAllKnowledgeFiles(): string[] {
    const now = Date.now();
    
    // 使用缓存
    if (now - this.lastScanTime < this.cacheExpiry) {
        return Array.from(this.fileCache.keys());
    }
    
    // 重新扫描
    const files = this.doScanFiles();
    this.lastScanTime = now;
    
    return files;
}
```

**延迟加载**：
```typescript
// 只在展开时加载子节点
getChildren(element?: KnowledgeTreeItem): Thenable<KnowledgeTreeItem[]> {
    if (!element) {
        return Promise.resolve(this.getRootNodes());
    }
    
    // 延迟加载子节点
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve(this.getChildNodes(element));
        }, 0);
    });
}
```

### 2. 用户体验

**加载提示**：
```typescript
// 显示加载状态
const loadingItem = new KnowledgeTreeItem(
    '⏳ 加载中...',
    vscode.TreeItemCollapsibleState.None,
    'loading'
);
```

**空状态提示**：
```typescript
if (items.length === 0) {
    return [new KnowledgeTreeItem(
        '📭 暂无内容',
        vscode.TreeItemCollapsibleState.None,
        'empty'
    )];
}
```

### 3. 错误处理

```typescript
try {
    const metadata = this.extractMetadata(file);
} catch (error) {
    console.error(`Failed to extract metadata from ${file}:`, error);
    // 使用默认值
    const metadata = {
        source_project: 'unknown',
        source_project_type: 'other'
    };
}
```

### 4. 国际化支持

```typescript
const label = isZh() 
    ? `${icon} ${typeLabels[type].zh} (${projectCount} 项目, ${fileCount} 条)`
    : `${icon} ${typeLabels[type].en} (${projectCount} projects, ${fileCount} items)`;
```

### 5. 上下文菜单

```typescript
// package.json 中配置
"menus": {
    "view/item/context": [
        {
            "command": "kiro-kb.openKnowledgeFile",
            "when": "view == kiro-kb.knowledgePanel && viewItem == knowledgeFile",
            "group": "inline"
        },
        {
            "command": "kiro-kb.deleteKnowledgeFile",
            "when": "view == kiro-kb.knowledgePanel && viewItem == knowledgeFile",
            "group": "inline"
        }
    ]
}
```

## 适用场景

1. **文件管理器**：按类型、项目、标签分组展示文件
2. **知识库浏览器**：多维度展示知识内容
3. **项目管理工具**：按团队、项目、任务层级展示
4. **代码导航**：按模块、类、方法层级展示代码结构
5. **数据可视化**：树形展示层级数据

## 扩展建议

### 1. 搜索过滤

```typescript
private searchQuery: string = '';

setSearchQuery(query: string): void {
    this.searchQuery = query;
    this.refresh();
}

private getFilesByProject(projectName: string): KnowledgeTreeItem[] {
    let files = this.doGetFilesByProject(projectName);
    
    // 应用搜索过滤
    if (this.searchQuery) {
        files = files.filter(item => 
            item.label.toLowerCase().includes(this.searchQuery.toLowerCase())
        );
    }
    
    return files;
}
```

### 2. 排序选项

```typescript
enum SortOrder {
    ByName = 'name',
    ByDate = 'date',
    BySize = 'size'
}

private sortOrder: SortOrder = SortOrder.ByDate;

setSortOrder(order: SortOrder): void {
    this.sortOrder = order;
    this.refresh();
}
```

### 3. 虚拟滚动

对于大量数据，使用虚拟滚动优化性能：

```typescript
// 只渲染可见区域的节点
private visibleRange: { start: number; end: number } = { start: 0, end: 50 };

getChildren(element?: KnowledgeTreeItem): Thenable<KnowledgeTreeItem[]> {
    const allChildren = this.getAllChildren(element);
    
    // 只返回可见范围的节点
    const visibleChildren = allChildren.slice(
        this.visibleRange.start,
        this.visibleRange.end
    );
    
    return Promise.resolve(visibleChildren);
}
```

### 4. 拖拽支持

```typescript
// 实现 TreeDragAndDropController
class KnowledgePanelProvider implements 
    vscode.TreeDataProvider<KnowledgeTreeItem>,
    vscode.TreeDragAndDropController<KnowledgeTreeItem> {
    
    dropMimeTypes = ['application/vnd.code.tree.knowledgePanel'];
    dragMimeTypes = ['text/uri-list'];
    
    handleDrag(source: KnowledgeTreeItem[], dataTransfer: vscode.DataTransfer): void {
        // 处理拖拽开始
    }
    
    handleDrop(target: KnowledgeTreeItem, dataTransfer: vscode.DataTransfer): void {
        // 处理拖拽放置
    }
}
```

### 5. 批量操作

```typescript
// 支持多选
const selectedItems: KnowledgeTreeItem[] = [];

async batchDelete(items: KnowledgeTreeItem[]): Promise<void> {
    const confirm = await vscode.window.showWarningMessage(
        `确定删除 ${items.length} 个文件？`,
        '删除', '取消'
    );
    
    if (confirm === '删除') {
        for (const item of items) {
            fs.unlinkSync(item.metadata.filePath);
        }
        this.refresh();
    }
}
```
