---
date: 2026-01-08
type: troubleshooting
---

# Kiro KB 插件故障排查指南

## 问题：左侧面板显示"没有可提供视图数据的已注册数据提供程序"

### 可能原因

1. **中央知识库路径未配置**
2. **插件初始化失败**
3. **命令注册顺序错误**
4. **KnowledgePanelProvider 初始化失败**

### 排查步骤

#### 步骤 1: 检查插件是否正确安装

1. 点击左侧扩展图标
2. 搜索 "Kiro Knowledge Base"
3. 确认：
   - ✅ 已安装
   - ✅ 版本是 2.49.0
   - ✅ 已启用（不是灰色）

#### 步骤 2: 查看输出日志

1. 按 `F1` → 输入 `output` → 选择 `View: Toggle Output`
2. 在输出面板右上角下拉菜单选择 `Kiro Knowledge Base`
3. 查找错误信息（红色文字）

**常见错误**：
- `command 'kiro-kb.xxx' not found` - 命令未注册
- `Cannot read property 'xxx' of undefined` - 对象未初始化
- `ENOENT: no such file or directory` - 路径不存在

#### 步骤 3: 检查中央知识库路径配置

1. 打开设置（文件 → 首选项 → 设置）
2. 搜索 `kiro-kb.centralPath`
3. 确认路径是否正确，例如：
   - Windows: `D:\G_GitHub\Kiro-Central-KB`
   - Mac/Linux: `/Users/xxx/Kiro-Central-KB`

**验证路径**：
- 路径必须存在
- 路径下应该有 `solutions/`, `notes/`, `discussions/` 等文件夹

#### 步骤 4: 手动初始化知识库

如果路径未配置，使用命令初始化：

1. 按 `F1`
2. 输入 `Kiro KB: 设置知识库`
3. 选择或输入中央知识库路径
4. 重新加载窗口

#### 步骤 5: 检查开发者工具

1. 按 `F1` → 输入 `toggle developer tools`
2. 选择 `Developer: Toggle Developer Tools`
3. 切换到 `Console` 标签
4. 查找红色错误信息

### 临时解决方案

如果以上步骤都无法解决，尝试：

#### 方案 A: 完全重置

1. **卸载插件**
   - 扩展面板 → Kiro Knowledge Base → 卸载
   
2. **删除缓存**（可选）
   - Windows: `%APPDATA%\Code\User\globalStorage\`
   - Mac: `~/Library/Application Support/Code/User/globalStorage/`
   - 删除 `kiro-kb` 相关文件夹

3. **重新安装**
   - 按 `F1` → `vsix` → 选择 `kiro-knowledge-base-2.49.0.vsix`

4. **配置路径**
   - 设置 → `kiro-kb.centralPath`

5. **重启 Kiro**

#### 方案 B: 使用旧版本

如果新版本有问题，可以回退到旧版本：

1. 卸载当前版本
2. 安装 `kiro-knowledge-base-2.48.0.vsix`
3. 重新加载窗口

### 已知问题

#### 问题 1: 初始化顺序错误

**症状**: 面板空白，日志显示 `knowledgePanelProvider is undefined`

**原因**: `knowledgePanelProvider` 在命令注册之后才初始化

**修复**: 已在 v2.49.0 中修复（将初始化移到命令注册之前）

#### 问题 2: 中央路径为空

**症状**: 面板显示"没有可提供视图数据的已注册数据提供程序"

**原因**: `centralPath` 配置为空或路径不存在

**修复**: 
1. 设置 → `kiro-kb.centralPath` → 输入正确路径
2. 或使用命令 `Kiro KB: 设置知识库`

#### 问题 3: Ollama 集成导致初始化失败

**症状**: 启用 Ollama 后插件无法加载

**原因**: Ollama 初始化失败阻塞了插件加载

**修复**:
1. 设置 → `kiro-kb.ollama.enabled` → 取消勾选
2. 重新加载窗口
3. 确保 Ollama 正常运行后再启用

### 调试技巧

#### 技巧 1: 查看完整日志

在输出面板中，右键 → `Clear Output` 清空日志，然后重新加载窗口，可以看到完整的初始化过程。

#### 技巧 2: 使用开发者工具

开发者工具的 Console 标签会显示更详细的错误堆栈，有助于定位问题。

#### 技巧 3: 检查文件权限

确保 Kiro 有权限读写中央知识库路径。

### 联系支持

如果以上方法都无法解决，请：

1. 收集以下信息：
   - Kiro 版本
   - 插件版本
   - 操作系统
   - 输出日志截图
   - 开发者工具 Console 截图

2. 提交 Issue 到 GitHub

3. 或在知识库中记录问题

---

**更新时间**: 2026-01-08  
**适用版本**: v2.49.0
