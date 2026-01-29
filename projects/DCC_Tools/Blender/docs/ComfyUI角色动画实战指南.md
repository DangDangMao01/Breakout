# ComfyUI 角色动画实战指南

## 🎯 快速开始（你已有ComfyUI）

既然你已经部署了ComfyUI，我们可以直接开始制作角色一致性动画！

---

## ✅ 第一步：检查现有环境

### 检查ComfyUI版本
```bash
# 进入ComfyUI目录
cd [你的ComfyUI路径]

# 查看版本
git log -1 --oneline

# 如果版本较旧，更新到最新版
git pull
```

### 检查已安装的插件
```bash
# 查看custom_nodes目录
ls custom_nodes/

# 我们需要的关键插件:
# 1. ComfyUI-AnimateDiff-Evolved (动画生成)
# 2. ComfyUI_IPAdapter_plus (角色一致性)
# 3. comfyui_controlnet_aux (姿势控制)
# 4. ComfyUI-VideoHelperSuite (视频处理)
```

---

## 📦 第二步：安装必要插件（如果缺少）

### 方法A：使用ComfyUI Manager（推荐）

```bash
# 1. 安装ComfyUI Manager（如果还没有）
cd custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager

# 2. 重启ComfyUI
# 3. 在界面右下角点击"Manager"按钮
# 4. 搜索并安装以下插件:
#    - AnimateDiff Evolved
#    - IPAdapter Plus
#    - ControlNet Auxiliary Preprocessors
#    - Video Helper Suite
```

### 方法B：手动安装

```bash
cd custom_nodes

# AnimateDiff（动画生成）
git clone https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved

# IPAdapter（角色一致性）
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus

# ControlNet辅助
git clone https://github.com/Fannovel16/comfyui_controlnet_aux

# 视频处理
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite

# 安装依赖
pip install -r ComfyUI-AnimateDiff-Evolved/requirements.txt
pip install -r ComfyUI_IPAdapter_plus/requirements.txt
pip install -r comfyui_controlnet_aux/requirements.txt
```

---

## 📥 第三步：下载必要模型

### 模型清单

#### 1. Stable Diffusion基础模型
```
推荐模型（选一个）:
- DreamShaper 8 (通用，质量好)
- RealisticVision 5.1 (写实风格)
- Anything V5 (动漫风格)

下载地址: https://civitai.com
保存位置: ComfyUI/models/checkpoints/
```

#### 2. AnimateDiff运动模型
```
必需模型:
- mm_sd_v15_v2.ckpt (SD 1.5)
或
- mm_sdxl_v10_beta.ckpt (SDXL)

下载地址: 
https://huggingface.co/guoyww/animatediff/tree/main

保存位置: ComfyUI/models/animatediff_models/
```

#### 3. IPAdapter模型
```
必需模型:
- ip-adapter_sd15.safetensors (SD 1.5)
或
- ip-adapter_sdxl_vit-h.safetensors (SDXL)

下载地址:
https://huggingface.co/h94/IP-Adapter/tree/main

保存位置: ComfyUI/models/ipadapter/

同时需要CLIP Vision模型:
- clip_vision_g.safetensors (SD 1.5)
或
- clip_vision_vit_h.safetensors (SDXL)

保存位置: ComfyUI/models/clip_vision/
```

#### 4. ControlNet模型
```
推荐模型:
- control_v11p_sd15_openpose.pth (姿势控制)
- control_v11f1p_sd15_depth.pth (深度控制)

下载地址:
https://huggingface.co/lllyasviel/ControlNet-v1-1/tree/main

保存位置: ComfyUI/models/controlnet/
```

#### 5. VAE模型（可选但推荐）
```
推荐:
- vae-ft-mse-840000-ema-pruned.safetensors

下载地址:
https://huggingface.co/stabilityai/sd-vae-ft-mse-original

保存位置: ComfyUI/models/vae/
```

### 快速下载脚本

```python
# download_models.py
import os
import requests
from tqdm import tqdm

def download_file(url, save_path):
    """下载文件并显示进度"""
    response = requests.get(url, stream=True)
    total_size = int(response.headers.get('content-length', 0))
    
    with open(save_path, 'wb') as file, tqdm(
        desc=os.path.basename(save_path),
        total=total_size,
        unit='B',
        unit_scale=True
    ) as bar:
        for data in response.iter_content(chunk_size=1024):
            size = file.write(data)
            bar.update(size)

# 模型下载列表
models = {
    "animatediff": {
        "url": "https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt",
        "path": "models/animatediff_models/mm_sd_v15_v2.ckpt"
    },
    "ipadapter": {
        "url": "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.safetensors",
        "path": "models/ipadapter/ip-adapter_sd15.safetensors"
    },
    "clip_vision": {
        "url": "https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors",
        "path": "models/clip_vision/clip_vision_g.safetensors"
    }
}

# 执行下载
for name, info in models.items():
    print(f"下载 {name}...")
    os.makedirs(os.path.dirname(info["path"]), exist_ok=True)
    download_file(info["url"], info["path"])
    print(f"{name} 下载完成！\n")
```

---

## 🎨 第四步：导入测试工作流

### 方法A：使用现成工作流（推荐）

#### 1. 下载工作流
```
推荐工作流网站:
1. RunComfy: https://www.runcomfy.com/comfyui-workflows
2. Civitai: https://civitai.com/models?type=Workflow
3. OpenArt: https://openart.ai/workflows

搜索关键词:
- "AnimateDiff IPAdapter"
- "Consistent Character Animation"
- "Character Video Generation"
```

#### 2. 导入工作流
```
1. 下载工作流JSON文件
2. 打开ComfyUI网页界面
3. 点击"Load"按钮
4. 选择下载的JSON文件
5. 工作流自动加载
```

#### 3. 推荐的入门工作流
```
工作流名称: "AnimateDiff + IPAdapter + OpenPose"
下载地址: https://civitai.com/models/322516

特点:
✅ 角色一致性好
✅ 姿势可控
✅ 适合游戏动画
✅ 配置简单
```

### 方法B：手工搭建基础工作流

```
基础节点连接:

[Load Image] (你的角色图)
    ↓
[IPAdapter Apply]
    ↓
[Load Checkpoint] (SD模型)
    ↓
[CLIP Text Encode] (正面提示词)
    ↓
[CLIP Text Encode] (负面提示词)
    ↓
[AnimateDiff Loader]
    ↓
[KSampler]
    ↓
[VAE Decode]
    ↓
[VHS Video Combine]
    ↓
[Save Video]
```

---

## 🚀 第五步：生成第一个测试动画

### 准备你的角色图

```
要求:
✅ 透明背景或纯色背景
✅ 角色清晰可见
✅ 分辨率: 512×512 或 1024×1024
✅ 格式: PNG/JPG

你的3D男孩角色图已经符合要求！
```

### 配置工作流参数

#### IPAdapter节点
```json
{
  "weight": 0.85,          // 角色一致性强度 (0.7-0.95)
  "weight_type": "linear", // 权重类型
  "start_at": 0.0,         // 开始位置
  "end_at": 1.0,           // 结束位置
  "unfold_batch": false    // 批处理
}
```

#### AnimateDiff节点
```json
{
  "model_name": "mm_sd_v15_v2.ckpt",
  "context_length": 16,    // 帧数 (8/16/24)
  "context_stride": 1,     // 步长
  "context_overlap": 4,    // 重叠帧
  "motion_scale": 1.0      // 运动幅度 (0.5-2.0)
}
```

#### KSampler节点
```json
{
  "seed": 123456,          // 固定种子保持一致性
  "steps": 25,             // 采样步数 (20-30)
  "cfg": 8.0,              // CFG强度 (7-9)
  "sampler_name": "dpmpp_2m", // 采样器
  "scheduler": "karras",   // 调度器
  "denoise": 0.8           // 去噪强度 (0.75-0.85)
}
```

### 提示词设置

#### 正面提示词（针对你的角色）
```
boy with blue hair, white sweater, holding brown book,
idle breathing animation, slight movement,
side view, 2D game animation style,
smooth motion, high quality, detailed,
masterpiece, best quality
```

#### 负面提示词
```
blurry, low quality, distorted, ugly,
multiple characters, inconsistent character,
different hair color, different clothing,
no book, extra limbs, deformed,
watermark, text, signature
```

### 生成设置

```
分辨率: 512×512 (测试) 或 768×768 (正式)
帧数: 16帧 (约0.5秒 @ 30fps)
批次: 1
种子: 固定 (如: 123456)
```

---

## 🎬 第六步：执行生成

### 生成流程

```
1. 加载工作流
2. 上传你的角色图到IPAdapter节点
3. 输入提示词
4. 设置参数
5. 点击"Queue Prompt"按钮
6. 等待生成（1-5分钟，取决于硬件）
7. 查看生成的视频
```

### 监控生成进度

```
ComfyUI界面会显示:
- 当前执行的节点
- 生成进度百分比
- 预计剩余时间
- 显存使用情况

如果显存不足:
- 降低分辨率 (512×512)
- 减少帧数 (8-12帧)
- 关闭其他程序
```

---

## 🔧 第七步：调优和迭代

### 如果角色一致性不好

```
调整方案:
1. 提高IPAdapter weight (0.85 → 0.9)
2. 使用更详细的角色描述
3. 添加更多负面提示词
4. 固定seed
5. 降低denoise (0.8 → 0.75)
```

### 如果动画不流畅

```
调整方案:
1. 增加帧数 (16 → 24)
2. 调整motion_scale (1.0 → 1.2)
3. 增加context_overlap (4 → 8)
4. 使用更好的AnimateDiff模型
```

### 如果生成速度太慢

```
优化方案:
1. 降低分辨率 (768 → 512)
2. 减少steps (25 → 20)
3. 减少帧数 (16 → 12)
4. 使用LCM LoRA加速
5. 启用xformers优化
```

---

## 📋 第八步：批量生成不同动画

### 创建动画模板

```python
# animation_templates.py

animations = {
    "idle": {
        "prompt": "boy with blue hair, white sweater, holding book, idle breathing, slight movement, side view, 2D game style",
        "motion_scale": 0.8,
        "seed": 123456
    },
    "run": {
        "prompt": "boy with blue hair, white sweater, holding book, running in place, energetic movement, side view, 2D game style",
        "motion_scale": 1.5,
        "seed": 123457
    },
    "jump": {
        "prompt": "boy with blue hair, white sweater, holding book, jumping up and down, dynamic motion, side view, 2D game style",
        "motion_scale": 1.8,
        "seed": 123458
    },
    "happy": {
        "prompt": "boy with blue hair, white sweater, holding book, happy expression, smiling, slight bounce, side view, 2D game style",
        "motion_scale": 1.0,
        "seed": 123459
    },
    "sad": {
        "prompt": "boy with blue hair, white sweater, holding book, sad expression, looking down, slow movement, side view, 2D game style",
        "motion_scale": 0.6,
        "seed": 123460
    },
    "reading": {
        "prompt": "boy with blue hair, white sweater, reading book, focused expression, turning pages, side view, 2D game style",
        "motion_scale": 0.7,
        "seed": 123461
    },
    "wave": {
        "prompt": "boy with blue hair, white sweater, waving hand, friendly gesture, holding book in other hand, side view, 2D game style",
        "motion_scale": 1.2,
        "seed": 123462
    },
    "surprised": {
        "prompt": "boy with blue hair, white sweater, holding book, surprised reaction, eyes wide, sudden movement, side view, 2D game style",
        "motion_scale": 1.3,
        "seed": 123463
    }
}
```

### 批量生成脚本

```python
# batch_generate.py
import json
import os
import time
from animation_templates import animations

def modify_workflow(template_path, output_path, animation_config):
    """修改工作流JSON"""
    with open(template_path, 'r', encoding='utf-8') as f:
        workflow = json.load(f)
    
    # 修改提示词节点（假设节点ID为6）
    workflow["6"]["inputs"]["text"] = animation_config["prompt"]
    
    # 修改seed节点（假设节点ID为3）
    workflow["3"]["inputs"]["seed"] = animation_config["seed"]
    
    # 修改AnimateDiff节点（假设节点ID为10）
    workflow["10"]["inputs"]["motion_scale"] = animation_config["motion_scale"]
    
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(workflow, f, indent=2)

# 批量生成
template_workflow = "workflow_template.json"

for name, config in animations.items():
    print(f"准备生成动画: {name}")
    
    # 修改工作流
    output_workflow = f"workflow_{name}.json"
    modify_workflow(template_workflow, output_workflow, config)
    
    print(f"工作流已保存: {output_workflow}")
    print(f"请在ComfyUI中加载并执行此工作流")
    print(f"完成后按Enter继续下一个...")
    input()

print("所有动画生成完成！")
```

---

## 🎯 第九步：提取序列帧

### 方法A：使用ComfyUI内置节点

```
在工作流中添加:
[VHS Video Combine] 
    ↓
[VHS Video to Images]
    ↓
[Save Image]

这样会自动保存序列帧
```

### 方法B：使用FFmpeg

```bash
# 提取序列帧
ffmpeg -i output_video.mp4 -vf fps=24 frames/frame_%04d.png

# 去除背景（需要rembg）
pip install rembg
rembg p -m u2net frames/ frames_nobg/

# 统一尺寸
ffmpeg -i frames_nobg/frame_%04d.png -vf scale=256:256 frames_final/frame_%04d.png
```

### 方法C：使用Python脚本

```python
# extract_frames.py
import cv2
import os
from rembg import remove
from PIL import Image

def extract_frames(video_path, output_dir, fps=24):
    """提取视频帧"""
    os.makedirs(output_dir, exist_ok=True)
    
    cap = cv2.VideoCapture(video_path)
    video_fps = cap.get(cv2.CAP_PROP_FPS)
    frame_interval = int(video_fps / fps)
    
    frame_count = 0
    saved_count = 0
    
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        
        if frame_count % frame_interval == 0:
            output_path = os.path.join(output_dir, f"frame_{saved_count:04d}.png")
            cv2.imwrite(output_path, frame)
            saved_count += 1
        
        frame_count += 1
    
    cap.release()
    print(f"提取了 {saved_count} 帧")

def remove_background_batch(input_dir, output_dir):
    """批量去除背景"""
    os.makedirs(output_dir, exist_ok=True)
    
    for filename in os.listdir(input_dir):
        if filename.endswith('.png'):
            input_path = os.path.join(input_dir, filename)
            output_path = os.path.join(output_dir, filename)
            
            with open(input_path, 'rb') as i:
                input_img = i.read()
                output_img = remove(input_img)
            
            with open(output_path, 'wb') as o:
                o.write(output_img)
    
    print(f"背景去除完成")

def resize_batch(input_dir, output_dir, size=(256, 256)):
    """批量调整尺寸"""
    os.makedirs(output_dir, exist_ok=True)
    
    for filename in os.listdir(input_dir):
        if filename.endswith('.png'):
            input_path = os.path.join(input_dir, filename)
            output_path = os.path.join(output_dir, filename)
            
            img = Image.open(input_path)
            img_resized = img.resize(size, Image.LANCZOS)
            img_resized.save(output_path)
    
    print(f"尺寸调整完成")

# 使用示例
if __name__ == "__main__":
    video_file = "output/idle_animation.mp4"
    
    # 1. 提取帧
    extract_frames(video_file, "frames/idle", fps=24)
    
    # 2. 去背景
    remove_background_batch("frames/idle", "frames/idle_nobg")
    
    # 3. 调整尺寸
    resize_batch("frames/idle_nobg", "frames/idle_final", size=(256, 256))
    
    print("处理完成！")
```

---

## 🎮 第十步：转换为Spine或游戏引擎格式

### 使用Cocos论坛的工具

```
1. 将序列帧合并为长图
   - 使用"Spine序列帧生成器"
   - 上传序列帧
   - 生成Spine文件

2. 或直接导入游戏引擎
   - Unity: Sprite Animation
   - Cocos: Sprite Frame Animation
   - Unreal: Paper2D
```

---

## 📊 完整工作流时间表

### Day 1: 环境准备
```
- [ ] 检查ComfyUI版本
- [ ] 安装必要插件
- [ ] 下载基础模型
- [ ] 测试运行
预计时间: 2-4小时
```

### Day 2: 工作流配置
```
- [ ] 下载推荐工作流
- [ ] 导入ComfyUI
- [ ] 配置参数
- [ ] 生成第一个测试动画
预计时间: 2-3小时
```

### Day 3: 角色测试
```
- [ ] 上传你的角色图
- [ ] 调整IPAdapter参数
- [ ] 生成idle动画
- [ ] 验证角色一致性
- [ ] 优化参数
预计时间: 3-4小时
```

### Day 4-5: 批量生产
```
- [ ] 生成8个基础动画
- [ ] 每个动画2-3次迭代
- [ ] 选择最佳版本
预计时间: 6-8小时
```

### Day 6: 后处理
```
- [ ] 提取序列帧
- [ ] 去背景
- [ ] 统一尺寸
- [ ] 转换格式
预计时间: 2-3小时
```

### Day 7: 整合测试
```
- [ ] 导入游戏引擎
- [ ] 测试播放
- [ ] 修复问题
- [ ] 最终验收
预计时间: 2-3小时
```

**总计: 17-25小时（约1周）**

---

## 💡 实战技巧

### 技巧1：创建工作流模板库
```
保存不同类型的工作流:
- template_idle.json (待机动画)
- template_action.json (动作动画)
- template_expression.json (表情动画)

每次只需修改提示词和seed
```

### 技巧2：使用固定seed保持一致性
```
所有动画使用连续的seed:
- idle: 123456
- run: 123457
- jump: 123458
...

这样角色外观更一致
```

### 技巧3：建立参数数据库
```json
{
  "character": {
    "ipadapter_weight": 0.85,
    "cfg": 8.0,
    "steps": 25
  },
  "animations": {
    "idle": {"motion_scale": 0.8},
    "run": {"motion_scale": 1.5},
    "jump": {"motion_scale": 1.8}
  }
}
```

### 技巧4：使用ControlNet提高精确度
```
对于复杂动作:
1. 先用Mixamo生成参考动画
2. 提取OpenPose骨骼
3. 在ComfyUI中使用ControlNet
4. 精确控制姿势
```

### 技巧5：分层生成
```
复杂场景分两步:
1. 低分辨率快速预览 (512×512)
2. 满意后高分辨率生成 (1024×1024)

节省时间和显存
```

---

## 🚀 立即开始

### 今天就可以做的事

```
1. [ ] 检查ComfyUI是否正常运行
2. [ ] 安装ComfyUI Manager
3. [ ] 通过Manager安装AnimateDiff和IPAdapter插件
4. [ ] 下载一个基础SD模型（如DreamShaper 8）
5. [ ] 下载AnimateDiff运动模型
6. [ ] 下载IPAdapter模型
7. [ ] 下载一个测试工作流
8. [ ] 生成第一个测试动画

预计时间: 2-3小时
```

### 明天的计划

```
1. [ ] 上传你的3D男孩角色图
2. [ ] 配置IPAdapter参数
3. [ ] 生成idle动画
4. [ ] 调优参数
5. [ ] 生成run动画
6. [ ] 对比角色一致性

预计时间: 3-4小时
```

---

## 📚 推荐资源

### 工作流下载
- RunComfy: https://www.runcomfy.com/comfyui-workflows
- Civitai: https://civitai.com/models?type=Workflow

### 模型下载
- Hugging Face: https://huggingface.co
- Civitai: https://civitai.com

### 教程视频
- YouTube: "ComfyUI AnimateDiff IPAdapter Tutorial"
- Bilibili: "ComfyUI角色一致性动画教程"

### 社区支持
- Reddit: r/comfyui
- Discord: ComfyUI Official
- GitHub: ComfyUI Issues

---

## 🎬 总结

你已经有ComfyUI了，这是最大的优势！

**接下来只需要**：
1. ✅ 安装3个插件（10分钟）
2. ✅ 下载4-5个模型（1-2小时）
3. ✅ 导入1个工作流（5分钟）
4. ✅ 上传你的角色图（1分钟）
5. ✅ 点击生成（1-5分钟）

**今天就可以看到第一个角色动画！**

---

**创建日期**: 2026年1月6日  
**适用对象**: 已部署ComfyUI的用户  
**预计完成时间**: 1周  
**难度**: ⭐⭐⭐（中等）
