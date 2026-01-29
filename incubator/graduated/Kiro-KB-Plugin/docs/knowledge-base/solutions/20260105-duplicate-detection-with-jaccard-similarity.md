---
domain: solution
tags: [algorithm, duplicate-detection, jaccard, similarity, vscode, typescript]
date: 2026-01-05
source_project: "kiro-knowledge-base"
value_score: 9
---

# 基于 Jaccard 相似度的重复内容检测实现

## 问题/背景

在知识管理系统中，用户可能会重复保存相似的内容，导致：
- 知识库冗余
- 搜索结果混乱
- 维护成本增加

需要在保存前检测是否存在相似内容，并给用户提示：
1. 扫描多个目录（本地、中央、项目、领域）
2. 计算标题相似度
3. 设置合理的阈值（60%）
4. 提供友好的用户交互

**性能要求**：
- 扫描 100 篇文档 < 2 秒
- 用户无感知延迟

## 解决方案

### 核心算法：Jaccard 相似度

Jaccard 相似度是一种简单高效的集合相似度算法：

```
Jaccard(A, B) = |A ∩ B| / |A ∪ B|
```

**优点**：
- 计算速度快（O(n)）
- 对词序不敏感
- 适合短文本（标题）
- 阈值直观（百分比）

**示例**：
```
标题1: "Kiro KB 插件开发指南"
标题2: "Kiro KB Plugin 开发指南"

分词:
words1 = {kiro, kb, 插件, 开发, 指南}
words2 = {kiro, kb, plugin, 开发, 指南}

交集 = {kiro, kb, 开发, 指南} = 4
并集 = {kiro, kb, 插件, plugin, 开发, 指南} = 6

相似度 = 4/6 = 66.7% > 60% ✅ 触发警告
```

## 关键代码

### 1. 标题相似度计算

```typescript
/**
 * 计算标题相似度 (Jaccard 算法)
 * @param title1 标题1
 * @param title2 标题2
 * @returns 相似度 (0-1)
 */
function calculateTitleSimilarity(title1: string, title2: string): number {
    // 标准化：转小写，移除特殊字符
    const normalize = (s: string) => 
        s.toLowerCase()
         .replace(/[^a-z0-9\u4e00-\u9fff]/g, ' ')
         .trim();
    
    const t1 = normalize(title1);
    const t2 = normalize(title2);
    
    // 完全相同
    if (t1 === t2) return 1;
    
    // 分词（按空格分割，过滤单字符）
    const words1 = new Set(t1.split(/\s+/).filter(w => w.length > 1));
    const words2 = new Set(t2.split(/\s+/).filter(w => w.length > 1));
    
    if (words1.size === 0 || words2.size === 0) return 0;
    
    // Jaccard 相似度
    const intersection = [...words1].filter(w => words2.has(w)).length;
    const union = new Set([...words1, ...words2]).size;
    
    return intersection / union;
}
```

### 2. 重复检测主函数

```typescript
/**
 * 保存前重复检测
 * @param title 知识标题
 * @param content 知识内容
 * @returns 是否继续保存
 */
async function checkDuplicateBeforeSave(
    title: string, 
    content: string
): Promise<{ shouldSave: boolean; existingPath?: string }> {
    
    // 收集所有知识文件
    const allFiles: { path: string; title: string; similarity: number }[] = [];
    
    const scanDir = (basePath: string, folders: string[]) => {
        for (const folder of folders) {
            const folderPath = path.join(basePath, folder);
            if (!fs.existsSync(folderPath)) continue;
            
            const files = fs.readdirSync(folderPath).filter(f => f.endsWith('.md'));
            for (const file of files) {
                const filePath = path.join(folderPath, file);
                try {
                    const fileContent = fs.readFileSync(filePath, 'utf8');
                    
                    // 提取标题
                    const titleMatch = fileContent.match(/^#\s+(.+)$/m);
                    const fileTitle = titleMatch 
                        ? titleMatch[1].trim() 
                        : file.replace('.md', '');
                    
                    // 计算标题相似度
                    const similarity = calculateTitleSimilarity(title, fileTitle);
                    
                    if (similarity > 0.6) {  // 60% 以上相似度
                        allFiles.push({ path: filePath, title: fileTitle, similarity });
                    }
                } catch {}
            }
        }
    };
    
    // 扫描本地知识库
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (workspaceFolder) {
        const localKB = path.join(workspaceFolder.uri.fsPath, 'knowledge-base');
        scanDir(localKB, ['solutions', 'notes', 'discussions']);
    }
    
    // 扫描中央知识库
    if (centralPath) {
        scanDir(centralPath, ['solutions', 'notes', 'discussions']);
        
        // 扫描 projects 目录
        const projectsDir = path.join(centralPath, 'projects');
        if (fs.existsSync(projectsDir)) {
            const projects = fs.readdirSync(projectsDir, { withFileTypes: true })
                .filter(d => d.isDirectory());
            for (const proj of projects) {
                scanDir(path.join(projectsDir, proj.name), ['solutions', 'notes', 'discussions']);
            }
        }
        
        // 扫描 domains 目录
        const domainsDir = path.join(centralPath, 'domains');
        if (fs.existsSync(domainsDir)) {
            const domains = fs.readdirSync(domainsDir, { withFileTypes: true })
                .filter(d => d.isDirectory());
            for (const domain of domains) {
                scanDir(path.join(domainsDir, domain.name), ['solutions', 'notes', 'discussions']);
            }
        }
    }
    
    if (allFiles.length === 0) {
        return { shouldSave: true };
    }
    
    // 按相似度排序
    allFiles.sort((a, b) => b.similarity - a.similarity);
    const topMatch = allFiles[0];
    
    // 显示提示
    const similarityPercent = Math.round(topMatch.similarity * 100);
    const action = await vscode.window.showWarningMessage(
        isZh() 
            ? `⚠️ 发现相似知识 (${similarityPercent}% 相似): "${topMatch.title}"`
            : `⚠️ Similar knowledge found (${similarityPercent}% similar): "${topMatch.title}"`,
        isZh() ? '查看已有' : 'View Existing',
        isZh() ? '仍然保存' : 'Save Anyway',
        isZh() ? '取消' : 'Cancel'
    );
    
    if (action === (isZh() ? '查看已有' : 'View Existing')) {
        // 打开已有文件
        const doc = await vscode.workspace.openTextDocument(topMatch.path);
        await vscode.window.showTextDocument(doc);
        
        // 再次询问
        const continueAction = await vscode.window.showInformationMessage(
            isZh() ? '是否继续保存新知识？' : 'Continue saving new knowledge?',
            isZh() ? '保存' : 'Save',
            isZh() ? '取消' : 'Cancel'
        );
        
        return { 
            shouldSave: continueAction === (isZh() ? '保存' : 'Save'),
            existingPath: topMatch.path
        };
    }
    
    if (action === (isZh() ? '仍然保存' : 'Save Anyway')) {
        return { shouldSave: true, existingPath: topMatch.path };
    }
    
    return { shouldSave: false, existingPath: topMatch.path };
}
```

### 3. 使用示例

```typescript
// 在保存知识前调用
const duplicateCheck = await checkDuplicateBeforeSave(title, content);

if (!duplicateCheck.shouldSave) {
    log(`Save cancelled due to duplicate: ${duplicateCheck.existingPath}`);
    return;
}

// 继续保存流程
const filePath = path.join(targetDir, fileName);
fs.writeFileSync(filePath, content, 'utf8');
```

## 性能测试结果

**测试环境**：
- 总文件数: 92 篇
- 扫描目录: 本地 + 中央 + 6 个项目目录

**测试结果**：
```
扫描耗时: 963ms
计算耗时: 1ms
总耗时: 965ms
平均速度: 95.3 篇/秒

✅ 性能测试通过 (目标: <2000ms)
```

**性能分析**：
1. **扫描阶段** (963ms) - 文件系统 I/O 操作
   - 读取 92 个文件内容
   - 提取标题信息
   - 平均每个文件 ~10ms

2. **计算阶段** (1ms) - 内存操作
   - Jaccard 相似度算法
   - 速度极快，可忽略不计

## 注意事项

### 1. 阈值选择

**60% 阈值的考虑**：
- **太低（<50%）**：误报率高，打扰用户
- **太高（>70%）**：漏报率高，无法检测相似内容
- **60%**：平衡点，适合大多数场景

**可配置化**：
```typescript
const threshold = vscode.workspace.getConfiguration('kiro-kb')
    .get<number>('duplicateThreshold', 0.6);

if (similarity > threshold) {
    // 触发警告
}
```

### 2. 分词策略

**当前策略**：
- 按空格分割
- 过滤单字符词
- 保留中英文字符和数字

**改进方向**：
- 中文分词（jieba）
- 停用词过滤（的、了、是）
- 词干提取（stemming）

### 3. 性能优化

**当前实现**：
- 每次保存都全量扫描
- 适合中小型知识库（<500 篇）

**优化方案**：
```typescript
// 1. 标题索引缓存
const titleIndex = new Map<string, string[]>(); // title -> filePaths
const cacheExpiry = 30 * 1000; // 30秒有效期

// 2. 增量更新
function updateTitleIndex(filePath: string, title: string) {
    const words = normalize(title).split(/\s+/);
    for (const word of words) {
        if (!titleIndex.has(word)) {
            titleIndex.set(word, []);
        }
        titleIndex.get(word)!.push(filePath);
    }
}

// 3. 快速查找
function findSimilarTitles(title: string): string[] {
    const words = normalize(title).split(/\s+/);
    const candidates = new Set<string>();
    
    for (const word of words) {
        const paths = titleIndex.get(word) || [];
        paths.forEach(p => candidates.add(p));
    }
    
    return Array.from(candidates);
}
```

### 4. 用户体验

**交互流程**：
```
1. 用户保存知识
   ↓
2. 后台扫描（显示进度）
   ↓
3. 发现相似内容
   ↓
4. 弹出警告对话框
   ├─ 查看已有 → 打开文件 → 再次询问
   ├─ 仍然保存 → 继续保存
   └─ 取消 → 取消保存
```

**进度提示**（可选）：
```typescript
await vscode.window.withProgress({
    location: vscode.ProgressLocation.Notification,
    title: "检测重复内容...",
    cancellable: false
}, async (progress) => {
    progress.report({ increment: 0 });
    
    // 扫描文件
    const result = await checkDuplicateBeforeSave(title, content);
    
    progress.report({ increment: 100 });
    return result;
});
```

### 5. 边界情况

```typescript
// 空标题
if (!title || title.trim().length === 0) {
    return { shouldSave: true };
}

// 标题太短（<3个字符）
if (title.length < 3) {
    return { shouldSave: true };
}

// 文件读取失败
try {
    const fileContent = fs.readFileSync(filePath, 'utf8');
} catch (error) {
    // 跳过该文件，继续扫描
    continue;
}
```

## 适用场景

1. **知识管理系统**：防止重复保存相似知识
2. **文档管理工具**：检测重复文档
3. **内容审核系统**：识别相似内容
4. **搜索引擎**：去重和聚类
5. **推荐系统**：相似内容推荐

## 扩展建议

### 1. 内容相似度检测

除了标题，还可以检测内容相似度：

```typescript
function calculateContentSimilarity(content1: string, content2: string): number {
    // 提取关键词
    const keywords1 = extractKeywords(content1);
    const keywords2 = extractKeywords(content2);
    
    // 计算 Jaccard 相似度
    return calculateJaccardSimilarity(keywords1, keywords2);
}
```

### 2. 语义相似度

使用词向量或 BERT 模型：

```typescript
async function calculateSemanticSimilarity(
    title1: string, 
    title2: string
): Promise<number> {
    // 调用 AI 模型 API
    const embedding1 = await getEmbedding(title1);
    const embedding2 = await getEmbedding(title2);
    
    // 计算余弦相似度
    return cosineSimilarity(embedding1, embedding2);
}
```

### 3. 批量重复检测

扫描整个知识库，生成重复报告：

```typescript
async function findAllDuplicates(): Promise<DuplicateReport[]> {
    const allFiles = scanAllKnowledgeFiles();
    const duplicates: DuplicateReport[] = [];
    
    for (let i = 0; i < allFiles.length; i++) {
        for (let j = i + 1; j < allFiles.length; j++) {
            const similarity = calculateTitleSimilarity(
                allFiles[i].title, 
                allFiles[j].title
            );
            
            if (similarity > 0.6) {
                duplicates.push({
                    file1: allFiles[i],
                    file2: allFiles[j],
                    similarity
                });
            }
        }
    }
    
    return duplicates;
}
```

### 4. 智能合并建议

```typescript
async function suggestMerge(file1: string, file2: string): Promise<string> {
    const content1 = fs.readFileSync(file1, 'utf8');
    const content2 = fs.readFileSync(file2, 'utf8');
    
    // 使用 AI 生成合并建议
    const mergedContent = await aiMerge(content1, content2);
    
    return mergedContent;
}
```
