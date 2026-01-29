# Work Patterns - 工作模式分析

这个目录用于存储 AI 生成的工作模式分析报告。

## 目录结构

```
work-patterns/
├── daily/          # 日报（每日工作总结）
├── weekly/         # 周报（每周工作模式分析）
├── monthly/        # 月报（每月成长总结）
└── profile.yaml    # 个人工作画像
```

## 功能说明

### 日报 (Daily Reports)

- **文件命名**: `YYYY-MM-DD.md`
- **生成时机**: 每天结束时（可配置）
- **内容包含**:
  - 当天工作总结
  - 最常访问的文件
  - 搜索关键词
  - Git 提交活动
  - 编辑时间分布

### 周报 (Weekly Reports)

- **文件命名**: `YYYY-WXX.md`（如 `2026-W02.md`）
- **生成时机**: 每周日（可配置）
- **内容包含**:
  - 一周工作模式分析
  - 高效时间段识别
  - 常用技术栈
  - 知识增长领域

### 月报 (Monthly Reports)

- **文件命名**: `YYYY-MM.md`
- **生成时机**: 每月最后一天
- **内容包含**:
  - 月度成长总结
  - 技能提升分析
  - 项目经验积累

### 个人画像 (Profile)

- **文件**: `profile.yaml`
- **更新时机**: 每周报告生成时
- **内容包含**:
  - 技能栈和熟练度
  - 工作习惯（高效时间段、偏好工具）
  - 常见问题领域
  - 知识资产统计

## 使用方式

### 自动生成

插件会在适当时机自动提示生成报告：
- 关闭 VSCode 时提示生成日报
- 周日晚上提示生成周报

### 手动生成

使用命令面板（Ctrl+Shift+P）：
- `Kiro KB: Generate Daily Report` - 生成日报
- `Kiro KB: Generate Weekly Report` - 生成周报
- `Kiro KB: Generate Monthly Report` - 生成月报

### 查看报告

直接在 VSCode 中打开 Markdown 文件查看。

## 隐私说明

- **本地处理**: 所有分析都在本地进行（使用 Ollama）
- **数据控制**: 你可以随时查看、编辑或删除任何报告
- **可迁移**: 所有数据存储在 Git 仓库中，可跨设备同步

## 配置选项

在 VSCode 设置中搜索 `kiro-kb.ollama`：

- `kiro-kb.ollama.enabled`: 启用/禁用 Ollama 集成
- `kiro-kb.ollama.baseUrl`: Ollama API 地址
- `kiro-kb.ollama.model`: 使用的 AI 模型
- `kiro-kb.ollama.dailyReportTime`: 日报生成时间
- `kiro-kb.ollama.weeklyReportDay`: 周报生成日期
- `kiro-kb.ollama.autoSyncEnabled`: 自动 Git 同步

## 示例报告

查看 [SETUP-GUIDE.md](../../.kiro/specs/ollama-integration/SETUP-GUIDE.md) 了解如何开始使用。

## 技术细节

- **AI 模型**: Llama 3.2 3B / Qwen 2.5 3B / DeepSeek Coder
- **数据格式**: Markdown + YAML front-matter
- **存储方式**: Git 版本控制
- **同步方式**: Git push/pull

## 未来计划

- [ ] 支持更多 AI 模型
- [ ] 添加可视化图表
- [ ] 支持团队协作模式（可选）
- [ ] 移动端查看

---

**核心原则**: AI 是工具，知识是资产 - 你的数据永远归你所有。
