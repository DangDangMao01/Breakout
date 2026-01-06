# ComfyUI 模型下载清单

## 📥 必需模型（约8.5GB）

### 1. SD基础模型 - DreamShaper 8

**文件名**：`dreamshaper_8.safetensors`  
**大小**：约2GB  
**下载地址**：https://civitai.com/models/4384  
**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\checkpoints\
```

**说明**：Stable Diffusion基础模型，用于图像生成

---

### 2. AnimateDiff运动模型

**文件名**：`mm_sd_v15_v2.ckpt`  
**大小**：约1.7GB  
**下载地址**：https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt  
**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\animatediff_models\
```

**说明**：AnimateDiff运动模型，用于生成动画

**备用下载**：
- https://huggingface.co/guoyww/animatediff/tree/main
- 选择 `mm_sd_v15_v2.ckpt` 下载

---

### 3. IPAdapter模型

**文件名**：`ip-adapter_sd15.safetensors`  
**大小**：约1.2GB  
**下载地址**：https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.safetensors  
**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\ipadapter\
```

**说明**：IPAdapter模型，用于保持角色一致性

**备用下载**：
- https://huggingface.co/h94/IP-Adapter/tree/main/models
- 选择 `ip-adapter_sd15.safetensors` 下载

---

### 4. CLIP Vision模型

**文件名**：`model.safetensors` → **重命名为** `clip_vision_g.safetensors`  
**大小**：约3.7GB  
**下载地址**：https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors  
**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\clip_vision\
```

**重要**：下载后需要重命名！
```
model.safetensors → clip_vision_g.safetensors
```

**说明**：CLIP Vision编码器，IPAdapter必需

**备用下载**：
- https://huggingface.co/h94/IP-Adapter/tree/main/models/image_encoder
- 选择 `model.safetensors` 下载

---

## 📂 目录结构

下载完成后，你的models目录应该是这样的：

```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\
├── checkpoints\
│   └── dreamshaper_8.safetensors
├── animatediff_models\
│   └── mm_sd_v15_v2.ckpt
├── ipadapter\
│   └── ip-adapter_sd15.safetensors
└── clip_vision\
    └── clip_vision_g.safetensors
```

---

## 🔧 可选模型（如果需要更多控制）

### 5. ControlNet OpenPose模型（可选）

**文件名**：`control_v11p_sd15_openpose.pth`  
**大小**：约1.4GB  
**下载地址**：https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth  
**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\controlnet\
```

**说明**：用于精确控制角色姿势（可选）

---

### 6. VAE模型（可选但推荐）

**文件名**：`vae-ft-mse-840000-ema-pruned.safetensors`  
**大小**：约300MB  
**下载地址**：https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors  
**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\vae\
```

**说明**：改善图像质量，减少色彩问题

---

## 💡 下载技巧

### 方法1：直接点击链接下载
- 点击上面的下载地址
- 浏览器会自动下载
- 下载完成后移动到对应目录

### 方法2：使用下载工具
- IDM（Internet Download Manager）
- 迅雷
- Free Download Manager

### 方法3：使用HuggingFace镜像（如果下载慢）
- 国内镜像：https://hf-mirror.com
- 将 `huggingface.co` 替换为 `hf-mirror.com`

**示例**：
```
原地址：
https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt

镜像地址：
https://hf-mirror.com/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt
```

---

## ✅ 下载检查清单

- [ ] DreamShaper 8 (2GB) → checkpoints/
- [ ] mm_sd_v15_v2.ckpt (1.7GB) → animatediff_models/
- [ ] ip-adapter_sd15.safetensors (1.2GB) → ipadapter/
- [ ] clip_vision_g.safetensors (3.7GB) → clip_vision/
- [ ] (可选) control_v11p_sd15_openpose.pth → controlnet/
- [ ] (可选) vae-ft-mse-840000-ema-pruned.safetensors → vae/

**总大小**：约8.5GB（必需）+ 1.7GB（可选）= 10.2GB

---

## 🔍 验证模型安装

下载完成后，重启ComfyUI，在控制台窗口应该看到：

```
Loading models...
Loading checkpoint: dreamshaper_8.safetensors
Loading AnimateDiff model: mm_sd_v15_v2.ckpt
Loading IPAdapter model: ip-adapter_sd15.safetensors
Loading CLIP Vision model: clip_vision_g.safetensors
```

如果看到这些信息，说明模型加载成功！

---

## 🆘 常见问题

### Q1: 下载速度太慢？
使用HuggingFace镜像或下载工具

### Q2: 下载的文件放在哪里？
严格按照上面的"保存位置"放置

### Q3: CLIP Vision模型需要重命名吗？
是的！`model.safetensors` → `clip_vision_g.safetensors`

### Q4: 模型没有被识别？
检查文件名和路径是否正确，重启ComfyUI

---

## 📅 下载进度跟踪

**开始时间**：2026-01-06  
**预计完成**：根据网速，1-3小时

**当前进度**：
- [ ] DreamShaper 8 - ____%
- [ ] AnimateDiff - ____%
- [ ] IPAdapter - ____%
- [ ] CLIP Vision - ____%

---

**下载完成后，我们就可以开始生成第一个角色动画了！** 🎨
