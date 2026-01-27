# 飞书工作配方 + GitLab 集成配置指南

> 日期: 2026-01-22  
> 目的: 使用飞书工作配方替代 GitLab CI 脚本方案  
> 参考: https://www.cnblogs.com/colincck/articles/17904879.html

---

## 🎯 方案优势

相比 GitLab CI + Python 脚本方案：
- ✅ **可视化配置**：无需写代码，拖拽即可
- ✅ **飞书原生**：集成度高，稳定性好
- ✅ **易于维护**：修改配置不需要提交代码
- ✅ **功能丰富**：可结合多维表格、AI 等功能
- ✅ **调试方便**：可视化日志，一目了然

---

## 📋 配置步骤

### Step 1: 创建飞书机器人应用

1. **打开飞书应用目录**
   - 飞书工作台 → 应用目录
   - 搜索"飞书机器人"

2. **创建机器人应用**
   - 点击"创建机器人应用"
   - 填写机器人名称：`美术资源通知机器人`
   - 填写描述：`自动通知美术资源提交`

3. **进入创建流程**
   - 等待创建完成
   - 点击"创建流程"按钮

---

### Step 2: 配置 GitLab 触发器

1. **选择触发器**
   - 点击"触发器"
   - 选择 **"GitLab Commit"**

2. **添加 GitLab 账号**
   - 点击"添加账号"
   - 填写 GitLab 信息：

**GitLab 域名配置**：
```
# 如果是公司内部 GitLab
your-company-gitlab.com

# 如果是 IP + 端口
192.168.1.100:8080

# 如果是官方 GitLab
gitlab.com
```

**⚠️ 重要提示**：
- 如果没有配置 SSL 证书（https），授权时需要手动删除 URL 中的 `s`
- 例如：`https://example.com` → `http://example.com`

---

### Step 3: 获取 GitLab Application ID 和 Secret

#### 在 GitLab 中创建应用

1. **打开 GitLab 设置**
   - 登录 GitLab
   - 用户头像 → Settings（设置）
   - 左侧菜单 → Applications（应用程序）

2. **创建新应用**
   - Name（名称）：`飞书机器人`
   - Redirect URI（回调地址）：
     ```
     https://botbuilder.feishu.cn/authorize/callback
     ```
   - Scopes（权限）：
     - ✅ `api` - 完整 API 访问权限
     - ✅ `read_user` - 读取用户信息
     - ✅ `read_repository` - 读取仓库信息

3. **保存并复制**
   - 点击"Save application"
   - 复制 **Application ID**
   - 复制 **Secret**

4. **填写到飞书**
   - 回到飞书机器人配置页面
   - 粘贴 Application ID
   - 粘贴 Secret
   - 点击"确定"

---

### Step 4: 授权 GitLab 账号

1. **跳转到 GitLab 授权页面**
   - 飞书会自动跳转到 GitLab
   - 如果没有 SSL 证书，手动修改 URL：
     - `https://` → `http://`

2. **授权应用**
   - 点击"Authorize"（授权）
   - 等待跳转回飞书

3. **授权成功**
   - 回到飞书机器人配置页面
   - 显示"已授权"

---

### Step 5: 配置监听项目和分支

1. **选择项目**
   - 在"项目"下拉框中选择：`GroupTwoGame/groupTowArt_Hb`
   - 或者你的其他项目

2. **选择分支**
   - 在"分支"下拉框中选择：`master` 或 `main`
   - 建议选择主分支

3. **确认配置**
   - 点击"确定"

---

### Step 6: 配置通知动作

#### 方案 A：简单通知（推荐新手）

1. **添加动作节点**
   - 点击"+"添加节点
   - 选择"发送飞书消息"

2. **配置消息内容**
   - 消息类型：卡片消息
   - 发送给：选择接收人（你的飞书账号）
   - 消息内容：
     ```
     【美术资源更新提醒】
     项目：{{project.name}}
     提交人：{{user.name}}
     提交信息：{{commit.message}}
     查看变更：{{commit.url}}
     ```

---

#### 方案 B：智能分配（推荐）

**节点 1：条件判断**
- 添加"条件判断"节点
- 条件：`{{project.path}}` 包含 `Y_遇水发财`
- 如果是 → 发送给赵丽达
- 如果否 → 继续判断

**节点 2：条件判断**
- 条件：`{{project.path}}` 包含 `C_财运接龙`
- 如果是 → 发送给王新来和赵丽达
- 如果否 → 继续判断

**节点 3：条件判断**
- 条件：`{{project.path}}` 包含 `groupTowArt_Hb`
- 如果是 → 发送给王新来
- 如果否 → 发送给默认负责人

---

#### 方案 C：高级功能（可选）

**添加多维表格记录**：
1. 添加"多维表格"节点
2. 选择表格：`美术资源提交记录`
3. 添加记录：
   - 项目名称：`{{project.name}}`
   - 提交人：`{{user.name}}`
   - 提交时间：`{{commit.timestamp}}`
   - 提交信息：`{{commit.message}}`
   - 负责人：根据项目匹配

**添加 AI 分类**：
1. 添加"AI 分类"节点
2. 分类依据：`{{commit.message}}`
3. 分类规则：
   - 美术资源更新
   - 代码修复
   - 功能开发
   - 文档更新

---

### Step 7: 启用和发布

1. **启用流程**
   - 点击右上角"启用"按钮
   - 确认启用

2. **发布流程**
   - ⚠️ **重要**：必须点击"发布"按钮
   - 否则流程不会生效

3. **测试流程**
   - 提交一次代码到 GitLab
   - 查看飞书是否收到通知

---

## 🎨 消息卡片模板

### 基础模板

```json
{
  "header": {
    "title": "美术资源更新提醒",
    "template": "blue"
  },
  "elements": [
    {
      "tag": "div",
      "text": {
        "tag": "lark_md",
        "content": "**项目**：{{project.name}}\n**提交人**：{{user.name}}\n**提交信息**：{{commit.message}}"
      }
    },
    {
      "tag": "action",
      "actions": [
        {
          "tag": "button",
          "text": "查看变更",
          "url": "{{commit.url}}",
          "type": "primary"
        }
      ]
    }
  ]
}
```

---

### 高级模板（包含文件列表）

```json
{
  "header": {
    "title": "美术资源更新提醒",
    "template": "blue"
  },
  "elements": [
    {
      "tag": "div",
      "fields": [
        {
          "is_short": true,
          "text": {
            "tag": "lark_md",
            "content": "**项目**\n{{project.name}}"
          }
        },
        {
          "is_short": true,
          "text": {
            "tag": "lark_md",
            "content": "**提交人**\n{{user.name}}"
          }
        }
      ]
    },
    {
      "tag": "div",
      "text": {
        "tag": "lark_md",
        "content": "**提交信息**\n{{commit.message}}"
      }
    },
    {
      "tag": "div",
      "text": {
        "tag": "lark_md",
        "content": "**变更文件**\n{{commit.added_files}}\n{{commit.modified_files}}"
      }
    },
    {
      "tag": "action",
      "actions": [
        {
          "tag": "button",
          "text": "查看变更",
          "url": "{{commit.url}}",
          "type": "primary"
        }
      ]
    },
    {
      "tag": "note",
      "elements": [
        {
          "tag": "plain_text",
          "content": "请及时拉取最新资源！"
        }
      ]
    }
  ]
}
```

---

## 🔧 常见问题

### Q1: 授权时提示"无法访问"

**原因**：GitLab 没有配置 SSL 证书

**解决**：
1. 复制授权 URL
2. 将 `https://` 改为 `http://`
3. 在浏览器中打开修改后的 URL

---

### Q2: 没有收到通知

**检查清单**：
1. ✅ 流程是否已启用？
2. ✅ 流程是否已发布？
3. ✅ 监听的分支是否正确？
4. ✅ 提交是否在监听的分支上？
5. ✅ 查看飞书机器人的执行日志

---

### Q3: 如何查看执行日志？

1. 打开飞书机器人应用
2. 点击"执行记录"
3. 查看最近的执行日志
4. 如果失败，查看错误信息

---

### Q4: 如何监听多个项目？

**方案 1：创建多个流程**
- 每个项目创建一个独立的流程
- 优点：配置简单，互不影响
- 缺点：需要维护多个流程

**方案 2：使用条件判断**
- 一个流程监听所有项目
- 使用条件判断分配负责人
- 优点：统一管理
- 缺点：配置稍复杂

---

### Q5: 如何监听多个分支？

飞书工作配方目前只支持监听单个分支。

**解决方案**：
- 创建多个流程，每个流程监听一个分支
- 或者监听主分支（master/main），其他分支合并到主分支时触发

---

## 📊 与 GitLab CI 方案对比

| 特性 | GitLab CI 方案 | 飞书工作配方 |
|------|---------------|-------------|
| 配置难度 | ⭐⭐⭐⭐ | ⭐⭐ |
| 维护成本 | ⭐⭐⭐⭐ | ⭐ |
| 功能扩展 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 调试难度 | ⭐⭐⭐⭐ | ⭐⭐ |
| 稳定性 | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| 学习成本 | ⭐⭐⭐⭐ | ⭐⭐ |

---

## 🎯 下一步

### 今天

1. ✅ 阅读本文档
2. ✅ 创建飞书机器人应用
3. ✅ 配置 GitLab 授权
4. ✅ 测试基础通知功能

### 本周

1. 📊 配置多维表格记录
2. 🤖 添加 AI 分类功能
3. 📈 设置数据统计报表

### 下周

1. 🔄 完全迁移到飞书工作配方
2. 🗑️ 停用 GitLab CI 方案
3. 📝 更新团队文档

---

## 📚 参考资料

- [飞书机器人官方文档](https://open.feishu.cn/document/ukTMukTMukTM/uYjNzUjL2YzM14iN2MTN)
- [GitLab Webhook 文档](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html)
- [飞书工作配方教程](https://www.cnblogs.com/colincck/articles/17904879.html)

---

## 💡 小贴士

1. **先测试后上线**
   - 在测试项目上先配置
   - 确认无误后再应用到生产项目

2. **保留旧方案作为备份**
   - 飞书工作配方稳定后再停用 GitLab CI
   - 避免出现通知中断

3. **定期检查执行日志**
   - 每周查看一次执行记录
   - 及时发现和解决问题

4. **利用飞书的高级功能**
   - 多维表格：记录提交历史
   - AI 分类：智能分类提交类型
   - 审批流程：重要提交需要审批

---

**配置完成后，记得测试！** 🚀

有问题随时问我！
