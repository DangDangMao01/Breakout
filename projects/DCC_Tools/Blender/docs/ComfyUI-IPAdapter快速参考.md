# ComfyUI IPAdapter 快速参考

## 🎯 核心问题

**Q: 为什么下载的工作流提示缺少 `IPAdapterApply` 节点？**

**A: 不是便携版的问题，是节点名称版本不匹配。**

---

## ✅ 快速解决方案

### 方案1：使用我们的工作流（最快）

```
文件位置: incubator/Blender/comfyui-workflows/ipadapter-animatediff-workflow.json

操作步骤:
1. 启动ComfyUI
2. 点击 "Load" 按钮
3. 选择 ipadapter-animatediff-workflow.json
4. 开始生成
```

**优势**：
- ✅ 使用新版节点名称
- ✅ 完整配置
- ✅ 直接可用

---

### 方案2：验证节点可用性（5分钟）

```
1. 启动ComfyUI
2. 右键点击空白处
3. 搜索 "IPAdapter"
4. 查看显示的节点
```

**应该看到的节点**：
```
✅ IPAdapterUnifiedLoader
✅ IPAdapterAdvanced
✅ IPAdapterUnified
✅ IPAdapterModelLoader
✅ IPAdapterEncoder
✅ IPAdapterApplyFaceID
✅ IPAdapterBatch
```

**如果看到这些节点** → 插件正常，使用方案1的工作流

**如果没有看到任何IPAdapter节点** → 插件未加载，需要排查

---

## 🔧 节点名称对照表

### 旧版本（2024年早期）
```
❌ IPAdapterApply (已废弃)
❌ IPAdapterApplyFace (已废弃)
❌ IPAdapterApplyEncoded (已废弃)
```

### 新版本（2024年中后期至今）
```
✅ IPAdapterUnifiedLoader (推荐)
✅ IPAdapterAdvanced (推荐)
✅ IPAdapterUnified
✅ IPAdapterModelLoader
✅ IPAdapterEncoder
✅ IPAdapterApplyFaceID
✅ IPAdapterBatch
✅ IPAdapterTiled
```

---

## 📋 工作流节点配置

### 完整节点链

```
1. CheckpointLoaderSimple
   └─ 加载: dreamshaper_8.safetensors

2. LoadImage
   └─ 上传: 你的角色图片

3. IPAdapterUnifiedLoader
   └─ preset: STANDARD (SD1.5)

4. IPAdapterAdvanced
   ├─ weight: 0.85
   ├─ weight_type: linear
   ├─ start_at: 0.0
   └─ end_at: 1.0

5. ADE_AnimateDiffLoaderGen1
   ├─ model_name: mm_sd_v15_v2.ckpt
   ├─ context_length: 16
   └─ motion_scale: 1.0

6. CLIPTextEncode (Positive)
   └─ text: "boy with blue hair, white sweater..."

7. CLIPTextEncode (Negative)
   └─ text: "blurry, low quality..."

8. EmptyLatentImage
   ├─ width: 512
   ├─ height: 512
   └─ batch_size: 16

9. KSampler
   ├─ seed: 123456
   ├─ steps: 20
   ├─ cfg: 7.0
   ├─ sampler_name: euler_a
   └─ denoise: 0.75

10. VAEDecode
    └─ 解码图像

11. VHS_VideoCombine
    ├─ frame_rate: 8
    └─ format: video/h264-mp4
```

---

## 🎨 提示词模板

### Idle（待机）
```
Positive:
boy with blue hair, white sweater, holding brown book,
idle breathing animation, slight up and down movement,
standing still, side view, high quality, detailed, smooth motion

Negative:
blurry, low quality, distorted, multiple characters,
inconsistent character, moving position, camera movement

Parameters:
- seed: 123456
- motion_scale: 0.8
```

### Wave（挥手）
```
Positive:
boy with blue hair, white sweater, holding brown book,
waving hand animation, friendly gesture,
one hand waving then returns to hold book,
standing still, side view, high quality, smooth motion

Negative:
blurry, low quality, distorted, multiple characters,
inconsistent character, moving position

Parameters:
- seed: 123457
- motion_scale: 1.2
```

### Happy（开心）
```
Positive:
boy with blue hair, white sweater, holding brown book,
happy expression animation, smiling, joyful,
slight bouncing movement, standing still,
side view, high quality, smooth motion

Negative:
blurry, low quality, distorted, multiple characters,
inconsistent character, sad expression

Parameters:
- seed: 123458
- motion_scale: 1.0
```

### Sad（悲伤）
```
Positive:
boy with blue hair, white sweater, holding brown book,
sad expression animation, looking down, melancholy,
slight drooping movement, standing still,
side view, high quality, smooth motion

Negative:
blurry, low quality, distorted, multiple characters,
inconsistent character, happy expression

Parameters:
- seed: 123459
- motion_scale: 0.7
```

### Surprised（惊讶）
```
Positive:
boy with blue hair, white sweater, holding brown book,
surprised reaction animation, eyes wide, shocked,
sudden movement then still, standing position,
side view, high quality, smooth motion

Negative:
blurry, low quality, distorted, multiple characters,
inconsistent character, calm expression

Parameters:
- seed: 123460
- motion_scale: 1.3
```

### Reading（阅读）
```
Positive:
boy with blue hair, white sweater, holding brown book,
reading animation, looking at book, turning pages,
focused expression, standing still,
side view, high quality, smooth motion

Negative:
blurry, low quality, distorted, multiple characters,
inconsistent character, not holding book

Parameters:
- seed: 123461
- motion_scale: 0.8
```

### Crying（大哭）
```
Positive:
boy with blue hair, white sweater, holding brown book,
crying animation, tears, sobbing motion,
shaking shoulders, standing still,
side view, high quality, smooth motion

Negative:
blurry, low quality, distorted, multiple characters,
inconsistent character, happy expression

Parameters:
- seed: 123462
- motion_scale: 1.1
```

### Angry（愤怒）
```
Positive:
boy with blue hair, white sweater, holding brown book,
angry expression animation, furrowed brows,
shoulders raised in anger, standing still,
side view, high quality, smooth motion

Negative:
blurry, low quality, distorted, multiple characters,
inconsistent character, calm expression

Parameters:
- seed: 123463
- motion_scale: 1.0
```

---

## 🔍 故障排查

### 问题1：没有IPAdapter节点

**检查插件安装**：
```powershell
dir "D:\Program Files\ComfyUI_windows_portable\ComfyUI\custom_nodes\ComfyUI_IPAdapter_plus"
```

**重新安装**：
```powershell
cd "D:\Program Files\ComfyUI_windows_portable\ComfyUI\custom_nodes"
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus
```

---

### 问题2：模型未找到

**检查模型文件**：
```powershell
dir "D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\ipadapter\ip-adapter_sd15.safetensors"
dir "D:\Program Files\ComfyUI_windows_portable\ComfyUI\models\clip_vision\clip_vision_g.safetensors"
```

**下载地址**：参考 `comfyui-models-download.md`

---

### 问题3：角色一致性不好

**调整参数**：
```
IPAdapterAdvanced:
- weight: 0.85 → 0.90 → 0.95

KSampler:
- denoise: 0.75 → 0.70 → 0.65
- seed: 固定相同值
```

**优化提示词**：
```
添加更详细的角色描述:
- 发色、发型
- 服装颜色、款式
- 持有物品
- 面部特征
```

---

### 问题4：动画不流畅

**调整参数**：
```
AnimateDiff:
- context_length: 16 → 24 (增加帧数)
- motion_scale: 调整运动强度

KSampler:
- steps: 20 → 25 → 30 (增加步数)
```

---

### 问题5：显存不足

**优化设置**：
```
EmptyLatentImage:
- width/height: 1024 → 512
- batch_size: 16 → 12

KSampler:
- steps: 20 → 15
```

**启用低显存模式**：
```powershell
# 编辑启动脚本，添加参数
--lowvram
```

---

## 📊 参数调优指南

### IPAdapter权重（角色一致性）

```
0.70-0.80: 轻度影响，更多创造性
0.80-0.90: 平衡（推荐）
0.90-1.00: 强烈一致性，可能僵硬
```

### Motion Scale（运动强度）

```
0.5-0.7: 微小动作（idle, reading）
0.8-1.0: 正常动作（wave, happy）
1.1-1.5: 明显动作（jump, surprised）
1.6-2.0: 夸张动作（不推荐）
```

### Denoise（降噪强度）

```
0.60-0.70: 更接近原图，变化小
0.70-0.80: 平衡（推荐）
0.80-0.95: 更多变化，可能不一致
```

### CFG Scale（提示词遵循度）

```
5-6: 更自由，可能偏离
7-8: 平衡（推荐）
9-12: 严格遵循，可能过度
```

---

## 🚀 快速开始步骤

### 1. 启动ComfyUI（1分钟）
```powershell
cd "D:\Program Files\ComfyUI_windows_portable"
.\run_nvidia_gpu.bat
```

### 2. 导入工作流（1分钟）
```
1. 打开 http://127.0.0.1:8188
2. 点击 "Load"
3. 选择 ipadapter-animatediff-workflow.json
```

### 3. 上传角色图（1分钟）
```
1. 点击 LoadImage 节点
2. 点击 "Choose File to Upload"
3. 选择你的角色图片
```

### 4. 修改提示词（2分钟）
```
1. 点击 CLIPTextEncode (Positive) 节点
2. 输入动作描述
3. 保持角色描述一致
```

### 5. 生成动画（2-5分钟）
```
1. 点击 "Queue Prompt"
2. 等待生成完成
3. 查看结果视频
```

---

## 💡 关键提示

### ✅ 成功要素

1. **固定seed** - 保持角色一致性
2. **详细提示词** - 描述角色特征
3. **合适的权重** - IPAdapter 0.85左右
4. **适当的运动** - motion_scale根据动作调整
5. **多次尝试** - 生成2-3次选最佳

### ⚠️ 常见错误

1. ❌ 使用旧版节点名称
2. ❌ 每次改变seed
3. ❌ 提示词太简单
4. ❌ 分辨率太高导致显存不足
5. ❌ 期望一次成功

---

## 📚 相关文档

- `ComfyUI-IPAdapter问题完整解决方案.md` - 详细问题分析
- `ComfyUI测试步骤-快速开始.md` - 完整测试流程
- `comfyui-models-download.md` - 模型下载指南
- `comfyui-troubleshooting.md` - 故障排查
- `ComfyUI角色一致性动画生成方案.md` - 技术方案

---

**创建日期**: 2026-01-07  
**用途**: IPAdapter快速参考和问题解决  
**状态**: 可直接使用

