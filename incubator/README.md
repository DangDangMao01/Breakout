# 🚀 项目孵化器（Incubator）

**定位**: 管理项目从想法到独立开发的完整生命周期  
**日期**: 2026-01-29  
**版本**: v1.0

---

## 📖 什么是孵化器？

孵化器是一个**项目全生命周期管理系统**，用于：

1. **想法验证**：快速验证项目可行性
2. **原型开发**：开发可玩的 Demo
3. **迭代优化**：根据反馈持续改进
4. **市场调研**：分析竞品和市场机会
5. **项目独立**：成熟后迁移到独立 Git 仓库

---

## 🗂️ 文件夹结构

```
incubator/
├── README.md                     # 本文件
├── templates/                    # 项目模板
│   ├── game-cocos2d/             # Cocos2D 游戏模板
│   ├── game-unity/               # Unity 游戏模板
│   └── app-mobile/               # 移动 App 模板
│
├── research/                     # 通用市场调研（所有项目共享）
│   ├── competitors/              # 竞品分析
│   │   ├── template.md           # 竞品分析模板
│   │   └── examples/             # 示例分析
│   ├── market-data/              # 市场数据
│   │   ├── 2d-games-2026.md      # 2D 游戏市场
│   │   ├── casual-games-2026.md  # 休闲游戏市场
│   │   └── mobile-games-2026.md  # 移动游戏市场
│   ├── references/               # 参考资料
│   │   ├── successful-indies.md  # 成功的独立游戏
│   │   └── game-design-patterns.md # 游戏设计模式
│   └── insights/                 # 洞察总结
│       ├── what-works.md         # 什么有效
│       └── opportunities.md      # 市场机会点
│
├── ideas/                        # 项目想法池
│   ├── README.md                 # 想法池说明
│   └── [idea-name].md            # 每个想法一个文件
│
├── active/                       # 活跃项目（正在开发）
│   └── SugarRush2D/              # 示例：Sugar Rush 2D 项目
│       ├── README.md             # 项目概述
│       ├── research/             # 项目专属调研
│       │   ├── competitors.md    # 竞品分析
│       │   ├── target-users.md   # 目标用户
│       │   └── references.md     # 参考资料链接
│       ├── design/               # 策划文档
│       │   ├── 01-项目概述.md
│       │   ├── 02-核心玩法.md
│       │   ├── 03-关卡设计.md
│       │   ├── 04-角色和道具.md
│       │   ├── 05-数值策划.md
│       │   ├── 06-美术需求.md
│       │   ├── 07-开发计划.md
│       │   └── 99-更新日志.md
│       ├── cocos-project/        # Cocos2D 项目（可用引擎打开）
│       │   ├── assets/
│       │   ├── settings/
│       │   └── project.json
│       ├── assets-source/        # 美术源文件
│       │   ├── psd/              # Photoshop 文件
│       │   ├── spine/            # Spine 项目
│       │   └── exports/          # 导出的资源
│       ├── tests/                # 测试记录
│       │   ├── playtest-notes/   # 玩家测试笔记
│       │   └── bug-reports/      # Bug 报告
│       ├── marketing/            # 营销素材
│       │   ├── screenshots/      # 截图
│       │   ├── videos/           # 视频
│       │   └── press-kit/        # 媒体资料包
│       └── postmortem/           # 复盘总结
│           └── lessons-learned.md
│
├── archived/                     # 归档项目（失败/暂停）
│   └── [project-name]/
│       ├── README.md             # 归档原因
│       └── [原项目文件]
│
├── graduated/                    # 已独立项目记录
│   └── [project-name].md         # 独立后的信息（Git 地址、发布状态等）
│
└── shared/                       # 共享资源（所有项目可用）
    ├── art/                      # 通用美术资源
    │   ├── ui/                   # UI 素材
    │   ├── effects/              # 特效
    │   └── audio/                # 音效
    ├── scripts/                  # 通用脚本
    │   ├── cocos2d/              # Cocos2D 工具
    │   └── unity/                # Unity 工具
    └── docs/                     # 通用文档
        ├── best-practices.md     # 最佳实践
        └── common-issues.md      # 常见问题
```

---

## 🎯 项目生命周期

### 阶段 1: 想法（Ideas）

**目标**: 快速记录和评估想法

**流程**:
1. 在 `ideas/` 创建想法文件
2. 简单描述（一句话 + 核心玩法）
3. 初步评估（可行性、市场、资源）
4. 决定是否立项

**示例**: `ideas/sugar-rush-2d.md`

---

### 阶段 2: 立项（Active）

**目标**: 开始开发，验证可行性

**流程**:
1. 从 `ideas/` 移动到 `active/`
2. 创建完整的项目结构
3. 进行市场调研（`research/`）
4. 编写策划文档（`design/`）
5. 创建引擎项目（`cocos-project/`）
6. 开发原型

**关键点**:
- ✅ 项目是完整的 Cocos2D/Unity 项目
- ✅ 可以用引擎打开和编辑
- ✅ 策划文档随开发持续更新
- ✅ 市场调研指导设计决策

---

### 阶段 3: 测试（Tests）

**目标**: 收集反馈，迭代优化

**流程**:
1. 内部测试（自己玩）
2. 小范围测试（朋友、同事）
3. 记录反馈（`tests/playtest-notes/`）
4. 修复 Bug（`tests/bug-reports/`）
5. 迭代优化

---

### 阶段 4: 发布准备（Marketing）

**目标**: 准备发布素材

**流程**:
1. 制作截图和视频
2. 准备媒体资料包
3. 编写游戏介绍
4. 准备应用商店素材

---

### 阶段 5: 独立（Graduated）

**目标**: 项目成熟，迁移到独立仓库

**流程**:
1. 创建独立 Git 仓库
2. 迁移代码和资源
3. 在 `graduated/` 记录信息
4. 继续在独立仓库开发

**示例**: `graduated/sugar-rush-2d.md`
```markdown
# Sugar Rush 2D

**独立日期**: 2026-03-15  
**Git 仓库**: https://github.com/yourname/sugar-rush-2d  
**发布状态**: 已上线 iOS/Android  
**下载量**: 10,000+  
**评分**: 4.5/5.0
```

---

### 阶段 6: 归档（Archived）

**目标**: 暂停或失败的项目

**原因**:
- 技术难度太高
- 市场验证失败
- 资源不足
- 方向调整

**流程**:
1. 移动到 `archived/`
2. 编写归档原因
3. 总结经验教训
4. 保留所有资料（未来可能重启）

---

## 📊 市场调研指南

### 通用调研（`research/`）

#### 1. 竞品分析（`competitors/`）

**模板**: `research/competitors/template.md`

**内容**:
- 游戏名称和类型
- 核心玩法
- 美术风格
- 盈利模式
- 优点和缺点
- 可借鉴的点

**示例**:
- Temple Run（跑酷）
- Candy Crush（三消）
- Super Mario Run（平台跑酷）

---

#### 2. 市场数据（`market-data/`）

**内容**:
- 市场规模
- 增长趋势
- 用户画像
- 热门品类
- 成功案例

**来源**:
- App Annie
- Sensor Tower
- Newzoo
- 游戏媒体报道

---

#### 3. 参考资料（`references/`）

**内容**:
- 成功的独立游戏案例
- 游戏设计模式
- 开发经验分享
- 技术文章

---

#### 4. 洞察总结（`insights/`）

**what-works.md** - 什么有效：
- 简单易上手的玩法
- 清晰的视觉反馈
- 合理的难度曲线
- 社交分享功能

**opportunities.md** - 市场机会点：
- 未被满足的需求
- 可以改进的地方
- 新的玩法组合

---

### 项目专属调研（`active/[project]/research/`）

#### 1. 竞品分析（`competitors.md`）

针对具体项目的竞品分析：
- 直接竞品（同类型游戏）
- 间接竞品（类似玩法）
- 差异化策略

#### 2. 目标用户（`target-users.md`）

- 年龄段
- 游戏偏好
- 付费意愿
- 游戏时长

#### 3. 参考资料（`references.md`）

- 相关游戏的链接
- 设计文章
- 技术方案
- 美术参考

---

## 📝 策划文档指南

### 策划文档结构（`design/`）

#### 01-项目概述.md
```markdown
# 项目概述

## 一句话介绍
一个糖果主题的 2D 平台跑酷游戏

## 核心体验
玩家控制角色在糖果世界中奔跑、跳跃、收集糖果

## 目标平台
iOS / Android

## 开发周期
2 个月（2026-02 ~ 2026-03）
```

---

#### 02-核心玩法.md
```markdown
# 核心玩法

## 玩家做什么？
- 奔跑：自动向前跑
- 跳跃：点击屏幕跳跃
- 收集：收集糖果得分
- 躲避：躲避障碍物

## 游戏目标
- 跑得越远越好
- 收集越多糖果越好
- 解锁新角色和道具
```

---

#### 03-关卡设计.md
```markdown
# 关卡设计

## 关卡列表
1. 糖果森林（简单）
2. 巧克力山脉（中等）
3. 棉花糖云层（困难）

## 难度曲线
- 前 500 米：简单，让玩家熟悉操作
- 500-1000 米：中等，增加障碍物
- 1000 米+：困难，快速移动
```

---

#### 04-角色和道具.md
```markdown
# 角色和道具

## 角色
- 糖果小熊（默认）
- 巧克力兔子（解锁）
- 棉花糖猫咪（解锁）

## 道具
- 加速糖果：短时间加速
- 护盾糖果：免疫一次伤害
- 磁铁糖果：自动吸收糖果

## 障碍物
- 石头：需要跳跃
- 坑洞：需要跳跃
- 移动平台：需要时机
```

---

#### 05-数值策划.md
```markdown
# 数值策划

## 分数系统
- 跑 1 米 = 1 分
- 收集 1 个糖果 = 10 分
- 使用道具 = 额外加分

## 生命值
- 初始生命：3
- 碰到障碍物：-1
- 生命为 0：游戏结束

## 解锁条件
- 巧克力兔子：累计 1000 分
- 棉花糖猫咪：累计 5000 分
```

---

#### 06-美术需求.md
```markdown
# 美术需求

## 角色
- 3 个角色（正面、侧面、跳跃）
- Spine 骨骼动画（跑、跳、受伤）

## 场景
- 3 个场景背景（森林、山脉、云层）
- 无限滚动

## UI
- 主菜单
- 游戏界面（分数、生命值）
- 结算界面

## 道具和障碍物
- 3 种道具
- 3 种障碍物
```

---

#### 07-开发计划.md
```markdown
# 开发计划

## 第 1 周（2026-02-03 ~ 02-09）
- [ ] 搭建 Cocos2D 项目
- [ ] 实现角色移动和跳跃
- [ ] 实现无限滚动背景

## 第 2 周（2026-02-10 ~ 02-16）
- [ ] 实现障碍物生成
- [ ] 实现碰撞检测
- [ ] 实现分数系统

## 第 3 周（2026-02-17 ~ 02-23）
- [ ] 实现道具系统
- [ ] 实现角色解锁
- [ ] 制作美术资源

## 第 4 周（2026-02-24 ~ 03-02）
- [ ] UI 界面
- [ ] 音效和音乐
- [ ] 测试和优化

## 第 5-8 周（2026-03-03 ~ 03-30）
- [ ] 内部测试
- [ ] 修复 Bug
- [ ] 准备发布
```

---

#### 99-更新日志.md
```markdown
# 更新日志

## 2026-02-05
- 创建项目
- 完成角色移动

## 2026-02-08
- 实现跳跃功能
- 调整跳跃手感

## 2026-02-12
- 添加障碍物
- 实现碰撞检测
```

---

## 🎮 引擎项目说明

### Cocos2D 项目（`cocos-project/`）

**重要**: 这是一个**完整的 Cocos2D 项目**，可以用 Cocos Creator 打开和编辑。

**结构**:
```
cocos-project/
├── assets/              # 资源文件
│   ├── scenes/          # 场景
│   ├── scripts/         # 脚本
│   ├── textures/        # 纹理
│   └── prefabs/         # 预制体
├── settings/            # 项目设置
├── project.json         # 项目配置
└── README.md            # 项目说明
```

**工作流**:
1. 用 Cocos Creator 打开 `cocos-project/`
2. 编辑场景、脚本、资源
3. 测试和调试
4. 构建发布

---

### Unity 项目（`unity-project/`）

类似 Cocos2D，也是完整的 Unity 项目。

---

## 🎨 美术源文件（`assets-source/`）

**目的**: 保存美术源文件，方便修改和导出

**结构**:
```
assets-source/
├── psd/                 # Photoshop 文件
│   ├── characters/      # 角色
│   ├── ui/              # UI
│   └── props/           # 道具
├── spine/               # Spine 项目
│   ├── character1/
│   └── character2/
└── exports/             # 导出的资源
    ├── png/             # PNG 图片
    └── atlas/           # 图集
```

**工作流**:
1. 在 Photoshop 制作美术资源
2. 保存 PSD 到 `psd/`
3. 导出 PNG 到 `exports/png/`
4. 在 Spine 制作动画
5. 导出到 `exports/atlas/`
6. 复制到 `cocos-project/assets/`

---

## 📦 项目模板（`templates/`）

### game-cocos2d/

**包含**:
- 基础的 Cocos2D 项目结构
- 常用脚本（场景管理、音效管理）
- UI 框架
- 配置文件

**使用**:
```bash
# 复制模板
cp -r templates/game-cocos2d/ active/MyNewGame/cocos-project/

# 重命名项目
# 修改 project.json
```

---

### game-unity/

类似 Cocos2D 模板，但用于 Unity 项目。

---

### app-mobile/

用于移动 App 项目（非游戏）。

---

## 🚀 快速开始

### 创建新项目

#### Step 1: 从想法开始
```bash
# 创建想法文件
touch ideas/my-game-idea.md
```

编辑 `ideas/my-game-idea.md`:
```markdown
# 我的游戏想法

## 一句话介绍
一个 XXX 类型的游戏

## 核心玩法
玩家做什么？

## 为什么做这个？
- 市场机会
- 个人兴趣
- 技术可行性

## 初步评估
- 开发周期：X 周
- 技术难度：简单/中等/困难
- 市场潜力：低/中/高
```

---

#### Step 2: 立项
```bash
# 创建项目文件夹
mkdir -p active/MyGame/{research,design,cocos-project,assets-source,tests,marketing,postmortem}
```

---

#### Step 3: 市场调研
```bash
# 创建调研文档
touch active/MyGame/research/competitors.md
touch active/MyGame/research/target-users.md
touch active/MyGame/research/references.md
```

---

#### Step 4: 编写策划文档
```bash
# 创建策划文档
cd active/MyGame/design/
touch 01-项目概述.md
touch 02-核心玩法.md
touch 03-关卡设计.md
touch 04-角色和道具.md
touch 05-数值策划.md
touch 06-美术需求.md
touch 07-开发计划.md
touch 99-更新日志.md
```

---

#### Step 5: 创建引擎项目
```bash
# 复制模板
cp -r ../../templates/game-cocos2d/* cocos-project/

# 用 Cocos Creator 打开
# 开始开发！
```

---

## 📋 最佳实践

### 1. 策划文档持续更新
- 不要一次性写完
- 随着开发不断调整
- 记录所有改动（`99-更新日志.md`）

### 2. 市场调研先行
- 立项前先做调研
- 了解竞品和市场
- 找到差异化点

### 3. 快速原型验证
- 先做最小可玩版本
- 验证核心玩法
- 再完善其他功能

### 4. 定期测试反馈
- 自己玩
- 给朋友玩
- 记录反馈
- 快速迭代

### 5. 及时归档失败项目
- 不要拖着
- 总结经验教训
- 保留资料（未来可能重启）

---

## 🎯 与 `projects/` 的区别

### `projects/` - TA 工具库
- **定位**: Technical Artist 开发工程
- **内容**: 脚本、插件、工具
- **用途**: 服务游戏开发的所有岗位
- **特点**: 可复用的工具和资源

### `incubator/` - 项目孵化器
- **定位**: 项目全生命周期管理
- **内容**: 完整的游戏/App 项目
- **用途**: 从想法到独立开发
- **特点**: 独立的、可运行的项目

**关系**:
- `incubator/` 的项目会使用 `projects/` 的工具
- 例如：Sugar Rush 2D 使用 `projects/DCC_Tools/Spine/` 的导出工具

---

## 📞 常见问题

### Q: 项目什么时候应该独立？
A: 当项目满足以下条件时：
- 核心功能完成
- 准备发布或已发布
- 需要独立的版本管理
- 团队规模扩大

### Q: 失败的项目怎么办？
A: 移动到 `archived/`，总结经验教训，保留资料。

### Q: 可以同时开发多个项目吗？
A: 可以，但建议专注 1-2 个项目，避免分散精力。

### Q: 市场调研要做多久？
A: 1-2 周，不要过度调研，快速验证想法更重要。

---

## 📚 相关文档

- `REORGANIZATION-PLAN-TA-WORKFLOW.md` - TA 工程重组计划
- `knowledge-base/notes/20260129-Kiro游戏开发最佳实践.md` - Kiro 游戏开发指南
- `projects/` - TA 工具库

---

**创建日期**: 2026-01-29  
**版本**: v1.0  
**维护者**: 你的名字

