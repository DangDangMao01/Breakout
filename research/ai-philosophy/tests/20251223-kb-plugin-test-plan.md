---
date: 2025-12-23
domain: kiro
tags: [kiro, testing, knowledge-base, plugin]
status: active
---

# Kiro 知识库插件完整测试方案

## 测试原则

1. **从安装开始** - 模拟全新用户体验
2. **记录问题** - 每个测试步骤记录遇到的问题
3. **迭代优化** - 发现问题立即修复，重新测试

---

## 阶段一：全新安装测试

### 1.1 模拟全新环境

**操作：**
```powershell
# 备份现有配置
Copy-Item "$env:USERPROFILE\.kiro\steering\check-knowledge-base.md" "$env:USERPROFILE\.kiro\steering\check-knowledge-base.md.bak"

# 删除全局 Steering（模拟新设备）
Remove-Item "$env:USERPROFILE\.kiro\steering\check-knowledge-base.md" -ErrorAction SilentlyContinue
```

**检查点：** 确认文件已删除

---

### 1.2 运行安装脚本

**操作：**
```powershell
cd E:\K_Kiro_Work
.\INSTALL.bat
```

**预期：**
- [ ] 安装过程无报错
- [ ] 显示安装完成信息
- [ ] 全局 Steering 规则创建成功

**问题记录：**
| 问题 | 严重程度 | 状态 |
|------|----------|------|
| (记录问题) | 高/中/低 | ⬜ |

---

## 阶段二：基础功能测试

### 2.1 新对话 - 进度检查

**操作：**
1. 关闭当前对话
2. 开启新对话
3. 随便说一句话

**预期：**
- [ ] Kiro 检查 PROGRESS.md
- [ ] 如有未完成任务，提示继续

**问题记录：**
| 问题 | 严重程度 | 状态 |
|------|----------|------|
| | | |

---

### 2.2 知识检索 - 已有问题

**操作：**
1. 问："PowerShell 脚本怎么运行？"

**预期：**
- [ ] Kiro 读取 INDEX.md
- [ ] 找到相关文档
- [ ] 展示摘要
- [ ] 询问是否执行

**问题记录：**
| 问题 | 严重程度 | 状态 |
|------|----------|------|
| | | |

---

### 2.3 知识检索 - 新问题

**操作：**
1. 问一个知识库中没有的问题
2. 例如："如何配置 ESLint？"

**预期：**
- [ ] Kiro 正常解答
- [ ] 对话结束时自动保存
- [ ] 保存格式正确（YAML front-matter）

**问题记录：**
| 问题 | 严重程度 | 状态 |
|------|----------|------|
| | | |

---

### 2.4 暂停保存

**操作：**
1. 开始讨论一个问题
2. 说"暂停"或"先不做了"

**预期：**
- [ ] 保存未完成内容到 discussions/
- [ ] 更新 PROGRESS.md
- [ ] 重新生成索引

**问题记录：**
| 问题 | 严重程度 | 状态 |
|------|----------|------|
| | | |

---

## 阶段三：跨项目测试

### 3.1 其他项目 - 知识检索

**操作：**
1. 用 Kiro 打开另一个项目
2. 问："怎么同步知识库？"

**预期：**
- [ ] 能访问中央知识库
- [ ] 找到相关解决方案

**问题记录：**
| 问题 | 严重程度 | 状态 |
|------|----------|------|
| | | |

---

### 3.2 其他项目 - 同步到中央库

**操作：**
1. 在其他项目解决一个问题
2. 运行同步命令

**预期：**
- [ ] 同步成功
- [ ] 文件名带项目前缀
- [ ] 中央库索引更新

**问题记录：**
| 问题 | 严重程度 | 状态 |
|------|----------|------|
| | | |

---

## 阶段四：问题汇总与优化

### 发现的问题汇总

| # | 问题描述 | 阶段 | 严重程度 | 修复状态 |
|---|----------|------|----------|----------|
| 1 | | | | ⬜ |
| 2 | | | | ⬜ |
| 3 | | | | ⬜ |

### 优化记录

| 日期 | 优化内容 | 相关文件 |
|------|----------|----------|
| | | |

---

## 测试完成检查清单

| 阶段 | 测试项 | 状态 |
|------|--------|------|
| 1 | 模拟全新环境 | ⬜ |
| 1 | 运行安装脚本 | ⬜ |
| 2 | 新对话进度检查 | ⬜ |
| 2 | 知识检索-已有问题 | ⬜ |
| 2 | 知识检索-新问题 | ⬜ |
| 2 | 暂停保存 | ⬜ |
| 3 | 其他项目知识检索 | ⬜ |
| 3 | 跨项目同步 | ⬜ |

---

## 测试执行命令速查

```powershell
# 模拟新环境
Remove-Item "$env:USERPROFILE\.kiro\steering\check-knowledge-base.md" -ErrorAction SilentlyContinue

# 安装
cd E:\K_Kiro_Work
.\INSTALL.bat

# 同步
powershell -File "E:\K_Kiro_Work\.kiro\scripts\sync-to-central.ps1" -CentralPath "E:\K_Kiro_Work\knowledge-base"

# 生成索引
powershell -File "E:\K_Kiro_Work\.kiro\scripts\generate-index.ps1"

# 恢复备份（测试完成后）
Copy-Item "$env:USERPROFILE\.kiro\steering\check-knowledge-base.md.bak" "$env:USERPROFILE\.kiro\steering\check-knowledge-base.md"
```
