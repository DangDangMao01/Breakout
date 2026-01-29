---
inclusion: always
---

# Knowledge Base 集成指南

## 🎯 目的

确保 Kiro 在孵化器项目中保持上下文连续性。

---

## 📊 自动保存规则

### 项目立项时
```
触发：创建新项目（active/[project]/）
保存：
  - 项目概述 → solutions/
  - 市场调研 → notes/
  - 立项决策 → discussions/
```

### 开发过程中
```
触发：解决技术问题
保存：
  - 技术方案 → solutions/
  - 代码片段 → notes/
  - 调试记录 → discussions/
```

### 项目完成时
```
触发：项目独立或归档
保存：
  - 复盘总结 → solutions/
  - 经验教训 → notes/
  - 项目记录 → discussions/
```

---

## 🔗 与中央知识库的关系

### 本地知识库（incubator/active/[project]/）
- 项目专属的知识
- 快速访问
- 项目内共享

### 中央知识库（D:\G_GitHub\Kiro-Central-KB）
- 跨项目的知识
- 跨设备同步
- 全局共享

### 同步策略
```
本地知识库
    ↓
定期同步（每天/每周）
    ↓
中央知识库
    ↓
跨设备可用
```

---

## 💡 使用场景

### 场景 1：跨设备开发

**公司电脑**：
```
开发 Sugar Rush 2D
    ↓
遇到问题：Spine 动画卡顿
    ↓
解决并保存到 Knowledge Base
    ↓
同步到中央知识库
```

**家里电脑**：
```
打开 K_Kiro_Work
    ↓
Kiro 读取中央知识库
    ↓
✅ 知道你之前解决了 Spine 动画卡顿
✅ 可以继续开发
```

---

### 场景 2：跨项目复用

**项目 A（Sugar Rush 2D）**：
```
开发金币飞行动画
    ↓
保存到 Knowledge Base
```

**项目 B（新游戏）**：
```
需要金币飞行动画
    ↓
Kiro 检索 Knowledge Base
    ↓
✅ 找到之前的方案
✅ 直接复用
```

---

## 🎯 最佳实践

### 1. 及时保存
- 解决问题后立即保存
- 不要等到项目结束

### 2. 清晰分类
- 技术方案 → solutions/
- 代码片段 → notes/
- 讨论记录 → discussions/

### 3. 定期同步
- 每天工作结束时同步
- 切换设备前同步

### 4. 定期回顾
- 每周回顾 Knowledge Base
- 整理和优化

---

## 🔧 Kiro 命令

### 保存当前对话
```
"保存到知识库"
"Save to KB"
```

### 检索知识库
```
"检索知识库：Spine 动画"
"Search KB: Spine animation"
```

### 同步到中央
```
"同步到中央知识库"
"Sync to central KB"
```

---

**创建日期**: 2026-01-29  
**版本**: v1.0

