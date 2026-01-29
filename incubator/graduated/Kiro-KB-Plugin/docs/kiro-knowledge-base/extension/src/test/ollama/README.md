# Ollama Integration Tests

这个目录包含 Ollama 集成的测试文件。

## 测试策略

我们使用**双重测试方法**：

### 1. 单元测试（Unit Tests）
- 验证具体示例和边界情况
- 测试错误处理
- 快速反馈

### 2. 属性测试（Property-Based Tests）
- 使用 fast-check 生成随机输入
- 验证通用属性（36 个属性）
- 每个测试至少 100 次迭代
- 发现边界情况

## 测试文件命名

- `*.test.ts` - 单元测试
- `*.property.test.ts` - 属性测试

## 运行测试

```bash
# 运行所有测试
npm test

# 运行特定测试文件
npm test -- ollama.test.ts

# 运行属性测试
npm test -- *.property.test.ts
```

## 测试覆盖率目标

- 行覆盖率: > 80%
- 分支覆盖率: > 75%
- 函数覆盖率: > 85%
- 属性覆盖率: 100% (所有 36 个属性)

## 属性测试标签格式

每个属性测试必须包含标签：
```typescript
// Feature: ollama-integration, Property {number}: {property_text}
```

## Mock 策略

- Mock Ollama API 调用
- Mock 文件系统操作
- Mock VSCode API
- 不 Mock 核心业务逻辑

## 性能基准

- 追踪开销: < 10ms per event
- 日报生成: < 30 seconds
- 周报生成: < 2 minutes
