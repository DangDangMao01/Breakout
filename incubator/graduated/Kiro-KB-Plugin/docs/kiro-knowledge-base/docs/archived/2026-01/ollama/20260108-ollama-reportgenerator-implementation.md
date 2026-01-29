---
domain: development
tags: [ollama, ai-integration, report-generator, work-patterns]
date: 2026-01-08
source_project: "Kiro-KB-Plugin"
level: "project"
value_score: 9
---

# Ollama 集成 - ReportGenerator 模块实现

**日期**: 2026-01-08  
**模块**: `reportGenerator.ts`  
**状态**: ✅ 已实现（核心功能）

## 概述

ReportGenerator 是 Ollama 本地 AI 集成的核心模块之一，负责生成 AI 驱动的工作报告和维护个人工作画像。

## 核心功能

### 1. 日报生成 (Daily Report)

**方法**: `generateDailyReport(date?: Date): Promise<string>`

**功能**:
- 收集当天的工作数据（文件访问、搜索、Git 提交、编辑时间）
- 构建结构化提示词发送给 Ollama
- 生成包含以下内容的日报：
  - Summary（2-3 句总结）
  - Key Activities（关键活动列表）
  - Time Distribution（时间分布表格）
  - Insights（1-2 句洞察）
- 保存到 `work-patterns/daily/YYYY-MM-DD.md`

**YAML Front-matter**:
```yaml
---
domain: work-patterns
tags: [daily-report, work-analysis, ai-generated]
date: YYYY-MM-DD
generated_by: ollama
model: llama3.2:3b
---
```

### 2. 周报生成 (Weekly Report)

**方法**: `generateWeeklyReport(weekNumber?: number): Promise<string>`

**功能**:
- 收集过去 7 天的工作数据
- 识别工作模式和趋势
- 生成周报并保存到 `work-patterns/weekly/YYYY-WXX.md`
- **自动更新个人画像** (profile.yaml)

**周报内容**:
- 周总结
- 工作模式分析
- 生产力趋势
- 改进建议

### 3. 月报生成 (Monthly Report)

**方法**: `generateMonthlyReport(month?: number): Promise<string>`

**状态**: 🚧 待实现

### 4. 个人画像管理 (Work Profile)

**方法**: 
- `updateProfile(insights: WorkInsights): Promise<void>`
- `getProfile(): Promise<WorkProfile>`

**画像内容** (profile.yaml):
```yaml
tech_stack:
  - name: TypeScript
    proficiency: proficient
    last_used: 2026-01-08
  - name: Unity
    proficiency: expert
    last_used: 2026-01-07

work_habits:
  productive_hours:
    - "09:00-11:00"
    - "14:00-16:00"
  preferred_tools:
    - VSCode
    - Git
    - Kiro
  learning_style: "hands-on, practice-first"

common_problems:
  - TypeScript type inference
  - Git branch management
  - Unity performance optimization

knowledge_assets:
  technical_docs: 200
  code_snippets: 50
  project_experiences: 30
  solutions: 100

last_updated: 2026-01-08
generated_by: ollama
model: llama3.2:3b
```

## 技术实现

### 依赖模块

1. **OllamaClient** - AI 通信
   - `generate(prompt: string): Promise<string>`
   - `getModel(): string`

2. **WorkPatternTracker** - 数据收集
   - `getDailySnapshot(): WorkData`
   - `getWeeklySnapshot(): WorkData`

3. **js-yaml** - YAML 解析和生成
   - 读取/写入 profile.yaml

### 提示词工程

**日报提示词结构**:
```typescript
You are a work pattern analyst. Analyze the following daily work data...

## Work Data

### File Access (Top 10)
- file1.ts: 15 times
- file2.ts: 12 times

### Searches
- "TypeScript async/await" (keyword)
- "Ollama API" (semantic)

### Git Commits
- feat: add report generator (5 files)
- fix: encoding issue (2 files)

## Instructions

Generate a concise daily work report with:
1. Summary (2-3 sentences)
2. Key Activities (bullet list)
3. Time Distribution (table)
4. Insights (1-2 sentences)
```

### 文件命名规范

- **日报**: `YYYY-MM-DD.md` (如 `2026-01-08.md`)
- **周报**: `YYYY-WXX.md` (如 `2026-W02.md`)
- **月报**: `YYYY-MM.md` (如 `2026-01.md`)

### 周数计算

使用 ISO 8601 标准：
```typescript
private getWeekNumber(date: Date): number {
    const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
    const dayNum = d.getUTCDay() || 7;
    d.setUTCDate(d.getUTCDate() + 4 - dayNum);
    const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
    return Math.ceil((((d.getTime() - yearStart.getTime()) / 86400000) + 1) / 7);
}
```

## 类型定义

### WorkProfile

```typescript
export interface WorkProfile {
    tech_stack: Array<{
        name: string;
        proficiency: 'learning' | 'familiar' | 'proficient' | 'expert';
        last_used: string;
    }>;
    work_habits: {
        productive_hours: string[];
        preferred_tools: string[];
        learning_style: string;
    };
    common_problems: string[];
    knowledge_assets: {
        technical_docs: number;
        code_snippets: number;
        project_experiences: number;
        solutions: number;
    };
    last_updated: string;
    generated_by: string;
    model: string | null;
}
```

### WorkInsights

```typescript
export interface WorkInsights {
    productiveHours?: string[];
    frequentTechnologies?: string[];
    commonProblems?: string[];
    knowledgeGrowth?: string[];
}
```

### WorkData

```typescript
export interface WorkData {
    timeRange: { start: Date; end: Date };
    fileAccess: Array<{ path: string; timestamp: Date; count: number }>;
    searches: Array<{ query: string; mode: 'local' | 'global'; timestamp: Date }>;
    gitCommits: Array<{ message: string; files: string[]; timestamp: Date }>;
    editingTime: Map<string, number>;
}
```

## 工厂函数

```typescript
export function createReportGenerator(
    ollamaClient: OllamaClient,
    workTracker: WorkPatternTracker,
    kbPath: string,
    outputChannel: vscode.OutputChannel
): ReportGenerator
```

## 日志系统

所有操作都会记录到 VSCode Output Channel：

```
[14:23:45] ℹ️ [ReportGen] Generating daily report for 2026-01-08...
[14:23:47] ℹ️ [ReportGen] Daily report saved: D:\KB\work-patterns\daily\2026-01-08.md
[14:23:50] ℹ️ [ReportGen] Profile updated successfully
```

## 错误处理

- **Ollama 连接失败**: 捕获异常，记录错误日志
- **文件写入失败**: 捕获异常，记录错误日志
- **YAML 解析失败**: 返回默认画像
- **目录不存在**: 自动创建 (`recursive: true`)

## 使用场景

### 场景 1: 每日工作总结

```typescript
const reportPath = await reportGenerator.generateDailyReport();
// 生成今天的日报
```

### 场景 2: 周末回顾

```typescript
const reportPath = await reportGenerator.generateWeeklyReport();
// 生成本周周报 + 更新个人画像
```

### 场景 3: 查看个人画像

```typescript
const profile = await reportGenerator.getProfile();
console.log(profile.tech_stack);
console.log(profile.work_habits.productive_hours);
```

## 待完善功能

### 短期 (v2.50.0)

1. **月报生成**: 实现 `generateMonthlyReport()`
2. **洞察提取**: 改进 `extractInsights()` 算法
3. **周报提示词**: 完善 `buildWeeklyReportPrompt()`
4. **技术栈检测**: 自动识别使用的技术栈
5. **生产力时段**: 自动分析高效工作时段

### 中期 (v2.51.0+)

1. **趋势分析**: 对比多周/多月数据
2. **目标追踪**: 设定和追踪个人目标
3. **技能成长**: 可视化技能提升曲线
4. **知识资产**: 自动统计知识库增长
5. **报告模板**: 支持自定义报告模板

### 长期 (v3.0.0+)

1. **多模型支持**: 支持切换不同 AI 模型
2. **报告对比**: 对比不同时期的报告
3. **团队报告**: 支持团队级别的报告（可选）
4. **导出功能**: 导出为 PDF/HTML
5. **可视化**: 图表展示工作数据

## 相关文档

- [Ollama 集成 Spec 分析](../../knowledge-base/discussions/20260108-ollama-integration-spec-analysis.md)
- [Ollama 集成设计文档](../../.kiro/specs/ollama-integration/design.md)
- [Ollama 集成需求文档](../../.kiro/specs/ollama-integration/requirements.md)
- [Ollama 集成任务列表](../../.kiro/specs/ollama-integration/tasks.md)

## 测试计划

### 单元测试

- [ ] `generateDailyReport()` - 日报生成
- [ ] `generateWeeklyReport()` - 周报生成
- [ ] `updateProfile()` - 画像更新
- [ ] `getProfile()` - 画像读取
- [ ] `saveReport()` - 报告保存
- [ ] `formatDate()` - 日期格式化
- [ ] `getWeekNumber()` - 周数计算

### 集成测试

- [ ] 端到端日报生成流程
- [ ] 端到端周报生成流程
- [ ] Ollama 连接失败处理
- [ ] 文件系统错误处理

### 属性测试

- [ ] Property: 任何有效日期都能生成日报
- [ ] Property: 周数计算符合 ISO 8601
- [ ] Property: 画像更新保留手动编辑

## 性能指标

- **日报生成**: < 30 秒（小模型 CPU）
- **周报生成**: < 2 分钟
- **画像更新**: < 5 秒
- **内存占用**: < 50MB

---

**实现者**: Kiro AI Assistant  
**完成时间**: 2026-01-08  
**状态**: ✅ 核心功能已完成，待集成和测试
