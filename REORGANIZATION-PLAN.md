# K_Kiro_Work 工作区重组方案

## 当前问题
- 根目录文件太多（test_*.txt, *.md 散落）
- incubator/ 里什么都有，缺乏分类
- 今天的 AI 探讨文档在 incubator/kiro-knowledge-base/
- 没有明确的项目分类

## 新目录结构（TA 工作目录规范）

```
K_Kiro_Work/
├── projects/                    # 正式项目
│   ├── Cocos_2D/               # Cocos Creator 项目
│   ├── Spine/                  # Spine 动画项目
│   └── SecondMind-Product/     # SecondMind 产品开发
│
├── scripts/                     # 脚本工具库
│   ├── 3dsmax/                 # 3ds Max 脚本
│   ├── blender/                # Blender 脚本
│   ├── photoshop/              # Photoshop 脚本
│   ├── spine/                  # Spine 脚本
│   └── windows/                # Windows 系统脚本
│
├── research/                    # 研究与探索
│   ├── ai-philosophy/          # AI 哲学探讨（今天的讨论）
│   ├── plugin-design/          # 插件设计研究
│   ├── comfyui/               # ComfyUI 研究
│   ├── agent/                 # Agent 研究
│   └── experiments/           # 实验性项目
│
├── art/                        # 美术资源
│   ├── style-bible/           # 风格指南
│   │   ├── Art_Style_Bible/
│   │   └── Panty_Stocking_Style_Guide.md
│   └── assets/                # 素材资源
│
├── knowledge-base/             # 知识库（保持不变）
│
├── docs/                       # 文档
│   ├── CONTACTS.md
│   ├── GLOSSARY.md
│   ├── PROGRESS.md
│   ├── PROJECT-TEMPLATE.md
│   ├── ROADMAP.md
│   └── README.md
│
├── archives/                   # 归档
│   ├── old-tests/             # 旧测试文件
│   └── deprecated/            # 废弃文件
│
├── temp/                       # 临时文件
│   └── screenshots/           # 截图
│
├── tools/                      # 工具
│   ├── gitlab-runner-windows-amd64.exe
│   └── test_bookmark.py
│
└── config/                     # 配置文件
    ├── .gitignore
    ├── .kiro-kb-binding.json
    ├── .runner_system_id
    ├── config.toml
    └── unfiled_ids.json
```

## 文件移动清单

### 1. 从 incubator/ 移出到 projects/
- `incubator/Cocos_2D/` → `projects/Cocos_2D/`
- `incubator/Spine/` → `projects/Spine/`
- `incubator/SecondMind-Product/` → `projects/SecondMind-Product/`

### 2. 从 incubator/ 移出到 scripts/
- `incubator/3dsmax-scripts/` → `scripts/3dsmax/`
- `incubator/Blender/` → `scripts/blender/`
- `incubator/PS_Script/` → `scripts/photoshop/`
- `incubator/Spine_Script/` → `scripts/spine/`
- `incubator/windows/` → `scripts/windows/`
- `incubator/scripts/` → `scripts/misc/`（杂项脚本）

### 3. 从 incubator/ 移出到 research/
- `incubator/kiro-knowledge-base/` → `research/ai-philosophy/`（今天的探讨）
- `incubator/ComfyUI/` → `research/comfyui/`
- `incubator/Agent/` → `research/agent/`
- `incubator/experiments/` → `research/experiments/`
- `incubator/Feishu_Notify_Setup/` → `research/experiments/feishu-notify/`

### 4. 根目录文件整理
- `test_*.txt` → `archives/old-tests/`
- `CONTACTS.md, GLOSSARY.md, PROGRESS.md, PROJECT-TEMPLATE.md, ROADMAP.md` → `docs/`
- `gitlab-runner-windows-amd64.exe, test_bookmark.py` → `tools/`
- `.gitignore, .kiro-kb-binding.json, .runner_system_id, config.toml, unfiled_ids.json` → 保持根目录（配置文件）

### 5. 美术资源整理
- `Art_Style_Bible/` → `art/style-bible/Art_Style_Bible/`
- `Panty_Stocking_Style_Guide.md` → `art/style-bible/`
- `assets/` → `art/assets/`

### 6. 保持不变
- `knowledge-base/` - 知识库
- `archives/` - 已有归档
- `tu/` - 不确定用途，暂时保留
- `.git/, .kiro/, .trae/, .venv/, .vscode/` - 系统文件夹

## 执行步骤

1. 创建新目录结构
2. 移动文件到对应位置
3. 更新 README.md
4. 删除空的 incubator/ 目录
5. 提交 Git 变更

## 注意事项

- 移动前先创建目标目录
- 保留 Git 历史（使用 git mv）
- 更新相关文档中的路径引用
- 备份重要文件
