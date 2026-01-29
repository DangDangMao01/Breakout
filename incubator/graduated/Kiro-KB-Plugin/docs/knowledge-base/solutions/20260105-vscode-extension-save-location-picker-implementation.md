---
domain: solution
tags: [vscode, extension, user-experience, dialog, typescript]
date: 2026-01-05
source_project: "kiro-knowledge-base"
value_score: 9
---

# VSCode 插件实现多层级保存位置选择器

## 问题/背景

在知识管理插件中，用户需要将知识保存到不同的位置：
- 本地项目知识库
- 中央知识库的项目目录
- 中央知识库的通用目录
- 中央知识库的领域目录

需要一个灵活的保存位置选择器，支持：
1. 多种保存位置选项
2. 智能默认选项（根据项目绑定状态）
3. 二级选择（领域选择）
4. 返回完整的保存位置信息

## 解决方案

### 核心设计

使用 `vscode.window.showQuickPick` 实现多选项对话框，配合类型系统确保类型安全。

**关键类型定义**：
```typescript
type SaveLocation = 'local' | 'central-project' | 'central-flat' | 'central-domain';

interface SaveLocationResult {
    location: SaveLocation;
    basePath: string;
    folder: string;
    projectName: string;
    projectType?: ProjectType;
    level: 'project' | 'project-group' | 'domain';
}
```

### 实现步骤

**1. 构建选项列表**

根据当前环境动态构建可用选项：

```typescript
async function showSaveLocationPicker(
    folder: string,
    suggestedLevel?: 'project' | 'project-group' | 'domain'
): Promise<SaveLocationResult | null> {
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    const binding = getProjectBinding();
    const projectName = workspaceFolder ? path.basename(workspaceFolder.uri.fsPath) : 'unknown';
    
    const items: { 
        label: string; 
        description: string; 
        value: SaveLocation; 
        level: 'project' | 'project-group' | 'domain' 
    }[] = [];
    
    // 1. 当前项目知识库
    if (workspaceFolder) {
        items.push({
            label: `📁 ${isZh() ? '当前项目知识库' : 'Current Project KB'}`,
            description: `knowledge-base/${folder}/`,
            value: 'local',
            level: 'project'
        });
    }
    
    // 2. 中央知识库 - 项目目录
    if (binding?.centralProjectPath) {
        items.push({
            label: `☁️ ${isZh() ? '中央知识库 - 项目目录' : 'Central KB - Project Dir'}`,
            description: `projects/${projectName}/${folder}/`,
            value: 'central-project',
            level: 'project'
        });
    } else if (centralPath) {
        // 没有绑定但有中央路径，提示可以创建
        items.push({
            label: `☁️ ${isZh() ? '中央知识库 - 创建项目' : 'Central KB - Create Project'}`,
            description: `projects/${projectName}/${folder}/ (${isZh() ? '新建' : 'new'})`,
            value: 'central-project',
            level: 'project'
        });
    }
    
    // 3. 中央知识库 - 通用目录
    if (centralPath) {
        items.push({
            label: `🌐 ${isZh() ? '中央知识库 - 通用目录' : 'Central KB - Flat Dir'}`,
            description: `${folder}/`,
            value: 'central-flat',
            level: 'project-group'
        });
    }
    
    // 4. 中央知识库 - 领域目录
    if (centralPath) {
        items.push({
            label: `📚 ${isZh() ? '中央知识库 - 领域目录' : 'Central KB - Domain Dir'}`,
            description: `domains/.../${folder}/`,
            value: 'central-domain',
            level: 'domain'
        });
    }
    
    if (items.length === 0) {
        vscode.window.showErrorMessage(isZh() ? '没有可用的保存位置' : 'No save location available');
        return null;
    }
    
    // 显示选择对话框
    const selected = await vscode.window.showQuickPick(items, {
        placeHolder: isZh() ? '选择保存位置' : 'Select save location',
        title: isZh() ? '💾 保存知识到...' : '💾 Save knowledge to...'
    });
    
    if (!selected) return null;
    
    // 根据选择确定实际路径
    let basePath: string;
    
    switch (selected.value) {
        case 'local':
            basePath = path.join(workspaceFolder!.uri.fsPath, 'knowledge-base');
            break;
            
        case 'central-project':
            if (binding?.centralProjectPath) {
                basePath = binding.centralProjectPath;
            } else {
                // 需要先创建项目
                await createCentralProjectAndBind(workspaceFolder!.uri.fsPath, projectName);
                const newBinding = getProjectBinding();
                if (!newBinding?.centralProjectPath) {
                    vscode.window.showErrorMessage(isZh() ? '创建项目失败' : 'Failed to create project');
                    return null;
                }
                basePath = newBinding.centralProjectPath;
            }
            break;
            
        case 'central-flat':
            basePath = centralPath;
            break;
            
        case 'central-domain':
            // 让用户选择领域
            const domain = await selectDomain();
            if (!domain) return null;
            basePath = path.join(centralPath, 'domains', domain);
            break;
            
        default:
            return null;
    }
    
    return {
        location: selected.value,
        basePath,
        folder,
        projectName,
        projectType: binding?.projectType,
        level: selected.level
    };
}
```

**2. 领域选择对话框**

```typescript
async function selectDomain(): Promise<string | null> {
    // 扫描现有领域
    const domainsDir = path.join(centralPath, 'domains');
    let existingDomains: string[] = [];
    
    if (fs.existsSync(domainsDir)) {
        existingDomains = fs.readdirSync(domainsDir, { withFileTypes: true })
            .filter(d => d.isDirectory())
            .map(d => d.name);
    }
    
    // 预定义领域
    const predefinedDomains = ['unity', 'kiro', 'web', 'backend', 'devops', 'ai-ml', 'tools'];
    const allDomains = [...new Set([...existingDomains, ...predefinedDomains])].sort();
    
    const items = [
        ...allDomains.map(d => ({
            label: d,
            description: existingDomains.includes(d) ? (isZh() ? '已存在' : 'exists') : (isZh() ? '新建' : 'new')
        })),
        { label: `➕ ${isZh() ? '自定义领域...' : 'Custom domain...'}`, description: '' }
    ];
    
    const selected = await vscode.window.showQuickPick(items, {
        placeHolder: isZh() ? '选择知识领域' : 'Select knowledge domain'
    });
    
    if (!selected) return null;
    
    if (selected.label.startsWith('➕')) {
        // 自定义输入
        return await vscode.window.showInputBox({
            prompt: isZh() ? '输入领域名称' : 'Enter domain name',
            placeHolder: 'e.g., unity, react, python'
        }) || null;
    }
    
    return selected.label;
}
```

## 关键代码

### 使用示例

```typescript
// 在保存知识时调用
const saveLocationResult = await showSaveLocationPicker('solutions', 'project');

if (saveLocationResult) {
    const { basePath, folder, projectName, level } = saveLocationResult;
    const targetDir = path.join(basePath, folder);
    
    // 确保目录存在
    if (!fs.existsSync(targetDir)) {
        fs.mkdirSync(targetDir, { recursive: true });
    }
    
    // 保存文件
    const filePath = path.join(targetDir, fileName);
    fs.writeFileSync(filePath, content, 'utf8');
    
    log(`Saved to ${level} level: ${filePath}`);
}
```

### 智能默认选项

```typescript
// 预选建议的位置
const defaultIndex = suggestedLevel 
    ? items.findIndex(i => i.level === suggestedLevel)
    : (binding?.defaultSaveLocation === 'central' ? 1 : 0);
```

## 注意事项

### 1. 用户体验优化

- **清晰的图标和描述**：使用 emoji 图标（📁☁️🌐📚）提升可识别性
- **智能默认选项**：根据项目绑定状态和建议层级预选选项
- **流畅的操作流程**：支持取消操作，不强制用户完成
- **及时的反馈**：创建项目失败时给出明确提示

### 2. 错误处理

```typescript
// 检查是否有可用选项
if (items.length === 0) {
    vscode.window.showErrorMessage('没有可用的保存位置');
    return null;
}

// 检查用户是否取消
if (!selected) return null;

// 检查项目创建是否成功
if (!newBinding?.centralProjectPath) {
    vscode.window.showErrorMessage('创建项目失败');
    return null;
}
```

### 3. 扩展性设计

- **类型安全**：使用 TypeScript 类型确保编译时检查
- **易于扩展**：添加新的保存位置只需在 items 数组中添加新项
- **配置化**：可以从配置文件读取默认保存位置

### 4. 性能考虑

- **延迟加载**：只在用户选择领域目录时才扫描 domains 文件夹
- **缓存优化**：可以缓存领域列表，避免重复扫描
- **异步操作**：所有文件系统操作都是异步的，不阻塞 UI

### 5. 国际化支持

```typescript
// 使用 isZh() 函数判断语言
label: `📁 ${isZh() ? '当前项目知识库' : 'Current Project KB'}`
```

## 适用场景

1. **知识管理插件**：需要多层级保存位置的知识库系统
2. **文件管理工具**：需要灵活的文件保存位置选择
3. **项目管理插件**：需要区分项目级、组级、领域级的资源管理
4. **配置管理工具**：需要在本地和远程之间选择保存位置

## 扩展建议

1. **保存位置记忆**：记住用户上次选择，下次默认选中
2. **快捷键支持**：为常用保存位置设置快捷键
3. **批量操作**：支持批量选择保存位置
4. **预览功能**：在选择前预览目标目录结构
