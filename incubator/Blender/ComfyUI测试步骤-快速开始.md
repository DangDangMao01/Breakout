# ComfyUI 测试步骤 - 快速开始

## ✅ 前置条件

- [x] ComfyUI已部署：`D:\Program Files\ComfyUI_windows_portable`
- [x] 插件已安装：AnimateDiff, IPAdapter, VideoHelper
- [x] 模型已下载：DreamShaper, AnimateDiff, IPAdapter, CLIP Vision

---

## 🚀 第一步：验证模型加载（5分钟）

### 1.1 启动ComfyUI

```powershell
cd "D:\Program Files\ComfyUI_windows_portable"
.\run_nvidia_gpu.bat
```

**或者双击**：`run_nvidia_gpu.bat`

### 1.2 检查控制台输出

等待启动完成，查看黑色控制台窗口，应该看到：

```
✅ 成功标志：
Loading checkpoint: dreamshaper_8.safetensors
Loading AnimateDiff model: mm_sd_v15_v2.ckpt
Loading IPAdapter model: ip-adapter_sd15.safetensors
Loading CLIP Vision model: clip_vision_g.safetensors

Total VRAM: XXXX MB
```

**如果看到错误**：
```
❌ 模型未找到：
- 检查文件名是否正确
- 检查文件路径是否正确
- 参考 comfyui-models-download.md
```

### 1.3 打开Web界面

浏览器自动打开，或手动访问：
```
http://127.0.0.1:8188
```

---

## 🎨 第二步：导入IPAdapter工作流（10分钟）

### ⚠️ 重要提示：IPAdapter节点名称变化

**问题**：网上下载的旧工作流可能使用 `IPAdapterApply` 节点，但新版插件已改名。

**解决**：使用我们提供的新版工作流。

---

### 方案A：使用我们的工作流（强烈推荐）

#### 2.1 工作流文件位置

```
文件: incubator/Blender/comfyui-workflows/ipadapter-animatediff-workflow.json
```

**这个工作流使用新版IPAdapter节点**：
- ✅ IPAdapterUnifiedLoader
- ✅ IPAdapterAdvanced
- ✅ 兼容最新版ComfyUI_IPAdapter_plus插件

#### 2.2 导入工作流

```
1. 打开ComfyUI网页界面 (http://127.0.0.1:8188)
2. 点击右上角 "Load" 按钮
3. 选择 ipadapter-animatediff-workflow.json
4. 工作流自动加载到画布
```

#### 2.3 验证节点加载

加载后检查：
- ✅ 所有节点显示正常（无红色错误）
- ✅ 节点之间有连线
- ✅ 没有"Missing Node"提示

**如果有红色节点**：
- 说明缺少某个插件或模型
- 查看节点名称，确认是哪个插件
- 参考 comfyui-troubleshooting.md 排查

---

### 方案B：从网上下载工作流（可能有问题）

#### 2.1 下载地址

**推荐工作流**：AnimateDiff + IPAdapter 基础版

**下载地址**：
1. Civitai: https://civitai.com/models/322516
2. RunComfy: https://www.runcomfy.com
3. GitHub: https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved/tree/main/examples

**搜索关键词**：
- "AnimateDiff IPAdapter workflow"
- "Character consistent animation ComfyUI"

#### 2.2 可能遇到的问题

**症状**：提示缺少 `IPAdapterApply` 节点

**原因**：工作流使用旧版节点名称

**解决**：
1. 使用方案A的工作流（推荐）
2. 或参考 `ComfyUI-IPAdapter问题完整解决方案.md`

---

### 方案C：手动创建工作流（高级）

如果你想自己创建工作流，基础节点结构：

```
CheckpointLoaderSimple (加载模型)
    ↓
Load Image (角色图) 
    ↓
IPAdapterUnifiedLoader (加载IPAdapter)
    ↓
IPAdapterAdvanced (应用角色特征)
    ↓
AnimateDiff Loader (加载动画模型)
    ↓
KSampler (生成)
    ↓
VAE Decode (解码)
    ↓
Video Combine (输出视频)
```

**注意**：使用新版节点名称，不是 `IPAdapterApply`

---

## 🧪 第三步：生成第一个测试动画（15分钟）

### 3.1 准备角色图片

**你的角色图**：蓝发男孩拿书（已有）

**图片要求**：
- ✅ 格式：PNG/JPG
- ✅ 分辨率：512×512 或 1024×1024
- ✅ 背景：透明或纯色
- ✅ 角色清晰

**如果需要调整尺寸**：
```powershell
# 使用FFmpeg调整
ffmpeg -i your_character.png -vf scale=512:512 character_512.png
```

### 3.2 配置工作流节点

#### Load Image 节点
```
1. 点击节点
2. 点击 "Choose File to Upload"
3. 选择你的角色图片
4. 上传完成
```

#### IPAdapter 节点
```
参数设置：
- weight: 0.85 (角色一致性强度)
- weight_type: linear
- start_at: 0.0
- end_at: 1.0
```

#### KSampler 节点
```
参数设置：
- seed: 123456 (固定种子，保证可复现)
- steps: 20 (测试用，正式可用25-30)
- cfg: 7.0 (提示词遵循度)
- sampler_name: euler_a
- scheduler: normal
- denoise: 0.75
```

#### AnimateDiff 节点
```
参数设置：
- context_length: 16 (帧数)
- motion_scale: 1.0 (运动强度)
```

#### 提示词节点（Positive Prompt）
```
boy with blue hair, white sweater, holding brown book,
idle breathing animation, slight movement,
high quality, detailed, smooth motion
```

#### 负面提示词（Negative Prompt）
```
blurry, low quality, distorted, multiple characters,
inconsistent character, different appearance
```

### 3.3 生成测试

```
1. 检查所有节点连接正确
2. 点击右侧 "Queue Prompt" 按钮
3. 查看控制台窗口进度
4. 等待生成完成（1-5分钟，取决于显卡）
```

**生成进度**：
```
控制台显示：
Step 1/20 ... 5% 
Step 5/20 ... 25%
Step 10/20 ... 50%
Step 20/20 ... 100%
Saving video...
Done!
```

### 3.4 查看结果

```
1. 生成完成后，视频会显示在界面上
2. 右键点击视频节点
3. 选择 "Save Video" 或 "Open in Browser"
4. 检查角色一致性和动画流畅度
```

---

## 🔧 第四步：调优参数（可选）

### 如果角色一致性不好

**问题**：生成的角色和原图差异大

**解决**：
```
调整 IPAdapter weight:
0.85 → 0.90 → 0.95

降低 denoise:
0.75 → 0.70 → 0.65

固定 seed:
使用相同的seed值
```

### 如果动画不流畅

**问题**：动作卡顿或不自然

**解决**：
```
增加帧数:
context_length: 16 → 24

调整运动强度:
motion_scale: 1.0 → 1.2 (增强)
motion_scale: 1.0 → 0.8 (减弱)

增加生成步数:
steps: 20 → 25 → 30
```

### 如果显存不足

**问题**：CUDA out of memory

**解决**：
```
降低分辨率:
1024×1024 → 512×512

减少帧数:
context_length: 16 → 12

减少步数:
steps: 20 → 15

启用低显存模式:
在启动参数中添加 --lowvram
```

---

## 📋 测试动画清单

### 第一个测试：Idle（待机）

**提示词**：
```
Positive:
boy with blue hair, white sweater, holding brown book,
idle breathing animation, slight up and down movement,
standing still, high quality, detailed, smooth motion

Negative:
blurry, low quality, distorted, multiple characters,
inconsistent character, moving position, camera movement
```

**参数**：
```
- seed: 123456
- steps: 20
- cfg: 7.0
- motion_scale: 0.8 (轻微动作)
- context_length: 16
```

### 第二个测试：Wave（挥手）

**提示词**：
```
Positive:
boy with blue hair, white sweater, holding brown book,
waving hand animation, friendly gesture,
one hand waving then returns to hold book,
standing still, high quality, smooth motion

Negative:
blurry, low quality, distorted, multiple characters,
inconsistent character, moving position
```

**参数**：
```
- seed: 123457
- steps: 20
- cfg: 7.0
- motion_scale: 1.2 (明显动作)
- context_length: 16
```

---

## 🎯 成功标准

### ✅ 第一个测试成功的标志

1. **角色一致性**：
   - ✅ 蓝色头发保持
   - ✅ 白色毛衣保持
   - ✅ 拿着书本保持
   - ✅ 面部特征相似

2. **动画质量**：
   - ✅ 动作流畅
   - ✅ 无明显闪烁
   - ✅ 无变形扭曲
   - ✅ 帧与帧之间连贯

3. **技术指标**：
   - ✅ 生成时间：1-5分钟
   - ✅ 视频时长：约1-2秒（16帧@8fps）
   - ✅ 无错误提示

---

## 🆘 常见问题排查

### Q1: 模型加载失败

**症状**：控制台显示 "Model not found"

**解决**：
```powershell
# 检查模型文件
cd "D:\Program Files\ComfyUI_windows_portable\ComfyUI\models"
dir checkpoints
dir animatediff_models
dir ipadapter
dir clip_vision
```

确认文件名和路径正确。

### Q2: 生成速度很慢

**症状**：每步超过10秒

**原因**：
- 显卡性能不足
- 分辨率太高
- 步数太多

**解决**：
- 降低分辨率到512×512
- 减少steps到15-20
- 减少帧数到12

### Q3: 角色变化太大

**症状**：生成的角色和原图差异大

**解决**：
- 提高IPAdapter weight到0.9-0.95
- 降低denoise到0.6-0.7
- 在提示词中详细描述角色特征

### Q4: 动画太静止或太夸张

**症状**：动作幅度不合适

**解决**：
- 调整motion_scale：
  * 太静止 → 增加到1.2-1.5
  * 太夸张 → 降低到0.6-0.8

---

## 📊 下一步计划

### 今天完成
- [x] 模型下载完成
- [ ] 启动ComfyUI验证模型加载
- [ ] 下载测试工作流
- [ ] 生成第一个Idle测试动画
- [ ] 验证角色一致性

### 明天完成
- [ ] 调优参数找到最佳配置
- [ ] 生成Wave挥手动画
- [ ] 对比ComfyUI vs 豆包效果
- [ ] 决定主要使用哪个工具

### 本周完成
- [ ] 批量生成8个动画
- [ ] 提取序列帧
- [ ] 生成Spine文件

---

## 💡 关键提示

1. **第一次生成可能需要调试**
   - 不要期望一次成功
   - 多尝试几次不同参数
   - 记录最佳参数组合

2. **固定seed很重要**
   - 保持角色一致性
   - 方便复现结果
   - 建立参数数据库

3. **从低分辨率开始**
   - 512×512快速测试
   - 满意后再用1024×1024
   - 节省时间和显存

4. **保存工作流**
   - 找到好的配置后保存
   - 方便后续复用
   - 建立工作流模板库

---

## 🚀 立即开始

**现在就可以做**：

1. 双击启动ComfyUI
2. 检查控制台模型加载信息
3. 告诉我是否有错误
4. 我帮你下载合适的工作流

**准备好了吗？让我们开始测试！**

---

**创建日期**: 2026-01-06  
**状态**: ⬜ 待测试  
**预计时间**: 30分钟完成首次测试
