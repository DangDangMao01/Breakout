# Webhook 方案部署指南

**方案类型**: GitLab Webhook + Python Flask 服务器  
**推荐度**: ⭐⭐⭐⭐⭐（5/5）  
**适用场景**: 对功能和用户体验要求高  
**更新日期**: 2026-01-27

---

## 📋 方案概述

运行独立的 Python Flask 服务器，接收 GitLab Webhook 请求，发送飞书通知。

### 优点

- ✅ **中文完美支持**：无编码问题
- ✅ **提交人信息完整**：准确显示提交人
- ✅ **功能强大**：完全自定义
- ✅ **易于维护**：代码清晰，调试方便
- ✅ **性能优秀**：响应快速

### 缺点

- ❌ **需要管理员权限**：需要开启 GitLab Webhook 本地网络请求
- ⚠️ **需要运行服务器**：需要保持服务器运行

---

## 🚀 快速部署（5 分钟）

### Step 1: 准备环境

#### 安装 Python 依赖

```bash
cd Feishu_Notify_Setup\webhook_server
pip install -r requirements.txt
```

`requirements.txt` 内容：
```
Flask==3.0.0
requests==2.31.0
```

### Step 2: 配置飞书应用

1. 登录飞书开放平台：https://open.feishu.cn/
2. 创建企业自建应用
3. 获取 `APP_ID` 和 `APP_SECRET`
4. 添加权限：`contact:user.email:readonly`
5. 发布应用

详细步骤：查看 [飞书应用创建指南](./飞书应用创建指南.md)

### Step 3: 配置环境变量

#### Windows 环境

```bash
# 临时设置（当前会话有效）
set FEISHU_APP_ID=cli_a9e3400711fbdbcb
set FEISHU_APP_SECRET=h61QXukkibdbO0wRRFxTkgppaLvcPQFS

# 永久设置（推荐）
setx FEISHU_APP_ID "cli_a9e3400711fbdbcb"
setx FEISHU_APP_SECRET "h61QXukkibdbO0wRRFxTkgppaLvcPQFS"
```

#### Linux/Mac 环境

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
export FEISHU_APP_ID="cli_a9e3400711fbdbcb"
export FEISHU_APP_SECRET="h61QXukkibdbO0wRRFxTkgppaLvcPQFS"

# 重新加载配置
source ~/.bashrc
```

### Step 4: 配置负责人名单

编辑 `config/owners.json`：

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

### Step 5: 启动服务器

#### 方式 1：使用 bat 脚本（Windows）

```bash
cd Feishu_Notify_Setup\webhook_server
启动Webhook服务器.bat
```

#### 方式 2：手动启动

```bash
cd Feishu_Notify_Setup\webhook_server
python webhook_server.py
```

#### 启动成功

```
============================================================
GitLab Webhook 服务器启动
============================================================
监听地址: http://0.0.0.0:5000
Webhook URL: http://your-server-ip:5000/gitlab-webhook
============================================================
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://172.22.96.1:5000
```

### Step 6: 配置 GitLab Webhook

#### 6.1 申请管理员权限

**如果你不是 GitLab 管理员**，需要申请开启 Webhook 本地网络请求权限。

参考文档：[给老板的申请文档](../给老板的申请文档.md)

#### 6.2 开启 Webhook 权限（管理员操作）

1. 登录 GitLab
2. 进入 Admin Area（管理员区域）
3. 点击 Settings → Network
4. 展开 Outbound requests
5. 勾选 "Allow requests to the local network from webhooks and integrations"
6. 点击 Save changes

#### 6.3 配置项目 Webhook

1. 打开 GitLab 项目
2. 进入 Settings → Webhooks
3. 填写配置：

```
URL: http://172.22.96.1:5000/gitlab-webhook
Secret Token: (留空或设置密钥)
Trigger: ✅ Push events
SSL verification: ❌ 取消勾选（内网环境）
```

4. 点击 "Add webhook"

### Step 7: 测试 Webhook

#### 方式 1：使用 GitLab 测试功能

1. 在 Webhooks 页面找到刚添加的 Webhook
2. 点击 "Test" → "Push events"
3. 查看响应结果

#### 方式 2：提交代码测试

```bash
cd D:\HuiXuanJiaSu\I_IAA_Work
git add .
git commit -m "测试 Webhook 通知"
git push
```

#### 方式 3：使用测试脚本

```bash
cd Feishu_Notify_Setup\webhook_server
测试Webhook.bat
```

### Step 8: 查看结果

#### 服务器日志

```
[Webhook] 项目: grouptwogame/grouptowart_hb
[Webhook] 提交人: 王新来 <wangxinlai@huixuanjiasu.com>
[Webhook] 提交信息: 更新角色动画资源，修复了跑步动画的bug
[成功] 通知已发送给 wangxinlai@huixuanjiasu.com
```

#### 飞书通知

```
[美术资源更新提醒]

项目: GroupTwoGame/groupTowArt_Hb
提交人: 王新来
提交信息: 更新角色动画资源，修复了跑步动画的bug

[查看变更]
```

---

## 📊 通知效果对比

### Webhook 方案（完美）

```
[美术资源更新提醒]

项目: GroupTwoGame/groupTowArt_Hb
提交人: 王新来
提交信息: 更新角色动画资源，修复了跑步动画的bug

[查看变更]
```

### GitLab CI 方案（受限）

```
[Art Resource Update Reminder]

Project: GroupTwoGame/groupTowArt_Hb
Submitter: Unknown User
Update Time: 2026-01-27 18:00:09

[View Changes]
```

---

## 🔧 高级配置

### 自定义端口

编辑 `webhook_server.py`：

```python
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)  # 改为 8080
```

### 添加 Secret Token 验证

编辑 `webhook_server.py`：

```python
@app.route('/gitlab-webhook', methods=['POST'])
def gitlab_webhook():
    # 验证 Secret Token
    token = request.headers.get('X-Gitlab-Token')
    if token != 'your-secret-token':
        return jsonify({'status': 'error', 'reason': 'Invalid token'}), 403
    
    # ... 其他代码
```

### 后台运行服务器

#### Windows 环境

使用 `pythonw.exe`（无窗口运行）：

```bash
start /B pythonw webhook_server.py
```

或者使用 NSSM（推荐）：

```bash
# 下载 NSSM: https://nssm.cc/download
nssm install FeishuWebhook "C:\Python\python.exe" "C:\path\to\webhook_server.py"
nssm start FeishuWebhook
```

#### Linux 环境

使用 systemd：

```bash
# 创建服务文件
sudo nano /etc/systemd/system/feishu-webhook.service

# 内容：
[Unit]
Description=Feishu Webhook Server
After=network.target

[Service]
Type=simple
User=your-user
WorkingDirectory=/path/to/webhook_server
Environment="FEISHU_APP_ID=your_app_id"
Environment="FEISHU_APP_SECRET=your_app_secret"
ExecStart=/usr/bin/python3 webhook_server.py
Restart=always

[Install]
WantedBy=multi-user.target

# 启动服务
sudo systemctl daemon-reload
sudo systemctl enable feishu-webhook
sudo systemctl start feishu-webhook
```

---

## 🐛 故障排查

### 问题 1：GitLab 报错 "URL 已被阻止"

**错误信息**：
```
URL 已被阻止: 不允许向本地网络发出请求
```

**原因**：
- GitLab 默认禁止向内网 IP 发送 Webhook 请求

**解决方案**：
1. 需要 GitLab 管理员权限
2. 进入 Admin Area → Settings → Network
3. 勾选 "Allow requests to the local network from webhooks and integrations"
4. 保存设置

**如果没有管理员权限**：
- 参考：[给老板的申请文档](../给老板的申请文档.md)
- 或者使用 GitLab CI 方案

---

### 问题 2：服务器无法访问

**排查步骤**：

1. **检查服务器是否运行**：
```bash
# Windows
netstat -ano | findstr :5000

# Linux
netstat -tuln | grep :5000
```

2. **检查防火墙**：
```bash
# Windows
netsh advfirewall firewall add rule name="Feishu Webhook" dir=in action=allow protocol=TCP localport=5000

# Linux
sudo ufw allow 5000
```

3. **检查 IP 地址**：
```bash
# Windows
ipconfig

# Linux
ip addr show
```

4. **测试本地访问**：
```bash
curl http://127.0.0.1:5000/health
```

---

### 问题 3：没有收到通知

**排查步骤**：

1. **检查服务器日志**：
   - 是否收到 Webhook 请求？
   - 是否有错误信息？

2. **检查 owners.json**：
   - 项目路径是否匹配？
   - 邮箱是否正确？

3. **检查飞书配置**：
   - APP_ID 和 APP_SECRET 是否正确？
   - 权限是否添加？
   - 应用是否发布？

4. **手动测试**：
```bash
# 使用测试脚本
cd webhook_server
python 测试Webhook.py
```

---

### 问题 4：中文乱码

**原因**：
- 这不应该发生！Webhook 方案完美支持中文

**如果出现乱码**：
1. 检查 `webhook_server.py` 文件编码是否为 UTF-8
2. 检查 Python 版本（建议 Python 3.7+）
3. 检查环境变量设置

---

## 📋 维护指南

### 添加新项目

编辑 `config/owners.json`：

```json
{
    "新项目名称": ["email@huixuanjiasu.com"]
}
```

**无需重启服务器**，配置立即生效。

### 添加新负责人

```json
{
    "项目名称": [
        "email1@huixuanjiasu.com",
        "email2@huixuanjiasu.com"
    ]
}
```

### 更新服务器代码

```bash
# 1. 停止服务器（Ctrl+C）
# 2. 修改代码
# 3. 重新启动
python webhook_server.py
```

### 查看日志

服务器日志会实时输出到控制台。

如果需要保存日志：

```bash
# Windows
python webhook_server.py > logs.txt 2>&1

# Linux
python webhook_server.py >> /var/log/feishu-webhook.log 2>&1
```

---

## 🚀 生产环境部署

### 使用 Gunicorn（Linux）

```bash
# 安装 Gunicorn
pip install gunicorn

# 启动服务器
gunicorn -w 4 -b 0.0.0.0:5000 webhook_server:app
```

### 使用 Nginx 反向代理

```nginx
server {
    listen 80;
    server_name webhook.example.com;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

### 使用 Docker

```dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY webhook_server.py .
COPY ../config/owners.json ./config/

ENV FEISHU_APP_ID=your_app_id
ENV FEISHU_APP_SECRET=your_app_secret

EXPOSE 5000
CMD ["python", "webhook_server.py"]
```

---

## 📚 相关文档

- [方案对比与选择指南](../方案对比与选择指南.md) - 三种方案对比
- [GitLab CI 方案部署指南](./GitLab-CI方案部署指南.md) - 备用方案
- [飞书工作配方部署指南](./飞书工作配方部署指南.md) - 官方方案
- [给老板的申请文档](../给老板的申请文档.md) - 申请权限
- [快速部署指南](../webhook_server/快速部署指南.md) - 简化版

---

## 🎉 总结

### 为什么选择 Webhook 方案？

1. **功能最完整**：
   - ✅ 提交人信息完整
   - ✅ 中文提交信息完整
   - ✅ 完全自定义

2. **用户体验最好**：
   - ✅ 通知内容详细
   - ✅ 无编码问题
   - ✅ 响应快速

3. **维护成本最低**：
   - ✅ 代码清晰
   - ✅ 调试方便
   - ✅ 易于扩展

### 唯一的要求

**需要 GitLab 管理员开启 Webhook 本地网络请求权限**

如果无法获得权限：
- 使用 GitLab CI 方案（备用）
- 或申请飞书工作配方（官方）

---

**创建时间**: 2026-01-27  
**维护人**: 技术团队  
**版本**: v1.0
