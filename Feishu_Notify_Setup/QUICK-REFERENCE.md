# 快速参考卡片

> 飞书美术资源通知系统 - 常用操作速查

---

## 🚀 快速开始

### 1. 新增项目配置

```bash
# 编辑配置文件
notepad config\owners.json

# 添加配置
{
    "新项目名称": ["email@huixuanjiasu.com"]
}

# 提交到 GitLab
git add config\owners.json
git commit -m "新增项目配置"
git push
```

---

## 📋 常用配置

### 单人负责
```json
"Y_遇水发财": ["zhaolida@huixuanjiasu.com"]
```

### 多人负责
```json
"C_财运接龙": [
    "wangxinlai@huixuanjiasu.com",
    "zhaolida@huixuanjiasu.com"
]
```

---

## 🔧 常用命令

### 本地测试
```bash
# 设置环境变量
set FEISHU_APP_ID=your_app_id
set FEISHU_APP_SECRET=your_app_secret
set CI_PROJECT_PATH=grouptwogame/测试文件
set GITLAB_USER_NAME=测试用户
set CI_COMMIT_MESSAGE=测试提交

# 运行脚本
cd Feishu_Notify_Setup\scripts
python notify_v3_auto_match.py
```

### 部署到生产
```bash
# 方式 1：使用批处理
部署到公司工程.bat

# 方式 2：手动复制
copy scripts\notify_v3_auto_match.py D:\HuiXuanJiaSu\I_IAA_Work\notify.py
copy config\owners.json D:\HuiXuanJiaSu\I_IAA_Work\owners.json
```

---

## 📊 查看日志

### GitLab CI 日志
1. 打开 GitLab 项目
2. 点击 CI/CD → Pipelines
3. 点击最新的 Pipeline
4. 查看 `notify` 任务日志

### 关键日志标识
```
✓ 成功标识
✗ 失败标识
🔍 查找标识
📤 发送标识
```

---

## 🐛 故障排查

### 问题：没收到通知

**检查清单**：
```bash
# 1. 检查项目路径是否匹配
# 日志中查找：[查找] 正在查找项目 'xxx' 的负责人...

# 2. 检查邮箱是否正确
# 日志中查找：[成功] 找到 X 个负责人

# 3. 检查用户 ID 是否找到
# 日志中查找：[成功] 找到用户 ID: ou_xxxxx

# 4. 检查消息是否发送成功
# 日志中查找：[成功] 卡片消息发送成功！
```

### 问题：部分人收到，部分人没收到

**解决方法**：
1. 查看 CI 日志，找到失败的邮箱
2. 确认邮箱拼写正确
3. 确认用户在飞书中存在

---

## 📁 文件位置

### 生产环境
```
D:\HuiXuanJiaSu\I_IAA_Work\
├── notify.py          # 主脚本
├── owners.json        # 配置文件
└── .gitlab-ci.yml     # CI 配置
```

### GitLab Runner
```
C:\GitLab-Runner\
├── notify.py          # 主脚本（副本）
└── owners.json        # 配置文件（副本）
```

### 开发环境
```
E:\K_Kiro_Work\Feishu_Notify_Setup\
├── scripts\notify_v3_auto_match.py  # 源码
└── config\owners.json               # 配置
```

---

## 🔗 快速链接

| 文档 | 路径 |
|------|------|
| 最新部署指南 | [docs/v3.1部署指南.md](./docs/v3.1部署指南.md) |
| 配置说明 | [config/README.md](./config/README.md) |
| 脚本说明 | [scripts/README.md](./scripts/README.md) |
| 更新日志 | [CHANGELOG.md](./CHANGELOG.md) |
| 主说明 | [README.md](./README.md) |

---

## 📞 联系方式

遇到问题？
1. 查看 [docs/修复方案.md](./docs/修复方案.md)
2. 查看 CI 日志
3. 联系开发人员

---

**版本**: v3.1  
**更新时间**: 2026-01-22  
**当前状态**: ✅ 已部署，等待测试验证
