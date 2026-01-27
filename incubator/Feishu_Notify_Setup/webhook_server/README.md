# GitLab Webhook 服务器 - 飞书通知

## 📋 方案说明

使用 GitLab Webhook + Python Flask 服务器接收 GitLab Push 事件，发送飞书通知。

### 为什么选择 Webhook 方案？

相比 GitLab CI 方案，Webhook 方案有以下优势：

1. **完全避免 Windows 编码问题** - 不需要通过 GitLab CI 传递中文
2. **提交人信息完整** - 直接从 Webhook 数据获取，不会丢失
3. **更专业可靠** - 这是 GitLab 官方推荐的集成方式
4. **性能更好** - 不需要启动 GitLab Runner，响应更快
5. **更易维护** - 代码逻辑清晰，调试方便

## 🚀 快速开始

### 1. 安装依赖

```bash
pip install -r requirements.txt
```

### 2. 配置项目负责人

编辑 `../config/owners.json`：

```json
{
    "Y_遇水发财": "zhangsan@huixuanjiasu.com",
    "N_奶奶的小农院": ["lisi@huixuanjiasu.com", "wangwu@huixuanjiasu.com"],
    "测试项目": "wangxinlai@huixuanjiasu.com"
}
```

支持：
- 单人通知：`"项目名": "email@xxx.com"`
- 多人通知：`"项目名": ["email1@xxx.com", "email2@xxx.com"]`

### 3. 启动服务器

**Windows:**
```bash
启动Webhook服务器.bat
```

**Linux/Mac:**
```bash
python webhook_server.py
```

服务器将在 `http://0.0.0.0:5000` 启动。

### 4. 配置 GitLab Webhook

1. 打开 GitLab 项目页面
2. 进入 **Settings** → **Webhooks**
3. 填写配置：
   - **URL**: `http://你的服务器IP:5000/gitlab-webhook`
   - **Secret Token**: 留空（可选）
   - **Trigger**: 勾选 `Push events`
   - **SSL verification**: 如果是内网 HTTP，取消勾选
4. 点击 **Add webhook**
5. 点击 **Test** → **Push events** 测试

### 5. 验证通知

提交代码到 GitLab，检查：
1. 服务器控制台是否有日志输出
2. 飞书是否收到通知
3. 提交人和提交信息是否正确显示

## 📁 文件说明

```
webhook_server/
├── webhook_server.py          # Webhook 服务器主程序
├── requirements.txt           # Python 依赖
├── 启动Webhook服务器.bat      # Windows 启动脚本
└── README.md                  # 本文档
```

## 🔧 配置说明

### 环境变量

服务器会自动读取以下环境变量（如果未设置，使用默认值）：

- `FEISHU_APP_ID`: 飞书应用 ID（默认：cli_a9e3400711fbdbcb）
- `FEISHU_APP_SECRET`: 飞书应用密钥（默认：h61QXukkibdbO0wRRFxTkgppaLvcPQFS）

### 项目匹配规则

服务器会根据 GitLab 项目路径（如 `grouptwogame/Y_遇水发财`）匹配 `owners.json` 中的配置：

1. **精确匹配**：项目路径包含完整的 key
   - 项目路径：`grouptwogame/Y_遇水发财`
   - 配置 key：`Y_遇水发财`
   - ✅ 匹配成功

2. **模糊匹配**：项目路径包含 key 的一部分
   - 项目路径：`grouptwogame/test_project`
   - 配置 key：`test`
   - ✅ 匹配成功

## 🔍 健康检查

访问 `http://你的服务器IP:5000/health` 检查服务器是否正常运行。

正常响应：
```json
{"status": "ok"}
```

## 📊 Webhook 数据格式

GitLab Push Hook 会发送以下数据：

```json
{
  "project": {
    "path_with_namespace": "grouptwogame/Y_遇水发财"
  },
  "user_name": "王新来",
  "user_email": "wangxinlai@huixuanjiasu.com",
  "commits": [
    {
      "message": "更新美术资源",
      "url": "https://gitlab.xxx.com/project/-/commit/abc123"
    }
  ]
}
```

服务器会提取这些信息，发送飞书通知。

## 🐛 故障排查

### 1. 服务器无法启动

**问题**: `ModuleNotFoundError: No module named 'flask'`

**解决**: 安装依赖
```bash
pip install -r requirements.txt
```

### 2. GitLab 无法连接到 Webhook

**问题**: Webhook 测试失败，显示连接超时

**可能原因**:
- 服务器防火墙阻止了 5000 端口
- GitLab 无法访问你的服务器 IP

**解决**:
1. 检查防火墙设置，开放 5000 端口
2. 确保 GitLab 服务器可以访问你的服务器
3. 如果是内网，确保在同一网络

### 3. 收不到飞书通知

**问题**: Webhook 触发成功，但飞书没有收到通知

**检查**:
1. 查看服务器控制台日志，是否有错误信息
2. 检查 `owners.json` 配置是否正确
3. 检查邮箱是否在飞书中存在
4. 检查飞书应用权限是否正确配置

### 4. 提交人显示错误

**问题**: 提交人显示为其他人的名字

**原因**: GitLab Webhook 发送的是 Git 提交者信息，不是 GitLab 用户信息

**说明**: 这是正常的，Git 提交者信息由本地 Git 配置决定

## 🔄 从 GitLab CI 方案迁移

如果你之前使用 GitLab CI 方案，迁移步骤：

1. **启动 Webhook 服务器**（按照上面的步骤）
2. **配置 GitLab Webhook**（按照上面的步骤）
3. **测试 Webhook 是否正常工作**
4. **禁用 GitLab CI 通知任务**：
   - 编辑 `.gitlab-ci.yml`
   - 注释或删除 `notify` 任务
   - 提交修改

## 📝 日志示例

正常运行时的日志：

```
[Webhook] 项目: grouptwogame/Y_遇水发财
[Webhook] 提交人: 王新来 <wangxinlai@huixuanjiasu.com>
[Webhook] 提交信息: 更新美术资源
[成功] 通知已发送给 zhangsan@huixuanjiasu.com
```

## 🎯 下一步

1. **生产环境部署**：
   - 使用 `gunicorn` 或 `uwsgi` 替代 Flask 开发服务器
   - 配置 Nginx 反向代理
   - 使用 HTTPS

2. **监控和日志**：
   - 添加日志文件记录
   - 配置日志轮转
   - 添加监控告警

3. **安全加固**：
   - 配置 Webhook Secret Token
   - 限制访问 IP
   - 使用环境变量管理敏感信息

## 📞 支持

如有问题，请查看：
- `../docs/关键经验-必读.md` - 关键经验和教训
- GitLab Webhook 文档: https://docs.gitlab.com/ee/user/project/integrations/webhooks.html
- 飞书开放平台文档: https://open.feishu.cn/document/home/index
