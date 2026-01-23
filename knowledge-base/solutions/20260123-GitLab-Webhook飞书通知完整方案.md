# GitLab Webhook 飞书通知完整方案

**日期**: 2026-01-23  
**标签**: #GitLab #Webhook #飞书 #通知系统 #Python #Flask  
**状态**: ✅ 已完成

---

## 📋 问题背景

### 原始需求
在 GitLab 项目中，当有人提交代码时，自动通知项目负责人（通过飞书私聊）。

### 遇到的问题（GitLab CI 方案）

1. **中文乱码问题**
   - Windows + GitLab CI + PowerShell 环境下，中文无法正确传递
   - GitLab CI 使用 Latin-1 编码存储环境变量（不支持中文）
   - PowerShell 默认使用 GBK 编码
   - 多次编码转换导致中文数据损坏

2. **提交人信息丢失**
   - PowerShell 多行命令块在 GitLab CI YAML 中执行不稳定
   - 文件内容为空，导致提交人显示为 "Unknown User"

3. **维护成本高**
   - 需要处理各种编码问题
   - 需要处理 GitLab Runner 工作目录问题
   - 需要手动保留环境变量
   - 调试困难

### 最终方案：GitLab Webhook

使用 GitLab Webhook + Python Flask 服务器，完全避免上述问题。

---

## 🎯 方案架构

```
GitLab 项目
    ↓ (Push 事件)
GitLab Webhook
    ↓ (HTTP POST)
Python Flask 服务器
    ↓ (解析数据)
飞书 API
    ↓ (发送通知)
项目负责人（飞书私聊）
```

### 核心组件

1. **GitLab Webhook**
   - 监听 Push 事件
   - 发送 JSON 数据到服务器

2. **Python Flask 服务器**
   - 接收 Webhook 数据
   - 解析项目路径、提交人、提交信息
   - 查找项目负责人
   - 调用飞书 API 发送通知

3. **飞书 API**
   - 通过邮箱查找用户 ID
   - 发送卡片消息（私聊）

---

## 🚀 实现细节

### 1. Webhook 服务器（webhook_server.py）

```python
from flask import Flask, request, jsonify
import requests
import json
import os

app = Flask(__name__)

@app.route('/gitlab-webhook', methods=['POST'])
def gitlab_webhook():
    """处理 GitLab Webhook"""
    data = request.json
    
    # 提取信息
    project_name = data['project']['path_with_namespace']
    user_name = data['user_name']
    user_email = data['user_email']
    commit_message = data['commits'][-1]['message']
    commit_url = data['commits'][-1]['url']
    
    # 查找项目负责人
    owner_emails = find_owner_by_project(project_name, owners)
    
    # 发送飞书通知
    for owner_email in owner_emails:
        user_id = get_user_id_by_email(owner_email, token)
        send_feishu_card(user_id, project_name, user_name, 
                        commit_message, commit_url, token)
    
    return jsonify({'status': 'success'}), 200
```

### 2. 项目负责人配置（owners.json）

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

### 3. 匹配规则

根据 GitLab 项目路径（如 `grouptwogame/Y_遇水发财`）匹配配置：

1. **精确匹配**：项目路径包含完整的 key
2. **模糊匹配**：项目路径包含 key 的一部分

### 4. 飞书通知

发送卡片消息（私聊），包含：
- 项目名称
- 提交人
- 提交信息
- 查看变更按钮

---

## 📦 部署步骤

### 1. 启动服务器

```bash
cd Feishu_Notify_Setup/webhook_server
启动Webhook服务器.bat
```

服务器将在 `http://0.0.0.0:5000` 启动。

### 2. 配置 GitLab Webhook

1. 打开 GitLab 项目页面
2. 进入 **Settings** → **Webhooks**
3. 填写配置：
   - **URL**: `http://你的服务器IP:5000/gitlab-webhook`
   - **Secret Token**: 留空
   - **Trigger**: 勾选 `Push events`
   - **SSL verification**: 取消勾选（内网 HTTP）
4. 点击 **Add webhook**
5. 点击 **Test** → **Push events** 测试

### 3. 配置项目负责人

编辑 `config/owners.json`，添加项目配置。

### 4. 测试通知

```bash
cd Feishu_Notify_Setup/webhook_server
测试Webhook.bat
```

或提交代码到 GitLab，检查飞书是否收到通知。

---

## ✅ 方案优势

### 对比 GitLab CI 方案

| 特性 | GitLab CI 方案 | Webhook 方案 |
|------|---------------|-------------|
| 中文编码 | ❌ 经常乱码 | ✅ 完美支持 |
| 提交人信息 | ❌ 容易丢失 | ✅ 完整显示 |
| 部署复杂度 | 🟡 中等 | 🟢 简单 |
| 维护成本 | 🔴 高 | 🟢 低 |
| 调试难度 | 🔴 困难 | 🟢 容易 |
| 性能 | 🟡 中等 | 🟢 快速 |

### 核心优势

1. **完全避免 Windows 编码问题**
   - 不需要通过 GitLab CI 传递中文
   - Python 原生支持 UTF-8

2. **提交人信息完整**
   - 直接从 Webhook 数据获取
   - 不会丢失或损坏

3. **更专业可靠**
   - GitLab 官方推荐的集成方式
   - 业界标准做法

4. **性能更好**
   - 不需要启动 GitLab Runner
   - 响应更快

5. **更易维护**
   - 代码逻辑清晰
   - 调试方便
   - 日志完整

---

## 📁 文件结构

```
Feishu_Notify_Setup/
├── webhook_server/
│   ├── webhook_server.py          # Webhook 服务器主程序
│   ├── requirements.txt           # Python 依赖
│   ├── 启动Webhook服务器.bat      # Windows 启动脚本
│   ├── 测试Webhook.bat            # 测试脚本
│   ├── 测试Webhook.py             # 测试程序
│   ├── README.md                  # 完整文档
│   └── 快速部署指南.md            # 5 分钟部署指南
├── config/
│   └── owners.json                # 项目负责人配置
├── docs/
│   └── 关键经验-必读.md           # 关键经验和教训
└── .gitlab-ci.yml                 # GitLab CI 配置（可禁用）
```

---

## 🔍 技术细节

### Webhook 数据格式

GitLab Push Hook 发送的 JSON 数据：

```json
{
  "object_kind": "push",
  "event_name": "push",
  "project": {
    "id": 1,
    "name": "项目名",
    "path_with_namespace": "grouptwogame/Y_遇水发财"
  },
  "user_name": "王新来",
  "user_email": "wangxinlai@huixuanjiasu.com",
  "commits": [
    {
      "id": "abc123",
      "message": "更新美术资源",
      "url": "https://gitlab.xxx.com/project/-/commit/abc123",
      "author": {
        "name": "王新来",
        "email": "wangxinlai@huixuanjiasu.com"
      }
    }
  ]
}
```

### 飞书 API 调用流程

1. **获取访问令牌**
   ```python
   POST https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal
   Body: {"app_id": "...", "app_secret": "..."}
   ```

2. **通过邮箱查找用户 ID**
   ```python
   POST https://open.feishu.cn/open-apis/contact/v3/users/batch_get_id
   Body: {"emails": ["user@xxx.com"]}
   ```

3. **发送卡片消息**
   ```python
   POST https://open.feishu.cn/open-apis/im/v1/messages
   Body: {
       "receive_id": "user_id",
       "msg_type": "interactive",
       "content": "{...}"  # 卡片 JSON
   }
   ```

### 飞书应用权限

需要以下权限：
- `contact:user.email:readonly` - 通过邮箱查找用户
- `im:message` - 发送消息

---

## 🐛 故障排查

### 问题 1：服务器无法启动

**错误**: `ModuleNotFoundError: No module named 'flask'`

**解决**:
```bash
pip install -r requirements.txt
```

### 问题 2：GitLab 无法连接到 Webhook

**错误**: `Connection refused` 或 `Timeout`

**可能原因**:
1. 服务器没有启动
2. 防火墙阻止了 5000 端口
3. IP 地址填写错误

**解决**:
1. 确认服务器正在运行
2. 检查防火墙设置，开放 5000 端口
3. 确认 IP 地址正确

### 问题 3：收不到飞书通知

**检查步骤**:
1. 查看服务器控制台，是否有错误日志
2. 检查 `owners.json` 配置是否正确
3. 检查邮箱是否在飞书中存在
4. 检查飞书应用权限

---

## 📚 相关文档

- [快速部署指南](../../Feishu_Notify_Setup/webhook_server/快速部署指南.md) - 5 分钟完成部署
- [完整文档](../../Feishu_Notify_Setup/webhook_server/README.md) - 详细说明
- [关键经验](../../Feishu_Notify_Setup/docs/关键经验-必读.md) - 血泪教训
- [GitLab Webhook 文档](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html)
- [飞书开放平台文档](https://open.feishu.cn/document/home/index)

---

## 💡 经验总结

### 为什么 GitLab CI 方案失败？

1. **Windows 编码问题**
   - GitLab CI 使用 Latin-1 编码
   - PowerShell 使用 GBK 编码
   - 多次转换导致中文损坏

2. **环境限制**
   - GitLab Runner 工作目录是临时的
   - 环境变量传递不稳定
   - PowerShell 多行命令块执行不稳定

3. **维护成本高**
   - 需要处理各种边界情况
   - 调试困难
   - 容易忘记关键配置

### 为什么 Webhook 方案成功？

1. **避开编码问题**
   - 不需要通过 GitLab CI 传递中文
   - Python 原生支持 UTF-8
   - 数据直接从 Webhook 获取

2. **架构简单**
   - 单一服务器
   - 逻辑清晰
   - 易于调试

3. **业界标准**
   - GitLab 官方推荐
   - 成熟可靠
   - 社区支持好

### 关键教训

1. **选择正确的方案**
   - 不要强行使用不适合的工具
   - 遇到问题时，考虑换方案
   - 业界标准通常是最佳实践

2. **记录经验**
   - 每次解决问题后，立即写文档
   - 记录失败的尝试
   - 记录成功的方案

3. **自动化测试**
   - 提供测试脚本
   - 降低部署门槛
   - 提高可靠性

---

## 🎯 下一步

### 生产环境优化

1. **使用生产级 WSGI 服务器**
   ```bash
   pip install gunicorn
   gunicorn -w 4 -b 0.0.0.0:5000 webhook_server:app
   ```

2. **配置 Nginx 反向代理**
   ```nginx
   server {
       listen 80;
       server_name webhook.example.com;
       
       location / {
           proxy_pass http://127.0.0.1:5000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```

3. **使用 HTTPS**
   - 申请 SSL 证书
   - 配置 Nginx HTTPS

4. **添加监控**
   - 日志文件记录
   - 日志轮转
   - 监控告警

5. **安全加固**
   - 配置 Webhook Secret Token
   - 限制访问 IP
   - 使用环境变量管理敏感信息

---

## 🎉 总结

通过使用 GitLab Webhook + Python Flask 服务器方案，我们成功解决了：

1. ✅ 中文乱码问题
2. ✅ 提交人信息丢失问题
3. ✅ 维护成本高的问题
4. ✅ 调试困难的问题

这是一个**专业、可靠、易维护**的解决方案，强烈推荐使用！

---

**创建时间**: 2026-01-23  
**作者**: Kiro AI Assistant  
**版本**: v1.0  
**状态**: ✅ 已完成并测试
