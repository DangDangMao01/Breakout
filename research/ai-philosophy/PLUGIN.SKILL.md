---
name: "kiro-knowledge-base"
version: "3.0.0"
description: "AI 个人记忆系统 - 让 AI 越用越懂你"
author: "DangDangMao"
type: "vscode-extension"
---

# Kiro Knowledge Base - Plugin Skill

## 核心理念

这个插件本身就是一个 Skill，它教会 AI 如何管理你的知识。

## 能力清单（Capabilities）

### 1. 保存对话（save-conversation）

**触发时机**：
- 对话结束后
- 用户手动保存
- 检测到有价值内容

**决策逻辑**：
```
判断可行性：
- 对话是否完整？
- 是否有实质内容？
- 是否值得保存？

判断分类：
- 包含解决方案 → solutions/
- 包含代码片段 → notes/
- 包含讨论记录 → discussions/
- 包含经验教训 → experiences/

判断优化：
- 是否与已有内容重复？
- 是否可以合并？
- 是否需要更新旧内容？
```

**执行步骤**：
1. 分析对话内容
2. 提取关键信息
3. 确定分类
4. 生成文件名（日期-主题）
5. 保存到对应目录
6. 更新索引

**示例**：
```markdown
输入：关于 Cocos2D 金币飞行动画的对话
输出：solutions/20260128-Cocos2D金币飞行动画开发.md
```

---

### 2. 生成 Skills（generate-skill）

**触发时机**：
- 检测到重复模式（频率 > 3）
- 用户手动触发
- 定期自动分析

**决策逻辑**：
```
判断可行性：
- 是否有足够的案例？（至少 3 个）
- 案例是否相似？（相似度 > 70%）
- 是否可以标准化？

判断更新性：
- 已有 Skill 是否过时？
- 新案例是否有新方法？
- 是否需要更新 Skill？

判断优化性：
- 新 Skill 是否更简洁？
- 是否覆盖更多场景？
- 是否更易理解？
```

**执行步骤**：
1. 扫描 knowledge-base
2. 聚类相似内容
3. 提取共同模式
4. 生成 SKILL.md
5. 保存到 .trae/skills/
6. 通知用户

**示例**：
```markdown
输入：3 个关于"调试 Cocos 脚本"的 solutions
输出：.trae/skills/cocos-debugger/SKILL.md
```

---

### 3. 智能检索（smart-search）

**触发时机**：
- 用户提问时
- Kiro 需要上下文时
- 自动推荐时

**决策逻辑**：
```
判断相关性：
- 语义相似度
- 关键词匹配
- 时间相关性

判断优先级：
- 最近的优先
- 成功的优先
- 完整的优先

判断数量：
- 简单问题：1-2 个
- 复杂问题：3-5 个
- 避免过载
```

**执行步骤**：
1. 分析查询意图
2. 计算语义相似度
3. 排序结果
4. 返回 Top-N
5. 格式化输出

---

### 4. 自动优化（auto-optimize）

**触发时机**：
- 每周自动运行
- 用户手动触发
- 检测到问题时

**决策逻辑**：
```
判断需要优化的内容：
- 重复内容 → 合并
- 过时内容 → 更新或删除
- 碎片内容 → 整理
- 缺失索引 → 重建

判断优化方式：
- 合并：相似度 > 80%
- 更新：时间 > 3 个月
- 删除：无价值内容
- 重组：结构混乱
```

**执行步骤**：
1. 扫描所有文件
2. 检测问题
3. 生成优化方案
4. 征求用户确认
5. 执行优化
6. 生成报告

---

## 决策规则（Decision Rules）

### 可行性判断

```yaml
feasibility_check:
  content_quality:
    - has_substantial_content: true
    - is_complete: true
    - is_coherent: true
  
  technical_feasibility:
    - can_extract_key_info: true
    - can_categorize: true
    - can_save: true
  
  value_assessment:
    - is_useful: true
    - is_reusable: true
    - is_unique: true
```

### 更新性判断

```yaml
update_check:
  time_based:
    - age_threshold: 3_months
    - check_for_newer_solutions: true
  
  content_based:
    - has_better_approach: check
    - technology_updated: check
    - best_practices_changed: check
  
  action:
    - if_outdated: mark_for_update
    - if_superseded: archive_or_merge
```

### 优化性判断

```yaml
optimization_check:
  code_quality:
    - is_simpler: compare
    - is_faster: benchmark
    - is_more_maintainable: analyze
  
  content_quality:
    - is_clearer: readability_score
    - is_more_complete: coverage_check
    - is_better_organized: structure_analysis
  
  action:
    - if_better: suggest_replacement
    - if_complementary: suggest_merge
    - if_worse: keep_current
```

---

## 记忆结构（Memory Structure）

### 短期记忆（Working Memory）
```
当前对话上下文
- 最近 10 条消息
- 当前任务状态
- 临时变量
```

### 长期记忆（Long-term Memory）
```
knowledge-base/
├── solutions/     # 解决方案
├── notes/         # 笔记片段
├── discussions/   # 讨论记录
├── experiences/   # 经验教训（新增）
└── patterns/      # 模式库（新增）

.trae/skills/      # 生成的 Skills
├── coding-expert/
├── debugger/
└── architect/

INDEX.md           # 知识图谱
```

---

## 学习机制（Learning Mechanism）

### 1. 经验积累
```
每次对话 → 提取经验 → 保存到 experiences/
```

### 2. 模式识别
```
定期分析 → 检测重复 → 提炼模式 → 保存到 patterns/
```

### 3. Skills 生成
```
模式成熟 → 标准化 → 生成 SKILL.md → 保存到 .trae/skills/
```

### 4. 自我优化
```
使用反馈 → 评估效果 → 调整策略 → 更新决策规则
```

---

## 接入 AI 的方式

### 方式 1: 本地 AI（推荐）

```typescript
// 使用 Kiro 自己的 AI
async function analyzeContent(content: string) {
  const analysis = await kiro.analyze({
    prompt: `根据 PLUGIN.SKILL.md 的规则，分析这段内容：
    
    ${content}
    
    判断：
    1. 可行性（能否保存）
    2. 分类（应该保存到哪里）
    3. 优化（是否需要合并/更新）
    `,
    context: readFile('PLUGIN.SKILL.md')
  });
  
  return analysis;
}
```

**优势**：
- ✅ 无需额外配置
- ✅ 深度集成
- ✅ 理解上下文

### 方式 2: 外部 AI（可选）

```typescript
// 接入其他 AI 服务
async function analyzeWithExternalAI(content: string) {
  // 可以接入：
  // - OpenAI API
  // - Claude API
  // - 本地 LLM（Ollama）
  
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'gpt-4',
      messages: [
        {
          role: 'system',
          content: readFile('PLUGIN.SKILL.md')
        },
        {
          role: 'user',
          content: `分析这段内容：${content}`
        }
      ]
    })
  });
  
  return response.json();
}
```

**优势**：
- ✅ 更强大的 AI
- ✅ 灵活选择
- ❌ 需要配置

---

## 避免臃肿的策略

### 1. 最小核心原则

```
核心代码 < 500 行
├── file-operations.ts    (100 行)
├── ai-interface.ts       (100 行)
├── decision-engine.ts    (150 行)
└── utils.ts              (150 行)
```

**所有复杂逻辑都在 PLUGIN.SKILL.md 中！**

### 2. 声明式编程

```typescript
// ❌ 不要这样（命令式）
function saveConversation(content) {
  if (content.includes('解决方案')) {
    const filename = generateFilename(content);
    const path = 'solutions/' + filename;
    fs.writeFile(path, content);
  } else if (content.includes('笔记')) {
    // ... 更多 if-else
  }
}

// ✅ 应该这样（声明式）
async function saveConversation(content) {
  // 让 AI 决策
  const decision = await ai.decide({
    content: content,
    rules: PLUGIN_SKILL.capabilities['save-conversation']
  });
  
  // 执行决策
  await execute(decision);
}
```

### 3. 插件化架构

```
核心插件（最小）
    ↓
加载 PLUGIN.SKILL.md
    ↓
AI 理解并执行
    ↓
需要新功能？
    ↓
更新 PLUGIN.SKILL.md（不改代码！）
```

---

## 使用示例

### 示例 1: 保存对话

```typescript
// 用户：保存这次对话
await plugin.saveConversation({
  content: currentConversation,
  // AI 自动决策：
  // 1. 判断可行性 ✅
  // 2. 分类：solutions
  // 3. 优化：检查重复
  // 4. 保存
});

// 结果：
// ✅ 保存到 solutions/20260128-xxx.md
// ✅ 更新 INDEX.md
// ✅ 通知用户
```

### 示例 2: 生成 Skill

```typescript
// 系统：检测到重复模式
await plugin.generateSkill({
  pattern: 'cocos-debugging',
  examples: [
    'solutions/20260120-xxx.md',
    'solutions/20260125-xxx.md',
    'solutions/20260128-xxx.md'
  ],
  // AI 自动决策：
  // 1. 判断可行性 ✅（3 个案例）
  // 2. 提炼共同点
  // 3. 生成 SKILL.md
});

// 结果：
// ✅ 生成 .trae/skills/cocos-debugger/SKILL.md
// ✅ 通知用户
```

### 示例 3: 智能检索

```typescript
// 用户：如何调试 Cocos 脚本？
const results = await plugin.smartSearch({
  query: '如何调试 Cocos 脚本',
  // AI 自动决策：
  // 1. 分析意图
  // 2. 检索相关内容
  // 3. 排序
  // 4. 返回 Top-3
});

// 结果：
// ✅ 返回 3 个最相关的 solutions
// ✅ 推荐 cocos-debugger Skill
```

---

## 总结

### 核心思想

```
插件 = PLUGIN.SKILL.md + 最小核心代码 + AI 决策引擎
```

### 优势

1. **AI 可理解**
   - 插件自己描述自己
   - AI 读取并执行

2. **易于扩展**
   - 新功能 = 更新 SKILL.md
   - 不改代码

3. **自我优化**
   - AI 持续学习
   - 决策规则进化

4. **避免臃肿**
   - 核心代码最小化
   - 逻辑在 SKILL.md

5. **人机协作**
   - 人定义规则
   - AI 执行决策

---

**版本**: v3.0.0  
**创建时间**: 2026-01-28  
**最后更新**: 2026-01-28
