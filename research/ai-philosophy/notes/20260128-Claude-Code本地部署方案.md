# Claude Code 本地部署方案

> 基于 Ollama + OpenCode 的完全本地化 AI 编程助手  
> 日期：2026-01-28

---

## 🎯 核心发现

**重要结论**：Claude Code 本身不能完全本地部署（需要 Anthropic API），但有两个方案：

1. **方案 A**：Claude Code + Ollama（混合方案）
   - Claude Code 连接本地 Ollama
   - 零 API 成本，完全隐私
   
2. **方案 B**：OpenCode（开源替代）
   - 完全开源的 Claude Code 替代品
   - 支持 75+ LLM 提供商
   - 支持本地 Ollama、GitHub Copilot、ChatGPT Plus

---

## 📋 方案对比

| 维度 | Claude Code + Ollama | OpenCode + Ollama |
|------|---------------------|-------------------|
| **开源** | ❌ 闭源 | ✅ 开源 |
| **本地运行** | ✅ 支持 | ✅ 支持 |
| **API 成本** | $0（本地模型） | $0（本地模型） |
| **隐私** | ✅ 完全本地 | ✅ 完全本地 |
| **模型选择** | 仅 Ollama | 75+ 提供商 |
| **功能完整性** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **社区支持** | 官方 | 社区 |
| **学习曲线** | 低 | 低 |
| **Windows 支持** | ✅ | ✅ |

**推荐**：先用 **OpenCode + Ollama**（完全开源、灵活）

---

## 🚀 方案 B：OpenCode + Ollama（推荐）

### 为什么选择 OpenCode？

1. **完全开源** - 不依赖任何闭源服务
2. **提供商自由** - 可以随时切换 AI 模型
3. **本地优先** - 完全隐私，零 API 成本
4. **功能完整** - Bash 执行、文件操作、代码搜索、LSP 集成
5. **会话管理** - SQLite 持久化对话历史
6. **美观 TUI** - 终端 UI，Vim 风格编辑器

### 核心特性

- ✅ 支持 75+ LLM 提供商（OpenAI、Anthropic、Ollama、Google、AWS Bedrock）
- ✅ 本地模型支持（Qwen3、Llama、DeepSeek）
- ✅ GitHub Copilot 集成（使用现有订阅）
- ✅ ChatGPT Plus 支持（使用现有订阅）
- ✅ 完整工具链（Bash、文件、搜索、LSP）
- ✅ 会话持久化（SQLite）

---

## 📦 安装步骤（Windows）

### 前置条件

1. **Node.js 18+** 或 **Bun**
2. **Git**
3. **Ollama**（本地 AI 模型运行器）

---

### Step 1：安装 Ollama

**下载安装**：
```powershell
# 访问 https://ollama.com/download
# 下载 Windows 版本并安装
```

**验证安装**：
```powershell
ollama --version
```

---

### Step 2：下载并配置 AI 模型

**推荐模型**（编程专用）：

1. **Qwen3 8B**（推荐，平衡性能和质量）
2. **DeepSeek Coder 6.7B**（代码专用）
3. **Llama 3.1 8B**（通用）

**下载模型**：
```powershell
# 下载 Qwen3 8B
ollama pull qwen3:8b

# 下载 DeepSeek Coder
ollama pull deepseek-coder:6.7b
```

**关键步骤：增加上下文窗口**（必须！）
```powershell
# 启动模型
ollama run qwen3:8b

# 在 Ollama 交互界面中执行：
>>> /set parameter num_ctx 16384
>>> /save qwen3:8b-16k
>>> /bye
```

**为什么要增加上下文窗口？**
- 默认上下文太小（2048 tokens）
- 工具调用需要更大的上下文（16K+）
- 否则会频繁丢失上下文

**启动 Ollama 服务**：
```powershell
ollama serve
```

---

### Step 3：安装 OpenCode

**使用 npm**：
```powershell
npm install -g opencode
```

**或使用 Bun**（推荐，更快）：
```powershell
# 先安装 Bun
irm bun.sh/install.ps1 | iex

# 安装 OpenCode
bun install -g opencode
```

**验证安装**：
```powershell
opencode --version
```

---

### Step 4：配置 OpenCode

**创建配置文件**：
```powershell
# 配置文件路径：~/.config/opencode/opencode.json
# Windows 路径：C:\Users\你的用户名\.config\opencode\opencode.json
```

**配置内容**：
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "qwen3:8b-16k": {
          "name": "Qwen3 8B (16K context)"
        },
        "deepseek-coder:6.7b": {
          "name": "DeepSeek Coder 6.7B"
        }
      }
    }
  }
}
```

---

### Step 5：启动和使用

**启动 OpenCode**：
```powershell
opencode
```

**列出可用模型**：
```
/models
```

**选择模型**：
```
/model qwen3:8b-16k
```

**开始编程**：
```
> 帮我创建一个 React 组件，实现金币飞行动画
```

---

## 🎨 OpenCode 核心命令

### 会话管理

```bash
/sessions          # 列出所有会话
/session abc123    # 恢复会话
/clear             # 清空当前会话
```

### 模型管理

```bash
/models            # 列出可用模型
/model qwen3:8b    # 切换模型
/connect           # 连接新的提供商
```

### 工具使用

```bash
/bash ls -la       # 执行 Bash 命令
/read file.txt     # 读取文件
/write file.txt    # 写入文件
/search "pattern"  # 搜索代码
```

---

## 💡 高级工作流

### 工作流 1：私密代码审查

```
# 使用本地模型审查敏感代码
/model qwen3:8b-16k

> 审查 src/auth/ 目录中的认证模块，检查安全漏洞
> 重点关注：JWT 处理、密码哈希、会话管理
```

### 工作流 2：多文件重构

```
> 重构支付处理系统：
> 1. 提取验证逻辑到独立的 PaymentValidator 类
> 2. 添加自定义 PaymentError 错误类型
> 3. 更新所有调用方使用新结构
> 4. 为新验证器添加单元测试
```

### 工作流 3：代码库理解

```
> 解释这个项目的架构：
> - 路由是如何处理的？
> - 状态管理在哪里？
> - 数据库访问模式是什么？
> - 模块之间的关键依赖关系
```

### 工作流 4：测试生成

```
> 为 src/utils/validation.ts 生成全面的测试：
> - 覆盖所有边界情况
> - 包括单元测试和集成测试
> - 遵循现有的测试模式
```

### 工作流 5：混合云/本地

```
# 敏感代码用本地模型
/model qwen3:8b-16k
> 审查我们的支付处理逻辑...

# 通用问题用云端模型
/model claude-3-sonnet
> 解释 Node.js 中速率限制的最佳实践...
```

---

## 🔧 与 Kiro KB 插件的整合

### 整合方案

**OpenCode 负责**：
- 代码生成和修改
- 代码审查
- 重构和测试

**Kiro KB 插件负责**：
- 保存对话历史
- 知识分类和搜索
- 生成 CLAUDE.md（项目规范）
- 管理技能库

### 工作流程

```
1. 用户在 OpenCode 中开发
   ↓
2. OpenCode 生成代码和解决方案
   ↓
3. Kiro KB 插件自动保存有价值的对话
   ↓
4. 插件提取项目规范，更新 CLAUDE.md
   ↓
5. OpenCode 读取 CLAUDE.md，理解项目规范
   ↓
6. 循环优化
```

### 数据流

```
OpenCode 会话
    ↓
Kiro KB 插件（Hook 触发）
    ↓
knowledge-base/solutions/
    ↓
提取规范
    ↓
CLAUDE.md（项目根目录）
    ↓
OpenCode 读取（下次启动）
```

---

## 📊 性能对比

### 模型性能（编程任务）

| 模型 | 参数量 | 上下文 | 代码质量 | 速度 | 内存占用 |
|------|--------|--------|----------|------|----------|
| Qwen3 8B | 8B | 16K | ⭐⭐⭐⭐ | 快 | 8GB |
| DeepSeek Coder 6.7B | 6.7B | 16K | ⭐⭐⭐⭐⭐ | 快 | 6GB |
| Llama 3.1 8B | 8B | 128K | ⭐⭐⭐ | 中 | 8GB |
| Claude Sonnet 4 | ? | 200K | ⭐⭐⭐⭐⭐ | 快 | 云端 |

**推荐配置**：
- **日常开发**：Qwen3 8B（平衡）
- **代码专用**：DeepSeek Coder 6.7B（最佳代码质量）
- **大型项目**：Llama 3.1 8B（超大上下文）

---

## 🛠️ 故障排查

### 问题 1：Ollama 连接失败

**症状**：OpenCode 无法连接到 Ollama

**解决**：
```powershell
# 检查 Ollama 是否运行
ollama list

# 重启 Ollama 服务
# 关闭 Ollama 进程，然后重新启动
ollama serve
```

### 问题 2：上下文窗口太小

**症状**：AI 频繁丢失上下文

**解决**：
```powershell
# 重新配置模型
ollama run qwen3:8b
>>> /set parameter num_ctx 32768
>>> /save qwen3:8b-32k
>>> /bye
```

### 问题 3：模型响应慢

**症状**：生成代码很慢

**解决**：
1. 使用更小的模型（DeepSeek Coder 6.7B）
2. 减少上下文窗口（16K → 8K）
3. 升级硬件（GPU 加速）

### 问题 4：OpenCode 安装失败

**症状**：npm install 失败

**解决**：
```powershell
# 清理 npm 缓存
npm cache clean --force

# 使用 Bun 安装（更可靠）
bun install -g opencode
```

---

## 🎯 下一步行动

### 立即可行

1. **安装 Ollama**（10 分钟）
   - 下载并安装
   - 下载 Qwen3 8B 模型
   - 配置 16K 上下文

2. **安装 OpenCode**（5 分钟）
   - npm/bun 安装
   - 配置 opencode.json
   - 测试连接

3. **测试工作流**（30 分钟）
   - 创建测试项目
   - 让 AI 生成代码
   - 审查和修改

### 短期目标（1-2 周）

1. **熟悉 OpenCode**
   - 学习核心命令
   - 测试不同模型
   - 优化配置

2. **整合 Kiro KB 插件**
   - 创建 Hook 自动保存 OpenCode 会话
   - 提取项目规范到 CLAUDE.md
   - 测试完整工作流

3. **优化工作流**
   - 定义常用技能
   - 创建项目模板
   - 建立最佳实践

### 长期目标（1-3 个月）

1. **构建技能库**
   - 定义个人工作流程
   - 创建可复用技能
   - 分享到社区

2. **优化模型选择**
   - 测试不同模型
   - 针对不同任务选择最佳模型
   - 建立模型切换策略

3. **完善知识图谱**
   - 积累项目规范
   - 构建知识关联
   - 实现跨项目复用

---

## 📚 相关资源

### 官方文档

- OpenCode GitHub: https://github.com/opencode-ai/opencode
- Ollama 官网: https://ollama.com
- Qwen3 模型: https://ollama.com/library/qwen3
- DeepSeek Coder: https://ollama.com/library/deepseek-coder

### 社区资源

- OpenCode Discord: https://discord.gg/opencode
- Ollama Discord: https://discord.gg/ollama
- Reddit r/LocalLLaMA: https://reddit.com/r/LocalLLaMA

### 学习资源

- OpenCode 教程: https://yuv.ai/learn/opencode-cli
- Ollama 教程: https://ollama.com/blog
- 本地 AI 指南: https://github.com/awesome-local-ai

---

## 💰 成本对比

### Claude Code（官方）

- **免费版**：有限使用
- **Pro 版**：$20/月
- **Max 版**：$200/月
- **企业版**：定制价格

**估算成本**（重度使用）：
- 每天 2-3 小时编程
- 每月 API 成本：$50-200
- 年度成本：$600-2400

### OpenCode + Ollama（本地）

- **Ollama**：免费
- **OpenCode**：免费（开源）
- **模型**：免费（开源）
- **API 成本**：$0
- **年度成本**：$0

**硬件要求**：
- CPU：4 核+
- 内存：16GB+（推荐 32GB）
- 存储：50GB+（模型文件）
- GPU：可选（加速推理）

**一次性投资**：
- 如果需要升级硬件：$500-1500
- 如果硬件足够：$0

**ROI（投资回报）**：
- 3-6 个月回本（vs Claude Code Max）
- 12 个月回本（vs Claude Code Pro）

---

## 🔮 未来展望

### OpenCode 路线图

- ✅ GitHub Copilot 集成（2026-01）
- ✅ ChatGPT Plus 支持（2026-01）
- 🔄 MCP 服务器支持（进行中）
- 🔄 多模态支持（图片、音频）
- 📅 VSCode 扩展（2026-Q2）
- 📅 Web 界面（2026-Q3）

### Ollama 路线图

- ✅ Windows 原生支持（2025-12）
- ✅ GPU 加速（2025-12）
- 🔄 模型量化优化（进行中）
- 📅 分布式推理（2026-Q2）
- 📅 模型微调工具（2026-Q3）

### Kiro KB 插件整合

- 📅 OpenCode 会话自动保存（2026-02）
- 📅 CLAUDE.md 自动生成（2026-02）
- 📅 技能库管理（2026-03）
- 📅 知识图谱构建（2026-Q2）

---

## 📝 总结

**核心优势**：
1. ✅ 完全本地，零 API 成本
2. ✅ 完全隐私，数据不出本地
3. ✅ 开源自由，不被锁定
4. ✅ 功能完整，媲美 Claude Code
5. ✅ 灵活切换，支持 75+ 提供商

**适合人群**：
- 重视隐私的开发者
- 预算有限的个人/小团队
- 需要处理敏感代码的企业
- 想要完全控制 AI 工具的用户

**不适合人群**：
- 硬件配置不足（<16GB 内存）
- 需要最顶级代码质量（Claude Opus 4）
- 不想折腾配置的用户

**推荐行动**：
1. 先安装 Ollama + OpenCode（1 小时）
2. 测试 1-2 周，评估效果
3. 如果满意，深度整合到工作流
4. 如果不满意，可以随时切换回 Claude Code

---

**最后更新**：2026-01-28  
**作者**：DangDangMao  
**版本**：v1.0
