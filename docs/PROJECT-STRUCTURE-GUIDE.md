# K_Kiro_Work 项目结构解说

> 最后更新：2026-01-28

## 📁 目录结构总览

```
K_Kiro_Work/
├── projects/           # 正式项目
├── scripts/            # 脚本工具库
├── research/           # 研究与探索
├── art/                # 美术资源
├── knowledge-base/     # 技术知识库（插件自动保存）
├── docs/               # 文档
├── archives/           # 归档
├── temp/               # 临时文件
├── tools/              # 工具程序
└── tu/                 # 截图文件夹
```

---

## 🎯 各目录详细说明

### 1. projects/ - 正式项目

**用途**：已经进入开发阶段的正式项目

**内容**：
- `Cocos_2D/` - Cocos Creator 2D 游戏开发
  - 金币飞行动画系统（Royal Match 风格）
  - 测试脚本和使用教程
- `Spine/` - Spine 动画项目
- `SecondMind-Product/` - SecondMind 产品开发

**何时使用**：
- 项目已经有明确的目标和交付物
- 需要持续维护和迭代
- 有完整的文档和测试

---

### 2. scripts/ - 脚本工具库

**用途**：按软件分类的脚本工具集合

**内容**：
- `3dsmax/` - 3ds Max 脚本（动画、破碎、导出等）
- `blender/` - Blender 脚本（建模、动画、导出等）
- `photoshop/` - Photoshop 脚本（批处理、自动化等）
- `spine/` - Spine 脚本（动画、导出等）
- `windows/` - Windows 系统脚本（批处理、自动化等）
- `misc/` - 杂项脚本（不属于特定软件的工具）

**何时使用**：
- 需要快速找到某个软件的脚本工具
- 添加新的脚本工具
- 复用已有的脚本逻辑

**命名规范**：
- 功能描述_版本.ext（如：`export_to_unity_v2.ms`）
- 使用下划线分隔单词
- 包含版本号便于追踪

---

### 3. research/ - 研究与探索

**用途**：实验性项目、技术研究、思想探讨

**内容**：
- `ai-philosophy/` - AI 哲学探讨（2026-01-28 的深度对话）
  - `discussions/` - 完整对话记录
  - `ideas/` - 提炼的核心思想
  - `PLUGIN.SKILL.md` - AI 驱动插件设计
- `plugin-design/` - 插件设计研究
- `comfyui/` - ComfyUI 研究
- `agent/` - Agent 研究
- `experiments/` - 实验性项目
  - `feishu-notify/` - 飞书通知实验

**何时使用**：
- 探索新技术、新想法
- 不确定是否会成为正式项目
- 需要记录思考过程

**毕业标准**：
- 当研究项目成熟后，移动到 `projects/`
- 失败的实验保留在这里作为经验

---

### 4. art/ - 美术资源

**用途**：美术相关的资源和指南

**内容**：
- `style-bible/` - 风格指南
  - `Art_Style_Bible/` - 美术风格圣经
  - `Panty_Stocking_Style_Guide.md` - PSG 风格指南
- `assets/` - 素材资源（图片、模型、纹理等）

**何时使用**：
- 需要参考美术风格
- 存储项目素材
- 制定美术规范

---

### 5. knowledge-base/ - 技术知识库

**用途**：Kiro KB 插件自动保存的技术知识

**内容**：
- `solutions/` - 解决具体问题
  - Bug 修复记录
  - 功能实现方案
  - 配置问题解决
- `notes/` - 学习笔记
  - 概念理解
  - 最佳实践
  - 工具使用
- `discussions/` - 技术探讨
  - 架构设计讨论
  - 方案对比分析
- `backlog/` - 待处理问题
  - `draft/` - 草稿
  - `pending/` - 待办

**何时使用**：
- 插件会在会话结束时自动评估并保存
- 手动保存：说 "保存到知识库"
- 搜索历史问题：说 "检索知识库"

**与 research/ 的区别**：
- `knowledge-base/` - 实用的技术问题和解决方案
- `research/` - 探索性的思考和实验

**文件命名**：
- `YYYYMMDD-简短描述.md`
- 例：`20260128-GitLab-Runner工作原理.md`

---

### 6. docs/ - 文档

**用途**：项目级别的文档和指南

**内容**：
- `CONTACTS.md` - 联系人信息
- `GLOSSARY.md` - 术语表
- `PROGRESS.md` - 进度跟踪
- `PROJECT-TEMPLATE.md` - 项目模板
- `ROADMAP.md` - 路线图
- `GRADUATION-CRITERIA.md` - 项目毕业标准
- `PROJECT-STRUCTURE-GUIDE.md` - 本文档

**何时使用**：
- 需要查看项目整体信息
- 更新项目进度
- 创建新项目时参考模板

---

### 7. archives/ - 归档

**用途**：不再使用但需要保留的文件

**内容**：
- `old-tests/` - 旧的测试文件（test_*.txt）
- `deprecated/` - 废弃的代码和文档

**何时使用**：
- 清理项目时移动旧文件
- 需要查看历史记录
- 避免删除可能有用的文件

**归档原则**：
- 超过 3 个月未使用的文件
- 已被新版本替代的文件
- 保留文件结构便于查找

---

### 8. temp/ - 临时文件

**用途**：临时性的文件，可随时删除

**内容**：
- `screenshots/` - 临时截图
- 下载的临时文件
- 测试生成的文件

**何时使用**：
- 需要临时存储文件
- 不确定是否需要长期保留

**清理规则**：
- 每月清理一次
- 超过 1 周未使用的文件可删除

---

### 9. tools/ - 工具程序

**用途**：独立的工具程序和可执行文件

**内容**：
- `gitlab-runner-windows-amd64.exe` - GitLab Runner
- `test_bookmark.py` - 书签测试工具

**何时使用**：
- 需要运行独立工具
- 不属于特定项目的工具

---

### 10. tu/ - 截图文件夹

**用途**：供 Kiro AI 查看的截图

**内容**：
- 问题截图
- 界面截图
- 错误信息截图

**何时使用**：
- 向 AI 展示问题
- 记录界面状态
- 保存错误信息

**命名规范**：
- `YYYYMMDD-HHMMSS-描述.png`
- 例：`20260128-143022-cocos-error.png`

---

## 🔄 工作流程

### 新项目开发流程

1. **探索阶段** → `research/experiments/项目名/`
   - 技术调研
   - 原型开发
   - 可行性验证

2. **开发阶段** → `projects/项目名/`
   - 正式开发
   - 文档完善
   - 测试验证

3. **完成阶段** → `archives/项目名/`
   - 项目归档
   - 经验总结
   - 知识沉淀

### 脚本开发流程

1. **创建脚本** → `scripts/软件名/功能_v1.ext`
2. **测试验证** → 在对应项目中测试
3. **迭代优化** → `scripts/软件名/功能_v2.ext`
4. **文档记录** → `scripts/软件名/README.md`

### 知识积累流程

1. **对话过程** → AI 自动记录
2. **会话结束** → Hook 自动评估
3. **自动保存** → `knowledge-base/分类/日期-标题.md`
4. **手动整理** → 定期回顾和补充

---

## 📝 文件命名规范

### 通用规范
- 使用英文或拼音，避免中文（Git 友好）
- 使用下划线或连字符分隔单词
- 包含日期：`YYYYMMDD-描述.ext`
- 包含版本：`功能_v1.ext`

### 特殊规范
- **Markdown 文档**：`YYYYMMDD-标题.md`
- **脚本文件**：`功能描述_版本.ext`
- **截图文件**：`YYYYMMDD-HHMMSS-描述.png`
- **配置文件**：`config_环境.ext`

---

## 🔍 快速查找指南

### 我想找...

**某个软件的脚本** → `scripts/软件名/`

**某个项目的代码** → `projects/项目名/`

**某个技术问题的解决方案** → `knowledge-base/solutions/`

**某个概念的学习笔记** → `knowledge-base/notes/`

**某个实验性项目** → `research/experiments/`

**某个美术风格指南** → `art/style-bible/`

**某个旧文件** → `archives/`

**某个临时截图** → `temp/screenshots/` 或 `tu/`

---

## 🛠️ 维护建议

### 每周
- 清理 `temp/` 目录
- 整理 `tu/` 截图
- 更新 `docs/PROGRESS.md`

### 每月
- 回顾 `research/` 项目，决定是否毕业到 `projects/`
- 归档不再使用的文件到 `archives/`
- 更新 `docs/ROADMAP.md`

### 每季度
- 清理 `archives/` 中超过 1 年的文件
- 整理 `knowledge-base/` 重复内容
- 更新本文档

---

## 🔗 相关文档

- `README.md` - 项目总览
- `ROADMAP.md` - 开发路线图
- `PROGRESS.md` - 进度跟踪
- `REORGANIZATION-PLAN.md` - 重组方案（2026-01-28）

---

## 📞 联系方式

- Email: dangdangshijie@gmail.com
- GitHub: https://github.com/DangDangMao01/Kiro_work
- 中央知识库: `D:\G_GitHub\Kiro-Knowledge-Base`

---

**最后更新**：2026-01-28  
**维护者**：DangDangMao  
**版本**：v1.0
