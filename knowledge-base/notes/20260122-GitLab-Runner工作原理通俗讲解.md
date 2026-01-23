# GitLab Runner 工作原理 - 通俗讲解

> 日期: 2026-01-22  
> 适合人群: 美术、策划等非后端开发人员  
> 难度: ⭐⭐☆☆☆

---

## 🎯 一句话总结

**GitLab Runner 就像一个"自动执行员工"，当你提交代码到 GitLab 时，它会自动帮你运行指定的任务（比如发送飞书通知）。**

---

## 📖 通俗比喻

### 比喻 1：快递系统

想象一下快递系统：

```
你（美术）  →  快递公司（GitLab）  →  快递员（Runner）  →  收件人（飞书）
   ↓              ↓                    ↓                  ↓
提交资源      接收提交请求         执行配送任务        收到通知
```

1. **你**：提交美术资源到 GitLab（就像寄快递）
2. **GitLab**：接收你的提交，查看配置文件 `.gitlab-ci.yml`（就像快递公司的派单系统）
3. **GitLab Runner**：自动执行任务（就像快递员送货）
4. **飞书**：收到通知（就像收件人收到快递）

### 比喻 2：餐厅点餐系统

```
顾客（你）  →  点餐系统（GitLab）  →  厨师（Runner）  →  上菜（通知）
   ↓              ↓                    ↓                ↓
点菜          接收订单             做菜              送到桌上
```

---

## 🏗️ GitLab Runner 的工作流程

### 第 1 步：你提交代码

```bash
# 你在本地修改了美术资源
git add 角色贴图.png
git commit -m "更新角色贴图"
git push
```

**发生了什么**：
- 你的文件被上传到 GitLab 服务器
- GitLab 收到了一个"提交事件"

---

### 第 2 步：GitLab 查看配置文件

GitLab 会自动查找项目根目录的 `.gitlab-ci.yml` 文件：

```yaml
# .gitlab-ci.yml（配置文件）
notify:
  stage: notify
  script:
    - python notify.py
  only:
    - master
```

**这个文件的意思**：
- `notify:` - 任务名称（就像菜单上的菜名）
- `script:` - 要执行的命令（就像菜谱）
- `only: master` - 只在 master 分支执行（就像只在工作日营业）

---

### 第 3 步：GitLab 分配任务给 Runner

```
GitLab: "有新任务了！谁来执行？"
Runner: "我来！我来！"（举手）
GitLab: "好，给你任务详情..."
```

**任务详情包括**：
- 项目路径：`GroupTwoGame/groupTowArt_Hb`
- 提交人：`王新来`
- 提交信息：`更新角色贴图`
- 提交 SHA：`abc123...`
- 要执行的命令：`python notify.py`

---

### 第 4 步：Runner 执行任务

Runner 会在自己的工作目录执行任务：

```
C:\GitLab-Runner\
├── builds\              # 临时工作区（每次任务都会清理）
│   └── mRyJ6ZTr6\
│       └── 0\
│           └── grouptowgame\
│               └── grouptowart_hb.tmp\  # 这里会拉取代码
│
└── notify.py            # 我们放在这里的脚本
└── owners.json          # 我们放在这里的配置
```

**执行过程**：
1. Runner 切换到工作目录
2. 设置环境变量（项目路径、提交人等）
3. 执行命令：`python notify.py`
4. 脚本读取环境变量，发送飞书通知
5. 任务完成，清理临时文件

---

### 第 5 步：查看执行结果

你可以在 GitLab 网页上看到执行日志：

```
Running with gitlab-runner 17.7.0
Executing "step_script" stage of the job script
$ python notify.py
============================================================
>>> 美术资源通知系统 v3.1 - 多人通知版
============================================================
[提交信息] 更新角色贴图
[提交人] 王新来
[项目路径] GroupTwoGame/groupTowArt_Hb
------------------------------------------------------------
[成功] 找到 1 个负责人:
  - wangxinlai@huixuanjiasu.com
------------------------------------------------------------
[成功] 卡片消息发送成功！
============================================================
Job succeeded
```

---

## 🔑 关键概念解释

### 1. GitLab（代码仓库）

**是什么**：
- 一个网站，用来存储和管理代码
- 就像"云盘"，但专门为代码设计

**你的 GitLab**：
- 地址：公司内部的 GitLab 服务器
- 项目：`GroupTwoGame/groupTowArt_Hb`

---

### 2. GitLab Runner（执行器）

**是什么**：
- 一个安装在服务器上的程序
- 专门用来执行 GitLab 分配的任务

**你的 Runner**：
- 安装位置：`C:\GitLab-Runner\`
- 运行在：公司的某台 Windows 服务器上
- 24 小时待命，随时准备执行任务

**Runner 的特点**：
- ✅ 自动执行，不需要人工干预
- ✅ 可以同时处理多个任务
- ✅ 执行完自动清理，不留垃圾
- ✅ 出错会记录日志，方便排查

---

### 3. .gitlab-ci.yml（配置文件）

**是什么**：
- 一个配置文件，告诉 Runner 要做什么
- 就像"任务清单"或"菜谱"

**我们的配置**：
```yaml
notify:
  stage: notify
  script:
    - Set-Location C:\GitLab-Runner
    - python notify.py
  only:
    - master
```

**翻译成人话**：
- 任务名称：`notify`（通知）
- 阶段：`notify`（通知阶段）
- 要做的事：
  1. 切换到 `C:\GitLab-Runner` 目录
  2. 运行 `python notify.py` 脚本
- 触发条件：只在 `master` 分支执行

---

### 4. 环境变量（传递信息的方式）

**是什么**：
- 一种传递信息的方式
- 就像"便签纸"，GitLab 把信息写在上面，Runner 读取

**常用的环境变量**：

| 变量名 | 含义 | 示例 |
|--------|------|------|
| `CI_PROJECT_PATH` | 项目路径 | `GroupTwoGame/groupTowArt_Hb` |
| `GITLAB_USER_NAME` | 提交人 | `王新来` |
| `CI_COMMIT_MESSAGE` | 提交信息 | `更新角色贴图` |
| `CI_COMMIT_SHA` | 提交 SHA | `abc123...` |
| `CI_PROJECT_URL` | 项目 URL | `https://gitlab.com/...` |

**怎么使用**：
```python
import os

# 读取环境变量
project_path = os.environ.get('CI_PROJECT_PATH')
user_name = os.environ.get('GITLAB_USER_NAME')

print(f"项目: {project_path}")
print(f"提交人: {user_name}")
```

---

## 🎬 完整流程动画

```
第 1 幕：你提交代码
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
你的电脑                          GitLab 服务器
   │                                  │
   │  git push                        │
   │─────────────────────────────────>│
   │                                  │
   │                                  │ ✓ 收到提交
   │                                  │ ✓ 读取 .gitlab-ci.yml
   │                                  │ ✓ 创建任务


第 2 幕：GitLab 分配任务
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
GitLab 服务器                     GitLab Runner
   │                                  │
   │  有新任务！                      │
   │─────────────────────────────────>│
   │                                  │
   │                                  │ ✓ 接收任务
   │                                  │ ✓ 准备环境
   │                                  │ ✓ 设置环境变量


第 3 幕：Runner 执行任务
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
GitLab Runner                     飞书服务器
   │                                  │
   │  执行 python notify.py           │
   │  ├─ 读取环境变量                 │
   │  ├─ 读取 owners.json             │
   │  ├─ 查找负责人                   │
   │  └─ 发送飞书消息                 │
   │─────────────────────────────────>│
   │                                  │
   │                                  │ ✓ 收到消息
   │                                  │ ✓ 推送给用户


第 4 幕：你收到通知
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
飞书服务器                        你的飞书
   │                                  │
   │  推送通知                        │
   │─────────────────────────────────>│
   │                                  │
   │                                  │ 🔔 叮！
   │                                  │ 【美术资源更新提醒】
   │                                  │ 项目：GroupTwoGame/...
   │                                  │ 提交人：王新来
   │                                  │ 提交信息：更新角色贴图
```

---

## 🤔 常见问题

### Q1: Runner 在哪里运行？

**答**：在公司的某台服务器上，24 小时运行。

**位置**：`C:\GitLab-Runner\`

**你不需要**：
- ❌ 手动启动它
- ❌ 关心它在哪台机器上
- ❌ 担心它会停止

**它会自动**：
- ✅ 监听 GitLab 的任务
- ✅ 执行任务
- ✅ 报告结果

---

### Q2: 为什么要用 Runner，不能直接发通知吗？

**不用 Runner 的问题**：
```
你提交代码 → GitLab 收到 → 然后呢？
```

GitLab 只是一个代码仓库，它不知道你想做什么。

**用 Runner 的好处**：
```
你提交代码 → GitLab 收到 → Runner 执行任务 → 发送通知
```

Runner 可以：
- ✅ 自动执行任何任务（发通知、运行测试、部署代码等）
- ✅ 不需要人工干预
- ✅ 24 小时工作
- ✅ 可以执行复杂的逻辑

---

### Q3: 为什么 Runner 的工作目录这么复杂？

**Runner 的工作目录**：
```
C:\GitLab-Runner\builds\mRyJ6ZTr6\0\grouptowgame\grouptowart_hb.tmp\
```

**为什么这么长**：
- `builds\` - 临时工作区
- `mRyJ6ZTr6\` - Runner 的唯一 ID
- `0\` - 并发任务编号
- `grouptowgame\` - 项目组名
- `grouptowart_hb.tmp\` - 项目名 + 临时标记

**为什么要这样**：
- ✅ 支持多个项目同时执行
- ✅ 支持同一个项目的多个任务同时执行
- ✅ 任务完成后自动清理，不留垃圾

**我们的解决方案**：
- 把脚本放在 `C:\GitLab-Runner\` 根目录
- 不依赖临时工作区的文件
- 避免路径问题

---

### Q4: 环境变量为什么会"丢失"？

**问题**：
```yaml
# 错误的配置
notify:
  script:
    - python notify.py
  variables:
    GIT_STRATEGY: none  # ← 这会导致环境变量丢失
```

**原因**：
- `GIT_STRATEGY: none` 告诉 Runner "不要拉取代码"
- Runner 为了优化，也不设置一些环境变量
- 结果：`CI_PROJECT_PATH` 等变量变成"未知"

**解决方案**：
```yaml
# 正确的配置
notify:
  script:
    - $env:CI_PROJECT_PATH = $env:CI_PROJECT_PATH  # 手动保留
    - Set-Location C:\GitLab-Runner
    - python notify.py
  variables:
    GIT_STRATEGY: none
```

---

### Q5: 为什么要用 `Set-Location C:\GitLab-Runner`？

**问题**：
- Runner 默认在临时工作区执行任务
- 临时工作区路径很长，而且每次都不一样
- 我们的脚本和配置文件在 `C:\GitLab-Runner\`

**解决方案**：
```yaml
script:
  - Set-Location C:\GitLab-Runner  # 切换到固定目录
  - python notify.py               # 运行脚本
```

**效果**：
- ✅ 脚本可以找到 `owners.json`
- ✅ 路径固定，不会变化
- ✅ 避免中文路径编码问题

---

## 🎓 进阶知识

### Runner 的类型

| 类型 | 说明 | 适用场景 |
|------|------|----------|
| Shared Runner | 所有项目共享 | 公司统一管理 |
| Group Runner | 项目组共享 | 部门内使用 |
| Specific Runner | 特定项目专用 | 特殊需求 |

**你们用的**：可能是 Shared Runner 或 Group Runner

---

### CI/CD 是什么？

**CI（Continuous Integration）**：持续集成
- 每次提交代码，自动运行测试
- 确保代码质量

**CD（Continuous Deployment）**：持续部署
- 测试通过后，自动部署到服务器
- 减少人工操作

**你们的场景**：
- 不是传统的 CI/CD
- 而是"持续通知"（Continuous Notification）
- 每次提交，自动发送飞书通知

---

### Pipeline（流水线）

**是什么**：
- 一次完整的任务执行过程
- 可以包含多个阶段（Stage）

**示例**：
```yaml
stages:
  - build    # 第 1 阶段：编译代码
  - test     # 第 2 阶段：运行测试
  - deploy   # 第 3 阶段：部署
  - notify   # 第 4 阶段：发送通知

build_job:
  stage: build
  script:
    - make build

test_job:
  stage: test
  script:
    - make test

deploy_job:
  stage: deploy
  script:
    - make deploy

notify_job:
  stage: notify
  script:
    - python notify.py
```

**你们的场景**：
- 只有一个阶段：`notify`
- 只有一个任务：发送飞书通知

---

## 📊 对比：手动 vs 自动

### 手动发通知

```
美术提交代码
   ↓
美术在群里说："我提交了新资源"
   ↓
程序员看到消息
   ↓
程序员拉取代码
```

**问题**：
- ❌ 美术要手动通知
- ❌ 程序员可能错过消息
- ❌ 晚上提交没人看到
- ❌ 效率低

---

### 自动发通知（GitLab Runner）

```
美术提交代码
   ↓
GitLab 自动触发 Runner
   ↓
Runner 自动发送飞书通知
   ↓
程序员立即收到通知
```

**优点**：
- ✅ 完全自动化
- ✅ 不会错过
- ✅ 24 小时工作
- ✅ 效率高

---

## 🔗 类比：其他自动化系统

### 1. 餐厅订餐系统

```
顾客点餐（提交代码）
   ↓
系统接收订单（GitLab）
   ↓
厨师做菜（Runner 执行任务）
   ↓
服务员上菜（发送通知）
```

### 2. 快递系统

```
寄件人寄快递（提交代码）
   ↓
快递公司接收（GitLab）
   ↓
快递员配送（Runner 执行任务）
   ↓
收件人收货（收到通知）
```

### 3. 工厂流水线

```
原料进入（提交代码）
   ↓
传送带运输（GitLab）
   ↓
机器加工（Runner 执行任务）
   ↓
成品输出（发送通知）
```

---

## 💡 总结

### 核心概念

1. **GitLab**：代码仓库（就像云盘）
2. **GitLab Runner**：自动执行员工（24 小时待命）
3. **.gitlab-ci.yml**：任务清单（告诉 Runner 做什么）
4. **环境变量**：传递信息的便签纸

### 工作流程

```
提交代码 → GitLab 接收 → Runner 执行 → 发送通知
```

### 关键点

- ✅ 完全自动化，不需要人工干预
- ✅ 24 小时工作，不会错过
- ✅ 可以执行任何任务（不只是发通知）
- ✅ 出错有日志，方便排查

---

## 📚 延伸阅读

### 想了解更多？

1. **GitLab CI/CD 官方文档**（英文）
   - https://docs.gitlab.com/ee/ci/

2. **GitLab Runner 官方文档**（英文）
   - https://docs.gitlab.com/runner/

3. **我们的实战文档**
   - [v3.1 部署指南](../../Feishu_Notify_Setup/docs/v3.1部署指南.md)
   - [修复方案](../../Feishu_Notify_Setup/docs/修复方案.md)
   - [快速参考](../../Feishu_Notify_Setup/QUICK-REFERENCE.md)

---

## 🎯 下一步

### 如果你想深入了解

1. **查看 CI 日志**
   - 打开 GitLab 项目
   - 点击 CI/CD → Pipelines
   - 查看任务执行过程

2. **修改配置文件**
   - 编辑 `.gitlab-ci.yml`
   - 添加新的任务
   - 提交测试

3. **学习 YAML 语法**
   - YAML 是一种配置文件格式
   - 很简单，半小时就能学会

---

**作者**: Kiro AI Assistant  
**日期**: 2026-01-22  
**版本**: v1.0  
**适合人群**: 美术、策划、非技术人员

有问题随时问我！🚀
