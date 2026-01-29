# 📊 市场调研中心

**定位**: 通用市场调研资源，所有项目共享  
**日期**: 2026-01-29

---

## 📖 什么是市场调研中心？

这里存放**通用的市场调研资源**，包括：
- 竞品分析模板和示例
- 市场数据和趋势报告
- 成功案例和参考资料
- 行业洞察和机会点

**与项目专属调研的区别**:
- **这里**: 通用的、可复用的调研资源
- **项目文件夹**: 针对具体项目的调研（`active/[project]/research/`）

---

## 🗂️ 文件夹结构

```
research/
├── README.md                     # 本文件
├── competitors/                  # 竞品分析
│   ├── template.md               # 竞品分析模板
│   └── examples/                 # 示例分析
│       ├── temple-run.md         # Temple Run 分析
│       ├── candy-crush.md        # Candy Crush 分析
│       └── super-mario-run.md    # Super Mario Run 分析
│
├── market-data/                  # 市场数据
│   ├── 2d-games-2026.md          # 2D 游戏市场
│   ├── casual-games-2026.md      # 休闲游戏市场
│   ├── mobile-games-2026.md      # 移动游戏市场
│   └── indie-games-2026.md       # 独立游戏市场
│
├── references/                   # 参考资料
│   ├── successful-indies.md      # 成功的独立游戏
│   ├── game-design-patterns.md   # 游戏设计模式
│   ├── monetization-models.md    # 盈利模式
│   └── marketing-strategies.md   # 营销策略
│
└── insights/                     # 洞察总结
    ├── what-works.md             # 什么有效
    ├── opportunities.md          # 市场机会点
    └── common-mistakes.md        # 常见错误
```

---

## 🎯 如何使用

### 1. 开始新项目时

**Step 1**: 阅读市场数据
```bash
# 了解市场趋势
cat research/market-data/2d-games-2026.md
cat research/market-data/casual-games-2026.md
```

**Step 2**: 参考竞品分析
```bash
# 学习如何分析竞品
cat research/competitors/template.md

# 查看示例
cat research/competitors/examples/temple-run.md
```

**Step 3**: 创建项目专属调研
```bash
# 在项目文件夹创建调研文档
cd active/MyGame/research/
touch competitors.md
touch target-users.md
touch references.md
```

---

### 2. 寻找灵感时

**查看成功案例**:
```bash
cat research/references/successful-indies.md
```

**查看市场机会**:
```bash
cat research/insights/opportunities.md
```

---

### 3. 避免常见错误

**查看常见错误**:
```bash
cat research/insights/common-mistakes.md
```

---

## 📝 竞品分析模板

### 使用方法

1. 复制 `competitors/template.md`
2. 填写竞品信息
3. 保存到项目文件夹（`active/[project]/research/competitors.md`）

### 模板内容

参见 `competitors/template.md`

---

## 📊 市场数据来源

### 推荐数据源

#### 1. 应用商店数据
- **App Annie**: https://www.appannie.com/
- **Sensor Tower**: https://sensortower.com/
- **App Store**: 直接查看排行榜

#### 2. 游戏行业报告
- **Newzoo**: https://newzoo.com/
- **Statista**: https://www.statista.com/
- **GDC Reports**: https://www.gdconf.com/

#### 3. 游戏媒体
- **Gamasutra**: https://www.gamasutra.com/
- **Polygon**: https://www.polygon.com/
- **IGN**: https://www.ign.com/

#### 4. 社区和论坛
- **Reddit**: r/gamedev, r/IndieGaming
- **Discord**: 游戏开发社区
- **Twitter**: 关注游戏开发者

---

## 🔍 调研方法

### 1. 竞品分析

**步骤**:
1. 下载并玩竞品游戏（至少 1 小时）
2. 记录核心玩法和特色
3. 分析优点和缺点
4. 找到可借鉴的点
5. 确定差异化策略

**工具**:
- 截图工具（SETUNA）
- 录屏工具（OBS）
- 笔记工具（Markdown）

---

### 2. 市场数据收集

**步骤**:
1. 查看应用商店排行榜
2. 阅读行业报告
3. 关注游戏媒体报道
4. 参与社区讨论
5. 整理数据和趋势

**关注指标**:
- 下载量
- 收入
- 用户评分
- 用户评论
- 更新频率

---

### 3. 用户调研

**方法**:
- 问卷调查
- 用户访谈
- 社区讨论
- 玩家测试

**问题示例**:
- 你喜欢玩什么类型的游戏？
- 你每天玩游戏多长时间？
- 你愿意为游戏付费吗？
- 你最喜欢的游戏是什么？为什么？

---

## 📈 调研报告模板

### 项目专属调研报告

**文件**: `active/[project]/research/competitors.md`

**结构**:
```markdown
# [项目名] 竞品分析

## 直接竞品

### 竞品 1: [游戏名]
- 核心玩法
- 美术风格
- 盈利模式
- 优点
- 缺点
- 可借鉴的点

### 竞品 2: [游戏名]
...

## 间接竞品

### 竞品 3: [游戏名]
...

## 差异化策略

我们的游戏与竞品的区别：
- 玩法创新
- 美术风格
- 目标用户
- 盈利模式

## 市场定位

- 目标用户：XXX
- 市场空白：XXX
- 竞争优势：XXX
```

---

## 🎯 调研清单

### 立项前必做

- [ ] 阅读市场数据（了解市场规模和趋势）
- [ ] 分析 3-5 个竞品（直接竞品 + 间接竞品）
- [ ] 确定目标用户（年龄、偏好、付费意愿）
- [ ] 找到差异化点（我们的游戏有什么不同？）
- [ ] 评估技术可行性（能做出来吗？）
- [ ] 评估资源需求（需要多少时间和人力？）

### 开发中持续

- [ ] 关注竞品更新（学习和借鉴）
- [ ] 收集用户反馈（玩家测试）
- [ ] 调整设计方向（根据反馈迭代）
- [ ] 关注市场变化（新的趋势和机会）

### 发布前

- [ ] 最终竞品对比（我们的优势是什么？）
- [ ] 目标用户验证（真的有人喜欢吗？）
- [ ] 营销策略制定（如何推广？）
- [ ] 定价策略（免费 + IAP？付费？）

---

## 💡 调研技巧

### 1. 不要过度调研
- 调研 1-2 周就够了
- 快速验证想法更重要
- 边做边调整

### 2. 关注核心问题
- 市场有需求吗？
- 我们能做出来吗？
- 有什么差异化？

### 3. 实际体验竞品
- 不要只看介绍
- 亲自玩至少 1 小时
- 记录真实感受

### 4. 多渠道收集信息
- 应用商店
- 游戏媒体
- 社区论坛
- 用户评论

### 5. 定期更新调研
- 市场在变化
- 竞品在更新
- 保持信息新鲜

---

## 📚 相关文档

- `incubator/README.md` - 孵化器使用指南
- `incubator/templates/` - 项目模板
- `active/[project]/research/` - 项目专属调研

---

**创建日期**: 2026-01-29  
**版本**: v1.0

