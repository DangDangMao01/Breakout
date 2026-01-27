# 脚本文件说明

> 本文件夹存放飞书通知系统的脚本文件

---

## 📋 文件列表

### notify_v3_auto_match.py
**版本**: v3.1  
**用途**: 美术资源通知主脚本  
**功能**:
- ✅ 自动识别项目路径
- ✅ 支持多人通知
- ✅ 美观的卡片消息
- ✅ 详细的日志输出
- ✅ 失败自动降级（卡片 → 文本）

**使用方法**:
```bash
# 在 GitLab CI 中自动运行
python notify_v3_auto_match.py
```

**环境变量**:
- `FEISHU_APP_ID` - 飞书应用 ID
- `FEISHU_APP_SECRET` - 飞书应用密钥
- `CI_COMMIT_MESSAGE` - 提交信息
- `GITLAB_USER_NAME` - 提交人
- `CI_PROJECT_PATH` - 项目路径
- `CI_COMMIT_SHA` - 提交 SHA
- `CI_PROJECT_URL` - 项目 URL

---

### gantt_reminder.py
**用途**: 甘特图任务提醒  
**说明**: 从飞书多维表格读取任务，发送提醒

---

### my_task_reminder.py
**用途**: 个人任务提醒  
**说明**: 读取 `my_tasks.json`，发送个人任务提醒

---

### my_tasks.json
**用途**: 个人任务配置文件  
**格式**:
```json
{
    "tasks": [
        {
            "title": "任务标题",
            "deadline": "2026-01-25",
            "owner": "email@huixuanjiasu.com"
        }
    ]
}
```

---

## 🚀 快速使用

### 本地测试

```bash
# 设置环境变量
set FEISHU_APP_ID=your_app_id
set FEISHU_APP_SECRET=your_app_secret
set CI_PROJECT_PATH=grouptwogame/测试文件
set GITLAB_USER_NAME=测试用户
set CI_COMMIT_MESSAGE=测试提交

# 运行脚本
python notify_v3_auto_match.py
```

### 部署到生产

```bash
# 复制到公司工程
copy notify_v3_auto_match.py D:\HuiXuanJiaSu\I_IAA_Work\notify.py

# 提交代码
git add notify.py
git commit -m "更新通知脚本"
git push
```

---

## 📊 版本历史

| 文件 | 版本 | 日期 | 说明 |
|------|------|------|------|
| notify_v3_auto_match.py | v3.1 | 2026-01-21 | 支持多人通知 |
| notify_v2_enhanced.py | v2.0 | 2025-12 | 增强版（已归档） |
| notify.py | v1.0 | 2025-11 | 基础版（已归档） |

---

## 🔧 开发说明

### 添加新功能

1. 在 `notify_v3_auto_match.py` 基础上修改
2. 更新版本号
3. 测试通过后部署
4. 更新文档

### 调试技巧

```python
# 启用详细日志
print(f"[调试] 变量值: {variable}")

# 测试模式
os.environ['TEST_MODE'] = 'true'
os.environ['TEST_EMAIL'] = 'your@email.com'
```

---

## 📚 相关文档

- [v3.1 部署指南](../docs/v3.1部署指南.md)
- [使用说明](../docs/使用说明.md)
- [修复方案](../docs/修复方案.md)

---

**更新时间**: 2026-01-22
