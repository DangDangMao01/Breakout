# 安装 Kiro KB v2.50.0

## 🎯 本次更新

**v2.50.0** - 修复 v2.49.0 激活失败问题

### 修复内容
- ✅ 修复插件无法激活的问题
- ✅ 修复左侧面板空白的问题
- ✅ 优化 Ollama 初始化流程
- ✅ 添加错误隔离和超时保护

### 新功能（来自 v2.49.0）
- ✅ Ollama 本地 AI 集成
- ✅ 工作模式追踪
- ✅ AI 生成日报/周报

---

## 📦 安装步骤

### 1. 卸载旧版本

1. 点击左侧扩展图标
2. 搜索 "Kiro Knowledge Base"
3. 点击 "卸载"

### 2. 安装 v2.50.0

1. 按 `F1` 打开命令面板
2. 输入 `vsix`
3. 选择 `Extensions: Install from VSIX...`
4. 选择文件：`kiro-knowledge-base-2.50.0.vsix`
5. 等待安装完成

### 3. 重新加载窗口

1. 按 `F1`
2. 输入 `reload`
3. 选择 `Developer: Reload Window`

---

## ✅ 验证安装

### 基本功能验证

1. **检查左侧面板**
   - 左侧应该显示 "Kiro Knowledge Base" 面板
   - 面板中应该显示知识库内容

2. **检查输出通道**
   - 菜单 → 查看 → 输出
   - 右上角下拉菜单选择 "Kiro Knowledge Base"
   - 应该看到初始化日志

3. **检查命令**
   - 按 `F1`
   - 输入 `Kiro KB`
   - 应该看到所有命令列表

### Ollama 功能验证（可选）

#### 如果 Ollama 未运行

**预期行为**：
- ✅ 插件正常加载
- ⚠️ 输出通道显示警告：`Ollama is not running or not accessible`
- ⚠️ 弹出提示：`Ollama 未运行。请启动 Ollama 或访问 https://ollama.ai 安装。`
- ✅ 其他功能正常使用

#### 如果 Ollama 运行中

**预期行为**：
- ✅ 插件正常加载
- ✅ 输出通道显示：`Ollama connected successfully`
- ✅ 弹出提示：`✅ Ollama AI 已连接，可以生成工作报告了！`
- ✅ 可以使用 Ollama 功能

---

## 🔧 启用 Ollama 功能

### 前提条件

1. **安装 Ollama**
   - 访问 https://ollama.ai
   - 下载并安装 Ollama

2. **下载模型**
   ```bash
   ollama pull qwen2.5:3b
   ```

3. **启动 Ollama**
   - Windows: 自动启动（系统托盘图标）
   - Mac/Linux: `ollama serve`

### 配置插件

1. **打开设置**
   - 文件 → 首选项 → 设置
   - 或按 `Ctrl+,`

2. **搜索 Ollama**
   - 输入 `kiro-kb.ollama`

3. **启用集成**
   - 勾选 `Kiro-kb › Ollama: Enabled`

4. **配置模型**（可选）
   - `Kiro-kb › Ollama: Model`: `qwen2.5:3b`（默认）
   - `Kiro-kb › Ollama: Base Url`: `http://localhost:11434`（默认）

5. **重新加载窗口**
   - 按 `F1` → `reload`

---

## 🚀 使用 Ollama 功能

### 方式一：VSCode/Kiro 插件命令

#### 测试连接

1. 按 `F1`
2. 输入 `Kiro KB: 测试 Ollama 连接`
3. 查看连接状态和可用模型

#### 生成日报

1. 按 `F1`
2. 输入 `Kiro KB: 生成日报`
3. 等待 AI 生成（约 10-30 秒）
4. 报告自动打开

#### 生成周报

1. 按 `F1`
2. 输入 `Kiro KB: 生成周报`
3. 等待 AI 生成（约 30-60 秒）
4. 报告自动打开

### 方式二：独立 CLI 工具（可选）

**适用场景**：
- 在 VSCode/Kiro 外部使用
- 自动化脚本集成
- 定时任务触发

#### 安装 CLI 工具

```bash
# 全局安装
npm install -g kiro-kb-ollama-cli

# 或本地开发
cd ollama-cli
npm install
npm run build
```

#### 使用 CLI 命令

```bash
# 测试连接
kiro-ollama test

# 生成日报
kiro-ollama daily

# 生成周报
kiro-ollama weekly

# 查看帮助
kiro-ollama --help
```

**详见**：`ollama-cli/README.md`

---

## ❓ 常见问题

### Q1: 安装后左侧面板还是空白？

**解决方案**：
1. 检查中央知识库路径是否配置
   - 设置 → 搜索 `kiro-kb.centralPath`
   - 输入正确路径，例如：`D:\G_GitHub\Kiro-Central-KB`
2. 重新加载窗口

### Q2: Ollama 连接失败？

**解决方案**：
1. 确认 Ollama 正在运行
   - Windows: 检查系统托盘
   - Mac/Linux: 运行 `ollama serve`
2. 测试 Ollama API
   - 浏览器访问：http://localhost:11434
   - 应该看到 "Ollama is running"
3. 检查防火墙设置

### Q3: 生成报告很慢？

**原因**：
- Qwen 2.5 3B 模型在 CPU 上运行较慢
- 首次生成需要加载模型

**优化建议**：
- 使用 GPU 加速（如果有 NVIDIA 显卡）
- 或使用更小的模型（如 `qwen2.5:1.5b`）

### Q4: 如何禁用 Ollama 功能？

**步骤**：
1. 设置 → 搜索 `kiro-kb.ollama.enabled`
2. 取消勾选
3. 重新加载窗口

---

## 📚 相关文档

- **Bug 修复详情**: `docs/20260108-v2.50.0-bugfix-summary.md`
- **Ollama 快速开始**: `docs/20260108-ollama-quick-start.md`
- **故障排查指南**: `docs/20260108-troubleshooting-guide.md`
- **完整集成总结**: `docs/20260108-phase1-integration-summary.md`

---

## 🆘 需要帮助？

如果遇到问题：

1. **查看输出日志**
   - 查看 → 输出 → "Kiro Knowledge Base"

2. **查看开发者工具**
   - 按 `F1` → `toggle developer tools`
   - 查看 Console 标签

3. **提交 Issue**
   - 收集日志和截图
   - 在 GitHub 提交 Issue

---

**版本**: v2.50.0  
**发布日期**: 2026-01-08  
**重要性**: 高（修复关键 bug）
