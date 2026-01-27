# 多模型使用指南

## 🎯 功能特性

新的多模型 CLI 支持：
- ✅ 同时管理多个 AI 模型
- ✅ 随时切换模型
- ✅ 对比不同模型的回答
- ✅ 保留网络搜索功能
- ✅ 独立的对话历史

---

## 🚀 快速开始

### 1. 下载多个模型

```bash
# 下载不同大小的模型
ollama pull qwen2.5:3b    # 小模型，快速
ollama pull qwen2.5:7b    # 中等模型，平衡
ollama pull qwen2.5:32b   # 大模型，质量高

# 或下载不同类型的模型
ollama pull llama3.1:8b   # Meta 的模型
ollama pull mistral:7b    # Mistral AI 的模型
ollama pull phi           # Microsoft 的小模型
```

### 2. 启动多模型 CLI

```bash
# 方式 1: 双击批处理文件
启动多模型CLI.bat

# 方式 2: 命令行
python cli_multi_model.py

# 方式 3: 指定默认模型
python cli_multi_model.py --model qwen2.5:7b
```

---

## 📖 使用说明

### 基本命令

```bash
# 查看所有可用模型
[qwen2.5:7b]> models

# 切换模型
[qwen2.5:7b]> switch qwen2.5:32b

# 对比多个模型
[qwen2.5:32b]> compare 什么是量子计算？

# 清空对话历史
[qwen2.5:32b]> clear

# 切换搜索模式
[qwen2.5:32b]> search

# 显示帮助
[qwen2.5:32b]> help

# 退出
[qwen2.5:32b]> quit
```

### 使用场景

#### 场景 1: 快速问答 → 小模型

```bash
# 切换到小模型（速度快）
[qwen2.5:32b]> switch qwen2.5:3b

# 提问
[qwen2.5:3b]> Python 如何读取文件？
```

#### 场景 2: 复杂分析 → 大模型

```bash
# 切换到大模型（质量高）
[qwen2.5:3b]> switch qwen2.5:32b

# 提问
[qwen2.5:32b]> 分析一下深度学习和传统机器学习的区别
```

#### 场景 3: 对比不同模型

```bash
# 对比多个模型的回答
[qwen2.5:32b]> compare 如何优化 Python 代码性能？

# 系统会自动使用前 3 个模型回答
```

#### 场景 4: 中英文切换

```bash
# 中文模型
[qwen2.5:7b]> 介绍一下 Blender

# 切换到英文模型
[qwen2.5:7b]> switch llama3.1:8b

# 英文提问
[llama3.1:8b]> Explain how neural networks work
```

---

## 🎨 模型推荐

### 按用途分类

| 用途 | 推荐模型 | 特点 |
|------|---------|------|
| 中文对话 | qwen2.5:7b/32b | 中文理解最好 |
| 英文对话 | llama3.1:8b/70b | 英文流畅 |
| 代码生成 | codellama:7b | 专门优化代码 |
| 快速响应 | phi / qwen2.5:3b | 速度快 |
| 高质量输出 | qwen2.5:32b / llama3.1:70b | 质量最高 |
| 数学推理 | mistral:7b | 逻辑推理强 |

### 按硬件分类

| 硬件配置 | 推荐组合 |
|---------|---------|
| RTX 4090 24GB | qwen2.5:32b + llama3.1:70b + codellama:13b |
| RTX 3060 12GB | qwen2.5:7b + llama3.1:8b + phi |
| GTX 1660 6GB | qwen2.5:3b + phi + mistral:7b |
| CPU 模式 | phi + qwen2.5:3b |

---

## 💡 高级用法

### 1. 多模型协作

```python
# 使用小模型快速筛选
[qwen2.5:3b]> 列出 5 个 Python 性能优化方向

# 切换到大模型详细分析
[qwen2.5:3b]> switch qwen2.5:32b
[qwen2.5:32b]> 详细解释第 3 个优化方向
```

### 2. 模型特长利用

```python
# 代码生成 → CodeLlama
[qwen2.5:7b]> switch codellama:7b
[codellama:7b]> 写一个 Python 快速排序

# 代码解释 → Qwen
[codellama:7b]> switch qwen2.5:7b
[qwen2.5:7b]> 解释上面代码的时间复杂度
```

### 3. 质量对比

```python
# 对比不同模型的代码质量
[qwen2.5:7b]> compare 实现一个 LRU 缓存

# 查看哪个模型的实现更好
```

---

## 🔧 配置文件

### config_multi.yaml

```yaml
# 多模型配置
ollama:
  host: "http://localhost:11434"
  
  # 模型组
  models:
    fast:
      name: "qwen2.5:3b"
      description: "快速响应"
      
    balanced:
      name: "qwen2.5:7b"
      description: "平衡性能"
      
    quality:
      name: "qwen2.5:32b"
      description: "高质量输出"
      
    code:
      name: "codellama:7b"
      description: "代码专用"
  
  # 默认模型
  default: "balanced"
  
  # 对比模型列表
  compare_models:
    - "qwen2.5:7b"
    - "llama3.1:8b"
    - "mistral:7b"
```

---

## 📊 性能对比

### 响应速度

| 模型 | 首字延迟 | 生成速度 | 适用场景 |
|------|---------|---------|---------|
| qwen2.5:3b | 0.5s | 40 t/s | 快速问答 |
| qwen2.5:7b | 0.8s | 30 t/s | 日常使用 |
| qwen2.5:32b | 1.5s | 20 t/s | 深度分析 |
| llama3.1:8b | 0.9s | 28 t/s | 英文对话 |
| codellama:7b | 0.8s | 32 t/s | 代码生成 |

### 质量对比

| 模型 | 中文 | 英文 | 代码 | 推理 |
|------|------|------|------|------|
| qwen2.5:3b | ⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐ |
| qwen2.5:7b | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| qwen2.5:32b | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| llama3.1:8b | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| codellama:7b | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

---

## 🎯 最佳实践

### 1. 根据任务选择模型

```python
# 简单问题 → 小模型
switch qwen2.5:3b

# 复杂问题 → 大模型
switch qwen2.5:32b

# 代码任务 → 代码模型
switch codellama:7b
```

### 2. 利用对比功能

```python
# 不确定哪个模型更好时
compare 你的问题

# 查看不同模型的思路
```

### 3. 保持对话连贯

```python
# 同一话题使用同一模型
# 避免频繁切换导致上下文丢失

# 如需切换，先 clear 清空历史
clear
switch new_model
```

### 4. 性能优化

```python
# 预热模型（首次使用较慢）
switch qwen2.5:32b
你好

# 之后的响应会更快
```

---

## 🐛 常见问题

### Q1: 切换模型后历史会丢失吗？

**答**: 是的，每个模型有独立的对话历史。如果需要保留上下文，建议：
- 在同一模型内完成对话
- 或使用 `compare` 命令同时询问多个模型

### Q2: 可以同时运行多个模型吗？

**答**: 
- `compare` 命令会依次调用多个模型
- 不会同时占用显存
- 如需真正并行，需要启动多个 Ollama 实例

### Q3: 如何选择最适合的模型？

**答**: 
1. 先用 `compare` 对比几个模型
2. 根据回答质量选择
3. 考虑响应速度和资源占用

### Q4: 模型太多，如何管理？

**答**:
```bash
# 查看所有模型
ollama list

# 删除不用的模型
ollama rm model_name

# 保留常用的 3-5 个即可
```

---

## 🚀 扩展功能

### 自动选择模型

```python
# 根据问题自动选择最合适的模型
# 代码问题 → codellama
# 中文问题 → qwen
# 英文问题 → llama
```

### 模型投票

```python
# 多个模型回答，选择最佳答案
# 或综合多个模型的回答
```

### 成本优化

```python
# 小模型预筛选
# 大模型精细处理
# 节省计算资源
```

---

## 📚 相关文档

- `DEPLOYMENT.md` - 部署指南
- `COMPLETE_SETUP_GUIDE.md` - 完整搭建指南
- `使用说明.md` - 基础使用说明

---

**创建时间**: 2026-01-11  
**作者**: Kiro AI Assistant
