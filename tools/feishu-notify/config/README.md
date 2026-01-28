# 配置文件说明

> 本文件夹存放飞书通知系统的配置文件

---

## 📋 文件列表

### owners.json
**用途**: 生产环境配置文件  
**说明**: 定义项目与负责人的对应关系

**格式**：
```json
{
    "_comment": "美术资源负责人配置文件 v3.1",
    "_说明": "支持单人或多人通知",
    
    "项目名称": ["email@huixuanjiasu.com"],
    "多人项目": [
        "email1@huixuanjiasu.com",
        "email2@huixuanjiasu.com"
    ]
}
```

**注意事项**：
- 项目名称要与 GitLab 项目路径匹配
- 邮箱必须是飞书企业邮箱
- 支持单人或多人通知
- 以 `_` 开头的字段会被忽略（用于注释）

---

### owners_example.json
**用途**: 配置示例文件  
**说明**: 提供配置格式参考

**使用方法**：
1. 复制 `owners_example.json` 为 `owners.json`
2. 修改项目名称和邮箱
3. 提交到 GitLab

---

## 🔧 配置示例

### 单人负责

```json
{
    "Y_遇水发财": ["zhaolida@huixuanjiasu.com"]
}
```

### 多人负责

```json
{
    "C_财运接龙": [
        "wangxinlai@huixuanjiasu.com",
        "zhaolida@huixuanjiasu.com"
    ]
}
```

### 完整配置

```json
{
    "_comment": "美术资源负责人配置文件 v3.1",
    "_说明": "支持单人或多人通知",
    
    "_游戏项目": "以下是游戏项目",
    "Y_遇水发财": ["zhaolida@huixuanjiasu.com"],
    "C_财运接龙": [
        "wangxinlai@huixuanjiasu.com",
        "zhaolida@huixuanjiasu.com"
    ],
    
    "_测试项目": "以下是测试项目",
    "测试文件": ["wangxinlai@huixuanjiasu.com"]
}
```

---

## 🐛 常见问题

### Q: 为什么没收到通知？

**检查清单**：
1. 项目名称是否正确匹配
2. 邮箱拼写是否正确
3. 用户是否在飞书中
4. 查看 CI 日志确认错误

### Q: 如何添加新项目？

```json
{
    "新项目名称": ["newemail@huixuanjiasu.com"]
}
```

### Q: 如何给现有项目增加人员？

```json
// 修改前
"C_财运接龙": ["wangxinlai@huixuanjiasu.com"]

// 修改后
"C_财运接龙": [
    "wangxinlai@huixuanjiasu.com",
    "zhaolida@huixuanjiasu.com"  // 新增
]
```

---

## 📚 相关文档

- [v3.1 部署指南](../docs/v3.1部署指南.md)
- [使用说明](../docs/使用说明.md)

---

**更新时间**: 2026-01-22
