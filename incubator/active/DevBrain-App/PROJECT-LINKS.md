# DevBrain-App 项目链接

**更新时间**: 2026-01-29

---

## 📂 相关仓库

### 1. DevBrain-App（主仓库）
- **路径**: `D:\G_GitHub\DevBrain-App`
- **类型**: 独立 Git 仓库
- **状态**: 活跃开发中
- **说明**: 桌面应用主代码

### 2. Kiro-KB-Plugin（插件仓库）
- **路径**: `D:\G_GitHub\Kiro-KB-Plugin`（推测）
- **类型**: 独立 Git 仓库
- **状态**: 已完成（孵化出 DevBrain-App）
- **说明**: VSCode 插件，DevBrain-App 的前身

### 3. K_Kiro_Work（孵化器）
- **路径**: 当前仓库
- **类型**: TA 工具库 + 项目孵化器
- **状态**: 活跃
- **说明**: 管理项目文档、调研、策划

---

## 🔗 项目族谱

```
K_Kiro_Work (2025-12 之前)
    ↓ 实验阶段
    ├─ 开始使用 Kiro
    └─ 探索知识管理需求
    
    ↓ 独立出来
    
Kiro-KB-Plugin (2025-12 ~ 2026-01)
    ↓ 插件开发
    ├─ v1.0 ~ v2.4.0
    ├─ 基础知识管理功能
    └─ 发现插件的局限性
    
    ↓ 孵化出来
    
DevBrain-App (2026-01 ~)
    ↓ 独立应用开发
    ├─ 超长记忆上下文
    ├─ Skills 自动生成
    ├─ 多平台接入
    └─ 本地 AI 支持
    
    ↓ 文档管理
    
K_Kiro_Work/incubator/active/DevBrain-App/
    ↓ 孵化器管理
    ├─ 项目文档
    ├─ 市场调研
    ├─ 策划设计
    └─ 链接到主仓库
```

---

## 🔧 如何添加 Git Submodule

如果 DevBrain-App 有远程仓库（GitHub/GitLab），可以添加为 submodule：

```bash
# 在 K_Kiro_Work 根目录执行
git submodule add <remote-repo-url> incubator/active/DevBrain-App/code

# 例如：
# git submodule add https://github.com/yourusername/DevBrain-App.git incubator/active/DevBrain-App/code
```

如果只是本地仓库，可以使用符号链接（需要管理员权限）：

```powershell
# 在 PowerShell（管理员）中执行
New-Item -ItemType SymbolicLink -Path "incubator\active\DevBrain-App\code" -Target "D:\G_GitHub\DevBrain-App"
```

或者手动在文档中维护链接关系（当前方案）。

---

## 📋 同步策略

### 方案 A: Git Submodule（推荐）
- ✅ 保持独立的 Git 历史
- ✅ 可以独立开发和提交
- ✅ 未来独立时直接移除 submodule
- ❌ 需要远程仓库

### 方案 B: 符号链接
- ✅ 只有一份代码
- ✅ 自动同步
- ❌ 需要管理员权限
- ❌ 跨设备不工作

### 方案 C: 文档链接（当前）
- ✅ 简单
- ✅ 不需要特殊权限
- ❌ 需要手动同步
- ✅ 适合文档管理

---

## 📝 工作流程

### 开发代码
```bash
# 在 DevBrain-App 主仓库工作
cd D:\G_GitHub\DevBrain-App
# 正常开发、提交、推送
```

### 管理文档
```bash
# 在 K_Kiro_Work 孵化器工作
cd E:\K_Kiro_Work
# 更新项目文档、调研、策划
```

### 同步信息
- 重要的架构决策 → 同时更新两边的文档
- 代码变更 → 只在 DevBrain-App 仓库
- 市场调研、竞品分析 → 只在 K_Kiro_Work 孵化器

---

## 🎯 未来计划

### 短期（当前）
- 在孵化器中管理项目文档
- 在 DevBrain-App 仓库开发代码
- 通过文档链接保持同步

### 中期（3-6 个月）
- 如果 DevBrain-App 有远程仓库，添加为 submodule
- 或者使用符号链接

### 长期（独立后）
- DevBrain-App 完全独立
- 在 K_Kiro_Work 的 `graduated/` 记录信息
- 保留历史文档作为参考

---

## 📚 相关文档

### 在 K_Kiro_Work 中
- `incubator/active/DevBrain-App/README.md` - 项目概述
- `incubator/active/DevBrain-App/research/` - 市场调研
- `incubator/active/DevBrain-App/NEXT-STEPS.md` - 下一步行动

### 在 DevBrain-App 中
- `D:\G_GitHub\DevBrain-App\README.md` - 代码仓库说明
- `D:\G_GitHub\DevBrain-App\src\` - 源代码
- `D:\G_GitHub\DevBrain-App\docs\` - 技术文档

### 在 Kiro-KB-Plugin 中
- `D:\G_GitHub\Kiro-KB-Plugin\` - 插件代码
- 插件的开发历史和经验

---

**创建时间**: 2026-01-29  
**维护者**: DangDangMao
