# 更新日志

---

## [v3.2] 2026-01-27

### 📚 创建三种方案独立部署指南

**新增文档**：
1. ✅ [GitLab CI 方案部署指南](./docs/GitLab-CI方案部署指南.md)
   - 当前使用的方案
   - 详细的部署步骤
   - 完整的故障排查

2. ✅ [Webhook 方案部署指南](./docs/Webhook方案部署指南.md)
   - 推荐方案
   - 5 分钟快速部署
   - 完美支持中文和提交人信息

3. ✅ [飞书工作配方部署指南](./docs/飞书工作配方部署指南.md)
   - 官方方案
   - 可视化配置
   - 无需维护

**决策文档**：
- ✅ [方案对比与选择指南](./方案对比与选择指南.md)
  - 三种方案详细对比
  - 决策流程图
  - 升级路径建议

- ✅ [给老板的申请文档](./给老板的申请文档.md)
  - 业务价值说明
  - 投资回报分析（ROI > 300%）
  - 申请模板

### 📁 文件夹深度整理

**清理旧文件**：
- ✅ 移动 4 个旧 bat 文件到 `archives/old-bat-files/`
  - 快速部署.bat
  - 一键部署完整包.bat
  - 一键修复部署.bat
  - 回滚配置.bat

- ✅ 移动 6 个旧文档到 `archives/old-docs/`
  - 今日部署检查清单.md
  - 周一测试清单.md
  - 飞书工作配方配置检查清单.md
  - 飞书秘钥检查清单.md
  - QUICK-REFERENCE.md
  - README-一键部署.md

**更新文档**：
- ✅ 更新 README.md
  - 添加方案选择指南
  - 优化目录结构说明
  - 添加快速开始指南

- ✅ 更新关键经验文档
  - 推荐 Webhook 方案
  - 添加方案对比
  - 更新最佳实践

**整理效果**：
- ✅ 根目录更清爽（只保留核心文件）
- ✅ 文档结构更清晰（三种方案独立）
- ✅ 决策流程更明确（对比 + 申请）
- ✅ 便于后续维护和扩展

---

## [整理] 2026-01-22

### 📁 文件夹结构重组

**整理前的问题**：
- ❌ 11 个不同版本的 `.gitlab-ci` 配置文件混乱
- ❌ 多个版本的脚本文件混在一起
- ❌ 测试文件和生产文件混在一起
- ❌ 文档分散，难以查找

**整理后的结构**：
```
Feishu_Notify_Setup/
├── archives/      # 归档旧文件
├── config/        # 配置文件
├── docs/          # 文档
├── scripts/       # 脚本
└── image/         # 图片
```

**具体操作**：
1. ✅ 创建 `archives/` 目录，归档旧文件
   - `ci-configs/` - 11 个旧 CI 配置
   - `old-scripts/` - v1.0, v2.0 脚本
   - `test-files/` - 测试文件
2. ✅ 创建 `config/` 目录，统一配置文件
3. ✅ 创建 `docs/` 目录，统一文档
4. ✅ 创建 `scripts/` 目录，统一脚本
5. ✅ 为每个目录添加 README.md 说明

**文件移动清单**：

**归档的 CI 配置**（11 个）：
- `.gitlab-ci-correct.yml`
- `.gitlab-ci-final-fix.yml`
- `.gitlab-ci-final-simple.yml`
- `.gitlab-ci-final.yml`
- `.gitlab-ci-fixed.yml`
- `.gitlab-ci-prod.yml`
- `.gitlab-ci-simple.yml`
- `.gitlab-ci-test.yml`
- `.gitlab-ci-v3.1.yml`
- `.gitlab-ci-working.yml`
- 保留根目录的 `.gitlab-ci.yml`（当前使用）

**归档的脚本**（2 个）：
- `notify.py` → `archives/old-scripts/`
- `notify_v2_enhanced.py` → `archives/old-scripts/`

**归档的测试文件**（3 个）：
- `test_feishu_api.py` → `archives/test-files/`
- `test_feishu_connection.py` → `archives/test-files/`
- `commit-message.txt` → `archives/test-files/`

**移动的配置文件**（2 个）：
- `owners.json` → `config/`
- `owners_example.json` → `config/`

**移动的文档**（11 个）：
- `v3.1部署指南.md` → `docs/`
- `v3.0部署指南.md` → `docs/`
- `飞书应用创建指南.md` → `docs/`
- `部署到公司工程指南.md` → `docs/`
- `使用说明.md` → `docs/`
- `修复方案.md` → `docs/`
- `功能价值说明.md` → `docs/`
- `需求调研问卷.md` → `docs/`
- `运行日志模板.md` → `docs/`
- `个人任务提醒部署指南.md` → `docs/`
- `飞书多维表格自动通知方案.md` → `docs/`

**移动的脚本**（4 个）：
- `notify_v3_auto_match.py` → `scripts/`
- `gantt_reminder.py` → `scripts/`
- `my_task_reminder.py` → `scripts/`
- `my_tasks.json` → `scripts/`

**新增的文档**（5 个）：
- `README.md` - 主说明文档
- `CHANGELOG.md` - 本文件
- `archives/README.md` - 归档说明
- `config/README.md` - 配置说明
- `scripts/README.md` - 脚本说明

**整理效果**：
- ✅ 根目录清爽，只保留必要文件
- ✅ 文件分类清晰，易于查找
- ✅ 每个目录都有说明文档
- ✅ 旧文件归档，不影响当前使用
- ✅ 便于后续维护和扩展

---

## [v3.1] 2026-01-21

### 🎉 支持多人通知

**新功能**：
- ✅ 一个项目可以通知多个人
- ✅ 兼容旧版本单人配置
- ✅ 详细的发送日志
- ✅ 失败统计

**配置格式**：
```json
{
    "项目名称": ["email1@xxx.com", "email2@xxx.com"]
}
```

**核心改进**：
1. `find_owner_by_project()` 返回邮箱数组
2. 主函数循环发送给所有负责人
3. 统计成功/失败人数

---

## [v3.0] 2026-01-20

### 🚀 自动项目路径匹配

**新功能**：
- ✅ 自动识别项目路径
- ✅ 支持精确匹配和模糊匹配
- ✅ 美观的卡片消息
- ✅ 详细的日志输出

**配置格式**：
```json
{
    "项目名称": "email@xxx.com"
}
```

---

## [v2.0] 2025-12

### 增强版通知

**功能**：
- ✅ 卡片消息
- ✅ 失败降级为文本消息
- ✅ 环境变量配置

---

## [v1.0] 2025-11

### 基础通知功能

**功能**：
- ✅ 基础文本消息
- ✅ 飞书 API 集成

---

**维护人**: Kiro AI Assistant  
**最后更新**: 2026-01-22
