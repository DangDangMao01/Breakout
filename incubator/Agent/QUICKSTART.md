# 快速开始指南

> 5分钟快速上手 DCC 智能体系统

## 前置条件

- ✅ Python 3.8+ 已安装
- ✅ 有网络连接（用于下载模型）
- ✅ 8GB+ 可用内存

## 步骤 1: 安装 Ollama

### Windows

```bash
# 下载并安装 Ollama
# 访问: https://ollama.com/download/windows
# 下载 OllamaSetup.exe 并运行
```

安装完成后，Ollama 会自动启动服务。

## 步骤 2: 下载 LLM 模型

打开命令行（CMD 或 PowerShell）：

```bash
# 推荐：Qwen 2.5 32B（中文支持好，适合 RTX 4090）
ollama pull qwen2.5:32b

# 或者：小模型测试（适合 RTX 3060 或无 GPU）
ollama pull qwen2.5:7b
```

**下载时间：** 根据网速，可能需要 10-30 分钟

## 步骤 3: 安装 Python 依赖

```bash
# 进入项目目录
cd E:\Git_file\K_Kiro_Work\incubator\Agent

# 安装依赖
pip install -r requirements.txt
```

## 步骤 4: 测试连接

### 方式 1: 使用批处理文件（推荐）

双击运行：`启动测试.bat`

### 方式 2: 使用 Python 脚本

```bash
python examples/test_ollama.py
```

**预期输出：**
```
========================================
Ollama 连接测试
========================================

[1] 创建 Ollama 客户端...
✅ 客户端创建成功

[2] 检查 Ollama 服务...
✅ Ollama 服务运行正常

[3] 列出可用模型...
✅ 找到 1 个模型:
  - qwen2.5:32b

[4] 测试对话功能...
提示: 你好，请用一句话介绍你自己。
✅ 回复: 你好！我是一个AI助手...

✅ 所有测试通过！Ollama 工作正常
```

## 步骤 5: 运行示例

### 示例 1: 记忆系统

```bash
python examples/memory_example.py
```

这会演示如何使用向量记忆系统存储和搜索信息。

### 示例 2: Blender 智能体

```bash
python examples/blender_example.py
```

这会演示如何使用自然语言控制 Blender（需要 Ollama 运行）。

### 示例 3: CLI 交互模式

```bash
# 启动 CLI
python cli.py --agent blender

# 或双击运行
启动CLI.bat
```

在 CLI 中尝试：
```
BlenderAgent> 创建一个立方体
BlenderAgent> 列出所有对象
BlenderAgent> help
BlenderAgent> quit
```

## 常见问题

### Q: Ollama 命令找不到

**解决方案：**
```bash
# 检查 Ollama 是否安装
where ollama

# 如果找不到，手动添加到 PATH
# 默认路径: C:\Users\<用户名>\AppData\Local\Programs\Ollama
```

### Q: 模型下载失败

**解决方案：**
- 检查网络连接
- 使用代理
- 尝试下载更小的模型：`ollama pull qwen2.5:7b`

### Q: 内存不足

**解决方案：**
- 使用更小的模型（7B 而不是 32B）
- 关闭其他占用内存的程序
- 使用量化模型

### Q: ChromaDB 安装失败

**解决方案：**
```bash
# 升级 pip
python -m pip install --upgrade pip

# 重新安装
pip install chromadb --upgrade
```

## 下一步

- 📖 阅读 [README.md](README.md) 了解详细功能
- 📖 阅读 [INSTALL.md](INSTALL.md) 了解完整安装步骤
- 🔧 修改 [config.yaml](config.yaml) 配置软件路径
- 💻 查看 [examples/](examples/) 目录的更多示例
- 🧪 运行测试：`python -m pytest tests/`

## 获取帮助

- 查看项目文档
- 查看知识库：`E:\Git_file\Kiro-Central-KB\solutions\2026-01-11-dcc-agent-system.md`
- 检查日志文件：`logs/agent.log`

---

**祝你使用愉快！** 🚀
