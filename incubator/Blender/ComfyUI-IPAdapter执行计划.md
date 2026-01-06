# ComfyUI + IPAdapter 执行计划

## 🎯 目标

使用ComfyUI + IPAdapter，将你的3D男孩角色图片生成多个动画，完全免费本地运行。

**输入**：你的角色图片（3D男孩拿书）  
**输出**：8个基础动画的序列帧  
**时间**：预计3-5天  
**成本**：¥0（已有ComfyUI）

---

## ✅ 第一步：环境检查（今天，30分钟）

### 1.1 检查ComfyUI版本
```bash
cd [你的ComfyUI目录]
git log -1 --oneline
```

### 1.2 检查已安装插件
```bash
ls custom_nodes/
```

**需要的插件**：
- [ ] ComfyUI-AnimateDiff-Evolved
- [ ] ComfyUI_IPAdapter_plus
- [ ] comfyui_controlnet_aux
- [ ] ComfyUI-VideoHelperSuite

### 1.3 检查显卡
- 你的显卡型号：_______
- 显存大小：_______
- 推荐：RTX 3060 12GB+

---

## 📦 第二步：安装插件（今天，10-30分钟）

### 方法A：使用ComfyUI Manager（推荐）

```bash
# 1. 安装Manager（如果还没有）
cd custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager

# 2. 重启ComfyUI
# 3. 在界面右下角点击"Manager"
# 4. 搜索并安装：
#    - AnimateDiff Evolved
#    - IPAdapter Plus
#    - ControlNet Auxiliary
#    - Video Helper Suite
```

### 方法B：手动安装

```bash
cd custom_nodes

# AnimateDiff
git clone https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved

# IPAdapter
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus

# ControlNet辅助
git clone https://github.com/Fannovel16/comfyui_controlnet_aux

# 视频处理
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
```

---

## 📥 第三步：下载模型（今天/明天，1-3小时）

### 3.1 必需模型清单

#### SD基础模型（选一个）
```
推荐：DreamShaper 8
下载：https://civitai.com/models/4384
大小：约2GB
位置：ComfyUI/models/checkpoints/
```

#### AnimateDiff运动模型
```
文件：mm_sd_v15_v2.ckpt
下载：https://huggingface.co/guoyww/animatediff/tree/main
大小：约1.7GB
位置：ComfyUI/models/animatediff_models/
```

#### IPAdapter模型
```
文件：ip-adapter_sd15.safetensors
下载：https://huggingface.co/h94/IP-Adapter/tree/main/models
大小：约1.2GB
位置：ComfyUI/models/ipadapter/
```

#### CLIP Vision模型
```
文件：clip_vision_g.safetensors 或 model.safetensors
下载：https://huggingface.co/h94/IP-Adapter/tree/main/models/image_encoder
大小：约3.7GB
位置：ComfyUI/models/clip_vision/
```

### 3.2 下载脚本（可选）

我会创建一个Python下载脚本帮你自动下载。

---

## 🎨 第四步：导入工作流（明天，30分钟）

### 4.1 下载推荐工作流

**推荐工作流**：
- 名称：AnimateDiff + IPAdapter + OpenPose
- 来源：Civitai或RunComfy
- 链接：https://civitai.com/models/322516

### 4.2 导入步骤
```
1. 下载工作流JSON文件
2. 打开ComfyUI网页界面
3. 点击"Load"按钮
4. 选择JSON文件
5. 工作流自动加载
```

---

## 🚀 第五步：生成第一个测试动画（明天，1小时）

### 5.1 准备你的角色图

**你的图片**：3D男孩拿书  
**要求**：
- ✅ 透明背景（已满足）
- ✅ 角色清晰（已满足）
- ✅ 分辨率：建议512×512或1024×1024

### 5.2 配置工作流

#### IPAdapter节点参数
```json
{
  "weight": 0.85,
  "weight_type": "linear",
  "start_at": 0.0,
  "end_at": 1.0
}
```

#### AnimateDiff节点参数
```json
{
  "context_length": 16,
  "motion_scale": 1.0
}
```

#### KSampler节点参数
```json
{
  "seed": 123456,
  "steps": 25,
  "cfg": 8.0,
  "sampler_name": "dpmpp_2m",
  "scheduler": "karras",
  "denoise": 0.8
}
```

### 5.3 提示词设置

**正面提示词**：
```
boy with blue hair, white sweater, holding brown book,
idle breathing animation, slight movement,
side view, 2D game animation style,
smooth motion, high quality, detailed
```

**负面提示词**：
```
blurry, low quality, distorted,
multiple characters, inconsistent character,
different hair color, different clothing, no book
```

### 5.4 生成设置
```
分辨率：512×512（测试）
帧数：16帧
批次：1
种子：123456（固定）
```

### 5.5 执行生成
```
1. 上传角色图到IPAdapter节点
2. 输入提示词
3. 点击"Queue Prompt"
4. 等待生成（1-5分钟）
5. 查看结果
```

---

## 🔧 第六步：调优（第3天，2-3小时）

### 6.1 如果角色一致性不好
```
调整：
- 提高IPAdapter weight：0.85 → 0.9
- 降低denoise：0.8 → 0.75
- 固定seed
- 添加更详细的角色描述
```

### 6.2 如果动画不流畅
```
调整：
- 增加帧数：16 → 24
- 调整motion_scale：1.0 → 1.2
- 增加context_overlap：4 → 8
```

### 6.3 如果显存不足
```
优化：
- 降低分辨率：512×512
- 减少帧数：16 → 12
- 减少steps：25 → 20
```

---

## 📋 第七步：批量生成8个动画（第4-5天，6-8小时）

### 7.1 动画清单

```python
animations = {
    "idle": {
        "prompt": "idle breathing, slight movement",
        "motion_scale": 0.8,
        "seed": 123456
    },
    "run": {
        "prompt": "running in place, energetic",
        "motion_scale": 1.5,
        "seed": 123457
    },
    "jump": {
        "prompt": "jumping up and down",
        "motion_scale": 1.8,
        "seed": 123458
    },
    "happy": {
        "prompt": "happy expression, smiling",
        "motion_scale": 1.0,
        "seed": 123459
    },
    "sad": {
        "prompt": "sad expression, looking down",
        "motion_scale": 0.6,
        "seed": 123460
    },
    "reading": {
        "prompt": "reading book, turning pages",
        "motion_scale": 0.7,
        "seed": 123461
    },
    "wave": {
        "prompt": "waving hand, friendly gesture",
        "motion_scale": 1.2,
        "seed": 123462
    },
    "surprised": {
        "prompt": "surprised reaction, eyes wide",
        "motion_scale": 1.3,
        "seed": 123463
    }
}
```

### 7.2 批量生成流程
```
每个动画：
1. 修改提示词
2. 修改seed
3. 修改motion_scale
4. 生成2-3次
5. 选择最佳版本
```

---

## 🎬 第八步：提取序列帧（第6天，2-3小时）

### 8.1 使用FFmpeg
```bash
# 提取帧
ffmpeg -i idle_animation.mp4 -vf fps=24 frames/idle/frame_%04d.png

# 去背景（如需要）
pip install rembg
rembg p -m u2net frames/idle/ frames/idle_nobg/

# 统一尺寸
ffmpeg -i frames/idle_nobg/frame_%04d.png -vf scale=256:256 frames/idle_final/frame_%04d.png
```

### 8.2 批量处理脚本

我会创建Python脚本帮你批量处理。

---

## 🎮 第九步：转换为游戏格式（第7天，2-3小时）

### 9.1 使用Cocos工具
```
1. 将序列帧合并为长图
2. 使用"Spine序列帧生成器"
3. 生成Spine文件
```

### 9.2 或直接导入游戏引擎
```
Unity/Cocos/Unreal → Sprite Animation
```

---

## 📊 时间表

| 天数 | 任务 | 预计时间 | 状态 |
|------|------|---------|------|
| Day 1 | 环境检查 + 安装插件 | 1小时 | ⬜ |
| Day 1-2 | 下载模型 | 1-3小时 | ⬜ |
| Day 2 | 导入工作流 + 测试 | 1.5小时 | ⬜ |
| Day 3 | 调优参数 | 2-3小时 | ⬜ |
| Day 4-5 | 批量生成8个动画 | 6-8小时 | ⬜ |
| Day 6 | 提取序列帧 | 2-3小时 | ⬜ |
| Day 7 | 转换游戏格式 | 2-3小时 | ⬜ |
| **总计** | **完成8个动画** | **17-25小时** | ⬜ |

---

## 🆘 备选方案

如果ComfyUI遇到问题，可以切换到：

### 备选A：Pika 1.5
- 成本：$10/月
- 时间：2小时完成
- 质量：⭐⭐⭐⭐

### 备选B：Runway Gen-4
- 成本：$76/月
- 时间：3小时完成
- 质量：⭐⭐⭐⭐⭐

### 备选C：豆包（免费）
- 成本：¥0
- 时间：4小时完成
- 质量：⭐⭐⭐

---

## 📝 检查清单

### 今天完成
- [ ] 检查ComfyUI版本
- [ ] 检查已安装插件
- [ ] 安装缺失插件
- [ ] 开始下载模型

### 明天完成
- [ ] 确认模型下载完成
- [ ] 下载测试工作流
- [ ] 导入ComfyUI
- [ ] 生成第一个测试动画
- [ ] 验证角色一致性

### 本周完成
- [ ] 调优参数
- [ ] 批量生成8个动画
- [ ] 提取序列帧
- [ ] 转换游戏格式
- [ ] 导入游戏引擎测试

---

## 💡 关键提示

1. **固定seed很重要**：保持角色一致性
2. **从低分辨率开始**：512×512测试，满意后再1024×1024
3. **每个动画生成2-3次**：选择最佳版本
4. **保存工作流模板**：方便后续复用
5. **记录最佳参数**：建立参数数据库

---

## 🚀 立即开始

**现在就可以做**：
1. 打开ComfyUI
2. 检查custom_nodes目录
3. 告诉我缺少哪些插件
4. 我帮你准备安装命令

**准备好了吗？让我们开始！**

---

**创建日期**：2026-01-06  
**预计完成**：2026-01-13（1周）  
**状态**：⬜ 待开始
