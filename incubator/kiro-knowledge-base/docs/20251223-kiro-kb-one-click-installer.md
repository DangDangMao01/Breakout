---
date: 2025-12-23
domain: kiro
tags: [kiro, installer, powershell, automation, knowledge-base]
status: completed
---

# Kiro 知识库一键安装脚本包

## 背景

将之前零散的知识库脚本整合成一个一键安装包，实现：
- 新设备快速部署
- 自动配置全局和工作区规则
- 统一管理所有相关脚本

## 解决方案

### 核心文件

1. **INSTALL.bat** - 双击运行的启动器
2. **.kiro/scripts/install-knowledge-base.ps1** - 主安装脚本

### 安装脚本功能

```
安装流程：
├── Step 1: 询问中央库路径（或使用当前目录）
├── Step 2: 创建目录结构
├── Step 3: 创建 .gitkeep 文件
├── Step 4: 创建 README.md
├── Step 5: 创建 PROGRESS.md
├── Step 6: 安装所有脚本
│   ├── sync-to-central.ps1
│   ├── generate-index.ps1
│   └── init-knowledge-base.ps1
├── Step 7: 配置全局 Steering 规则
├── Step 8: 配置工作区 Steering 规则
└── Step 9: 保存配置到 kb-config.json
```

### 使用方式

**首次安装：**
```batch
双击 INSTALL.bat
```

**新设备克隆后：**
```powershell
git clone https://github.com/DangDangMao01/Kiro_work.git
cd Kiro_work
.\INSTALL.bat
```

**其他项目初始化：**
```powershell
powershell -File "E:\K_Kiro_Work\.kiro\scripts\init-knowledge-base.ps1" -CentralPath "E:\K_Kiro_Work"
```

### 配置文件示例

安装后生成 `.kiro/kb-config.json`：
```json
{
    "device": "DESKTOP-03V0L9O",
    "version": "1.0",
    "installedAt": "2025-12-23 16:28:32",
    "centralPath": "E:\\K_Kiro_Work"
}
```

## 关键要点

1. 支持 `-Silent` 参数静默安装
2. 自动检测并跳过已存在的文件
3. 配置文件记录设备信息，便于多设备管理
4. 安装完成后显示所有可用命令

## 流程优化（v1.2 - 完全自动化）

### 核心发现

- 脚本创建的 Hook JSON 文件不被 Kiro 识别（系统限制）
- 但 **Steering 规则本身就能实现自动保存**，不需要 Hook
- Hook 变成可选的增强功能

### 最终简化流程

**安装（一次性）：**
```
双击 INSTALL.bat → 完成！
```

**使用（全自动）：**
1. 用 Kiro 打开任何项目
2. 正常对话
3. Steering 规则自动触发保存
4. 需要时运行同步命令

### 关键改进

- ❌ 不需要手动运行初始化命令
- ❌ 不需要添加 Hook
- ❌ 不需要等待用户操作
- ✅ 全局 Steering 规则自动处理一切
- ✅ 新用户零学习成本

## 知识检索功能（v1.3）

### 核心功能

让 Kiro 能够检索历史知识库，发现相似问题时直接调用之前的解决方案。

### 实现方式

通过 Steering 规则 + INDEX.md 索引文件：

```
用户提问 → Kiro 读取 INDEX.md → 匹配相关内容 → 调取解决方案 → 询问是否执行
```

### Steering 规则配置

```markdown
## KNOWLEDGE RETRIEVAL (On User Question)

When user asks a question:
1. Read INDEX.md to see available knowledge
2. Search for related topics by keywords/domain
3. If found similar content, read the relevant file and tell user:
   "Found related solution in knowledge base: [filename]
   [Brief summary]
   Want me to apply this solution?"
```

### 当前能力

| 功能 | 状态 |
|------|------|
| 自动保存对话 | ✅ |
| 检索历史知识 | ✅ (通过 INDEX.md) |
| 匹配相似问题 | ✅ (关键词/标签匹配) |
| 调取解决方案 | ✅ |
| 询问是否执行 | ✅ |

## 自动记录机制（v1.4）

### 新增功能

安装脚本和 Steering 规则现在支持自动记录：

| 事件 | 自动操作 |
|------|----------|
| 安装脚本运行 | 生成 `install-log-日期.md` |
| 发现问题 | 记录到 `issues-log.md` |
| 解决问题 | 保存到 `solutions/` |
| 用户暂停 | 保存到 `discussions/` + 更新 `PROGRESS.md` |

### Steering 规则新增 Step 5

```markdown
## STEP 5: ON ERROR / ISSUE FOUND (Auto-Record)

When any issue occurs:
1. Create/update `knowledge-base/notes/issues-log.md`
2. Record: date, description, steps, severity, status
```

### 测试方式

用户只需正常使用，Kiro 自动记录一切，无需手动填写测试表格。

## 测试问题回传模块（v1.5）

### 背景

测试时发现的问题需要自动传回开发项目（K_Kiro_Work），便于集中管理和修复。

### 新增脚本

`.kiro/scripts/report-test-issue.ps1`

```powershell
# 使用方式
powershell -File "E:\K_Kiro_Work\.kiro\scripts\report-test-issue.ps1" -Issue "问题描述" -Severity "high/medium/low" -Steps "复现步骤"
```

### 工作流程

```
其他项目测试
    ↓
发现问题
    ↓
Kiro 自动运行 report-test-issue.ps1
    ↓
问题记录到 K_Kiro_Work/knowledge-base/notes/issues-log.md
    ↓
回到开发项目查看并修复
```

### 注意

此模块为测试阶段使用，插件完善后可删除。

## 下一步

- 运行完整安装测试
- 验证问题回传功能
