# GitLab Webhook 飞书通知 - 一键部署完整包

> 🎉 5 分钟完成部署，自动收到 GitLab 提交通知！

---

## 📦 完整包内容

```
Feishu_Notify_Setup/
├── 一键部署完整包.bat          # 🔥 完整部署流程（推荐）
│
├── webhook_server/             # Webhook 服务器
│   ├── 一键部署.bat            # 快速部署
│   ├── 检查环境.bat            # 环境检查
│   ├── 配置向导.bat            # 配置向导
│   ├── 启动Webhook服务器.bat   # 启动服务器
│   ├── 测试Webhook.bat         # 测试工具
│   ├── webhook_server.py       # 服务器主程序
│   ├── requirements.txt        # Python 依赖
│   ├── 给同事的使用说明.md     # 🔥 给同事看这个
│   ├── 快速部署指南.md         # 详细指南
│   ├── README.md               # 完整文档
│   └── 分享给同事.txt          # 分享说明
│
├── config/
│   ├── owners.json             # 项目负责人配置
│   └── owners_example.json     # 配置示例
│
├── docs/
│   ├── 关键经验-必读.md        # 血泪教训
│   ├── GitLab-CI-vs-Webhook方案对比.md
│   └── ...
│
└── scripts/                    # 旧的 GitLab CI 脚本（已废弃）
```

---

## 🚀 快速开始

### 方式 1：完整部署流程（推荐新手）

双击运行：
```
一键部署完整包.bat
```

会引导你完成：
1. ✅ 环境检查
2. ✅ 配置项目负责人
3. ✅ 一键部署
4. ✅ 生成部署信息

### 方式 2：快速部署（推荐熟手）

```bash
cd webhook_server
一键部署.bat
```

### 方式 3：手动部署（推荐高级用户）

```bash
cd webhook_server

# 1. 检查环境
检查环境.bat

# 2. 配置项目负责人
配置向导.bat

# 3. 启动服务器
启动Webhook服务器.bat

# 4. 配置 GitLab Webhook（查看 部署信息.txt）

# 5. 测试
测试Webhook.bat
```

---

## 📋 部署步骤详解

### 第 1 步：环境检查

运行 `webhook_server/检查环境.bat`

会自动检查：
- ✅ Python 环境（需要 3.7+）
- ✅ pip 包管理器
- ✅ Flask 框架
- ✅ requests 库
- ✅ 配置文件
- ✅ 网络配置
- ✅ 防火墙规则

**如果有错误**：
- 按照提示安装 Python
- 运行 `一键部署.bat` 自动安装依赖

### 第 2 步：配置项目负责人

编辑 `config/owners.json`：

```json
{
    "项目名": "邮箱@huixuanjiasu.com"
}
```

**单人通知**：
```json
{
    "Y_遇水发财": "zhangsan@huixuanjiasu.com"
}
```

**多人通知**：
```json
{
    "N_奶奶的小农院": [
        "lisi@huixuanjiasu.com",
        "wangwu@huixuanjiasu.com"
    ]
}
```

**匹配规则**：
- GitLab 项目路径：`grouptwogame/Y_遇水发财`
- 配置 key：`Y_遇水发财`
- 只要项目路径包含 key 即可匹配

### 第 3 步：启动服务器

运行 `webhook_server/启动Webhook服务器.bat`

看到以下信息表示成功：
```
========================================
  服务器信息
========================================
  监听地址: http://0.0.0.0:5000
  Webhook URL: http://192.168.1.100:5000/gitlab-webhook
  健康检查: http://192.168.1.100:5000/health
========================================
```

**⚠️ 重要**：保持窗口打开，不要关闭！

### 第 4 步：配置 GitLab Webhook

1. 打开 GitLab 项目页面
2. 进入 **Settings** → **Webhooks**
3. 填写配置（从 `部署信息.txt` 复制）：
   ```
   URL: http://你的IP:5000/gitlab-webhook
   Secret Token: (留空)
   Trigger: ✅ Push events
   SSL verification: ❌ 取消勾选
   ```
4. 点击 **Add webhook**
5. 点击 **Test** → **Push events** 测试

### 第 5 步：测试通知

**方式 1：自动测试**
```
测试Webhook.bat
```

**方式 2：提交代码测试**
```bash
git add .
git commit -m "测试通知"
git push
```

**验证**：
- ✅ 服务器控制台有日志输出
- ✅ 飞书收到通知
- ✅ 提交人和提交信息正确显示

---

## 🎯 使用场景

### 场景 1：个人使用

1. 部署 Webhook 服务器
2. 配置自己的项目
3. 收到自己的提交通知

### 场景 2：团队使用

1. 管理员部署 Webhook 服务器
2. 配置所有项目和负责人
3. 团队成员收到相关项目的通知

### 场景 3：多项目管理

1. 配置多个项目
2. 每个项目可以通知多个人
3. 灵活管理通知规则

---

## 📊 方案对比

| 特性 | GitLab CI 方案 | Webhook 方案（本方案） |
|------|---------------|---------------------|
| 中文支持 | ❌ 经常乱码 | ✅ 完美支持 |
| 提交人信息 | ❌ 容易丢失 | ✅ 完整显示 |
| 部署复杂度 | 🟡 中等 | 🟢 简单（5 分钟） |
| 维护成本 | 🔴 高 | 🟢 低 |
| 调试难度 | 🔴 困难 | 🟢 容易 |
| 性能 | 🟡 中等 | 🟢 快速 |

**详细对比**：查看 `docs/GitLab-CI-vs-Webhook方案对比.md`

---

## 🔧 常用操作

### 启动服务器
```
webhook_server/启动Webhook服务器.bat
```

### 停止服务器
在服务器窗口按 `Ctrl+C`

### 修改配置
编辑 `config/owners.json`，保存后自动生效

### 查看日志
查看服务器控制台输出

### 测试功能
```
webhook_server/测试Webhook.bat
```

### 检查环境
```
webhook_server/检查环境.bat
```

---

## 📚 文档导航

### 快速开始
- **给同事的使用说明**：`webhook_server/给同事的使用说明.md` 🔥
- **快速部署指南**：`webhook_server/快速部署指南.md`

### 详细文档
- **完整文档**：`webhook_server/README.md`
- **方案对比**：`docs/GitLab-CI-vs-Webhook方案对比.md`
- **关键经验**：`docs/关键经验-必读.md`

### 分享给同事
- **分享说明**：`webhook_server/分享给同事.txt`
- **使用说明**：`webhook_server/给同事的使用说明.md`

---

## 🐛 故障排查

### 问题 1：服务器无法启动

**错误**：`ModuleNotFoundError: No module named 'flask'`

**解决**：
```
运行 "一键部署.bat" 自动安装依赖
```

### 问题 2：GitLab 无法连接

**错误**：`Connection refused` 或 `Timeout`

**检查**：
1. 服务器是否正在运行？
2. 防火墙是否开放 5000 端口？
3. IP 地址是否正确？

**解决**：
```
运行 "检查环境.bat" 自动诊断
```

### 问题 3：收不到通知

**检查清单**：
1. ✅ Webhook 服务器正在运行
2. ✅ GitLab Webhook 配置正确
3. ✅ `owners.json` 配置了项目
4. ✅ 邮箱在飞书中存在

**解决**：
```
1. 查看服务器控制台日志
2. 运行 "测试Webhook.bat"
3. 检查 GitLab Webhook 测试结果
```

### 更多问题

查看 `webhook_server/README.md` 的故障排查章节

---

## 🎁 分享给同事

### 打包分享

1. 右键点击 `Feishu_Notify_Setup` 文件夹
2. 选择 "发送到" → "压缩(zipped)文件夹"
3. 将 `Feishu_Notify_Setup.zip` 分享给同事

### 分享说明

发送以下消息：

```
【推荐】GitLab 飞书通知系统

✅ 自动通知：提交代码后自动收到飞书消息
✅ 5 分钟部署：一键部署，无需复杂配置
✅ 多人通知：支持一个项目通知多个人
✅ 中文支持：完美支持中文提交信息

部署步骤：
1. 解压 Feishu_Notify_Setup.zip
2. 运行 "一键部署完整包.bat"
3. 按照提示完成配置

详细说明：
查看 webhook_server/给同事的使用说明.md

快来试试吧！🚀
```

---

## 🎉 总结

### 优势

1. **部署简单**：5 分钟完成，一键部署
2. **功能完整**：提交人、中文信息完整显示
3. **易于维护**：代码清晰，调试方便
4. **性能优秀**：响应快速，稳定可靠
5. **易于分享**：完整包，同事可快速部署

### 适用场景

- ✅ 个人项目通知
- ✅ 团队项目管理
- ✅ 多项目协作
- ✅ 美术资源更新通知
- ✅ 代码审查提醒

### 下一步

1. **部署**：运行 `一键部署完整包.bat`
2. **测试**：提交代码测试通知
3. **分享**：分享给团队成员
4. **优化**：根据需求调整配置

---

**创建时间**: 2026-01-23  
**版本**: v1.0  
**维护**: 技术团队  
**状态**: ✅ 生产就绪

---

**祝使用愉快！** 🎉
