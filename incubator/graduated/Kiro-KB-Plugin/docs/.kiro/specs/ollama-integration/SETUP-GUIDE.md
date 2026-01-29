# Ollama 安装和配置指南

## 1. 安装 Ollama

### Windows

1. 访问 [https://ollama.ai](https://ollama.ai)
2. 下载 Windows 安装包
3. 运行安装程序
4. 安装完成后，Ollama 会自动启动

### macOS

```bash
brew install ollama
```

### Linux

```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

## 2. 验证安装

打开终端/命令提示符，运行：

```bash
ollama --version
```

应该看到版本号输出。

## 3. 启动 Ollama 服务

Ollama 通常会自动启动。如果没有，手动启动：

```bash
ollama serve
```

## 4. 下载推荐模型

我们推荐使用以下轻量级模型（适合本地运行）：

### Llama 3.2 3B（通用分析）

```bash
ollama pull llama3.2:3b
```

### Qwen 2.5 3B（中文优化）

```bash
ollama pull qwen2.5:3b
```

### DeepSeek Coder（代码分析）

```bash
ollama pull deepseek-coder:6.7b
```

## 5. 验证 Ollama API

运行以下命令验证 API 可用：

```bash
curl http://localhost:11434/api/tags
```

应该看到已安装模型的列表。

## 6. 测试模型

```bash
ollama run llama3.2:3b "Hello, how are you?"
```

## 7. 配置 Kiro KB 插件

1. 打开 VSCode/Kiro
2. 打开设置（Ctrl+,）
3. 搜索 "kiro-kb.ollama"
4. 配置以下选项：
   - `kiro-kb.ollama.enabled`: true
   - `kiro-kb.ollama.baseUrl`: http://localhost:11434
   - `kiro-kb.ollama.model`: llama3.2:3b

## 8. 硬件要求

### 最低配置
- CPU: 4 核心
- RAM: 8GB
- 磁盘: 5GB 可用空间

### 推荐配置
- CPU: 8 核心
- RAM: 16GB
- 磁盘: 10GB 可用空间
- GPU: 可选（NVIDIA GPU 可加速）

## 9. 常见问题

### Q: Ollama 无法启动
A: 检查端口 11434 是否被占用：
```bash
netstat -ano | findstr :11434  # Windows
lsof -i :11434                 # macOS/Linux
```

### Q: 模型下载很慢
A: 使用国内镜像（如果可用）或使用代理

### Q: 内存不足
A: 使用更小的模型（如 1B 或 3B 参数）

### Q: 如何切换模型？
A: 在 VSCode 设置中修改 `kiro-kb.ollama.model`

## 10. 下一步

安装完成后，继续阅读：
- [requirements.md](./requirements.md) - 了解功能需求
- [design.md](./design.md) - 了解系统设计
- [tasks.md](./tasks.md) - 了解实施计划

## 11. 支持

如有问题，请：
1. 查看 Ollama 官方文档：https://ollama.ai/docs
2. 提交 Issue：https://github.com/DangDangMao01/Kiro_work/issues
