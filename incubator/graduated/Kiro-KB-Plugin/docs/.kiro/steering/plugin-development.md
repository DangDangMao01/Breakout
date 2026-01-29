---
inclusion: fileMatch
fileMatchPattern: "kiro-kb-plugin/**/*.ts"
---

# Kiro KB 插件开发规范

## 功能更新流程

每次更新插件功能时，必须同步更新以下文件：

### 1. 测试用例 (必须)
文件: `kiro-kb-plugin/tests/TEST-CASES.md`

- 新增功能 → 添加对应测试用例
- 修改功能 → 更新相关测试步骤和预期结果
- 更新版本号和日期

### 2. 功能大纲 (必须)
文件: `kiro-kb-plugin/PLUGIN-OVERVIEW.md`

- 更新功能列表
- 更新版本号

### 3. README (可选)
文件: `kiro-kb-plugin/extension/README.md`

- 用户可见的功能说明更新

### 4. 版本号 (必须)
文件: `kiro-kb-plugin/extension/package.json`

- 功能新增: 次版本号 +1 (如 1.3.0 → 1.4.0)
- Bug 修复: 修订号 +1 (如 1.4.0 → 1.4.1)

## 提交规范

Git commit 格式:
```
v{版本号}: {简短描述}
```

示例:
- `v1.4.0: Enhanced Sync and Open commands`
- `v1.4.1: Fix sync path issue`
