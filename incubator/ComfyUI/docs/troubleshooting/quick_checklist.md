# 快速排查清单（ComfyUI）

## 启动相关
- 控制台是否有 "Error loading custom node"
- 缺依赖：优先用便携版 python_embeded 安装 requirements.txt

## 工作流导入失败
- 常见原因：节点名过期 / 插件未加载 / JSON 结构不完整
- 先跑 templates/00_core_txt2img_selfcheck.json 判断核心是否正常

## IPAdapter 常见坑
- clip_vision 模型文件名不匹配：model.safetensors 需要改名为 clip_vision_g.safetensors（视节点要求）
- IPAdapterAdvanced 的 clip_vision 输入未连接会直接报错或效果异常

## AnimateDiff 常见坑
- motion model 未放到 ComfyUI/models/animatediff_models
- 帧数过高 + 分辨率过大导致 OOM：先 512 + 16 帧
