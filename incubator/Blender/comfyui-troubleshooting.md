# ComfyUI 启动失败排查和修复

## 🔴 问题描述

安装了AnimateDiff、IPAdapter、VideoHelper插件后，ComfyUI无法启动。

**原因**：新插件缺少Python依赖库。

---

## 🔧 解决方案

### 方法A：查看错误日志（推荐）

1. **打开命令行窗口**
```powershell
cd "D:\Program Files\ComfyUI_windows_portable"
```

2. **手动启动ComfyUI查看错误**
```powershell
.\python_embeded\python.exe -s ComfyUI\main.py
```

3. **查看错误信息**
- 找到红色的错误提示
- 通常会显示缺少哪个库
- 例如：`ModuleNotFoundError: No module named 'xxx'`

**把错误信息发给我，我会告诉你如何修复！**

---

### 方法B：安装插件依赖（最可能的解决方案）

```powershell
cd "D:\Program Files\ComfyUI_windows_portable"

# 安装AnimateDiff依赖
.\python_embeded\python.exe -m pip install -r ComfyUI\custom_nodes\ComfyUI-AnimateDiff-Evolved\requirements.txt

# 安装IPAdapter依赖
.\python_embeded\python.exe -m pip install -r ComfyUI\custom_nodes\ComfyUI_IPAdapter_plus\requirements.txt

# 安装VideoHelper依赖
.\python_embeded\python.exe -m pip install -r ComfyUI\custom_nodes\ComfyUI-VideoHelperSuite\requirements.txt
```

---

### 方法C：临时禁用新插件（快速恢复）

如果需要先让ComfyUI能启动，可以临时禁用新插件：

```powershell
cd "D:\Program Files\ComfyUI_windows_portable\ComfyUI\custom_nodes"

# 重命名插件文件夹（添加.disabled后缀）
ren ComfyUI-AnimateDiff-Evolved ComfyUI-AnimateDiff-Evolved.disabled
ren ComfyUI_IPAdapter_plus ComfyUI_IPAdapter_plus.disabled
ren ComfyUI-VideoHelperSuite ComfyUI-VideoHelperSuite.disabled
```

然后重新启动ComfyUI，应该能正常打开。

**修复后再改回来**：
```powershell
ren ComfyUI-AnimateDiff-Evolved.disabled ComfyUI-AnimateDiff-Evolved
ren ComfyUI_IPAdapter_plus.disabled ComfyUI_IPAdapter_plus
ren ComfyUI-VideoHelperSuite.disabled ComfyUI-VideoHelperSuite
```

---

### 方法D：逐个测试插件

找出是哪个插件导致的问题：

```powershell
# 1. 先禁用所有新插件
cd "D:\Program Files\ComfyUI_windows_portable\ComfyUI\custom_nodes"
ren ComfyUI-AnimateDiff-Evolved ComfyUI-AnimateDiff-Evolved.disabled
ren ComfyUI_IPAdapter_plus ComfyUI_IPAdapter_plus.disabled
ren ComfyUI-VideoHelperSuite ComfyUI-VideoHelperSuite.disabled

# 2. 启动ComfyUI（应该能启动）

# 3. 逐个启用插件测试
# 启用AnimateDiff
ren ComfyUI-AnimateDiff-Evolved.disabled ComfyUI-AnimateDiff-Evolved
# 重启ComfyUI测试
# 如果失败，就是这个插件的问题

# 4. 如果成功，继续测试下一个
ren ComfyUI_IPAdapter_plus.disabled ComfyUI_IPAdapter_plus
# 重启ComfyUI测试

# 5. 继续测试VideoHelper
ren ComfyUI-VideoHelperSuite.disabled ComfyUI-VideoHelperSuite
# 重启ComfyUI测试
```

---

## 🔍 常见错误和解决方案

### 错误1：ModuleNotFoundError: No module named 'einops'
```powershell
cd "D:\Program Files\ComfyUI_windows_portable"
.\python_embeded\python.exe -m pip install einops
```

### 错误2：ModuleNotFoundError: No module named 'insightface'
```powershell
.\python_embeded\python.exe -m pip install insightface
```

### 错误3：ModuleNotFoundError: No module named 'onnxruntime'
```powershell
.\python_embeded\python.exe -m pip install onnxruntime
```

### 错误4：ModuleNotFoundError: No module named 'opencv-python'
```powershell
.\python_embeded\python.exe -m pip install opencv-python
```

### 错误5：ModuleNotFoundError: No module named 'imageio'
```powershell
.\python_embeded\python.exe -m pip install imageio imageio-ffmpeg
```

---

## 📋 完整修复流程

### 步骤1：查看错误
```powershell
cd "D:\Program Files\ComfyUI_windows_portable"
.\python_embeded\python.exe -s ComfyUI\main.py
```

### 步骤2：安装所有常见依赖
```powershell
.\python_embeded\python.exe -m pip install einops insightface onnxruntime opencv-python imageio imageio-ffmpeg
```

### 步骤3：安装插件requirements
```powershell
.\python_embeded\python.exe -m pip install -r ComfyUI\custom_nodes\ComfyUI-AnimateDiff-Evolved\requirements.txt
.\python_embeded\python.exe -m pip install -r ComfyUI\custom_nodes\ComfyUI_IPAdapter_plus\requirements.txt
.\python_embeded\python.exe -m pip install -r ComfyUI\custom_nodes\ComfyUI-VideoHelperSuite\requirements.txt
```

### 步骤4：重新启动
```powershell
# 双击运行
D:\Program Files\ComfyUI_windows_portable\run_nvidia_gpu.bat
```

---

## 🆘 如果还是不行

**请执行这个命令并把输出发给我**：

```powershell
cd "D:\Program Files\ComfyUI_windows_portable"
.\python_embeded\python.exe -s ComfyUI\main.py > error_log.txt 2>&1
```

然后打开 `error_log.txt` 文件，把内容发给我。

---

## 💡 关于ControlNet Auxiliary

ControlNet Auxiliary Preprocessors不是必需的，可以暂时不装。我们先让AnimateDiff和IPAdapter工作起来。

---

## ✅ 快速恢复方案（推荐）

如果你想快速恢复ComfyUI，执行这个：

```powershell
cd "D:\Program Files\ComfyUI_windows_portable"

# 安装所有可能需要的依赖
.\python_embeded\python.exe -m pip install einops insightface onnxruntime opencv-python imageio imageio-ffmpeg scipy

# 重新启动
.\run_nvidia_gpu.bat
```

---

**现在请执行方法A或方法B，把错误信息告诉我！**
