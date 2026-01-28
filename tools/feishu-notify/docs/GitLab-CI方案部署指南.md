# GitLab CI 方案部署指南

**方案类型**: GitLab CI Pipeline  
**推荐度**: ⭐⭐⭐（3/5）  
**适用场景**: 需要立即使用，不能等待审批  
**更新日期**: 2026-01-27

---

## 📋 方案概述

通过 GitLab CI Pipeline 执行 Python 脚本，在代码提交时自动发送飞书通知。

### 优点

- ✅ **不需要任何审批**：立即可用
- ✅ **配置简单**：只需配置环境变量
- ✅ **核心功能完整**：自动通知、多人通知

### 缺点

- ⚠️ **提交人信息缺失**：显示为 "Unknown User"
- ⚠️ **不显示中文提交信息**：使用时间戳代替
- ⚠️ **维护成本较高**：需要处理编码问题

---

## 🚀 快速部署（5 分钟）

### Step 1: 准备文件

需要准备 3 个文件：

1. **notify_v3_gitlab_ci.py** - 通知脚本
2. **owners.json** - 项目负责人配置
3. **.gitlab-ci.yml** - CI 配置文件

### Step 2: 配置飞书应用

1. 登录飞书开放平台：https://open.feishu.cn/
2. 创建企业自建应用
3. 获取 `APP_ID` 和 `APP_SECRET`
4. 添加权限：`contact:user.email:readonly`
5. 发布应用

详细步骤：查看 [飞书应用创建指南](./飞书应用创建指南.md)

### Step 3: 配置 GitLab 环境变量

1. 打开 GitLab 项目
2. 进入 Settings → CI/CD → Variables
3. 添加两个变量：

```
FEISHU_APP_ID = cli_a9e3400711fbdbcb
FEISHU_APP_SECRET = h61QXukkibdbO0wRRFxTkgppaLvcPQFS
```

⚠️ **注意**：勾选 "Masked" 保护密钥

### Step 4: 配置负责人名单

编辑 `owners.json`：

```json
{
    "_comment": "美术资源负责人配置文件",
    "_说明": "支持单人或多人通知",
    
    "项目名称": ["email@huixuanjiasu.com"],
    "groupTowArt_Hb": ["wangxinlai@huixuanjiasu.com"],
    "Y_遇水发财": ["zhaolida@huixuanjiasu.com"],
    "C_财运接龙": [
        "wangxinlai@huixuanjiasu.com",
        "zhaolida@huixuanjiasu.com"
    ]
}
```

**匹配规则**：
- 项目路径包含 key 即可匹配
- 例如：`grouptwogame/grouptowart_hb` 会匹配 `groupTowArt_Hb`

### Step 5: 部署到 GitLab Runner

```bash
# 复制文件到 GitLab Runner 目录
copy scripts\notify_v3_gitlab_ci.py C:\GitLab-Runner\notify.py
copy config\owners.json C:\GitLab-Runner\owners.json
```

### Step 6: 配置 .gitlab-ci.yml

在项目根目录创建 `.gitlab-ci.yml`：

```yaml
stages:
  - notify

notify:
  stage: notify
  tags:
    - windows
  script:
    # 保留环境变量（重要！）
    - $env:CI_PROJECT_PATH = $env:CI_PROJECT_PATH
    - $env:CI_COMMIT_SHA = $env:CI_COMMIT_SHA
    - $env:CI_PROJECT_URL = $env:CI_PROJECT_URL
    - $env:GITLAB_USER_EMAIL = $env:GITLAB_USER_EMAIL
    - $env:GITLAB_USER_LOGIN = $env:GITLAB_USER_LOGIN
    
    # 切换到 GitLab Runner 目录（重要！）
    - Set-Location C:\GitLab-Runner
    
    # 运行通知脚本
    - python notify.py
  
  variables:
    GIT_STRATEGY: none  # 不拉取代码（重要！）
  
  only:
    - master
    - main
```

### Step 7: 提交测试

```bash
git add .gitlab-ci.yml
git commit -m "添加飞书通知功能"
git push
```

### Step 8: 查看结果

1. 打开 GitLab 项目
2. 点击 CI/CD → Pipelines
3. 查看最新任务日志
4. 确认飞书收到通知

---

## 📊 通知效果

### 飞书卡片消息

```
[Art Resource Update Reminder]

Project: GroupTwoGame/groupTowArt_Hb
Submitter: Unknown User
Update Time: 2026-01-27 18:00:09

[View Changes]
```

### 日志输出

```
============================================================
>>> GitLab CI Feishu Notification v3.2 (Optimized)
============================================================
[INFO] Submitter: wangxinlai@huixuanjiasu.com
[INFO] Project: grouptwogame/grouptowart_hb
[INFO] Update Time: 2026-01-27 18:00:09
------------------------------------------------------------
[OK] Loaded owners.json, 4 entries
[SEARCH] Finding owner for project 'grouptwogame/grouptowart_hb'...
[MATCH] Fuzzy match: 'groupTowArt_Hb' in project path
[OK] Found 1 owner(s):
  - wangxinlai@huixuanjiasu.com
------------------------------------------------------------
[TOKEN] Getting Feishu access token...
[OK] Token obtained
[SEARCH] Finding Feishu user: wangxinlai@huixuanjiasu.com
[OK] User ID: ou_xxx
------------------------------------------------------------
[SEND] Sending notification to wangxinlai@huixuanjiasu.com...
[OK] Notification sent successfully!
============================================================
[COMPLETE] Notification process finished
[SUCCESS] 1 recipient(s)
============================================================
```

---

## 🔧 配置说明

### .gitlab-ci.yml 关键配置

#### 1. 保留环境变量

```yaml
script:
  - $env:CI_PROJECT_PATH = $env:CI_PROJECT_PATH
  - $env:CI_COMMIT_SHA = $env:CI_COMMIT_SHA
  - $env:CI_PROJECT_URL = $env:CI_PROJECT_URL
  - $env:GITLAB_USER_EMAIL = $env:GITLAB_USER_EMAIL
  - $env:GITLAB_USER_LOGIN = $env:GITLAB_USER_LOGIN
```

**为什么需要**：
- 使用 `GIT_STRATEGY: none` 后，环境变量会丢失
- 必须手动保留所有需要的变量

#### 2. 切换工作目录

```yaml
script:
  - Set-Location C:\GitLab-Runner
```

**为什么需要**：
- GitLab Runner 的工作目录是临时的
- 脚本和配置文件必须放在固定目录

#### 3. 不拉取代码

```yaml
variables:
  GIT_STRATEGY: none
```

**为什么需要**：
- 避免中文文件名导致编码错误
- 提高执行速度

---

## 🐛 故障排查

### 问题 1：找不到 owners.json

**错误信息**：
```
[ERROR] owners.json not found
```

**原因**：
- 文件没有复制到 `C:\GitLab-Runner\`
- 或者没有使用 `Set-Location C:\GitLab-Runner`

**解决方案**：
```bash
# 确保文件存在
copy config\owners.json C:\GitLab-Runner\owners.json

# 确保 .gitlab-ci.yml 中有这行
- Set-Location C:\GitLab-Runner
```

---

### 问题 2：环境变量为 "未知"

**错误信息**：
```
[WARNING] No owner found for project: 'unknown/project'
```

**原因**：
- 使用了 `GIT_STRATEGY: none`
- 没有手动保留环境变量

**解决方案**：
```yaml
script:
  - $env:CI_PROJECT_PATH = $env:CI_PROJECT_PATH  # ← 必须加这行
  - Set-Location C:\GitLab-Runner
  - python notify.py
```

---

### 问题 3：提交人显示为 "Unknown User"

**原因**：
- 环境变量 `GITLAB_USER_EMAIL` 和 `GITLAB_USER_LOGIN` 丢失
- 这是 GitLab CI 方案的已知限制

**解决方案**：
- 接受现状（当前方案）
- 或者切换到 Webhook 方案（推荐）

---

### 问题 4：没有收到通知

**排查步骤**：

1. **检查 CI 日志**：
   - 是否有错误信息？
   - 是否找到了负责人？

2. **检查飞书配置**：
   - APP_ID 和 APP_SECRET 是否正确？
   - 权限是否添加？
   - 应用是否发布？

3. **检查 owners.json**：
   - 项目路径是否匹配？
   - 邮箱是否正确？

4. **手动测试**：
```bash
# 设置环境变量
set FEISHU_APP_ID=your_app_id
set FEISHU_APP_SECRET=your_app_secret
set CI_PROJECT_PATH=grouptwogame/测试文件

# 运行脚本
cd C:\GitLab-Runner
python notify.py
```

---

## 📋 维护指南

### 添加新项目

编辑 `C:\GitLab-Runner\owners.json`：

```json
{
    "新项目名称": ["email@huixuanjiasu.com"]
}
```

提交后立即生效，无需重启。

### 添加新负责人

```json
{
    "项目名称": [
        "email1@huixuanjiasu.com",
        "email2@huixuanjiasu.com"
    ]
}
```

### 更新脚本

```bash
# 1. 修改脚本
# 2. 复制到 GitLab Runner
copy scripts\notify_v3_gitlab_ci.py C:\GitLab-Runner\notify.py

# 3. 提交测试
cd D:\HuiXuanJiaSu\I_IAA_Work
git add .
git commit -m "测试通知"
git push
```

---

## 🚀 升级到 Webhook 方案

如果你对当前方案不满意（提交人信息缺失、不显示中文），可以升级到 Webhook 方案。

### 升级步骤

1. **申请 GitLab 管理员权限**
   - 开启 Webhook 本地网络请求
   - 参考：[给老板的申请文档](../给老板的申请文档.md)

2. **部署 Webhook 服务器**
   - 参考：[Webhook 方案部署指南](./Webhook方案部署指南.md)

3. **禁用 GitLab CI 通知**
   - 删除或注释 `.gitlab-ci.yml` 中的 `notify` 任务

### 升级收益

- ✅ 提交人信息完整
- ✅ 中文提交信息完整
- ✅ 维护成本更低
- ✅ 用户体验更好

---

## 📚 相关文档

- [方案对比与选择指南](../方案对比与选择指南.md) - 三种方案对比
- [Webhook 方案部署指南](./Webhook方案部署指南.md) - 推荐方案
- [飞书工作配方部署指南](./飞书工作配方部署指南.md) - 官方方案
- [关键经验-必读](./关键经验-必读.md) - 避免踩坑
- [给老板的申请文档](../给老板的申请文档.md) - 申请权限

---

## 🎉 总结

### 适用场景

- ✅ 需要立即使用
- ✅ 不能等待审批
- ✅ 可以接受提交人信息缺失

### 不适用场景

- ❌ 对提交人信息要求高
- ❌ 需要显示中文提交信息
- ❌ 希望降低维护成本

### 推荐方案

**如果可以申请权限，强烈推荐使用 Webhook 方案**：
- 功能更完整
- 用户体验更好
- 维护成本更低

---

**创建时间**: 2026-01-27  
**维护人**: 技术团队  
**版本**: v1.0
