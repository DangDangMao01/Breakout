# DCC 智能体统一控制系统

> 统一控制 Blender、Maya、Unity 的 AI 智能体系统

## 项目概述

一个基于 Ollama 本地 LLM 的智能体系统，通过自然语言控制 DCC 软件（Blender、Maya、Unity）。

## 核心功能

- 🎨 **Blender Agent** - 建模、动画、渲染自动化
- 🎬 **Maya Agent** - 角色绑定、动画制作
- 🎮 **Unity Agent** - 场景搭建、脚本生成
- 🤖 **统一调度** - 跨软件工作流自动化
- 💾 **记忆系统** - 学习用户习惯和偏好

## 技术栈

- **LLM**: Ollama (qwen2.5:32b / llama3.1:70b)
- **框架**: LangChain / CrewAI
- **向量库**: ChromaDB
- **API**: Blender Python API, Maya Python API, Unity C# API

## 项目结构

```
incubator/Agent/
├── README.md                 # 项目说明
├── requirements.txt          # Python 依赖
├── config.yaml              # 配置文件
├── core/                    # 核心模块
│   ├── llm_client.py       # Ollama 客户端
│   ├── agent_base.py       # 智能体基类
│   └── memory.py           # 记忆系统
├── agents/                  # 各软件智能体
│   ├── blender_agent.py    # Blender 智能体
│   ├── maya_agent.py       # Maya 智能体
│   └── unity_agent.py      # Unity 智能体
├── tools/                   # 工具函数
│   ├── blender_tools.py    # Blender 工具集
│   ├── maya_tools.py       # Maya 工具集
│   └── unity_tools.py      # Unity 工具集
├── workflows/               # 预定义工作流
│   ├── game_asset.py       # 游戏资产制作流程
│   └── animation.py        # 动画制作流程
├── examples/                # 示例脚本
│   ├── blender_example.py
│   ├── maya_example.py
│   └── unity_example.py
└── tests/                   # 测试
    └── test_agents.py
```

## 快速开始

### 1. 安装依赖

详细安装步骤请查看 [INSTALL.md](INSTALL.md)

```bash
# 安装 Python 依赖
pip install -r requirements.txt

# 安装 Ollama (如果未安装)
# 下载地址: https://ollama.com/download
```

### 2. 下载 LLM 模型

```bash
# 推荐：Qwen 2.5 32B (中文支持好)
ollama pull qwen2.5:32b

# 或者：Llama 3.1 70B (英文更强)
ollama pull llama3.1:70b
```

### 3. 测试连接

```bash
# 运行测试脚本
python examples/test_ollama.py

# 或使用批处理文件 (Windows)
启动测试.bat
```

### 4. 运行示例

```bash
# Blender 智能体示例
python examples/blender_example.py

# 记忆系统示例
python examples/memory_example.py
```

## 使用示例

### Blender Agent

```python
from agents.blender_agent import BlenderAgent

agent = BlenderAgent()
agent.execute("创建一个立方体，添加细分修改器，渲染")
```

### 跨软件工作流

```python
from workflows.game_asset import GameAssetWorkflow

workflow = GameAssetWorkflow()
workflow.run("制作一个破碎动画并导入 Unity")
```

## 开发计划

### Phase 1: 核心框架 ✅
- [x] Ollama 客户端封装
- [x] 智能体基类设计
- [x] 向量记忆系统 (ChromaDB)
- [x] 基础工具注册机制

### Phase 2: Blender Agent ✅
- [x] Blender 工具集封装
- [x] Blender 智能体实现
- [x] 示例和测试代码
- [ ] RPC 通信实现（与 Blender 进程通信）

### Phase 3: Maya Agent 🚧
- [ ] Maya 工具集封装
- [ ] Maya 智能体实现
- [ ] Maya Python API 集成

### Phase 4: Unity Agent 🚧
- [ ] Unity 工具集封装
- [ ] Unity 智能体实现
- [ ] Unity C# API 调用

### Phase 5: 跨软件工作流 📋
- [ ] 工作流编排系统
- [ ] 游戏资产制作流程
- [ ] 动画制作流程

### Phase 6: 记忆和学习系统 ✅
- [x] 向量记忆存储
- [x] 记忆搜索和检索
- [ ] 用户习惯学习
- [ ] 工作流推荐

## 项目结构说明

```
incubator/Agent/
├── core/                    # 核心模块 ✅
│   ├── llm_client.py       # Ollama 客户端
│   ├── agent_base.py       # 智能体基类
│   └── memory.py           # 向量记忆系统
├── agents/                  # 智能体实现
│   ├── blender_agent.py    # Blender 智能体 ✅
│   ├── maya_agent.py       # Maya 智能体 🚧
│   └── unity_agent.py      # Unity 智能体 🚧
├── tools/                   # 工具函数
│   ├── blender_tools.py    # Blender 工具集 ✅
│   ├── maya_tools.py       # Maya 工具集 🚧
│   └── unity_tools.py      # Unity 工具集 🚧
├── workflows/               # 工作流 📋
├── examples/                # 示例代码 ✅
│   ├── test_ollama.py      # Ollama 连接测试
│   ├── blender_example.py  # Blender 示例
│   └── memory_example.py   # 记忆系统示例
├── tests/                   # 单元测试 ✅
├── config.yaml             # 配置文件
├── requirements.txt        # Python 依赖
├── INSTALL.md             # 安装指南
└── README.md              # 项目说明
```

## 相关文档

- [安装指南](INSTALL.md) - 详细安装步骤
- [Blender Python API](https://docs.blender.org/api/current/)
- [Maya Python API](https://help.autodesk.com/view/MAYAUL/2024/ENU/)
- [Unity Scripting API](https://docs.unity3d.com/ScriptReference/)
- [Ollama 文档](https://github.com/ollama/ollama)
- [ChromaDB 文档](https://docs.trychroma.com/)

## 常见问题

### 如何添加新的工具？

```python
# 在智能体中注册新工具
def my_custom_tool(param1: str, param2: int) -> Dict:
    """工具描述"""
    # 实现工具逻辑
    return {"success": True, "result": "..."}

agent.register_tool("my_tool", my_custom_tool)
```

### 如何使用记忆系统？

```python
from core.memory import MemorySystem

memory = MemorySystem()

# 添加记忆
memory.add_memory("用户喜欢使用快捷键", category="preference")

# 搜索记忆
results = memory.search_memory("快捷键", n_results=5)
```

### 如何与 Blender 通信？

目前有两种方式：
1. **内部运行**：在 Blender 内部运行 Python 脚本
2. **RPC 通信**：通过网络与 Blender 进程通信（开发中）

---

*创建日期: 2026-01-11*
*最后更新: 2026-01-11*
