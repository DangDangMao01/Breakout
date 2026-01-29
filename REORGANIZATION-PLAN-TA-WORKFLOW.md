# TA 工程重组计划

**工程定位**: Technical Artist 开发工程，服务游戏开发所有岗位  
**日期**: 2026-01-29  
**原则**: 不删除任何资料，按 DCC 工具合理分类

---

## 🎯 重组目标

### 当前问题
- `projects/` 混杂了游戏引擎项目和 DCC 工具项目
- `scripts/` 按工具分类，但与 `projects/` 不统一
- 缺少清晰的 TA 工作流导向

### 目标结构
```
projects/
├── DCC_Tools/              # DCC 工具项目（美术侧）
│   ├── 3dsMax/
│   ├── Blender/
│   ├── Houdini/
│   ├── Maya/
│   ├── Substance/
│   ├── TouchDesigner/
│   ├── Photoshop/
│   └── Spine/
├── GameEngines/            # 游戏引擎项目（程序侧）
│   ├── Cocos2D/
│   ├── Unity/
│   └── Unreal/
├── Pipelines/              # 跨工具管道
│   ├── Max_to_Unity/
│   ├── Blender_to_Spine/
│   └── PS_to_Spine/
└── Products/               # 产品和工具
    └── SecondMind/
```

---

## 📋 详细迁移计划

### Phase 1: 创建新结构

#### 1.1 创建 DCC_Tools 分类（细分脚本和插件）

```
projects/DCC_Tools/
├── 3dsMax/
│   ├── scripts/              # MaxScript 脚本
│   │   ├── animation/        # 动画相关
│   │   ├── export/           # 导出工具
│   │   ├── modeling/         # 建模工具
│   │   ├── rigging/          # 绑定工具
│   │   └── utils/            # 通用工具
│   ├── plugins/              # 插件（.dlm, .dlu）
│   │   ├── fracture/         # 破碎插件
│   │   └── custom/           # 自定义插件
│   ├── startup/              # 启动脚本
│   ├── macroscripts/         # 宏脚本（.mcr）
│   ├── projects/             # 实际项目文件
│   └── docs/                 # 文档
│
├── Blender/
│   ├── addons/               # Blender 插件
│   │   ├── export/           # 导出插件
│   │   ├── modeling/         # 建模插件
│   │   └── animation/        # 动画插件
│   ├── scripts/              # Python 脚本
│   │   ├── automation/       # 自动化脚本
│   │   ├── batch/            # 批处理
│   │   └── utils/            # 工具脚本
│   ├── projects/             # .blend 文件
│   ├── presets/              # 预设
│   └── docs/                 # 文档
│
├── Houdini/
│   ├── hda/                  # Digital Assets（插件）
│   │   ├── modeling/
│   │   ├── effects/
│   │   └── export/
│   ├── scripts/              # Python/VEX 脚本
│   │   ├── python/
│   │   ├── vex/
│   │   └── shelf/
│   ├── hip/                  # 项目文件
│   ├── exports/              # 导出缓存
│   └── docs/
│
├── Maya/
│   ├── scripts/              # MEL/Python 脚本
│   │   ├── mel/
│   │   ├── python/
│   │   └── shelf/
│   ├── plugins/              # Maya 插件（.mll, .py）
│   │   ├── modeling/
│   │   ├── rigging/
│   │   └── animation/
│   ├── projects/             # .ma/.mb 文件
│   └── docs/
│
├── Substance/
│   ├── Designer/
│   │   ├── materials/        # 材质文件（.sbs）
│   │   ├── scripts/          # Python 脚本
│   │   │   ├── automation/
│   │   │   └── export/
│   │   ├── plugins/          # 插件
│   │   ├── presets/          # 预设
│   │   └── docs/
│   └── Painter/
│       ├── projects/         # 项目文件
│       ├── scripts/          # Python 脚本
│       ├── plugins/          # 插件
│       └── smart_materials/  # 智能材质
│
├── TouchDesigner/
│   ├── projects/             # .toe 文件
│   ├── components/           # 组件（.tox）
│   │   ├── effects/
│   │   ├── generators/
│   │   └── utils/
│   ├── scripts/              # Python 脚本
│   │   ├── automation/
│   │   ├── osc/
│   │   └── utils/
│   ├── plugins/              # 插件
│   └── docs/
│
├── Photoshop/
│   ├── scripts/              # JSX 脚本
│   │   ├── export/           # 导出脚本
│   │   ├── batch/            # 批处理
│   │   ├── spine/            # Spine 相关
│   │   └── utils/            # 工具脚本
│   ├── plugins/              # 插件（.8bf, .8li）
│   │   ├── filters/
│   │   └── automation/
│   ├── actions/              # 动作（.atn）
│   ├── presets/              # 预设
│   └── docs/
│
└── Spine/
    ├── projects/             # Spine 项目文件
    ├── scripts/              # 脚本
    │   ├── batch_export/     # 批量导出
    │   ├── automation/       # 自动化
    │   └── mcp_server/       # MCP 服务器
    ├── plugins/              # Spine 插件
    ├── exports/              # 导出文件
    │   ├── json/
    │   ├── atlas/
    │   └── images/
    └── docs/
```

#### 1.2 创建 GameEngines 分类（细分脚本和插件）

```
projects/GameEngines/
├── Cocos2D/
│   ├── scripts/             # JavaScript 脚本
│   │   ├── components/      # 组件
│   │   ├── effects/         # 特效
│   │   ├── ui/              # UI
│   │   └── utils/           # 工具
│   ├── plugins/             # Cocos 插件
│   ├── projects/            # 实际项目
│   └── docs/
│
├── Unity/
│   ├── scripts/             # C# 脚本
│   │   ├── editor/          # 编辑器脚本
│   │   ├── runtime/         # 运行时脚本
│   │   └── tools/           # 工具脚本
│   ├── plugins/             # Unity 插件
│   │   ├── native/          # 原生插件（.dll, .so）
│   │   └── managed/         # 托管插件
│   ├── shaders/             # 着色器
│   ├── editor_tools/        # 编辑器工具
│   └── docs/
│
└── Unreal/
    ├── plugins/             # Unreal 插件
    │   ├── editor/          # 编辑器插件
    │   └── runtime/         # 运行时插件
    ├── scripts/             # Python 脚本
    │   ├── editor/
    │   └── automation/
    ├── cpp/                 # C++ 代码
    │   ├── source/
    │   └── public/
    ├── blueprints/          # 蓝图
    ├── content/             # 内容资源
    └── docs/
```

#### 1.3 创建 Pipelines 分类
```
projects/Pipelines/
├── Max_to_Unity/
│   ├── exporters/
│   ├── importers/
│   └── docs/
│
├── Blender_to_Spine/
│   ├── addon/
│   ├── scripts/
│   └── docs/
│
├── PS_to_Spine/
│   ├── jsx_scripts/
│   └── docs/
│
└── Houdini_to_Engine/
    ├── hda/
    └── docs/
```

#### 1.4 创建 Products 分类
```
projects/Products/
└── SecondMind/          # 从 projects/SecondMind-Product/ 移动
    ├── design/
    ├── prototype/
    └── docs/
```

---

### Phase 2: 迁移现有内容

#### 2.1 Cocos_2D → GameEngines/Cocos2D/
**源**: `projects/Cocos_2D/`  
**目标**: `projects/GameEngines/Cocos2D/`

**文件清单**:
- ✅ CoinFlyAnimation.js
- ✅ CoinFlyAnimation_Simple.js
- ✅ CoinFlyAnimation_RoyalMatch.js
- ✅ CoinFlyExample.js
- ✅ CoinFlyExample_RoyalMatch.js
- ✅ CoinTest_Fixed.js
- ✅ CoinTest_Simple.js
- ✅ SkeletonExt.js
- ✅ README-CoinFly.md
- ✅ 使用教程-金币飞行.md
- ✅ 金币飞行-调试清单.md
- ✅ TestButton配置说明.md

**新结构**:
```
GameEngines/Cocos2D/
├── components/
│   ├── CoinFly/
│   │   ├── CoinFlyAnimation.js
│   │   ├── CoinFlyAnimation_Simple.js
│   │   ├── CoinFlyAnimation_RoyalMatch.js
│   │   ├── CoinFlyExample.js
│   │   ├── CoinFlyExample_RoyalMatch.js
│   │   ├── CoinTest_Fixed.js
│   │   └── CoinTest_Simple.js
│   └── Skeleton/
│       └── SkeletonExt.js
└── docs/
    ├── README-CoinFly.md
    ├── 使用教程-金币飞行.md
    ├── 金币飞行-调试清单.md
    └── TestButton配置说明.md
```

---

#### 2.2 Spine → DCC_Tools/Spine/
**源**: `projects/Spine/`  
**目标**: `projects/DCC_Tools/Spine/`

**文件清单**:
- ✅ Spine_Script/ (批量导出脚本)
- ✅ SpineMCP/ (MCP 服务器)

**新结构**:
```
DCC_Tools/Spine/
├── scripts/
│   ├── batch_export/
│   │   ├── Spine批量导出.bat
│   │   ├── Spine批量导出.ps1
│   │   ├── 运行Spine批量导出.bat
│   │   └── Spine批量导出指南.md
│   └── mcp_server/
│       ├── server.py
│       ├── requirements.txt
│       ├── example-config.json
│       └── README.md
├── projects/
└── exports/
```

---

#### 2.3 Houdini → DCC_Tools/Houdini/
**源**: `projects/Houdini/` (新建的)  
**目标**: `projects/DCC_Tools/Houdini/`

**保持**: README.md 和文件夹结构

---

#### 2.4 Substance_Designer → DCC_Tools/Substance/Designer/
**源**: `projects/Substance_Designer/`  
**目标**: `projects/DCC_Tools/Substance/Designer/`

**保持**: README.md 和文件夹结构

---

#### 2.5 TouchDesigner → DCC_Tools/TouchDesigner/
**源**: `projects/TouchDesigner/`  
**目标**: `projects/DCC_Tools/TouchDesigner/`

**保持**: README.md 和文件夹结构

---

#### 2.6 SecondMind-Product → Products/SecondMind/
**源**: `projects/SecondMind-Product/`  
**目标**: `projects/Products/SecondMind/`

**文件清单**:
- ✅ IDEAS-BRAINSTORM.md
- ✅ PRODUCT-FRAMEWORK.md
- ✅ README.md

---

### Phase 3: 整合 scripts/ 文件夹

#### 3.1 scripts/3dsmax/ → DCC_Tools/3dsMax/scripts/
**迁移所有内容**:
- ✅ scripts/
- ✅ plugins/
- ✅ startup/
- ✅ README.md

---

#### 3.2 scripts/blender/ → DCC_Tools/Blender/
**分类整理**:
```
DCC_Tools/Blender/
├── addons/
│   └── Blender_to_Spine_2D_Mesh_Export_Addon-main/
├── scripts/
│   └── Blender_CollisionAnimation.py
└── docs/
    ├── AI工作流/
    │   ├── 3D角色一致性动画生成方案.md
    │   ├── AI序列帧Spine动画完整工作流方案.md
    │   ├── 游戏角色动画AI方案-序列帧输出.md
    │   └── 视频转骨骼动画方案汇总.md
    ├── ComfyUI/
    │   ├── ComfyUI-IPAdapter快速参考.md
    │   ├── ComfyUI角色一致性动画生成方案.md
    │   └── ComfyUI实战总结和经验教训.md
    ├── Spine工作流/
    │   ├── Blender-Spine工作流自动化改进方案.md
    │   ├── FBX2Spine完整使用教程.md
    │   └── Mixamo-Blender-Spine完整测试流程.md
    └── README.md
```

---

#### 3.3 scripts/photoshop/ → DCC_Tools/Photoshop/scripts/
**迁移所有内容**:
- ✅ 所有 .jsx 脚本
- ✅ 所有 .py 脚本
- ✅ PS_Script/ 文件夹

---

#### 3.4 scripts/windows/ → 保持原位置
**原因**: Windows 工具是通用的，不属于特定 DCC 工具

---

### Phase 4: 创建跨工具管道

#### 4.1 Blender → Spine 管道
**源**: 
- `DCC_Tools/Blender/addons/Blender_to_Spine_2D_Mesh_Export_Addon-main/`
- `DCC_Tools/Blender/docs/Spine工作流/`

**目标**: `projects/Pipelines/Blender_to_Spine/`

**内容**:
- Blender 插件
- 导出脚本
- 工作流文档
- 测试案例

---

#### 4.2 Photoshop → Spine 管道
**源**: 
- `DCC_Tools/Photoshop/scripts/PS_图层导出PNG_Spine.jsx`
- `DCC_Tools/Photoshop/scripts/PS_导出到Spine.jsx`
- `DCC_Tools/Photoshop/scripts/PhotoshopToSpine.jsx`

**目标**: `projects/Pipelines/PS_to_Spine/`

---

#### 4.3 3ds Max → Unity/Unreal 管道
**源**: 
- `DCC_Tools/3dsMax/scripts/BatchExportFBX.ms`

**目标**: `projects/Pipelines/Max_to_Engine/`

---

## 🔄 执行步骤

### Step 1: 备份
```bash
# 创建备份
git add .
git commit -m "备份：重组前的完整状态"
git tag backup-before-reorganization
```

### Step 2: 创建新结构
```bash
# 创建主文件夹
mkdir projects/DCC_Tools
mkdir projects/GameEngines
mkdir projects/Pipelines
mkdir projects/Products
```

### Step 3: 逐步迁移
- 一次迁移一个工具
- 每次迁移后测试
- 确认无误后继续

### Step 4: 更新文档
- 更新所有 README
- 更新路径引用
- 更新脚本中的路径

### Step 5: 清理
- 删除空文件夹
- 更新 .gitignore
- 提交最终版本

---

## 📝 注意事项

### 路径引用
- 检查所有脚本中的路径引用
- 更新相对路径
- 更新文档中的路径

### 文档更新
- README.md
- 使用指南
- 配置文件

### Git 历史
- 使用 `git mv` 保留历史
- 分批提交
- 清晰的提交信息

---

## ✅ 验证清单

- [ ] 所有文件都已迁移
- [ ] 没有文件丢失
- [ ] 路径引用已更新
- [ ] 文档已更新
- [ ] 脚本可以正常运行
- [ ] Git 历史完整
- [ ] 新结构清晰易懂

---

## ✅ 执行完成

**执行日期**: 2026-01-29  
**状态**: 已完成  

### 已完成的任务

1. ✅ 创建备份（git tag: backup-before-ta-reorganization）
2. ✅ 创建新文件夹结构
   - `projects/DCC_Tools/` (3dsMax, Blender, Photoshop, Spine 等)
   - `projects/GameEngines/` (Cocos2D, Unity, Unreal)
   - `projects/Pipelines/` (跨工具管道)
   - `projects/Products/` (产品)
3. ✅ 迁移所有内容
   - Cocos2D → GameEngines/Cocos2D/
   - Spine → DCC_Tools/Spine/
   - 3ds Max 脚本 → DCC_Tools/3dsMax/
   - Blender 插件和文档 → DCC_Tools/Blender/
   - Photoshop 脚本 → DCC_Tools/Photoshop/
   - SecondMind → Products/SecondMind/
4. ✅ 删除空的旧文件夹
5. ✅ Git 提交（保留完整历史）

### 新结构特点

- **按 DCC 工具分类**：每个工具有独立文件夹
- **细分 scripts/ 和 plugins/**：便于管理和查找
- **清晰的 TA 工作流导向**：美术侧（DCC_Tools）、程序侧（GameEngines）、管道（Pipelines）
- **保留完整 Git 历史**：所有文件移动都使用 `git mv`

---

**创建日期**: 2026-01-29  
**完成日期**: 2026-01-29  
**实际时间**: 约 1 小时
