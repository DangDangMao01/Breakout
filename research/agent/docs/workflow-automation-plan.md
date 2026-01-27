# 工作流自动化开发规划

> 讨论日期: 2026-01-12
> 命题: 本地 AI 驱动的 DCC 工作流自动化

## 核心理念

**本地 AI 的真正价值不是"问答"，而是"工作流自动化"**

- 不是替代云端 AI 做通用问答
- 而是长时间运行、自动化执行预定义流程
- 解放人力，让 AI 处理重复性工作

## 应用场景

### 1. ComfyUI 批量生图
- 监控队列状态
- 自动调整参数
- 失败重试
- 生成报告

### 2. Blender 自动绑定
- 批量处理模型
- 检查绑定错误
- 生成绑定报告
- 自动修复常见问题

### 3. 渲染农场管理
- 分配渲染任务
- 监控渲染进度
- 处理渲染异常
- 合成最终输出

### 4. 资产管道
- 整理项目文件
- 生成缩略图
- 自动标记分类
- 版本管理

## 技术优势

| 优势 | 说明 |
|------|------|
| 长时间运行 | 不需要保持浏览器/IDE 打开 |
| 低智能要求 | 执行预定义流程，不需要复杂推理 |
| 成本控制 | 本地免费，云端 API 长时间运行成本高 |
| 隐私保护 | 项目文件不上传云端 |

## 项目结构建议

```
E:\K_Kiro_Work\incubator\Agent\
 agents/              # 智能体
    blender_agent.py      # 已有
    comfyui_agent.py      # 新增
    workflow_agent.py     # 新增 - 工作流编排
 workflows/           # 工作流（重点扩展）
    comfyui_batch_generate.py  # ComfyUI 批量生图
    blender_auto_rig.py        # Blender 自动绑定
    render_farm.py             # 渲染农场管理
    asset_pipeline.py          # 资产管道
 tools/               # 工具集
    blender_tools.py      # 已有
    comfyui_tools.py      # 新增
    render_tools.py       # 新增
 examples/            # 使用示例
    workflow_examples.py
 docs/
     workflow-automation-plan.md  # 本文档
```

## 开发优先级

### Phase 1: 基础工作流
1. ComfyUI 批量生图工作流
2. Blender 批量导入/导出
3. 简单的任务监控

### Phase 2: 智能化
1. 错误自动修复
2. 参数自动优化
3. 质量检查

### Phase 3: 完整管道
1. 跨软件工作流
2. 资产管理集成
3. 团队协作支持

## 与其他项目的关系

| 项目 | 定位 | 关系 |
|------|------|------|
| Kiro KB 插件 | 知识管理 | 独立，保存对话和知识 |
| ollama-cli | 知识库问答 | 暂停开发，价值不高 |
| Agent 工作流 | DCC 自动化 | 核心项目，重点发展 |

## 技术栈

- **语言**: Python
- **LLM**: Ollama (qwen2.5:32b)
- **工作流引擎**: 自研（基于现有 Agent 框架）
- **DCC 集成**: 
  - Blender Python API
  - ComfyUI API
  - Maya Python API

## 下一步

1. 保持 Agent 项目在 kiro-work 工程中
2. 不单独开新工程（避免重复）
3. 扩展 workflows/ 目录
4. 从最常用的场景开始实现

---

*整理自 2026-01-12 与 Kiro 的讨论*
