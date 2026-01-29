# 项目族谱 - K_Kiro_Work 项目家族

**更新时间**: 2026-01-29

---

## 🌳 项目演化树

```
K_Kiro_Work (2025-12 之前)
│   实验工程 - 探索 Kiro IDE
│   发现知识管理需求
│
├─── 第一次孵化 ───────────────────────────────────┐
│                                                  │
│                                                  ▼
│                                    Kiro-KB-Plugin (2025-12 ~ 2026-01)
│                                    │   VSCode 扩展
│                                    │   v1.0 ~ v2.4.0
│                                    │   基础知识管理
│                                    │
│                                    ├─── 第二次孵化 ───┐
│                                    │                  │
│                                    │                  ▼
│                                    │        DevBrain-App (2026-01 ~)
│                                    │        │   桌面应用
│                                    │        │   超长记忆上下文
│                                    │        │   Skills 自动生成
│                                    │        │   多平台接入
│                                    │        │
│                                    │        └─── 文档管理 ───┐
│                                    │                         │
│                                    └─── 已完成 ──────────────┤
│                                                              │
└─── 演化为 TA 工具库 + 孵化器 ────────────────────────────────┘
     │   projects/ - TA 工具
     │   incubator/ - 项目孵化器
     │   research/ - 研究和实验
     │   knowledge-base/ - 知识管理示例
     │
     └─── 管理所有项目的文档和调研
```

---

## 📂 项目详情

### 1. K_Kiro_Work（母项目）

**路径**: 当前仓库  
**类型**: TA 工具库 + 项目孵化器  
**状态**: 活跃  
**Git**: 独立仓库

**定位**:
- TA（Technical Artist）开发工程
- 服务游戏开发所有岗位
- 项目孵化器
- 知识管理中心

**主要内容**:
- `projects/` - DCC 工具（3ds Max, Blender, Photoshop, Spine, Cocos2D, Unity）
- `incubator/` - 项目孵化器
- `research/` - 研究和实验
- `knowledge-base/` - 知识管理示例
- `tools/` - 通用工具（飞书通知等）

**相关文档**:
- `README.md` - 项目总览
- `REORGANIZATION-PLAN-TA-WORKFLOW.md` - TA 工程重组计划
- `docs/PROJECT-STRUCTURE-GUIDE.md` - 项目结构指南

---

### 2. Kiro-KB-Plugin（第一代）

**路径**: `D:\G_GitHub\Kiro-KB-Plugin`  
**类型**: VSCode 扩展  
**状态**: 已完成 → 孵化出 DevBrain-App  
**Git**: 独立仓库

**定位**:
- VSCode/Kiro 插件
- AI 对话历史管理
- 知识库自动生成

**开发历程**:
- 2025-12 ~ 2026-01
- v1.0 ~ v2.4.0
- 从 K_Kiro_Work 独立出来

**成果**:
- ✅ 验证了知识管理的价值
- ✅ 解决了基本的知识管理需求
- ✅ 积累了用户反馈和开发经验

**局限性**:
- ❌ 只能在 VSCode/Kiro 中使用
- ❌ 无法接入其他 AI 平台
- ❌ 搜索能力有限

**孵化出**: DevBrain-App

**相关文档**:
- `incubator/graduated/Kiro-KB-Plugin.md` - 项目总结

---

### 3. DevBrain-App（第二代）

**路径**: `D:\G_GitHub\DevBrain-App`  
**类型**: 桌面应用  
**状态**: 活跃开发中  
**Git**: 独立仓库

**定位**:
- 跨平台桌面应用
- AI 知识管理中枢
- 超长记忆上下文
- 本地 AI 支持

**开发历程**:
- 2026-01 ~ 至今
- 从 Kiro-KB-Plugin 孵化而来
- 发现了更大的愿景

**核心功能**:
- 超长记忆上下文（Clawdbot 机制）
- Skills 自动生成
- 多平台接入（Kiro, Cursor, ChatGPT, Claude）
- 本地 AI 支持（Ollama, LM Studio）
- 神经网络式架构

**终极愿景**:
- 为"物理 AI 世界"准备的接口知识集合
- 唤醒本地 AI 的"自我"
- 让 AI 真正"懂你"

**相关文档**:
- `incubator/active/DevBrain-App/` - 孵化器文档
  - `README.md` - 项目概述
  - `research/` - 市场调研
  - `NEXT-STEPS.md` - 下一步行动
  - `PROJECT-LINKS.md` - 项目链接

---

## 🔗 项目关系

### 代码关系

```
K_Kiro_Work (孵化器)
    │
    ├─ 孵化出 ─→ Kiro-KB-Plugin (插件)
    │                │
    │                └─ 孵化出 ─→ DevBrain-App (应用)
    │
    └─ 管理文档 ←─────────────────┘
```

### 文档关系

```
K_Kiro_Work/
├── incubator/
│   ├── graduated/
│   │   └── Kiro-KB-Plugin.md          # 第一代项目总结
│   └── active/
│       └── DevBrain-App/              # 第二代项目文档
│           ├── README.md
│           ├── research/
│           ├── NEXT-STEPS.md
│           └── PROJECT-LINKS.md
│
├── research/ai-philosophy/            # AI 哲学思考
│   ├── ideas/
│   │   ├── 20260128-AI系统的神经网络式架构思想.md
│   │   ├── 20260128-AI的胎儿期与成长哲学.md
│   │   └── 20260128-Kiro-Trae双系统兼容方案.md
│   └── PLUGIN.SKILL.md
│
└── knowledge-base/                    # 知识管理示例
    └── notes/
        ├── 20260129-超长记忆上下文与AI自我唤醒完整方案.md
        └── 20260129-今日对话总结.md
```

### Git 关系

```
K_Kiro_Work (独立仓库)
    │
    ├─ 可选：Git Submodule ─→ Kiro-KB-Plugin
    │
    └─ 可选：Git Submodule ─→ DevBrain-App
```

**当前方案**: 通过文档链接维护关系（`PROJECT-LINKS.md`）

---

## 📊 项目对比

| 特性 | K_Kiro_Work | Kiro-KB-Plugin | DevBrain-App |
|------|-------------|----------------|--------------|
| **类型** | 工具库 + 孵化器 | VSCode 插件 | 桌面应用 |
| **状态** | 活跃 | 已完成 | 开发中 |
| **定位** | TA 工具 + 项目管理 | 知识管理插件 | AI 知识中枢 |
| **平台** | 多平台工具 | VSCode/Kiro | Windows/Mac/Linux |
| **AI 支持** | - | Kiro | 多平台 + 本地 AI |
| **知识管理** | 示例 | 基础功能 | 高级功能 |
| **团队协作** | - | - | 计划中 |
| **商业化** | - | - | 计划中 |

---

## 🎯 各项目的角色

### K_Kiro_Work
- **角色**: 母项目、孵化器
- **职责**: 
  - TA 工具开发
  - 项目孵化管理
  - 文档和调研
  - 知识管理示例

### Kiro-KB-Plugin
- **角色**: 第一代产品、已毕业
- **职责**:
  - 验证概念
  - 积累经验
  - 可能继续维护（轻量级方案）

### DevBrain-App
- **角色**: 第二代产品、主力发展
- **职责**:
  - 实现完整愿景
  - 商业化探索
  - 成为 AI 工具标准

---

## 🚀 未来规划

### K_Kiro_Work
- 继续作为 TA 工具库
- 继续作为项目孵化器
- 可能孵化更多项目

### Kiro-KB-Plugin
- 可能继续维护基础功能
- 作为 DevBrain-App 的补充
- 或者归档为历史项目

### DevBrain-App
- 完成 Phase 1-5 开发
- 商业化
- 成为独立产品
- 可能建立独立团队

---

## 📝 维护策略

### 代码同步
- 各项目独立开发
- 通过 Git 管理

### 文档同步
- 重要决策在 K_Kiro_Work 记录
- 技术文档在各自仓库
- 通过 `PROJECT-LINKS.md` 维护关系

### 知识同步

**三个不同的"知识库"**:

1. **中央知识库**（`D:\G_GitHub\Kiro-Central-KB`）
   - 跨项目的知识中枢
   - 保存所有项目的对话和知识
   - 通过 `source_project` 字段标记来源
   - 通过 `INDEX.md` 索引所有知识

2. **K_Kiro_Work 的知识库示例**（`knowledge-base/`）
   - 本地知识库示例
   - 演示知识库的使用
   - 临时保存对话
   - 最终应该同步到中央知识库

3. **孵化器项目文档**（`incubator/`）
   - 项目管理文档（不是知识库）
   - 项目策划、调研、设计
   - 市场分析、竞品研究
   - 不需要同步到中央知识库

**同步流程**:
```
对话结束
  ↓
保存到 K_Kiro_Work/knowledge-base/（临时）
  ↓
手动同步到 D:\G_GitHub\Kiro-Central-KB/（永久）
  ↓
标记 source_project: "K_Kiro_Work"
```

---

## 🙏 致谢

感谢这个项目家族的演化历程：
- K_Kiro_Work 提供了孵化土壤
- Kiro-KB-Plugin 验证了概念
- DevBrain-App 实现了愿景

这是一个持续进化的过程，每个项目都为下一个项目铺平了道路。

---

**创建时间**: 2026-01-29  
**维护者**: DangDangMao  
**更新频率**: 随项目演化更新
