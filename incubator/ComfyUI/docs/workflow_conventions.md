# 工作流规范（ComfyUI）

## 版本与节点兼容
- 插件更新频繁，节点名可能变更（尤其 IPAdapter、AnimateDiff）
- 避免依赖过时节点名（如旧版 IPAdapterApply）
- 推荐使用新版节点：
  - IPAdapterAdvanced / IPAdapterUnifiedLoader
  - ADE_AnimateDiffLoaderGen1
  - VHS_VideoCombine（需要 VideoHelperSuite）

## 模板推荐参数（游戏动画：循环/待机类）
- 分辨率：512x512 起步
- 帧数：16（先跑通，再扩展到 24/32）
- FPS：8（预览），需要更丝滑可到 12/15
- AnimateDiff：
  - motion_scale：0.81.0（过大会抖/变形）
  - context_length：16 起步（显存紧张就分段）
- KSampler：
  - steps：2030
  - cfg：68
  - denoise：0.550.75（越低越稳但越没动）

## 输出策略
- 优先输出序列帧 + 可选视频合成
- 商用管线建议：序列帧进入后期（AE/PR/Spine）再做最终合成
