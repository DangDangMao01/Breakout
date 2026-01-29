# ComfyUI 模型下载清单（已更正）

## 📥 必需模型（约7.5GB）

### 1. SD基础模型 - DreamShaper 8

**文件名**：`dreamshaper_8.safetensors`  
**大小**：约2GB  

**下载地址**：
```
方法1（直接下载）：
https://civitai.com/api/download/models/128713

方法2（Civitai页面）：
https://civitai.com/models/4384/dreamshaper
点击 "Download" 按钮，选择 DreamShaper 8 版本

方法3（HuggingFace）：
https://huggingface.co/Lykon/DreamShaper/resolve/main/DreamShaper_8_pruned.safetensors

方法4（国内镜像）：
https://hf-mirror.com/Lykon/DreamShaper/resolve/main/DreamShaper_8_pruned.safetensors
```

**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\checkpoints\
```

---

### 2. AnimateDiff运动模型

**文件名**：`mm_sd_v15_v2.ckpt`  
**大小**：约1.7GB  

**下载地址**：
```
方法1（直接下载）：
https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt

方法2（国内镜像）：
https://hf-mirror.com/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt

方法3（浏览器下载）：
https://huggingface.co/guoyww/animatediff/tree/main
选择 mm_sd_v15_v2.ckpt 下载
```

**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\animatediff_models\
```

---

### 3. IPAdapter模型（标准版）

**文件名**：`ip-adapter_sd15.safetensors`  
**大小**：44.6 MB ✅  

**下载地址**：
```
方法1（直接下载）：
https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.safetensors

方法2（国内镜像）：
https://hf-mirror.com/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.safetensors

方法3（浏览器下载）：
https://huggingface.co/h94/IP-Adapter/tree/main/models
选择 ip-adapter_sd15.safetensors 下载
```

**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\ipadapter\
```

---

### 4. CLIP Vision模型

**文件名**：`model.safetensors` → **重命名为** `clip_vision_g.safetensors`  
**大小**：约3.7GB  

**下载地址**：
```
方法1（直接下载）：
https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors

方法2（国内镜像）：
https://hf-mirror.com/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors

方法3（浏览器下载）：
https://huggingface.co/h94/IP-Adapter/tree/main/models/image_encoder
选择 model.safetensors 下载
```

**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\clip_vision\
```

**⚠️ 重要**：下载后需要重命名！
```
model.safetensors → clip_vision_g.safetensors
```

---

## 🎨 可选模型（提升效果）

### 5. IPAdapter Plus版（推荐）⭐

**文件名**：`ip-adapter-plus_sd15.safetensors`  
**大小**：98.2 MB  

**下载地址**：
```
方法1（直接下载）：
https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sd15.safetensors

方法2（国内镜像）：
https://hf-mirror.com/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sd15.safetensors
```

**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\ipadapter\
```

**说明**：角色一致性更强，推荐使用

---

### 6. IPAdapter Plus Face版（表情动画专用）⭐

**文件名**：`ip-adapter-plus-face_sd15.safetensors`  
**大小**：93.6 MB  

**下载地址**：
```
方法1（直接下载）：
https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus-face_sd15.safetensors

方法2（国内镜像）：
https://hf-mirror.com/h94/IP-Adapter/resolve/main/models/ip-adapter-plus-face_sd15.safetensors
```

**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\ipadapter\
```

**说明**：专注面部表情，适合表情动画（Happy, Sad, Surprised等）

---

### 7. ControlNet OpenPose模型（可选）

**文件名**：`control_v11p_sd15_openpose.pth`  
**大小**：约1.3GB  

**下载地址**：
```
方法1（直接下载）：
https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth

方法2（国内镜像）：
https://hf-mirror.com/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth

方法3（浏览器下载）：
https://huggingface.co/lllyasviel/ControlNet-v1-1/tree/main
选择 control_v11p_sd15_openpose.pth 下载
```

**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\controlnet\
```

**说明**：用于精确控制角色姿势（高级用法）

---

### 8. VAE模型（可选但推荐）

**文件名**：`vae-ft-mse-840000-ema-pruned.safetensors`  
**大小**：约300MB  

**下载地址**：
```
方法1（直接下载）：
https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors

方法2（国内镜像）：
https://hf-mirror.com/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors
```

**保存位置**：
```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\vae\
```

**说明**：改善图像质量，减少色彩问题

---

## 📂 完整目录结构

```
D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\
├── checkpoints\
│   └── dreamshaper_8.safetensors (2GB)
├── animatediff_models\
│   └── mm_sd_v15_v2.ckpt (1.7GB)
├── ipadapter\
│   ├── ip-adapter_sd15.safetensors (44.6MB) ✅ 必需
│   ├── ip-adapter-plus_sd15.safetensors (98.2MB) ⭐ 推荐
│   └── ip-adapter-plus-face_sd15.safetensors (93.6MB) ⭐ 表情动画
├── clip_vision\
│   └── clip_vision_g.safetensors (3.7GB)
├── controlnet\ (可选)
│   └── control_v11p_sd15_openpose.pth (1.3GB)
└── vae\ (可选)
    └── vae-ft-mse-840000-ema-pruned.safetensors (300MB)
```

---

## ✅ 下载检查清单

### 必需模型（最小配置）
- [x] dreamshaper_8.safetensors (~2GB)
- [x] mm_sd_v15_v2.ckpt (~1.7GB)
- [x] ip-adapter_sd15.safetensors (44.6MB)
- [x] clip_vision_g.safetensors (~3.7GB)

**总大小**：约7.5GB ✅ 已完成

### 推荐配置（更好效果）
- [x] 上述必需模型
- [ ] ip-adapter-plus-face_sd15.safetensors (93.6MB) ⏳ 下载中

**总大小**：约7.6GB

### 完整配置（最佳效果）
- [ ] 上述推荐配置
- [ ] control_v11p_sd15_openpose.pth (1.3GB) ⏳ 下载中
- [ ] vae-ft-mse-840000-ema-pruned.safetensors (300MB)

**总大小**：约9.2GB

---

**必需模型已全部下载完成！可以开始测试了！** 🎨

**更新日期**: 2026-01-06  
**状态**: ✅ 已更正所有错误信息，添加完整下载地址
