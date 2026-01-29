# 同步到中央知识库

**用途**: 将本地知识库的内容同步到中央知识库

---

## 📋 需要同步的文件

### 今天创建的文档（2026-01-29）

**从**: `knowledge-base/notes/`  
**到**: `D:\G_GitHub\Kiro-Central-KB\notes/` 或 `solutions/`

1. `20260129-超长记忆上下文与AI自我唤醒完整方案.md`
   - 目标: `D:\G_GitHub\Kiro-Central-KB\notes\20260129-超长记忆上下文与AI自我唤醒完整方案.md`
   - 类型: 笔记（综合性文档）

2. `20260129-今日对话总结.md`
   - 目标: `D:\G_GitHub\Kiro-Central-KB\notes\20260129-今日对话总结.md`
   - 类型: 笔记（总结）

3. `20260129-Kiro-IDE-最佳实践指南.md`
   - 目标: `D:\G_GitHub\Kiro-Central-KB\notes\20260129-Kiro-IDE-最佳实践指南.md`
   - 类型: 笔记（指南）

4. `20260129-Kiro游戏开发最佳实践.md`
   - 目标: `D:\G_GitHub\Kiro-Central-KB\notes\20260129-Kiro游戏开发最佳实践.md`
   - 类型: 笔记（指南）

---

## 🔧 同步命令

### 手动复制（推荐）

```powershell
# 复制到中央知识库
Copy-Item "knowledge-base\notes\20260129-*.md" "D:\G_GitHub\Kiro-Central-KB\notes\"
```

### 使用 robocopy

```powershell
robocopy "knowledge-base\notes" "D:\G_GitHub\Kiro-Central-KB\notes" "20260129-*.md"
```

---

## ✅ 同步后的清理

同步到中央知识库后，本地的这些文件可以：
- 保留（作为本地副本）
- 删除（避免重复）
- 添加链接（指向中央知识库）

**推荐**: 保留，但在文件开头添加说明：

```markdown
> **注意**: 此文档已同步到中央知识库
> - 中央路径: `D:\G_GitHub\Kiro-Central-KB\notes\20260129-xxx.md`
> - 同步时间: 2026-01-29
```

---

## 📊 同步策略

### 方案 A: 手动同步（当前）
- 对话结束后手动复制
- 简单直接
- 需要记得同步

### 方案 B: Hook 自动同步（未来）
- 创建 Kiro Hook
- 对话结束时自动同步
- 需要开发

### 方案 C: 插件自动同步（未来）
- Kiro-KB-Plugin 或 DevBrain-App
- 自动检测和同步
- 最理想的方案

---

**创建时间**: 2026-01-29  
**用途**: 指导如何同步到中央知识库
