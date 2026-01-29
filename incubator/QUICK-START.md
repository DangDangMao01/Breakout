# 🚀 孵化器快速开始指南

**日期**: 2026-01-29  
**版本**: v1.0

---

## 📖 5 分钟了解孵化器

### 什么是孵化器？

孵化器是一个**项目全生命周期管理系统**，帮助你：
- ✅ 从想法到独立开发
- ✅ 市场调研和竞品分析
- ✅ 策划文档和开发计划
- ✅ 完整的引擎项目（可用引擎打开）
- ✅ 测试、发布、复盘

---

## 🗂️ 文件夹结构（一图看懂）

```
incubator/
├── 📚 research/          # 通用市场调研（所有项目共享）
│   ├── competitors/      # 竞品分析模板和示例
│   ├── market-data/      # 市场数据和趋势
│   ├── references/       # 参考资料和成功案例
│   └── insights/         # 洞察总结（什么有效、市场机会）
│
├── 💡 ideas/             # 项目想法池（快速记录灵感）
│
├── 🚀 active/            # 活跃项目（正在开发）
│   └── SugarRush2D/      # 示例：Sugar Rush 2D 项目
│       ├── research/     # 项目专属调研
│       ├── design/       # 策划文档（7 个文件）
│       ├── cocos-project/# Cocos2D 项目（可用引擎打开）
│       ├── assets-source/# 美术源文件
│       ├── tests/        # 测试记录
│       ├── marketing/    # 营销素材
│       └── postmortem/   # 复盘总结
│
├── 📦 archived/          # 归档项目（失败/暂停）
├── 🎓 graduated/         # 已独立项目记录
├── 🎨 shared/            # 共享资源（通用美术、脚本）
└── 📋 templates/         # 项目模板（Cocos2D、Unity、App）
```

---

## 🎯 项目生命周期（6 个阶段）

```
💡 想法 → 🚀 立项 → 🧪 测试 → 📢 发布 → 🎓 独立 → 📦 归档
(ideas)  (active)  (tests)  (marketing) (graduated) (archived)
```

### 1. 想法阶段（ideas/）
- 快速记录灵感
- 初步评估可行性
- 决定是否立项

### 2. 立项阶段（active/）
- 市场调研
- 策划文档
- 开发原型
- 迭代优化

### 3. 测试阶段（tests/）
- 内部测试
- 玩家测试
- Bug 修复
- 性能优化

### 4. 发布阶段（marketing/）
- 准备素材
- 应用商店上架
- 营销推广

### 5. 独立阶段（graduated/）
- 迁移到独立 Git 仓库
- 持续开发和运营

### 6. 归档阶段（archived/）
- 暂停或失败的项目
- 总结经验教训

---

## 🚀 3 步创建新项目

### Step 1: 记录想法（1 分钟）

```bash
# 创建想法文件
cd incubator/ideas/
touch my-game-idea.md
```

填写模板：
```markdown
# 游戏名称

## 一句话介绍
[描述]

## 核心玩法
[玩法]

## 评估
- 市场需求: ⭐⭐⭐⭐⭐
- 技术可行性: ⭐⭐⭐⭐⭐
- 资源需求: ⭐⭐⭐⭐⭐
- 个人兴趣: ⭐⭐⭐⭐⭐
```

---

### Step 2: 市场调研（1-2 周）

```bash
# 创建项目文件夹
mkdir -p active/MyGame/research
cd active/MyGame/research/
```

**必做调研**:
1. **竞品分析**（`competitors.md`）
   - 分析 3-5 个竞品
   - 找到差异化点
   - 使用模板：`../../research/competitors/template.md`

2. **目标用户**（`target-users.md`）
   - 年龄、性别、偏好
   - 付费意愿

3. **参考资料**（`references.md`）
   - 相关游戏链接
   - 设计文章
   - 技术方案

**参考资源**:
- `research/insights/what-works.md` - 什么有效
- `research/insights/opportunities.md` - 市场机会点

---

### Step 3: 编写策划（1 周）

```bash
# 创建策划文档
cd active/MyGame/design/
```

**7 个策划文档**:
1. `01-项目概述.md` - 一句话介绍
2. `02-核心玩法.md` - 玩家做什么
3. `03-关卡设计.md` - 关卡列表
4. `04-角色和道具.md` - 角色、道具、障碍物
5. `05-数值策划.md` - 分数、生命值
6. `06-美术需求.md` - 需要哪些美术资源
7. `07-开发计划.md` - 时间表

**策划原则**:
- ✅ 简单实用（不要写小说）
- ✅ 随开发更新（不是一次性的）
- ✅ 记录所有改动（`99-更新日志.md`）

---

## 📊 市场调研指南

### 通用调研（research/）

**已准备好的资源**:

1. **竞品分析模板**（`research/competitors/template.md`）
   - 完整的分析框架
   - 直接复制使用

2. **什么有效**（`research/insights/what-works.md`）
   - 成功游戏的共同点
   - 玩法、美术、盈利模式
   - 留存策略

3. **市场机会点**（`research/insights/opportunities.md`）
   - 2026 年游戏市场机会
   - 玩法创新方向
   - 细分市场机会

### 项目专属调研（active/[project]/research/）

**必做 3 件事**:
1. **下载并玩竞品**（至少 1 小时）
2. **填写竞品分析**（使用模板）
3. **确定差异化策略**（我们有什么不同？）

---

## 🎮 示例项目：Sugar Rush 2D

### 项目概述

- **类型**: 2D 平台跑酷
- **主题**: 糖果世界
- **引擎**: Cocos2D
- **开发周期**: 2 个月

### 已完成的工作

✅ 项目立项（`active/SugarRush2D/README.md`）  
✅ 竞品分析（`active/SugarRush2D/research/competitors.md`）  
- 分析了 Temple Run、Subway Surfers、Super Mario Run  
- 确定了差异化策略（糖果主题 + 2D + 简单操作）

### 下一步

- [ ] 完成其他调研文档
- [ ] 编写策划文档
- [ ] 创建 Cocos2D 项目
- [ ] 开发原型

---

## 💡 最佳实践

### 1. 市场调研先行
- ❌ 不要直接开始开发
- ✅ 先做调研，了解市场
- ✅ 找到差异化点

### 2. 策划文档持续更新
- ❌ 不要一次性写完
- ✅ 随开发不断调整
- ✅ 记录所有改动

### 3. 快速原型验证
- ❌ 不要追求完美
- ✅ 先做最小可玩版本
- ✅ 验证核心玩法

### 4. 定期测试反馈
- ❌ 不要闭门造车
- ✅ 给朋友玩
- ✅ 收集反馈，快速迭代

### 5. 及时归档失败项目
- ❌ 不要拖着
- ✅ 总结经验教训
- ✅ 保留资料（未来可能重启）

---

## 🎯 与 projects/ 的区别

### projects/ - TA 工具库
- **定位**: Technical Artist 开发工程
- **内容**: 脚本、插件、工具
- **特点**: 可复用的工具和资源

### incubator/ - 项目孵化器
- **定位**: 项目全生命周期管理
- **内容**: 完整的游戏/App 项目
- **特点**: 独立的、可运行的项目

**关系**:
- `incubator/` 的项目会使用 `projects/` 的工具
- 例如：Sugar Rush 2D 使用 `projects/DCC_Tools/Spine/` 的导出工具

---

## 📚 完整文档

### 核心文档
- `README.md` - 孵化器使用指南（完整版）
- `QUICK-START.md` - 本文件（快速开始）

### 市场调研
- `research/README.md` - 市场调研指南
- `research/competitors/template.md` - 竞品分析模板
- `research/insights/what-works.md` - 什么有效
- `research/insights/opportunities.md` - 市场机会点

### 想法管理
- `ideas/README.md` - 想法池使用指南

### 示例项目
- `active/SugarRush2D/README.md` - 项目概述
- `active/SugarRush2D/research/competitors.md` - 竞品分析

---

## 🚀 立即开始

### 选项 1: 继续 Sugar Rush 2D 项目

```bash
cd incubator/active/SugarRush2D/
# 查看项目概述
cat README.md
# 查看竞品分析
cat research/competitors.md
# 开始编写策划文档
cd design/
```

### 选项 2: 创建你自己的项目

```bash
cd incubator/ideas/
# 创建想法文件
touch my-game-idea.md
# 编辑文件，填写模板
# 评估想法
# 决定是否立项
```

---

## 📞 常见问题

### Q: 孵化器和 projects/ 有什么区别？
A: `projects/` 是 TA 工具库（可复用的工具），`incubator/` 是项目孵化器（完整的游戏项目）。

### Q: 市场调研要做多久？
A: 1-2 周，不要过度调研，快速验证想法更重要。

### Q: 策划文档要写多详细？
A: 简单实用即可，不要写小说。随开发持续更新。

### Q: 项目什么时候应该独立？
A: 当项目准备发布或已发布，需要独立的版本管理时。

### Q: 失败的项目怎么办？
A: 移动到 `archived/`，总结经验教训，保留资料。

---

## 🎉 总结

孵化器帮助你：
- ✅ 系统化管理项目
- ✅ 市场调研指导开发
- ✅ 策划文档持续更新
- ✅ 完整的项目生命周期
- ✅ 从想法到独立开发

**现在就开始你的第一个项目吧！** 🚀

---

**创建日期**: 2026-01-29  
**版本**: v1.0

