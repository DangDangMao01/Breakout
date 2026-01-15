# ComfyUI 资料仓位（incubator/ComfyUI）

这里存放与 ComfyUI 相关的所有可复用资产：
- docs/：安装、排错、参数与管线规范
- workflows/：可导入的工作流 JSON（templates 为可复用模板）
- custom_nodes/：自研 ComfyUI 插件（每个插件一个目录）
- scripts/：辅助脚本（下载/校验/桥接等）
- assets/：示例输入/输出/控制图（不放大模型文件）
- templates/：Prompt/命名/目录规范等模板

约束：
- 模型文件（checkpoints、ipadapter、clip_vision、controlnet、animatediff_models 等）不进入仓库
- 工作流必须注明依赖插件与最低 ComfyUI 版本（写在 docs/workflow_conventions.md）
