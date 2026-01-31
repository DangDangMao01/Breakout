# Cocos3D 项目目录

## 📋 说明

这个目录用于存放 Cocos3D 游戏项目。

**⚠️ 重要**: 由于 AI 无法自动检测外层 Git 仓库，在这个目录下创建项目可能会导致 Git 嵌套问题。

---

## 🚀 项目孵化流程

### 问题背景

当 Trae 在 `projects/GameEngines/Cocos3D/projects/` 下创建新项目时，它会自动初始化 Git 仓库，导致：
- Git 嵌套问题（Git 中有 Git）
- 主项目无法正确追踪子项目的变更
- 可能导致提交冲突和数据丢失

### 解决方案：项目孵化

**流程**:
1. **Trae 在此目录创建项目**（会自动创建 Git）
2. **Kiro 监听到新项目**（通过文件系统或 Git 变更）
3. **删除内层 .git 目录**（避免嵌套）
4. **复制项目到独立目录**（如 `D:\G_GitHub\ProjectName`）
5. **从主项目中删除原项目**
6. **在独立目录初始化 Git**（让 Trae 可以自由管理）
7. **Kiro 监听独立项目**（通过文件系统监听或 Git Hook）

---

## 📂 已孵化的项目

### Breakout（打砖块）

**孵化时间**: 2026-01-31  
**独立路径**: `D:\G_GitHub\Breakout`  
**状态**: 已孵化，等待 Git 初始化

**项目信息**:
- **引擎**: Cocos Creator 3.x
- **语言**: TypeScript
- **目标**: 验证 Trae + Kiro 协作流程
- **协作模式**: Trae 生成代码 → Kiro 审查优化

**下一步**:
1. 在 `D:\G_GitHub\Breakout` 初始化 Git 仓库
2. 将项目添加到工作区（让 Kiro 可以监听）
3. 测试 Trae 在独立项目中的工作流程
4. 测试 Kiro 监听 Trae 工作的可行性

---

## 🔧 Kiro 监听方案

### 方案 A: 文件系统监听

**原理**: 使用 Node.js 的 `fs.watch` 或 `chokidar` 监听文件变更

**优点**:
- ✅ 实时监听
- ✅ 不依赖 Git

**缺点**:
- ❌ 需要额外的进程
- ❌ 可能有性能问题

---

### 方案 B: Git Hook

**原理**: 在独立项目中设置 Git Hook，提交时通知 Kiro

**优点**:
- ✅ 不需要额外进程
- ✅ 只在提交时触发

**缺点**:
- ❌ 依赖 Git
- ❌ 需要手动配置

---

### 方案 C: 定期轮询

**原理**: Kiro 定期检查独立项目的 Git 历史

**优点**:
- ✅ 简单易实现
- ✅ 不需要额外配置

**缺点**:
- ❌ 不是实时的
- ❌ 可能有延迟

---

## 📝 使用指南

### 创建新项目

1. **让 Trae 在此目录创建项目**
   ```
   用户: "在 projects/GameEngines/Cocos3D/projects/ 创建一个新游戏项目"
   Trae: [创建项目，自动初始化 Git]
   ```

2. **Kiro 监听并孵化**
   ```
   Kiro: "检测到新项目 [ProjectName]，准备孵化..."
   Kiro: [删除内层 .git，复制到独立目录，从主项目删除]
   Kiro: "项目已孵化到 D:\G_GitHub\[ProjectName]"
   ```

3. **初始化独立项目的 Git**
   ```powershell
   cd D:\G_GitHub\[ProjectName]
   git init
   git add .
   git commit -m "Initial commit"
   ```

4. **添加到工作区**
   - 在 Kiro 中打开 `D:\G_GitHub\[ProjectName]`
   - 让 Kiro 可以监听项目变更

---

## 🎯 目标

通过项目孵化机制，实现：
- ✅ 避免 Git 嵌套问题
- ✅ Trae 可以自由管理独立项目
- ✅ Kiro 可以监听 Trae 的工作
- ✅ 验证 Trae + Kiro 协作流程

---

**创建时间**: 2026-01-31  
**用途**: 说明项目孵化流程和 Kiro 监听方案
