# 跨电脑部署指南

## 📦 可移植性说明

这个智能体系统**可以在其他电脑上使用**，但需要根据硬件配置选择合适的方案。

---

## 🖥️ 硬件要求对照表

### 方案 1: 高性能配置（推荐）

**适用于**: 游戏本、工作站、高端台式机

| 组件 | 最低要求 | 推荐配置 | 说明 |
|------|---------|---------|------|
| GPU | RTX 3060 12GB | RTX 4090 24GB | 用于运行大模型 |
| RAM | 16GB | 32GB+ | 系统 + 模型内存 |
| 存储 | 50GB 可用 | 100GB+ SSD | 模型 + 依赖 |
| 系统 | Windows 10+ | Windows 11 | 支持 WSL2 更佳 |

**可用模型**:
- ✅ Qwen 2.5 32B（19GB）- 最佳中文支持
- ✅ Llama 3.1 70B（量化版）
- ✅ Mistral 7B（快速）

### 方案 2: 中等配置

**适用于**: 普通笔记本、中端台式机

| 组件 | 配置 |
|------|------|
| GPU | GTX 1660 6GB / RTX 3050 8GB |
| RAM | 16GB |
| 存储 | 30GB 可用 |

**可用模型**:
- ✅ Qwen 2.5 7B（4.7GB）- 推荐
- ✅ Llama 3.1 8B
- ✅ Mistral 7B

### 方案 3: 低配置（CPU 模式）

**适用于**: 办公本、老旧电脑

| 组件 | 配置 |
|------|------|
| CPU | 4 核心+ |
| RAM | 8GB+ |
| 存储 | 20GB 可用 |

**可用模型**:
- ✅ Qwen 2.5 3B（量化版）
- ✅ Phi-2 2.7B
- ⚠️ 推理速度较慢（1-5 tokens/s）

---

## 📋 部署步骤

### 步骤 1: 复制项目文件

```bash
# 方式 1: 使用 Git
git clone <repository_url>
cd incubator/Agent

# 方式 2: 直接复制文件夹
# 将整个 incubator/Agent 文件夹复制到目标电脑
```

### 步骤 2: 安装 Ollama

#### Windows
```bash
# 下载安装包
https://ollama.com/download/windows

# 安装后验证
ollama --version
```

#### macOS
```bash
# 使用 Homebrew
brew install ollama

# 或下载 DMG
https://ollama.com/download/mac
```

#### Linux
```bash
# 一键安装
curl -fsSL https://ollama.com/install.sh | sh

# 启动服务
sudo systemctl start ollama
```

### 步骤 3: 选择并下载模型

根据硬件配置选择合适的模型：

#### 高性能（GPU 12GB+）
```bash
# Qwen 2.5 32B（推荐）
ollama pull qwen2.5:32b

# 或 Llama 3.1 70B
ollama pull llama3.1:70b
```

#### 中等配置（GPU 6-12GB）
```bash
# Qwen 2.5 7B（推荐）
ollama pull qwen2.5:7b

# 或 Llama 3.1 8B
ollama pull llama3.1:8b
```

#### 低配置（CPU 或 GPU <6GB）
```bash
# Qwen 2.5 3B
ollama pull qwen2.5:3b

# 或 Phi-2
ollama pull phi
```

### 步骤 4: 安装 Python 依赖

#### 方式 A: 快速聊天（最小依赖）
```bash
pip install requests ddgs
```

#### 方式 B: 完整功能
```bash
cd incubator/Agent
pip install -r requirements.txt
```

**注意**: 如果 ChromaDB 安装失败，可以跳过，使用快速聊天版本。

### 步骤 5: 修改配置

编辑 `config.yaml`：

```yaml
ollama:
  host: "http://localhost:11434"
  model: "qwen2.5:7b"  # 改为你下载的模型

# 如果 Ollama 在其他机器上
# host: "http://192.168.1.100:11434"
```

### 步骤 6: 测试运行

```bash
# 测试 Ollama 连接
python test_ollama_simple.py

# 启动快速聊天
python quick_chat.py

# 或启动完整 CLI（需要完整依赖）
python cli_enhanced.py
```

---

## 🔄 不同操作系统的差异

### Windows

**优点**:
- ✅ Ollama 安装简单
- ✅ GPU 支持好（NVIDIA）
- ✅ 批处理文件可直接使用

**注意**:
- 使用 PowerShell 或 CMD
- 路径使用反斜杠 `\` 或正斜杠 `/`

### macOS

**优点**:
- ✅ Apple Silicon (M1/M2/M3) 性能优秀
- ✅ 统一内存架构，大模型运行流畅

**修改**:
```bash
# 批处理文件改为 shell 脚本
# 快速聊天.bat → 快速聊天.sh

#!/bin/bash
echo "快速聊天"
python3 quick_chat.py
```

**模型推荐**:
- M1/M2 8GB: Qwen 2.5 3B
- M1/M2 16GB: Qwen 2.5 7B
- M3 Max 32GB+: Qwen 2.5 32B

### Linux

**优点**:
- ✅ 服务器部署方便
- ✅ Docker 支持好
- ✅ 性能优化更灵活

**修改**:
```bash
# 批处理文件改为 shell 脚本
chmod +x *.sh

# 启动服务
./快速聊天.sh
```

---

## 🌐 网络部署（局域网/远程）

### 场景 1: 局域网共享

**服务器端**（运行 Ollama 的电脑）:
```bash
# 修改 Ollama 配置，允许外部访问
# Windows: 编辑环境变量
OLLAMA_HOST=0.0.0.0:11434

# Linux/macOS: 编辑 systemd 服务
sudo systemctl edit ollama
# 添加：
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"

# 重启服务
sudo systemctl restart ollama
```

**客户端**（其他电脑）:
```yaml
# config.yaml
ollama:
  host: "http://192.168.1.100:11434"  # 服务器 IP
  model: "qwen2.5:7b"
```

### 场景 2: 云服务器部署

**推荐配置**:
- GPU 实例（AWS p3, Azure NC 系列）
- 至少 16GB RAM
- 50GB+ 存储

**部署步骤**:
```bash
# 1. 安装 Ollama
curl -fsSL https://ollama.com/install.sh | sh

# 2. 下载模型
ollama pull qwen2.5:7b

# 3. 配置防火墙
sudo ufw allow 11434

# 4. 启动服务
sudo systemctl enable ollama
sudo systemctl start ollama

# 5. 客户端连接
# config.yaml
ollama:
  host: "http://your-server-ip:11434"
```

---

## 📦 Docker 部署（推荐）

### Dockerfile

```dockerfile
FROM python:3.11-slim

# 安装依赖
RUN apt-get update && apt-get install -y curl

# 安装 Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# 复制项目文件
WORKDIR /app
COPY . .

# 安装 Python 依赖
RUN pip install -r requirements.txt

# 下载模型
RUN ollama pull qwen2.5:7b

# 启动服务
CMD ["python", "cli_enhanced.py"]
```

### docker-compose.yml

```yaml
version: '3.8'

services:
  ollama:
    image: ollama/ollama:latest
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

  agent:
    build: .
    depends_on:
      - ollama
    environment:
      - OLLAMA_HOST=http://ollama:11434
    volumes:
      - ./data:/app/data

volumes:
  ollama_data:
```

---

## 🔧 配置优化

### 低配置优化

```yaml
# config.yaml
ollama:
  model: "qwen2.5:3b"
  
  # 减少上下文长度
  options:
    num_ctx: 2048  # 默认 4096
    
  # 降低并发
  num_parallel: 1
```

### 高配置优化

```yaml
# config.yaml
ollama:
  model: "qwen2.5:32b"
  
  # 增加上下文长度
  options:
    num_ctx: 8192
    
  # 提高并发
  num_parallel: 4
  
  # GPU 层数（全部使用 GPU）
  num_gpu: 99
```

---

## 📝 依赖清单

### 最小依赖（快速聊天）
```txt
requests>=2.31.0
ddgs>=9.10.0
```

### 完整依赖
```txt
# LLM 和智能体
langchain>=0.1.0
ollama>=0.1.0

# 向量数据库
chromadb>=0.3.23

# 工具库
pydantic>=2.0.0
pyyaml>=6.0
requests>=2.31.0

# 网络搜索
ddgs>=9.10.0
```

---

## 🚀 快速部署脚本

### Windows (PowerShell)

```powershell
# deploy.ps1
Write-Host "开始部署智能体系统..."

# 1. 检查 Python
python --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "请先安装 Python 3.8+"
    exit 1
}

# 2. 检查 Ollama
ollama --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "请先安装 Ollama"
    Write-Host "下载地址: https://ollama.com/download/windows"
    exit 1
}

# 3. 安装依赖
Write-Host "安装 Python 依赖..."
pip install requests ddgs

# 4. 下载模型
Write-Host "下载模型（根据配置选择）..."
Write-Host "1. Qwen 2.5 3B (低配)"
Write-Host "2. Qwen 2.5 7B (中配)"
Write-Host "3. Qwen 2.5 32B (高配)"
$choice = Read-Host "请选择 (1-3)"

switch ($choice) {
    "1" { ollama pull qwen2.5:3b }
    "2" { ollama pull qwen2.5:7b }
    "3" { ollama pull qwen2.5:32b }
}

# 5. 测试
Write-Host "测试连接..."
python quick_chat.py

Write-Host "部署完成！"
```

### Linux/macOS (Bash)

```bash
#!/bin/bash
# deploy.sh

echo "开始部署智能体系统..."

# 1. 检查 Python
if ! command -v python3 &> /dev/null; then
    echo "请先安装 Python 3.8+"
    exit 1
fi

# 2. 安装 Ollama
if ! command -v ollama &> /dev/null; then
    echo "安装 Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

# 3. 安装依赖
echo "安装 Python 依赖..."
pip3 install requests ddgs

# 4. 下载模型
echo "选择模型："
echo "1. Qwen 2.5 3B (低配)"
echo "2. Qwen 2.5 7B (中配)"
echo "3. Qwen 2.5 32B (高配)"
read -p "请选择 (1-3): " choice

case $choice in
    1) ollama pull qwen2.5:3b ;;
    2) ollama pull qwen2.5:7b ;;
    3) ollama pull qwen2.5:32b ;;
esac

# 5. 测试
echo "测试连接..."
python3 quick_chat.py

echo "部署完成！"
```

---

## ⚠️ 常见问题

### Q1: 其他电脑没有 GPU 怎么办？

**答**: 使用 CPU 模式，选择小模型（3B 或 7B）

```bash
# 下载小模型
ollama pull qwen2.5:3b

# 修改 config.yaml
ollama:
  model: "qwen2.5:3b"
```

### Q2: 可以在手机/平板上使用吗？

**答**: 
- ❌ 直接运行：不支持（需要 x86/ARM64 架构）
- ✅ 远程访问：可以通过网页或 API 访问服务器

### Q3: 可以多人同时使用吗？

**答**: 可以，但需要：
1. 服务器配置足够（每个用户占用 ~2GB RAM）
2. 配置并发数：`num_parallel: 4`
3. 使用负载均衡（多个 Ollama 实例）

### Q4: 数据会同步吗？

**答**: 
- 对话历史：存储在本地，不会自动同步
- ChromaDB 记忆：存储在 `data/memory`，可以复制到其他电脑
- 配置文件：需要手动同步

---

## 📊 性能对比

| 配置 | 模型 | 推理速度 | 内存占用 | 适用场景 |
|------|------|---------|---------|---------|
| RTX 4090 24GB | Qwen 32B | 30 t/s | 20GB | 专业工作 |
| RTX 3060 12GB | Qwen 7B | 20 t/s | 8GB | 日常使用 |
| GTX 1660 6GB | Qwen 3B | 15 t/s | 4GB | 轻度使用 |
| CPU (8核) | Qwen 3B | 2-5 t/s | 4GB | 应急使用 |
| M2 Max 32GB | Qwen 32B | 25 t/s | 20GB | Mac 专业 |
| M1 16GB | Qwen 7B | 18 t/s | 8GB | Mac 日常 |

---

## 🎯 推荐部署方案

### 个人使用
- 本地安装 Ollama
- 使用快速聊天版本
- 模型根据硬件选择

### 团队使用
- 服务器部署 Ollama
- 局域网共享
- 使用完整 CLI 版本

### 生产环境
- Docker 容器化
- 负载均衡
- 监控和日志

---

**总结**: 这个系统可以在几乎任何电脑上运行，关键是选择合适的模型和配置！
