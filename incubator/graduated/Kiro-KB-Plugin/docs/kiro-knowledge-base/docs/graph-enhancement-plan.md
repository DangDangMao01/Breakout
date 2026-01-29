# 知识图谱增强计划

> 基于早期版本截图的功能恢复和增强
> 计划日期：2026-01-14

## 📸 参考截图分析

### 截图1：整体布局
- 清晰的节点聚类（中间绿色密集区域是核心知识群）
- 三种颜色节点：绿色（Solutions）、蓝色（Notes）、橙色（Discussions）
- 顶部完整的工具栏

### 截图2：文件夹筛选
- 多选下拉菜单
- 可选择：Solutions / Notes / Discussions
- 带勾选框，可组合筛选

### 截图3：标签筛选
- 单选下拉菜单
- 显示所有标签列表（20+ 个标签）
- 选择后只显示包含该标签的节点

## 🎯 功能差距对比

### 当前已有功能 ✅
- [x] 基础图谱渲染（SVG + 力导向）
- [x] 节点拖拽
- [x] 画布平移
- [x] 鼠标滚轮缩放
- [x] 悬停提示
- [x] 统计信息（节点数、边数、核心节点、孤立节点）
- [x] 重置视图按钮
- [x] 图例切换按钮
- [x] 本地/中央知识库选择

### 缺失的核心功能 ❌
1. **搜索节点** - 输入框，实时搜索并高亮节点
2. **文件夹筛选** - 多选下拉菜单（Solutions/Notes/Discussions）
3. **标签筛选** - 单选下拉菜单（显示所有标签）
4. **查看按钮** - 功能待确认
5. **切换布局按钮** - 切换不同的布局算法
6. **适应窗口按钮** - 自动调整缩放和位置
7. **节点点击** - 打开对应的 Markdown 文件
8. **节点颜色** - 应该对应分类（Solutions=绿色，Notes=蓝色，Discussions=橙色）

## 📋 实现任务清单

### Phase 1: 工具栏重构（2-3小时）

#### 1.1 新增搜索功能
```typescript
// 搜索输入框
<input type="text" id="search-input" placeholder="搜索节点" />

// 搜索逻辑
function searchNodes(query: string) {
    // 1. 模糊匹配节点标题
    // 2. 高亮匹配的节点（放大 + 边框）
    // 3. 其他节点半透明
    // 4. 自动居中到第一个匹配节点
}
```

**实现要点**：
- 实时搜索（输入时触发）
- 支持中英文
- 高亮显示匹配节点
- 显示匹配数量

#### 1.2 文件夹筛选（多选）
```typescript
// 下拉菜单结构
<select id="folder-filter" multiple>
    <option value="all" selected>全部文件夹</option>
    <option value="solutions">✓ Solutions</option>
    <option value="notes">Notes</option>
    <option value="discussions">Discussions</option>
</select>

// 筛选逻辑
function filterByFolders(selected: string[]) {
    // 1. 只显示选中分类的节点
    // 2. 隐藏其他节点和相关边
    // 3. 重新计算布局
}
```

**实现要点**：
- 使用自定义下拉组件（原生 select 多选体验差）
- 勾选框样式
- 至少选择一个分类

#### 1.3 标签筛选（单选）
```typescript
// 下拉菜单结构
<select id="tag-filter">
    <option value="all" selected>全部标签</option>
    <option value="vscode-extension">vscode-extension</option>
    <option value="typescript">typescript</option>
    // ... 动态生成所有标签
</select>

// 筛选逻辑
function filterByTag(tag: string) {
    // 1. 只显示包含该标签的节点
    // 2. 隐藏其他节点和相关边
    // 3. 重新计算布局
}
```

**实现要点**：
- 从所有节点提取标签列表
- 按字母排序
- 显示每个标签的节点数量

#### 1.4 其他按钮
```typescript
// 查看按钮 - 待确认功能
<button id="view-btn">查看</button>

// 切换布局按钮
<button id="layout-btn">切换布局</button>
// 支持：力导向、圆形、网格、层次

// 适应窗口按钮
<button id="fit-btn">适应窗口</button>
// 自动计算最佳缩放和位置
```

### Phase 2: 节点交互增强（1-2小时）

#### 2.1 节点颜色映射
```typescript
// 当前：按 domain 分配颜色
// 改为：按分类（category）分配颜色
const categoryColors = {
    'solutions': '#4CAF50',    // 绿色
    'notes': '#2196F3',        // 蓝色
    'discussions': '#FF9800'   // 橙色
};
```

#### 2.2 节点点击事件
```typescript
circle.addEventListener('click', async () => {
    // 1. 获取节点对应的文件路径
    // 2. 通过 VSCode API 打开文件
    // 3. 可选：高亮节点表示已打开
});
```

#### 2.3 节点右键菜单（可选）
```typescript
circle.addEventListener('contextmenu', (e) => {
    e.preventDefault();
    // 显示菜单：
    // - 打开文件
    // - 复制标题
    // - 查看关联节点
    // - 在图谱中隐藏
});
```

### Phase 3: 布局算法优化（1-2小时）

#### 3.1 改进力导向算法
```typescript
// 当前问题：节点分散，没有明显聚类
// 改进方向：
// 1. 增强同分类节点的吸引力
// 2. 增强强关联节点的吸引力
// 3. 减弱弱关联节点的吸引力
// 4. 添加分类中心点（虚拟节点）
```

#### 3.2 支持多种布局
```typescript
const layouts = {
    'force': forceDirectedLayout,  // 力导向（默认）
    'circle': circleLayout,        // 圆形布局
    'grid': gridLayout,            // 网格布局
    'hierarchy': hierarchyLayout   // 层次布局
};
```

### Phase 4: 性能优化（1小时）

#### 4.1 大数据量优化
```typescript
// 当前：所有节点都渲染
// 优化：
// 1. 节点数 > 100 时，只渲染可见区域
// 2. 使用 Canvas 代替 SVG（性能更好）
// 3. 节点聚合（距离很近的节点合并显示）
```

#### 4.2 筛选性能
```typescript
// 当前：每次筛选重新渲染
// 优化：
// 1. 使用 display: none 隐藏节点
// 2. 缓存筛选结果
// 3. 防抖处理搜索输入
```

## 🎨 UI 设计规范

### 工具栏布局
```
[搜索框] [文件夹▼] [标签▼] [查看] [切换布局] [适应窗口] | [统计信息...] [重置] [图例]
```

### 颜色方案
```typescript
const colors = {
    solutions: '#4CAF50',      // 绿色
    notes: '#2196F3',          // 蓝色
    discussions: '#FF9800',    // 橙色
    
    // 边的颜色
    strongLink: '#666',        // 强关联（深灰）
    weakLink: '#333',          // 弱关联（浅灰）
    
    // 高亮
    highlight: '#FFD700',      // 金色
    selected: '#FF4081'        // 粉色
};
```

### 节点大小
```typescript
// 基础大小：6-12px（根据连接度）
// 搜索高亮：放大 1.5 倍
// 悬停：放大 1.3 倍
// 选中：放大 1.5 倍 + 边框
```

## 📝 实现顺序建议

### 第一步：工具栏 HTML/CSS（30分钟）
- 重新设计工具栏布局
- 添加所有控件
- 调整样式

### 第二步：搜索功能（1小时）
- 实现搜索逻辑
- 高亮匹配节点
- 测试中英文搜索

### 第三步：文件夹筛选（1小时）
- 实现多选下拉组件
- 筛选逻辑
- 测试组合筛选

### 第四步：标签筛选（1小时）
- 提取所有标签
- 实现单选筛选
- 测试标签筛选

### 第五步：节点交互（1小时）
- 修改节点颜色映射
- 添加点击打开文件
- 测试文件打开

### 第六步：布局优化（1-2小时）
- 改进力导向算法
- 实现切换布局
- 测试布局效果

### 第七步：测试和优化（1小时）
- 完整功能测试
- 性能测试
- Bug 修复

## 🔧 技术实现细节

### 自定义下拉组件
```typescript
// 使用 HTML + CSS 实现，不用原生 select
class CustomDropdown {
    constructor(options: {
        id: string;
        title: string;
        items: Array<{value: string, label: string, checked?: boolean}>;
        multiple: boolean;
        onChange: (selected: string[]) => void;
    }) {
        // 实现自定义下拉菜单
    }
}
```

### WebView 消息通信
```typescript
// 前端 → 后端
vscode.postMessage({
    command: 'openFile',
    filePath: '/path/to/file.md'
});

// 后端处理
webview.onDidReceiveMessage(message => {
    if (message.command === 'openFile') {
        vscode.workspace.openTextDocument(message.filePath)
            .then(doc => vscode.window.showTextDocument(doc));
    }
});
```

### 布局算法参数
```typescript
const layoutParams = {
    force: {
        repulsion: 2000,        // 斥力
        attraction: 0.02,       // 引力
        categoryBonus: 2.0,     // 同分类吸引力加成
        strongLinkBonus: 1.5,   // 强关联吸引力加成
        damping: 0.85           // 阻尼系数
    }
};
```

## 📊 预期效果

### 功能完整性
- ✅ 搜索：快速定位节点
- ✅ 筛选：按分类和标签过滤
- ✅ 交互：点击打开文件
- ✅ 布局：清晰的知识聚类
- ✅ 性能：流畅的交互体验

### 用户体验
- 工具栏功能丰富但不复杂
- 筛选逻辑清晰直观
- 节点颜色一目了然
- 搜索响应快速
- 布局美观合理

## ⚠️ 注意事项

1. **保持向后兼容**：不要破坏现有的基础功能
2. **性能优先**：大数据量时保持流畅
3. **用户体验**：每个功能都要直观易用
4. **代码质量**：保持模块化，便于维护
5. **测试充分**：每个功能都要测试边界情况

## 📚 参考资料

- 早期版本截图（3张）
- 当前实现：`graphGenerator.ts`
- D3.js 力导向布局文档
- VSCode WebView API 文档

---

**预计总工时**：6-8 小时
**建议分配**：
- 上午（3-4小时）：工具栏 + 搜索 + 筛选
- 下午（3-4小时）：节点交互 + 布局优化 + 测试

**完成标准**：
- 所有截图中的功能都已实现
- 编译通过，无 TypeScript 错误
- 功能测试通过
- 打包成功
