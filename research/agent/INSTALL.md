# 安装指南

## 系统要求

- Python 3.8+
- Ollama (本地 LLM 服务)
- 8GB+ RAM (推荐 16GB)
- GPU (可选，用于加速 LLM 推理)

## 安装步骤

### 1. 安装 Ollama

#### Windows

1. 下载 Ollama 安装包：https://ollama.com/download/windows
2. 运行安装程序
3. 安装完成后，Ollama 会自动启动服务

#### 验证安装

```bash
# 打开命令行，测试 Ollama
ollama --version

# 如果提示找不到命令，需要添加到 PATH
# Ollama 默认安装路径：C:\Users\<用户名>\AppData\Local\Programs\Ollama
```

### 2. 下载 LLM 模型

```bash
# 推荐模型（选择其一）

# 方案 1: Qwen 2.5 32B (推荐，中文支持好)
ollama pull qwen2.5:32b

# 方案 2: Llama 3.1 70B (英文更强)
ollama pull llama3.1:70b

# 方案 3: 小模型测试 (7B，速度快)
ollama pull qwen2.5:7b
```

**模型选择建议：**
- RTX 4090 24GB → qwen2.5:32b 或 llama3.1:70b (量化版)
- RTX 3060 12GB → qwen2.5:7b 或 llama3.1:8b
- 无 GPU → qwen2.5:7b (CPU 推理)

### 3. 安装 Python 依赖

```bash
# 进入项目目录
cd incubator/Agent

# 安装依赖
pip install -r requirements.txt

# 或使用 setup.py
pip install -e .
```

### 4. 配置

编辑 `config.yaml`，修改以下配置：

```yaml
ollama:
  host: "http://localhost:11434"
  model: "qwen2.5:32b"  # 改为你下载的模型

software:
  blender:
    executable: "C:/Program Files/Blender Foundation/Blender 4.0/blender.exe"
  maya:
    executable: "C:/Program Files/Autodesk/Maya2024/bin/maya.exe"
  unity:
    executable: "C:/Program Files/Unity/Hub/Editor/2022.3.62f3c1/Editor/Unity.exe"
```

### 5. 测试安装

```bash
# 测试 Ollama 连接
python examples/test_ollama.py

# 测试记忆系统
python examples/memory_example.py

# 测试 Blender 智能体（需要 Ollama 运行）
python examples/blender_example.py
```

## 常见问题

### Q1: Ollama 无法启动

**解决方案：**
```bash
# 手动启动 Ollama 服务
ollama serve

# 或在 Windows 服务中启动
# 服务名称: Ollama
```

### Q2: 模型下载慢

**解决方案：**
- 使用国内镜像（如果有）
- 使用代理
- 下载预量化模型（体积更小）

### Q3: 内存不足

**解决方案：**
- 使用更小的模型（7B 或 13B）
- 关闭其他占用内存的程序
- 使用量化模型（Q4_K_M 或 Q5_K_M）

### Q4: GPU 未被使用

**解决方案：**
```bash
# 检查 CUDA 是否安装
nvidia-smi

# Ollama 会自动使用 GPU，无需额外配置
# 如果未使用，检查 CUDA 驱动版本
```

### Q5: ChromaDB 错误

**解决方案：**
```bash
# 重新安装 ChromaDB
pip uninstall chromadb
pip install chromadb

# 清空数据目录
rm -rf data/memory
```

## 下一步

- 阅读 [README.md](README.md) 了解使用方法
- 查看 [examples/](examples/) 目录的示例代码
- 运行测试：`python -m pytest tests/`

## 技术支持

- GitHub Issues: [项目地址]
- 文档: [文档地址]
