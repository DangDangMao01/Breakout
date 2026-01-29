# 知识图谱增强实施进度

> 开始日期：2026-01-14
> 当前状态：Phase 1 完成

## ✅ 已完成（2026-01-14）

### 1. 数据结构增强
- ✅ `GraphNode` 接口添加 `filePath` 字段（用于打开文件）
- ✅ `GraphNode` 接口添加 `category` 字段（solutions/notes/discussions）
- ✅ `GraphData` 接口添加 `allTags` 字段（所有标签列表）
- ✅ `scanKnowledgeBase()` 函数收集所有标签
- ✅ `parseFile()` 函数返回完整路径和分类

### 2. 消息通信机制
- ✅ 添加 `webview.onDidReceiveMessage` 处理器
- ✅ 实现 `openFile` 命令（点击节点打开文件）
- ✅ 错误处理和用户提示

### 3. 代码质量
- ✅ 编译通过（无 TypeScript 错误）
- ✅ 备份原文件（graphGenerator.ts.backup）
- ✅ 代码注释完整
- ✅ 修复缺失的工具函数（2026-01-14）
  - 添加 `safeReadFile()` - 安全文件读取
  - 添加 `extractKeywords()` - 关键词提取（含停用词过滤）
  - 添加 `extractReferences()` - Wiki链接和Markdown链接提取
  - 添加 `extractTagsFromPath()` - 从文件frontmatter提取标签

### 4. 适应窗口功能 ✅（2026-01-14）
- ✅ 实现 `fitToWindow()` 函数（graphGenerator.ts 第 754-781 行）
- ✅ 工具栏添加"适应窗口"按钮
- ✅ 自动计算最佳缩放和居中位置

## ⏳ 进行中

### Phase 2: 前端功能实现（预计 4-6 小时）

#### 2.1 工具栏重构（1-2小时）
**当前状态**：基础工具栏已有（统计信息 + 重置/图例按钮）

**需要添加**：
```html
<!-- 搜索框 -->
<input type="text" id="search-input" placeholder="搜索节点..." />

<!-- 文件夹筛选（自定义下拉） -->
<div class="dropdown" id="folder-filter">
    <button class="dropdown-btn">全部文件夹 ▼</button>
    <div class="dropdown-content">
        <label><input type="checkbox" value="solutions" checked> Solutions</label>
        <label><input type="checkbox" value="notes" checked> Notes</label>
        <label><input type="checkbox" value="discussions" checked> Discussions</label>
    </div>
</div>

<!-- 标签筛选 -->
<select id="tag-filter">
    <option value="all">全部标签</option>
    <!-- 动态生成标签选项 -->
</select>

<!-- 布局切换 -->
<button id="layout-btn">切换布局</button>

<!-- 适应窗口 -->
<button id="fit-btn">适应窗口</button>
```

**CSS 样式**：
- 自定义下拉菜单样式（模拟多选）
- 搜索框样式
- 按钮hover效果

#### 2.2 搜索功能（1小时）
**实现要点**：
```javascript
function searchNodes(query) {
    const lowerQuery = query.toLowerCase();
    const matches = [];
    
    nodes.forEach(node => {
        const score = calculateMatchScore(node, lowerQuery);
        if (score > 0) {
            matches.push({ node, score });
        }
    });
    
    // 排序并高亮
    matches.sort((a, b) => b.score - a.score);
    highlightNodes(matches.map(m => m.node.id));
    
    // 居中到第一个匹配节点
    if (matches.length > 0) {
        centerToNode(matches[0].node);
    }
}

function calculateMatchScore(node, query) {
    let score = 0;
    if (node.title.toLowerCase().includes(query)) score += 10;
    if (node.tags.some(t => t.toLowerCase().includes(query))) score += 5;
    if (node.domain.toLowerCase().includes(query)) score += 3;
    return score;
}

function highlightNodes(nodeIds) {
    nodes.forEach(node => {
        const circle = document.querySelector(`[data-id="${node.id}"]`);
        if (nodeIds.includes(node.id)) {
            circle.setAttribute('r', node.radius * 1.5);
            circle.setAttribute('stroke', '#FFD700');
            circle.setAttribute('stroke-width', '3');
            circle.style.opacity = '1';
        } else {
            circle.style.opacity = '0.3';
        }
    });
}
```

#### 2.3 文件夹筛选（1小时）
**实现要点**：
```javascript
let activeCategories = ['solutions', 'notes', 'discussions'];

function filterByCategories(categories) {
    activeCategories = categories;
    
    // 隐藏/显示节点
    nodes.forEach(node => {
        const circle = document.querySelector(`[data-id="${node.id}"]`);
        if (categories.includes(node.category)) {
            circle.style.display = 'block';
        } else {
            circle.style.display = 'none';
        }
    });
    
    // 隐藏/显示边
    edges.forEach(edge => {
        const source = nodes.find(n => n.id === edge.source);
        const target = nodes.find(n => n.id === edge.target);
        const line = document.querySelector(`[data-edge="${edge.source}-${edge.target}"]`);
        
        if (categories.includes(source.category) && categories.includes(target.category)) {
            line.style.display = 'block';
        } else {
            line.style.display = 'none';
        }
    });
    
    // 重新布局
    simulate();
}
```

#### 2.4 标签筛选（30分钟）
**实现要点**：
```javascript
function filterByTag(tag) {
    if (tag === 'all') {
        // 显示所有节点
        nodes.forEach(node => {
            const circle = document.querySelector(`[data-id="${node.id}"]`);
            circle.style.display = 'block';
        });
    } else {
        // 只显示包含该标签的节点
        nodes.forEach(node => {
            const circle = document.querySelector(`[data-id="${node.id}"]`);
            if (node.tags.includes(tag)) {
                circle.style.display = 'block';
            } else {
                circle.style.display = 'none';
            }
        });
    }
    
    // 更新边的显示
    updateEdgesVisibility();
    simulate();
}
```

#### 2.5 节点颜色映射（30分钟）
**当前**：按 domain 分配颜色
**改为**：按 category 分配颜色

```javascript
const categoryColors = {
    'solutions': '#4CAF50',    // 绿色
    'notes': '#2196F3',        // 蓝色
    'discussions': '#FF9800'   // 橙色
};

// 在渲染节点时使用
circle.setAttribute('fill', categoryColors[node.category]);
```

#### 2.6 节点点击打开文件（已完成 ✅）
```javascript
circle.addEventListener('click', () => {
    vscode.postMessage({
        command: 'openFile',
        filePath: node.filePath
    });
});
```

#### 2.7 布局切换（1小时）
**实现要点**：
```javascript
let currentLayout = 'force';  // force/circle/grid

function switchLayout() {
    const layouts = ['force', 'circle', 'grid'];
    const currentIndex = layouts.indexOf(currentLayout);
    currentLayout = layouts[(currentIndex + 1) % layouts.length];
    
    switch (currentLayout) {
        case 'force':
            applyForceLayout();
            break;
        case 'circle':
            applyCircleLayout();
            break;
        case 'grid':
            applyGridLayout();
            break;
    }
    
    render();
}

function applyCircleLayout() {
    const radius = Math.min(width, height) * 0.4;
    nodes.forEach((node, i) => {
        const angle = (i / nodes.length) * 2 * Math.PI;
        node.x = Math.cos(angle) * radius;
        node.y = Math.sin(angle) * radius;
    });
}

function applyGridLayout() {
    const cols = Math.ceil(Math.sqrt(nodes.length));
    const cellSize = Math.min(width, height) / cols * 0.8;
    
    nodes.forEach((node, i) => {
        const row = Math.floor(i / cols);
        const col = i % cols;
        node.x = (col - cols / 2) * cellSize;
        node.y = (row - cols / 2) * cellSize;
    });
}
```

#### 2.8 适应窗口 ✅（已完成 - 2026-01-14）
**实现位置**：`graphGenerator.ts` 第 754-781 行

**功能说明**：
- 计算所有节点的边界框
- 计算最佳缩放比例（留10%边距）
- 自动居中图谱
- 限制最大缩放为 2x

**实现代码**：
```javascript
function fitToWindow() {
    // 计算所有节点的边界
    let minX = Infinity, maxX = -Infinity;
    let minY = Infinity, maxY = -Infinity;
    
    nodes.forEach(node => {
        minX = Math.min(minX, node.x);
        maxX = Math.max(maxX, node.x);
        minY = Math.min(minY, node.y);
        maxY = Math.max(maxY, node.y);
    });
    
    const graphWidth = maxX - minX;
    const graphHeight = maxY - minY;
    const graphCenterX = (minX + maxX) / 2;
    const graphCenterY = (minY + maxY) / 2;
    
    // 计算最佳缩放（留10%边距）
    const scaleX = (width * 0.9) / graphWidth;
    const scaleY = (height * 0.9) / graphHeight;
    scale = Math.min(scaleX, scaleY, 2);  // 最大2倍
    
    // 居中
    translateX = width / 2 - graphCenterX * scale;
    translateY = height / 2 - graphCenterY * scale;
    
    render();
}
```

#### 2.9 布局算法优化（1小时）
**改进力导向算法**：
```javascript
function simulate() {
    const iterations = 100;
    for (let i = 0; i < iterations; i++) {
        // 斥力
        for (let j = 0; j < nodes.length; j++) {
            for (let k = j + 1; k < nodes.length; k++) {
                const dx = nodes[k].x - nodes[j].x;
                const dy = nodes[k].y - nodes[j].y;
                const dist = Math.sqrt(dx * dx + dy * dy) || 1;
                const force = 2000 / (dist * dist);
                nodes[j].vx -= dx / dist * force;
                nodes[j].vy -= dy / dist * force;
                nodes[k].vx += dx / dist * force;
                nodes[k].vy += dy / dist * force;
            }
        }
        
        // 引力（增强同分类节点的吸引力）
        edges.forEach(edge => {
            const source = nodes.find(n => n.id === edge.source);
            const target = nodes.find(n => n.id === edge.target);
            if (!source || !target) return;
            
            const dx = target.x - source.x;
            const dy = target.y - source.y;
            const dist = Math.sqrt(dx * dx + dy * dy) || 1;
            
            // 同分类节点吸引力加倍
            const categoryBonus = source.category === target.category ? 2.0 : 1.0;
            const force = dist * 0.02 * categoryBonus;
            
            source.vx += dx / dist * force;
            source.vy += dy / dist * force;
            target.vx -= dx / dist * force;
            target.vy -= dy / dist * force;
        });
        
        // 更新位置
        nodes.forEach(node => {
            node.x += node.vx;
            node.y += node.vy;
            node.vx *= 0.85;
            node.vy *= 0.85;
        });
    }
    render();
}
```

## 📋 实施计划

### 今天下午（2-3小时）
1. ✅ 数据结构增强（已完成）
2. ✅ 消息通信机制（已完成）
3. ✅ 适应窗口功能（已完成）
4. ⏳ 节点颜色映射（30分钟）
5. ⏳ 测试和打包（30分钟）

### 明天（4-5小时）
1. 工具栏重构（1-2小时）
2. 搜索功能（1小时）
3. 文件夹筛选（1小时）
4. 标签筛选（30分钟）
5. 布局切换（1小时）
6. 布局算法优化（1小时）
7. 完整测试和打包（1小时）

## 🔧 技术要点

### 自定义下拉菜单
由于原生 `<select multiple>` 体验差，需要自定义实现：

```html
<div class="custom-dropdown">
    <button class="dropdown-toggle">全部文件夹 ▼</button>
    <div class="dropdown-menu">
        <label class="dropdown-item">
            <input type="checkbox" value="solutions" checked>
            <span>✓ Solutions</span>
        </label>
        <label class="dropdown-item">
            <input type="checkbox" value="notes" checked>
            <span>Notes</span>
        </label>
        <label class="dropdown-item">
            <input type="checkbox" value="discussions" checked>
            <span>Discussions</span>
        </label>
    </div>
</div>
```

```css
.custom-dropdown {
    position: relative;
}

.dropdown-menu {
    position: absolute;
    top: 100%;
    left: 0;
    background: var(--vscode-dropdown-background);
    border: 1px solid var(--vscode-dropdown-border);
    border-radius: 3px;
    padding: 4px 0;
    display: none;
    z-index: 1000;
}

.dropdown-menu.show {
    display: block;
}

.dropdown-item {
    display: flex;
    align-items: center;
    padding: 4px 12px;
    cursor: pointer;
}

.dropdown-item:hover {
    background: var(--vscode-list-hoverBackground);
}
```

### 防抖处理
搜索输入需要防抖，避免频繁触发：

```javascript
let searchTimeout;
searchInput.addEventListener('input', (e) => {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        searchNodes(e.target.value);
    }, 300);
});
```

### 性能优化
- 节点数 > 100 时，考虑使用 Canvas 代替 SVG
- 筛选时使用 `display: none` 而非重新渲染
- 缓存 DOM 查询结果

## 📊 预期效果

完成后的知识图谱将具备：
- ✅ 实时搜索并高亮节点
- ✅ 按分类筛选（多选）
- ✅ 按标签筛选（单选）
- ✅ 三种布局模式切换
- ✅ 一键适应窗口
- ✅ 点击节点打开文件
- ✅ 按分类着色（绿/蓝/橙）
- ✅ 同分类节点聚类

## 🐛 已知问题

无

## 📝 注意事项

1. **保持向后兼容**：不破坏现有功能
2. **性能优先**：大数据量时保持流畅
3. **用户体验**：每个功能都要直观易用
4. **代码质量**：保持模块化，便于维护

## 📚 参考资料

- 早期版本截图（3张）
- `docs/graph-enhancement-plan.md` - 详细设计文档
- D3.js 力导向布局文档
- VSCode WebView API 文档
