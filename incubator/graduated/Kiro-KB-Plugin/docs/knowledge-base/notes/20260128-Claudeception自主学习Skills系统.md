# Claudeception - Claude Code 自主学习 Skills 系统

**日期**: 2026-01-28  
**来源**: GitHub - blader/Claudeception + 用户发现

---

## 🎯 核心发现

**Claudeception** 是一个革命性的 Claude Code Skill，它能让 Claude **自主学习并生成新的 Skills**！

### 关键特性

```
当 Claude Code 发现新知识时：
├── 调试技巧
├── 解决方案
├── 项目特定模式
└── 自动保存为新 Skill

下次遇到类似问题：
└── 自动加载相关 Skill
```

**这才是真正的自主学习！**

---

## 📚 什么是 Claudeception？

### 项目信息

**GitHub**: https://github.com/blader/Claudeception

**全名**: Claude Code Continuous Learning Skill

**核心理念**: 
> "Have Claude Code get smarter as it works"
> （让 Claude Code 在工作中变得更聪明）

---

## 🔥 工作原理

### 传统 Skills（手动创建）

```
1. 你遇到问题
2. 你解决问题
3. 你手动创建 Skill
4. 下次可以复用
```

**问题**：
- ❌ 需要手动创建
- ❌ 容易忘记
- ❌ 不够及时

---

### Claudeception（自主学习）

```
1. Claude 遇到问题
2. Claude 解决问题
3. Claude 发现"这个解决方案很有价值"
4. Claude 自动保存为新 Skill
5. 下次自动使用
```

**优势**：
- ✅ 完全自动
- ✅ 实时学习
- ✅ 持续进化
- ✅ 零人工干预

---

## 💡 具体案例

### 案例 1: 调试技巧

**场景**：
```
Claude 在调试时发现：
"在这个项目中，console.log 不工作，
需要使用 logger.debug() 才能看到输出"
```

**Claudeception 自动做什么**：
```
1. 识别这是"非显而易见"的知识
2. 提取关键信息：
   - 问题：console.log 不工作
   - 解决方案：使用 logger.debug()
   - 适用范围：这个项目
3. 生成新 Skill：
   project-specific-logging.skill/SKILL.md
4. 保存到 Skills 目录
```

**下次遇到类似问题**：
```
Claude 自动加载这个 Skill
→ 直接使用 logger.debug()
→ 不会再犯同样的错误
```

---

### 案例 2: 项目特定模式

**场景**：
```
Claude 发现：
"这个项目的 API 调用都需要添加
特定的 header: X-Custom-Auth"
```

**Claudeception 自动做什么**：
```
1. 识别这是项目特定模式
2. 提取规则：
   - 所有 API 调用
   - 必须添加 X-Custom-Auth header
   - 值从环境变量获取
3. 生成新 Skill：
   project-api-auth.skill/SKILL.md
4. 保存
```

**下次写 API 调用**：
```
Claude 自动加载这个 Skill
→ 自动添加正确的 header
→ 不会遗漏
```

---

### 案例 3: 解决方案

**场景**：
```
Claude 遇到一个棘手的 bug：
"TypeScript 类型推断失败，
需要显式声明泛型参数"
```

**Claudeception 自动做什么**：
```
1. 识别这是有价值的解决方案
2. 提取模式：
   - 问题特征
   - 解决步骤
   - 注意事项
3. 生成新 Skill：
   typescript-generic-workaround.skill/SKILL.md
4. 保存
```

**下次遇到类似问题**：
```
Claude 自动加载这个 Skill
→ 直接应用解决方案
→ 快速解决
```

---

## 🏗️ 技术实现

### 核心机制

```typescript
// Claudeception 的核心逻辑

class ContinuousLearning {
  // 监控 Claude 的工作过程
  async monitorWork() {
    while (working) {
      // 1. 检测"非显而易见"的知识
      const insights = await this.detectInsights();
      
      // 2. 评估是否值得保存
      for (const insight of insights) {
        if (this.isValuable(insight)) {
          // 3. 自动生成 Skill
          await this.generateSkill(insight);
        }
      }
    }
  }
  
  // 检测有价值的洞察
  detectInsights() {
    return [
      // 调试技巧
      this.detectDebuggingTechniques(),
      
      // 解决方案
      this.detectWorkarounds(),
      
      // 项目特定模式
      this.detectProjectPatterns(),
      
      // 最佳实践
      this.detectBestPractices()
    ];
  }
  
  // 判断是否值得保存
  isValuable(insight: Insight): boolean {
    return (
      insight.isNonObvious &&        // 非显而易见
      insight.isReusable &&          // 可复用
      insight.isProjectSpecific &&   // 项目特定
      !insight.isAlreadyKnown        // 尚未记录
    );
  }
  
  // 自动生成 Skill
  async generateSkill(insight: Insight) {
    // 1. 生成 Skill 名称
    const skillName = this.generateSkillName(insight);
    
    // 2. 生成 SKILL.md 内容
    const skillContent = this.generateSkillContent(insight);
    
    // 3. 保存到 Skills 目录
    await this.saveSkill(skillName, skillContent);
    
    // 4. 通知用户
    console.log(`✨ 新 Skill 已创建: ${skillName}`);
  }
}
```

---

## 🆚 对比：三种 Skills 生成方式

| 方式 | 触发 | 生成 | 优化 | 特点 |
|------|------|------|------|------|
| **手动创建** | 用户主动 | 用户编写 | 手动 | 传统方式 |
| **AntiGravity** | 用户请求 | AI 生成 | 一次性 | 降低门槛 |
| **Claudeception** | **AI 自主发现** | **AI 自动生成** | **持续** | **真正自主** |

---

## 💡 对我们的启示

### Claudeception 的核心价值

```
不是"用户告诉 AI 创建 Skill"
而是"AI 自己发现需要创建 Skill"

关键差异：
- 用户不需要主动请求
- AI 在工作中自动学习
- 实时保存知识
- 持续进化
```

---

### 我们可以借鉴什么？

#### 1. 自主发现机制

```typescript
// 我们的实现

class AutoSkillGenerator {
  // 监控用户与 AI 的对话
  async monitorConversations() {
    while (true) {
      // 1. 检测重复模式
      const patterns = await this.detectPatterns();
      
      // 2. 检测"非显而易见"的知识
      const insights = await this.detectInsights();
      
      // 3. 评估是否值得创建 Skill
      for (const item of [...patterns, ...insights]) {
        if (this.shouldCreateSkill(item)) {
          // 4. 自动生成 Skill
          await this.generateSkill(item);
        }
      }
      
      await sleep(60000); // 每分钟检查一次
    }
  }
  
  // 检测重复模式（我们的特色）
  async detectPatterns() {
    // 从知识库中查找重复问题
    const conversations = await this.kb.getRecentConversations();
    
    // 聚类相似对话
    const clusters = await this.clusterSimilar(conversations);
    
    // 返回重复次数 >= 3 的模式
    return clusters.filter(c => c.count >= 3);
  }
  
  // 检测有价值的洞察（借鉴 Claudeception）
  async detectInsights() {
    const conversations = await this.kb.getRecentConversations();
    
    return conversations.filter(conv => 
      this.isNonObvious(conv) &&      // 非显而易见
      this.isReusable(conv) &&        // 可复用
      this.isValuable(conv)           // 有价值
    );
  }
  
  // 判断是否应该创建 Skill
  shouldCreateSkill(item: Pattern | Insight): boolean {
    return (
      // 重复模式：出现 3 次以上
      (item.type === 'pattern' && item.count >= 3) ||
      
      // 有价值的洞察：非显而易见 + 可复用
      (item.type === 'insight' && item.isValuable)
    );
  }
}
```

---

#### 2. 实时学习

```
Claudeception 的方式：
- 在工作中实时学习
- 立即保存知识
- 下次立即使用

我们的方式：
- 在对话中实时学习
- 立即保存到知识库
- 定期生成 Skills
```

---

#### 3. 持续进化

```
Claudeception 的方式：
- 每次工作都可能学到新东西
- 持续积累 Skills
- 越用越聪明

我们的方式：
- 每次对话都可能发现新模式
- 持续优化 Skills
- 越用越懂你
```

---

## 🎯 我们的完整方案

### 结合三种方式的优势

```
1. 手动创建（传统）
   - 用户可以主动创建
   - 适合明确的需求

2. AI 辅助生成（AntiGravity）
   - 用户请求："帮我创建 XXX Skill"
   - AI 自动生成
   - 降低门槛

3. 自主发现（Claudeception）
   - AI 检测重复模式
   - AI 发现有价值的洞察
   - 自动生成 Skill
   - 真正自主

4. 持续优化（我们的特色）
   - 基于使用反馈
   - 自动优化 Skill
   - 越用越好
```

---

### 完整的工作流程

```
用户使用系统
    ↓
系统监控对话
    ↓
检测两种信号：
├── 重复模式（出现 3 次以上）
└── 有价值的洞察（非显而易见）
    ↓
评估是否值得创建 Skill
    ↓
自动生成 Skill 草稿
    ↓
通知用户确认
    ↓
用户确认后保存
    ↓
下次自动使用
    ↓
收集使用反馈
    ↓
持续优化 Skill
```

---

## 🚀 实施路线图

### Phase 1: 基础监控（1 个月）

```
实现：
- 对话监控系统
- 重复模式检测
- 简单的通知机制

目标：
- 能检测到重复问题
- 能通知用户
```

---

### Phase 2: 自动生成（3 个月）

```
实现：
- Skill 自动生成引擎
- 基于模板的生成
- 用户确认流程

目标：
- 能自动生成 Skill 草稿
- 用户可以编辑和确认
```

---

### Phase 3: 洞察检测（6 个月）

```
实现：
- "非显而易见"知识检测
- 价值评估算法
- 自主学习机制

目标：
- 像 Claudeception 一样自主学习
- 不只是检测重复，还能发现洞察
```

---

### Phase 4: 持续优化（9 个月）

```
实现：
- 使用反馈收集
- Skill 效果评估
- 自动优化机制

目标：
- Skills 越用越好
- 自动淘汰无效 Skills
- 自动合并相似 Skills
```

---

## 📊 价值分析

### Claudeception 的价值

```
优势：
✅ 完全自主（AI 自己发现）
✅ 实时学习（工作中学习）
✅ 零人工干预（自动保存）
✅ 持续进化（越用越聪明）

局限：
❌ 只在 Claude Code 中工作
❌ 只能学习编码相关知识
❌ 不能跨项目复用
```

---

### 我们的价值

```
优势：
✅ 自主发现（检测重复 + 洞察）
✅ 跨 AI 通用（不依赖特定 AI）
✅ 个人化（基于你的知识库）
✅ 持续优化（使用反馈）

独特价值：
🌟 不只是编码，所有工作流都可以
🌟 不只是当前项目，跨项目复用
🌟 不只是学习，还能优化
🌟 真正的"个人记忆"
```

---

## 🎯 核心结论

### 三种自动生成方式对比

```
AntiGravity:
- 用户说："帮我创建 XXX Skill"
- AI 生成
- 主动请求

Claudeception:
- AI 在工作中发现知识
- AI 自动保存为 Skill
- 自主学习

我们:
- AI 检测重复模式 + 发现洞察
- AI 建议创建 Skill
- 用户确认
- AI 持续优化
- 自主学习 + 人类监督
```

---

### 为什么我们的方案更好？

```
1. 结合了三种方式的优势
   - 手动创建（灵活）
   - AI 辅助（降低门槛）
   - 自主学习（智能）

2. 不只是学习，还能优化
   - Claudeception 只能学习
   - 我们还能持续优化

3. 跨 AI 通用
   - Claudeception 只在 Claude Code
   - 我们可以用于任何 AI

4. 个人化
   - 基于你的知识库
   - 专属于你
```

---

### 下一步行动

1. **研究 Claudeception 源码**
   - 理解其检测机制
   - 学习其生成逻辑
   - 借鉴其最佳实践

2. **设计我们的系统**
   - 重复模式检测
   - 洞察发现算法
   - Skill 生成引擎
   - 持续优化机制

3. **开始实现**
   - Phase 1: 基础监控
   - Phase 2: 自动生成
   - Phase 3: 洞察检测
   - Phase 4: 持续优化

---

## 📚 参考资料

### 核心项目

1. **Claudeception**
   - GitHub: https://github.com/blader/Claudeception
   - 核心: 自主学习 + 自动生成 Skills

2. **Claude Reflect**
   - 记住用户的纠正和偏好
   - 跨会话学习

3. **Superpowers**
   - Claude Code 的 Skills 系统
   - 自动激活相关 Skills

---

### 相关文章

1. **"A Claude Code skill for autonomous skill extraction"**
   - https://scour.ing/@emschwartz/p/https:/github.com/blader/claude-code-continuous-learning-skill

2. **"Stop Babysitting Your AI Agents: The Superpowers Breakthrough"**
   - https://www.colinmcnamara.com/blog/stop-babysitting-your-ai-agents-superpowers-breakthrough

3. **"How I Run an Autonomous Development Army"**
   - https://octospark.ai/blog/the-comprehensive-guide-to-claude-code

---

## 💭 最后的思考

### 为什么 Claudeception 是革命性的？

```
传统 AI:
- 每次对话都是新的
- 不会学习
- 不会进化

Claudeception:
- 在工作中学习
- 自动保存知识
- 持续进化

这才是真正的"AI 成长"
```

---

### 我们要做得更好

```
Claudeception 的局限:
- 只在 Claude Code
- 只学习编码知识
- 不能跨项目

我们的目标:
- 跨 AI 通用
- 学习所有工作流
- 跨项目复用
- 持续优化
- 真正的"个人记忆"
```

---

**创建时间**: 2026-01-28  
**核心发现**: Claudeception 实现了真正的自主学习  
**关键洞察**: 我们可以做得更好（跨 AI + 个人化 + 持续优化）

**下一步**: 研究 Claudeception 源码，设计我们的自主学习系统

