# 仓库规范（ComfyUI）

## 目录与命名
- workflows/templates：可复用模板，命名建议：NN_topic_variant.json
  - 例：00_core_txt2img_selfcheck.json
  - 例：10_sd15_animatediff_ipadapter_basic_16f_8fps.json
- workflows/examples：可直接跑的实例（可以更偏项目）
- custom_nodes：每个插件独立目录，建议结构：
  - custom_nodes/MyNodePack/
    - __init__.py
    - requirements.txt（如需要）
    - README.md（节点说明、输入输出、兼容性、示例图）
    - LICENSE（如需要）

## 工作流提交要求
- 模板必须可导入（JSON 格式正确）
- 模板必须包含占位输入：
  - Checkpoint 名称
  - 参考图（如用 IPAdapter）
  - 输出前缀
- 模板必须避免隐式依赖：
  - IPAdapter 的 clip_vision 必须明确连接（不要留 null）
  - 依赖 VideoHelperSuite 时必须在文档里注明

## 模型与路径
- docs 里只记录相对 ComfyUI/models 的推荐放置路径，不记录个人绝对路径
- clip_vision 模型文件名必须与节点期望一致（常见：clip_vision_g.safetensors）
