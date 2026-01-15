# SOLO 过渡期使用指南

> 创建时间: 2026-01-14
> 场景: Kiro 会员额度用尽，主要使用 SOLO 开发

## 一、过渡期策略

### 核心原则
**用 SOLO 开发，为 Kiro 回归做准备**

```
当前阶段（1-2个月）
├─ 主力工具: TRAE SOLO
├─ 备用工具: Kiro（仅紧急情况）
└─ 目标: 保持开发效率 + 控制成本
```

---

## 二、SOLO 使用最佳实践

### 1. 项目组织规范

#### Git 提交规范
```bash
# SOLO 生成代码后立即提交
git add .
git commit -m "feat(solo): 添加用户认证模块 [SOLO生成]"

# 手动修改后单独提交
git commit -m "refactor: 优化认证逻辑 [手动调整]"
```

**为什么重要？**
- 将来用 Kiro 审查时，能清楚区分 SOLO 生成和手动修改的代码
- 方便回滚和对比

#### 文件标记
```typescript
/**
 * 用户认证服务
 * 
 * @generated SOLO 2026-01-14
 * @reviewed 未审查
 * @refactor-needed 需要优化错误处理
 */
export class AuthService {
  // ...
}
```

### 2. 代码质量控制

#### 自检清单（SOLO 生成后）

```markdown
## 代码审查清单

### 基础检查
- [ ] 代码能正常运行
- [ ] 没有明显的语法错误
- [ ] TypeScript 类型正确

### 安全检查
- [ ] 没有硬编码的密钥/密码
- [ ] 用户输入有验证
- [ ] SQL 查询有参数化

### 性能检查
- [ ] 没有明显的性能问题
- [ ] 循环嵌套不超过 3 层
- [ ] 数据库查询有索引

### 待优化标记
- [ ] 标记需要重构的代码
- [ ] 记录潜在问题
- [ ] 添加 TODO 注释
```

#### 问题标记规范

```typescript
// TODO-KIRO: 需要用 Kiro 重构，添加错误重试机制
async function fetchData() {
  // SOLO 生成的代码
}

// FIXME-SOLO: SOLO 生成的逻辑有问题，临时修复
function calculatePrice() {
  // 手动修复的代码
}

// OPTIMIZE-LATER: 性能可以优化，但不紧急
function processLargeArray() {
  // 当前实现
}
```

### 3. 文档管理

#### 创建开发日志

```markdown
<!-- dev-log.md -->
# 开发日志

## 2026-01-14

### SOLO 生成
- ✓ 用户认证模块（登录/注册/JWT）
- ✓ 商品列表页面（React 组件）
- ✓ API 封装层（Axios）

### 手动调整
- 修复登录表单验证逻辑
- 优化商品列表加载性能
- 添加错误提示组件

### 待 Kiro 审查
- [ ] 认证模块的安全性
- [ ] API 封装的错误处理
- [ ] 组件的类型定义

### 已知问题
- 登录失败后没有清除 token
- 商品列表滚动加载有 bug
- 错误提示样式不统一
```

---

## 三、关键场景处理

### 场景 1: 新功能开发

```
步骤 1: SOLO 生成
"创建商品详情页，包含:
- 商品图片轮播
- 规格选择器
- 加入购物车
- 评论列表"

步骤 2: 快速测试
- 运行代码，检查基本功能
- 记录发现的问题

步骤 3: 必要修复
- 只修复阻塞性问题
- 其他问题标记为 TODO-KIRO

步骤 4: Git 提交
git commit -m "feat(solo): 商品详情页 [SOLO生成+手动修复]"
```

### 场景 2: Bug 修复

```
简单 Bug → SOLO 处理
"修复商品列表页面加载失败的问题"

复杂 Bug → 手动修复 + 标记
// TODO-KIRO: 这个 bug 涉及架构问题，需要深度重构
// 当前只是临时修复，治标不治本
```

### 场景 3: 代码重构

```
❌ 不要在过渡期大规模重构
✓ 只做必要的局部优化
✓ 标记需要重构的地方
✓ 等 Kiro 额度恢复后统一处理
```

---

## 四、为 Kiro 回归做准备

### 1. 创建审查清单

```markdown
<!-- kiro-review-checklist.md -->
# Kiro 审查清单

## 高优先级（安全/性能）
- [ ] 用户认证模块 - 安全性审查
- [ ] 支付接口 - 安全性审查
- [ ] 数据库查询 - 性能优化

## 中优先级（代码质量）
- [ ] API 封装层 - 错误处理优化
- [ ] 组件库 - 类型定义完善
- [ ] 工具函数 - 单元测试补充

## 低优先级（优化）
- [ ] 代码风格统一
- [ ] 注释补充
- [ ] 文档完善
```

### 2. 整理技术债务

```markdown
<!-- tech-debt.md -->
# 技术债务清单

## 架构问题
1. **状态管理混乱**
   - 位置: src/store/
   - 问题: Redux 和 Context API 混用
   - 影响: 中
   - 预计工作量: 2天

2. **API 层缺乏统一错误处理**
   - 位置: src/api/
   - 问题: 每个接口单独处理错误
   - 影响: 高
   - 预计工作量: 1天

## 代码质量
1. **类型定义不完整**
   - 位置: src/types/
   - 问题: 大量使用 any
   - 影响: 中
   - 预计工作量: 3天

## 性能问题
1. **商品列表渲染慢**
   - 位置: src/pages/ProductList.tsx
   - 问题: 没有虚拟滚动
   - 影响: 高
   - 预计工作量: 1天
```

### 3. 保存重要上下文

```markdown
<!-- project-context.md -->
# 项目上下文

## 架构决策
- 使用 React + TypeScript + Vite
- 状态管理: Redux Toolkit
- 路由: React Router v6
- UI 库: Ant Design
- API: RESTful

## 关键模块
1. **认证模块** (src/auth/)
   - JWT token 管理
   - 自动刷新机制
   - 权限控制

2. **商品模块** (src/products/)
   - 列表/详情/搜索
   - 购物车集成
   - 库存管理

## 已知限制
- 不支持 IE11
- 图片上传限制 5MB
- 并发请求限制 10 个

## 待实现功能
- [ ] 订单管理
- [ ] 用户中心
- [ ] 优惠券系统
```

---

## 五、紧急情况使用 Kiro

### 何时必须用 Kiro？

1. **安全漏洞** - SOLO 可能忽略安全问题
2. **生产事故** - 需要精确定位和修复
3. **架构重构** - SOLO 难以处理复杂重构
4. **代码审查** - 上线前的最后把关

### Kiro 使用策略（额度有限）

```
原则: 一次性解决，避免反复对话

❌ 不好:
"帮我看看这个文件" → 5K tokens
"再看看那个文件" → 5K tokens
"还有这个问题" → 5K tokens
总计: 15K tokens

✓ 好:
"审查以下模块的安全性和性能:
1. src/auth/ - 认证模块
2. src/api/ - API 封装
3. src/payment/ - 支付接口
重点关注: 安全漏洞、性能瓶颈、类型安全"
总计: 8K tokens
```

---

## 六、SOLO 使用技巧

### 1. 提示词优化

#### 基础模板
```
创建 [功能名称]，要求:

技术栈:
- 前端: React + TypeScript
- 状态: Redux Toolkit
- UI: Ant Design

功能需求:
1. [具体需求 1]
2. [具体需求 2]
3. [具体需求 3]

代码规范:
- 使用 TypeScript 严格模式
- 组件使用函数式 + Hooks
- 添加错误处理
- 添加 loading 状态

文件结构:
src/
  features/[功能名]/
    components/
    hooks/
    types/
    index.ts
```

#### 进阶技巧
```
# 分阶段实现
"第一阶段: 创建基础组件和类型定义"
"第二阶段: 实现业务逻辑和状态管理"
"第三阶段: 添加错误处理和 loading"

# 参考现有代码
"参考 src/auth/ 的代码风格，创建商品模块"

# 明确约束
"不要使用 class 组件，只用函数式组件"
"不要使用 any 类型，必须明确类型定义"
```

### 2. 常见问题处理

#### SOLO 生成代码有问题

```
方案 1: 重新生成
"刚才生成的代码有问题，请重新生成，注意 [具体问题]"

方案 2: 手动修复 + 标记
// FIXME-SOLO: SOLO 生成的代码有 bug，已手动修复
// 原因: [问题描述]
// 待 Kiro 审查: 是否有更好的实现方式

方案 3: 简化需求
"先实现核心功能，其他功能后续添加"
```

#### SOLO 理解错误

```
✓ 提供更详细的上下文
✓ 给出具体示例
✓ 分步骤说明
✓ 参考现有代码
```

---

## 七、月度计划

### 第 1 个月（SOLO 为主）

```
Week 1: 熟悉 SOLO
- 学习 SOLO 的提示词技巧
- 建立代码审查流程
- 创建文档模板

Week 2-3: 快速开发
- 用 SOLO 实现核心功能
- 手动修复关键问题
- 记录技术债务

Week 4: 整理总结
- 整理代码审查清单
- 更新技术债务文档
- 准备 Kiro 审查计划
```

### 第 2 个月（准备回归）

```
Week 1: 代码整理
- 统一代码风格
- 补充注释
- 更新文档

Week 2: 自测优化
- 修复已知问题
- 性能优化
- 安全检查

Week 3: Kiro 审查（额度恢复后）
- 安全性审查
- 性能优化
- 架构重构

Week 4: 持续优化
- 根据 Kiro 建议优化
- 补充单元测试
- 完善文档
```

---

## 八、工具配置

### VS Code 插件推荐

```json
{
  "recommendations": [
    "dbaeumer.vscode-eslint",      // 代码检查
    "esbenp.prettier-vscode",      // 代码格式化
    "streetsidesoftware.code-spell-checker", // 拼写检查
    "usernamehw.errorlens",        // 错误高亮
    "wayou.vscode-todo-highlight"  // TODO 高亮
  ]
}
```

### ESLint 配置（捕获 SOLO 常见问题）

```javascript
// .eslintrc.js
module.exports = {
  rules: {
    '@typescript-eslint/no-explicit-any': 'error', // 禁止 any
    '@typescript-eslint/explicit-function-return-type': 'warn', // 要求返回类型
    'no-console': 'warn', // 警告 console
    'no-debugger': 'error', // 禁止 debugger
  }
}
```

---

## 九、快速参考

### SOLO 提示词模板

```
# 新功能
创建 [功能]，技术栈 [X]，要求: [1,2,3]

# Bug 修复
修复 [问题]，位置 [文件]，现象 [描述]

# 代码优化
优化 [模块]，重点 [性能/安全/可读性]

# 文档生成
为 [模块] 生成 API 文档，包含 [类型/示例/说明]
```

### 代码标记规范

```typescript
// TODO-KIRO: 需要 Kiro 审查/重构
// FIXME-SOLO: SOLO 生成的代码有问题
// OPTIMIZE-LATER: 可以优化但不紧急
// SECURITY-REVIEW: 需要安全审查
// PERFORMANCE-ISSUE: 性能问题
```

### Git 提交规范

```bash
feat(solo): [功能] [SOLO生成]
fix(solo): [修复] [SOLO生成]
refactor: [重构] [手动调整]
docs: [文档] [SOLO生成]
```

---

## 十、总结

### 过渡期目标

1. ✓ 保持开发效率（SOLO 快速开发）
2. ✓ 控制技术债务（标记问题，不累积）
3. ✓ 为 Kiro 回归做准备（文档、清单、上下文）
4. ✓ 学习 SOLO 最佳实践（提高生成质量）

### 成功标准

- 项目能正常运行
- 关键功能已实现
- 技术债务有清单
- 代码有审查标记
- 文档保持更新

### 回归 Kiro 后的计划

1. 安全性审查（1-2 天）
2. 性能优化（2-3 天）
3. 架构重构（3-5 天）
4. 代码规范统一（1-2 天）
5. 文档完善（1 天）

---

**记住**: SOLO 是工具，不是替代品。用它快速开发，但不要忘记代码质量。

**最后更新**: 2026-01-14
