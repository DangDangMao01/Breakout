# ComfyUI 环境检查和安装命令

## 📋 你的ComfyUI路径
```
D:\Program Files\ComfyUI_windows_portable
```

---

## ✅ 第一步：检查环境

### 1.1 检查已安装的插件
```powershell
# 打开PowerShell，执行：
cd "D:\Program Files\ComfyUI_windows_portable\ComfyUI\custom_nodes"
ls
```

**需要的插件**：
- [ ] ComfyUI-AnimateDiff-Evolved
- [ ] ComfyUI_IPAdapter_plus
- [ ] comfyui_controlnet_aux
- [ ] ComfyUI-VideoHelperSuite
- [ ] ComfyUI-Manager（推荐）

**请告诉我**：你看到了哪些文件夹？

---

## 📦 第二步：安装缺失的插件

### 方法A：使用ComfyUI Manager（最简单）⭐

#### 1. 安装Manager（如果还没有）
```powershell
cd "D:\Program Files\ComfyUI_windows_portable\ComfyUI\custom_nodes"
git clone https://github.com/ltdrdata/ComfyUI-Manager
```

#### 2. 重启ComfyUI
```powershell
# 关闭ComfyUI
# 双击运行：D:\Program Files\ComfyUI_windows_portable\run_nvidia_gpu.bat
```

#### 3. 使用Manager安装插件
```
1. 打开ComfyUI网页界面（通常是 http://127.0.0.1:8188）
2. 点击右下角的"Manager"按钮
3. 点击"Install Custom Nodes"
4. 搜索并安装：
   - AnimateDiff Evolved
   - IPAdapter Plus
   - ControlNet Auxiliary Preprocessors
   - Video Helper Suite
5. 点击"Restart"重启ComfyUI
```

---

### 方法B：手动安装（如果Manager不工作）

```powershell
# 进入custom_nodes目录
cd "D:\Program Files\ComfyUI_windows_portable\ComfyUI\custom_nodes"

# 安装AnimateDiff
git clone https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved

# 安装IPAdapter
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus

# 安装ControlNet辅助
git clone https://github.com/Fannovel16/comfyui_controlnet_aux

# 安装视频处理
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite

# 安装依赖
cd ComfyUI-AnimateDiff-Evolved
pip install -r requirements.txt

cd ../ComfyUI_IPAdapter_plus
pip install -r requirements.txt

cd ../comfyui_controlnet_aux
pip install -r requirements.txt
```

---

## 📥 第三步：下载模型文件

### 3.1 创建模型目录（如果不存在）
```powershell
cd "D:\Program Files\ComfyUI_windows_portable\ComfyUI\models"

# 检查目录
ls

# 需要的目录：
# - checkpoints
# - animatediff_models
# - ipadapter
# - clip_vision
# - controlnet
# - vae
```

### 3.2 下载模型（手动下载）

#### SD基础模型
```
模型名称：DreamShaper 8
下载地址：https://civitai.com/models/4384
文件名：dreamshaper_8.safetensors
大小：约2GB
保存到：D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\checkpoints\
```

#### AnimateDiff运动模型
```
模型名称：mm_sd_v15_v2.ckpt
下载地址：https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt
大小：约1.7GB
保存到：D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\animatediff_models\
```

#### IPAdapter模型
```
模型名称：ip-adapter_sd15.safetensors
下载地址：https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.safetensors
大小：约1.2GB
保存到：D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\ipadapter\
```

#### CLIP Vision模型
```
模型名称：model.safetensors（重命名为clip_vision_g.safetensors）
下载地址：https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors
大小：约3.7GB
保存到：D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\clip_vision\
```

#### ControlNet模型（可选）
```
模型名称：control_v11p_sd15_openpose.pth
下载地址：https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth
大小：约1.4GB
保存到：D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\controlnet\
```

---

## 🔧 第四步：下载测试工作流

### 4.1 推荐工作流

**工作流1：AnimateDiff + IPAdapter（基础）**
```
名称：AnimateDiff IPAdapter Basic
来源：Civitai
链接：https://civitai.com/models/322516
下载：workflow.json文件
```

**工作流2：角色一致性动画（推荐）**
```
名称：Consistent Character Animation
来源：RunComfy
链接：https://www.runcomfy.com/comfyui-workflows/consistent-character-animation
下载：workflow.json文件
```

### 4.2 导入工作流
```
1. 下载workflow.json文件
2. 打开ComfyUI网页界面
3. 点击"Load"按钮（或拖拽JSON文件到界面）
4. 工作流自动加载
```

---

## 🚀 第五步：测试生成

### 5.1 准备你的角色图片
```
文件：3D男孩拿书.png
位置：保存到桌面或任意位置
要求：
- 透明背景或纯色背景
- 分辨率：512×512 或 1024×1024
```

### 5.2 在ComfyUI中操作
```
1. 找到"Load Image"节点
2. 点击"choose file to upload"
3. 选择你的角色图片
4. 找到"CLIP Text Encode"节点（正面提示词）
5. 输入：
   "boy with blue hair, white sweater, holding brown book,
    idle breathing animation, slight movement,
    side view, 2D game animation style"
6. 找到"CLIP Text Encode"节点（负面提示词）
7. 输入：
   "blurry, low quality, distorted, multiple characters"
8. 点击"Queue Prompt"按钮
9. 等待生成（1-5分钟）
```

---

## 📊 检查清单

### 今天完成
- [ ] 检查custom_nodes目录，列出已安装插件
- [ ] 安装ComfyUI Manager
- [ ] 使用Manager安装4个必需插件
- [ ] 重启ComfyUI验证插件加载成功

### 明天完成
- [ ] 下载SD基础模型（DreamShaper 8）
- [ ] 下载AnimateDiff模型
- [ ] 下载IPAdapter模型
- [ ] 下载CLIP Vision模型
- [ ] 下载测试工作流
- [ ] 导入工作流到ComfyUI

### 后天完成
- [ ] 准备角色图片
- [ ] 上传到ComfyUI
- [ ] 配置提示词
- [ ] 生成第一个测试动画
- [ ] 验证效果

---

## 💡 常见问题

### Q1: 如何启动ComfyUI？
```
双击运行：
D:\Program Files\ComfyUI_windows_portable\run_nvidia_gpu.bat

等待启动完成，浏览器会自动打开
或手动访问：http://127.0.0.1:8188
```

### Q2: 如何知道插件安装成功？
```
启动ComfyUI后，在控制台窗口查看：
- 看到"Import times for custom nodes"
- 列出所有加载的插件
- 没有红色错误信息
```

### Q3: 下载模型太慢怎么办？
```
方法1：使用国内镜像
- HuggingFace镜像：https://hf-mirror.com

方法2：使用下载工具
- IDM、迅雷等

方法3：分批下载
- 先下载最小必需模型测试
- 确认可用后再下载其他
```

### Q4: 显存不够怎么办？
```
优化方案：
1. 降低分辨率（512×512）
2. 减少帧数（8-12帧）
3. 使用FP8模型（更小）
4. 启用CPU offload
```

---

## 🆘 需要帮助？

**请告诉我**：
1. 执行`ls custom_nodes`后看到了什么？
2. 你的显卡型号和显存大小？
3. 遇到了什么错误？

我会根据你的情况提供具体的解决方案！

---

**创建日期**：2026-01-06  
**ComfyUI路径**：D:\Program Files\ComfyUI_windows_portable  
**状态**：⬜ 等待环境检查结果
