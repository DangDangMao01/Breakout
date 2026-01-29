---
domain: solution
tags: [vscode-extension, tfidf, semantic-search, typescript, algorithm, knowledge-management]
date: 2026-01-05
source_project: "Kiro-KB-Plugin"
value_score: 10
---

# VSCode 插件中实现 TF-IDF 语义搜索引擎

## 问题/背景

在知识库管理插件中，传统的关键词搜索只能进行简单的文件名和标题匹配，无法理解用户的搜索意图。需要实现一个智能的语义搜索引擎，能够：

1. 理解自然语言查询
2. 按相关度排序结果
3. 支持中英文混合搜索
4. 快速响应（< 1秒）

## 解决方案

### 核心技术：TF-IDF 算法

**TF (Term Frequency)** - 词频
```
TF = 词在文档中出现的次数 / 文档总词数
```

**IDF (Inverse Document Frequency)** - 逆文档频率
```
IDF = log(总文档数 / 包含该词的文档数)
```

**TF-IDF 分数**
```
TF-IDF = TF × IDF
```

**相似度计算** - 余弦相似度
```typescript
similarity = dotProduct / (norm1 * norm2)
```

### 实现架构

```
用户查询 → 分词 → TF-IDF 向量化 → 余弦相似度计算 → 排序 → 返回结果
```

## 关键代码

### 1. TF-IDF 搜索引擎类

```typescript
// classifier.ts
export class TFIDFSearchEngine {
    private documents: Map<string, DocumentIndex> = new Map();
    private idf: Map<string, number> = new Map();
    
    // 添加文档到索引
    addDocuments(docs: any[]) {
        this.documents.clear();
        
        for (const doc of docs) {
            const text = `${doc.title} ${doc.content}`;
            const terms = this.tokenize(text);
            const tf = this.calculateTF(terms);
            
            this.documents.set(doc.id, {
                id: doc.id,
                path: doc.path,
                title: doc.title,
                tf,
                terms,
                domain: doc.domain,
                tags: doc.tags
            });
        }
        
        // 计算 IDF
        this.calculateIDF();
    }
    
    // 分词（中英文混合）
    private tokenize(text: string): string[] {
        const tokens: string[] = [];
        
        // 英文分词
        const englishWords = text.toLowerCase()
            .match(/[a-z]{2,}/g) || [];
        tokens.push(...englishWords);
        
        // 中文分词（2-3字切分）
        const chineseChars = text.match(/[\u4e00-\u9fa5]/g) || [];
        for (let i = 0; i < chineseChars.length - 1; i++) {
            tokens.push(chineseChars[i] + chineseChars[i + 1]);
            if (i < chineseChars.length - 2) {
                tokens.push(chineseChars[i] + chineseChars[i + 1] + chineseChars[i + 2]);
            }
        }
        
        // 过滤停用词
        return tokens.filter(t => !this.isStopWord(t));
    }
    
    // 计算 TF
    private calculateTF(terms: string[]): Map<string, number> {
        const tf = new Map<string, number>();
        const total = terms.length;
        
        for (const term of terms) {
            tf.set(term, (tf.get(term) || 0) + 1 / total);
        }
        
        return tf;
    }
    
    // 计算 IDF
    private calculateIDF() {
        this.idf.clear();
        const docCount = this.documents.size;
        const termDocCount = new Map<string, number>();
        
        // 统计每个词出现在多少文档中
        for (const doc of this.documents.values()) {
            const uniqueTerms = new Set(doc.terms);
            for (const term of uniqueTerms) {
                termDocCount.set(term, (termDocCount.get(term) || 0) + 1);
            }
        }
        
        // 计算 IDF
        for (const [term, count] of termDocCount) {
            this.idf.set(term, Math.log(docCount / count));
        }
    }
    
    // 搜索
    search(query: string, limit: number = 10): SearchResult[] {
        const queryTerms = this.tokenize(query);
        const queryTF = this.calculateTF(queryTerms);
        
        // 计算查询向量
        const queryVector = new Map<string, number>();
        for (const [term, tf] of queryTF) {
            const idf = this.idf.get(term) || 0;
            queryVector.set(term, tf * idf);
        }
        
        // 计算每个文档的相似度
        const results: SearchResult[] = [];
        
        for (const doc of this.documents.values()) {
            const similarity = this.cosineSimilarity(queryVector, doc.tf);
            
            if (similarity > 0) {
                // 找出匹配的词
                const matchedTerms = queryTerms.filter(t => doc.terms.includes(t));
                
                results.push({
                    path: doc.path,
                    title: doc.title,
                    score: similarity,
                    domain: doc.domain,
                    tags: doc.tags,
                    matchedTerms: [...new Set(matchedTerms)]
                });
            }
        }
        
        // 按相关度排序
        results.sort((a, b) => b.score - a.score);
        return results.slice(0, limit);
    }
    
    // 余弦相似度
    private cosineSimilarity(vec1: Map<string, number>, vec2: Map<string, number>): number {
        let dotProduct = 0;
        let norm1 = 0;
        let norm2 = 0;
        
        for (const [term, value] of vec1) {
            const idf = this.idf.get(term) || 0;
            const tfidf1 = value * idf;
            const tfidf2 = (vec2.get(term) || 0) * idf;
            
            dotProduct += tfidf1 * tfidf2;
            norm1 += tfidf1 * tfidf1;
        }
        
        for (const [term, value] of vec2) {
            const idf = this.idf.get(term) || 0;
            const tfidf2 = value * idf;
            norm2 += tfidf2 * tfidf2;
        }
        
        if (norm1 === 0 || norm2 === 0) return 0;
        return dotProduct / (Math.sqrt(norm1) * Math.sqrt(norm2));
    }
}

// 导出单例
export const tfidfEngine = new TFIDFSearchEngine();
```

### 2. 集成到搜索命令

```typescript
// extension.ts
async function semanticSearchKB() {
    if (!centralPath || !fs.existsSync(centralPath)) {
        vscode.window.showErrorMessage('知识库未配置');
        return;
    }
    
    // 输入查询
    const query = await vscode.window.showInputBox({
        prompt: '输入搜索内容（支持自然语言）',
        placeHolder: '例如: Unity Shader 优化技巧'
    });
    
    if (!query || query.trim().length === 0) return;
    
    // 显示进度
    await vscode.window.withProgress({
        location: vscode.ProgressLocation.Notification,
        title: '🔍 语义搜索中...',
        cancellable: false
    }, async (progress) => {
        // 扫描文档
        const folders = ['discussions', 'solutions', 'notes'];
        const docs: any[] = [];
        
        for (const folder of folders) {
            const folderPath = path.join(centralPath, folder);
            if (!fs.existsSync(folderPath)) continue;
            
            const files = fs.readdirSync(folderPath).filter(f => f.endsWith('.md'));
            
            for (const file of files) {
                const filePath = path.join(folderPath, file);
                const content = fs.readFileSync(filePath, 'utf8');
                
                // 提取元数据
                const titleMatch = content.match(/^#\s+(.+)$/m);
                const title = titleMatch ? titleMatch[1].trim() : file.replace('.md', '');
                
                docs.push({
                    id: filePath,
                    path: filePath,
                    title,
                    content,
                    domain: extractDomain(content),
                    tags: extractTags(content)
                });
            }
        }
        
        progress.report({ increment: 30 });
        
        // 构建索引并搜索
        tfidfEngine.addDocuments(docs);
        const results = tfidfEngine.search(query, 20);
        
        progress.report({ increment: 100 });
        
        // 显示结果
        if (results.length === 0) {
            vscode.window.showInformationMessage('😔 未找到相关结果');
            return;
        }
        
        const searchItems = results.map(result => ({
            label: `${getIcon(result.domain)} ${result.title}`,
            description: `⭐ ${result.score.toFixed(3)} | ${result.tags.join(', ')}`,
            detail: `匹配词: ${result.matchedTerms.slice(0, 5).join(', ')}`,
            filePath: result.path
        }));
        
        const selection = await vscode.window.showQuickPick(searchItems, {
            placeHolder: `找到 ${results.length} 个相关结果（按相关度排序）`
        });
        
        if (selection) {
            const doc = await vscode.workspace.openTextDocument(selection.filePath);
            await vscode.window.showTextDocument(doc);
        }
    });
}
```

### 3. 搜索模式选择

```typescript
async function quickSearchKB() {
    // 先询问搜索模式
    const searchMode = await vscode.window.showQuickPick([
        {
            label: '🔍 关键词搜索',
            description: '按文件名、标题、标签搜索',
            value: 'keyword'
        },
        {
            label: '🤖 语义搜索 (TF-IDF)',
            description: '智能理解搜索意图，更精准的结果',
            value: 'semantic'
        }
    ], {
        placeHolder: '选择搜索模式'
    });
    
    if (!searchMode) return;
    
    if (searchMode.value === 'semantic') {
        await semanticSearchKB();
        return;
    }
    
    // 关键词搜索逻辑...
}
```

## 测试结果

### 测试环境
- 文档数量: 92 篇
- 查询: `VSCode 插件开发`

### 性能数据
- 扫描文件: ~150ms
- 构建索引: ~200ms
- 执行搜索: ~50ms
- **总耗时: ~400ms** ✅ (目标 < 1000ms)

### 搜索结果
1. ✅ VSCode TreeView实现三级分组展示 - **0.520**
2. ✅ VSCode插件实现多层级保存位置选择器 - **0.512**
3. 📄 VS Code / Kiro 插件开发完整指南 - **0.036**

**观察**:
- 前两个结果高度相关（0.520, 0.512）
- 算法能有效区分相关性
- 相关度评分合理

## 注意事项

### 1. 中文分词精度
- 当前使用简单的 2-3 字切分
- 对于专业术语可能不够精确
- **改进方案**: 集成 jieba 分词库

### 2. 停用词列表
```typescript
const STOP_WORDS = new Set([
    // 中文
    '的', '了', '是', '在', '我', '有', '和', '就', '不', '人',
    '都', '一', '一个', '上', '也', '很', '到', '说', '要', '去',
    // 英文
    'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to',
    'for', 'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are'
]);
```

### 3. 性能优化
- **增量索引**: 只索引新增/修改的文档
- **持久化**: 将索引保存到磁盘，避免重复构建
- **缓存**: 缓存常用查询结果

### 4. 大型知识库
- 超过 500 篇文档时，首次索引较慢
- 建议使用 Web Worker 或后台任务
- 考虑分批索引

### 5. 搜索优化
- 查询长度建议 5-50 字符
- 避免过多停用词
- 使用具体的技术术语

## 适用场景

### ✅ 适合
- 知识库搜索
- 文档检索
- 内容推荐
- 相似文档查找

### ❌ 不适合
- 实时搜索（需要预先索引）
- 超大规模文档（> 10000 篇）
- 需要精确匹配的场景

## 扩展方向

### 短期优化
1. 集成 jieba 中文分词
2. 持久化索引到磁盘
3. 增量更新索引
4. 搜索历史记录

### 长期规划
1. 向量搜索（Embedding）
2. AI 辅助查询优化
3. 多模态搜索（图片、代码）
4. 个性化排序

## 参考资料

- [TF-IDF 算法详解](https://en.wikipedia.org/wiki/Tf%E2%80%93idf)
- [余弦相似度](https://en.wikipedia.org/wiki/Cosine_similarity)
- [VSCode Extension API](https://code.visualstudio.com/api)
- [中文分词 jieba](https://github.com/fxsjy/jieba)

---

**版本**: v2.46.0  
**实现时间**: 2026-01-05  
**测试状态**: ✅ 基础功能测试通过

