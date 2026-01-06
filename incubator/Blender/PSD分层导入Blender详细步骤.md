# PSD 分层导入 Blender 详细步骤

> 目标：将 Photoshop 分层角色导入 Blender，制作骨骼动画，导出到 Spine

---

## 准备工作

### 你需要：
- ✅ Photoshop（或 GIMP/Krita）
- ✅ Blender 5.01
- ✅ 已安装 Blender to Spine Addon
- ✅ 分层的 PSD 角色文件

### PSD 文件要求：
```
推荐图层结构：
- head（头部）
- body（身体）
- arm_L（左臂）
- arm_R（右臂）
- leg_L（左腿）
- leg_R（右腿）

每个图层应该：
- 独立的身体部件
- 有透明背景
- 命名清晰
```

---

## 第一部分：Photoshop 导出分层 PNG

### 方法 A：批量导出（推荐）

#### 1.1 使用脚本导出

```
1. 打开 PSD 文件
2. File → Scripts → Export Layers to Files...
3. 弹出设置窗口：

【Destination】
- 点击 "Browse..." 选择输出文件夹
- 建议创建新文件夹：character_parts

【File Name Prefix】
- 留空（使用图层名称）

【Visible Layers Only】
- ☐ 不勾选（导出所有图层）

【File Type】
- 选择：PNG-24
- ☑ Transparency（保留透明度）

4. 点击 "Run" 开始导出
5. 等待完成
```

#### 1.2 检查导出结果

```
输出文件夹应该有：
- head.png
- body.png
- arm_L.png
- arm_R.png
- leg_L.png
- leg_R.png

检查：
- 每个 PNG 有透明背景
- 图片尺寸合适（建议 512-2048px）
- 文件命名正确
```

---

### 方法 B：手动导出（简单但慢）

```
为每个图层重复：

1. 在图层面板隐藏所有其他图层
2. 只显示当前要导出的图层
3. Image → Trim（裁剪透明区域）
4. File → Export → Quick Export as PNG
5. 保存为图层名称（如 head.png）
6. Ctrl + Z 撤销裁剪
7. 重复下一个图层
```

---

### 方法 C：使用 GIMP（免费替代）

```
1. 打开 PSD 文件
2. Filters → Python-Fu → Console
3. 运行脚本（或使用插件）
4. 或者手动：
   - 右键图层 → Export As
   - 选择 PNG
   - 重复每个图层
```

---

## 第二部分：Blender 导入图片

### 2.1 新建项目

```
1. 打开 Blender 5.01
2. File → New → General
3. 删除默认立方体（X 键 → Delete）
4. 删除默认灯光和相机（可选）
```

### 2.2 设置视图

```
1. 按小键盘 7（顶视图）
2. 或者 View → Viewpoint → Top
3. 这样方便摆放 2D 平面
```

---

### 2.3 导入第一个部件（头部示例）

#### 步骤 1：创建平面

```
1. Shift + A → Mesh → Plane
2. 平面会出现在原点
```

#### 步骤 2：UV 展开

```
1. Tab 进入编辑模式
2. A 全选（如果未选中）
3. U 键 → Unwrap
4. Tab 退出编辑模式
```

#### 步骤 3：添加材质和纹理

```
1. 切换到 Shading 工作区（顶部标签）

2. 在 Shader Editor（下方面板）：
   - 点击 "+ New" 创建新材质

3. 添加图片纹理节点：
   - Shift + A → Texture → Image Texture
   - 或者在菜单 Add → Texture → Image Texture

4. 加载图片：
   - 点击 Image Texture 节点的文件夹图标
   - 浏览到导出的 PNG 文件夹
   - 选择 head.png
   - 点击 "Open Image"

5. 连接节点：
   - 拖动 Image Texture 的 "Color" 输出
   - 连接到 Principled BSDF 的 "Base Color" 输入
   - 拖动 Image Texture 的 "Alpha" 输出
   - 连接到 Principled BSDF 的 "Alpha" 输入
```

#### 步骤 4：设置透明度

```
在右侧属性面板：
1. 找到材质属性（球体图标）
2. 展开 "Settings" 部分
3. Blend Mode: Alpha Blend（或 Alpha Clip）
4. ☑ Show Backface（可选，双面显示）
```

#### 步骤 5：查看效果

```
1. 在 3D 视图右上角
2. 切换着色模式：
   - 点击第 4 个球体图标（Material Preview）
   - 或按 Z 键 → Material Preview
3. 应该看到头部图片显示在平面上
```

#### 步骤 6：调整平面大小

```
1. 按 S 键进入缩放模式
2. 根据图片比例调整：
   - S → X → 输入数值（调整宽度）
   - S → Z → 输入数值（调整高度）
3. 或者直接 S → 输入数值（等比缩放）
4. Enter 确认
```

#### 步骤 7：重命名对象

```
1. 在 Outliner（右上角面板）
2. 双击 "Plane" 
3. 重命名为 "head"
```

---

### 2.4 导入其他部件

**重复上述步骤为每个部件：**

#### 身体（Body）

```
1. Shift + A → Mesh → Plane
2. Tab → U → Unwrap → Tab
3. Shading 工作区 → 添加材质
4. 加载 body.png
5. 连接 Color 和 Alpha
6. 设置 Alpha Blend
7. 调整大小和位置：
   - G 键移动
   - S 键缩放
8. 重命名为 "body"
```

#### 左臂（Arm_L）

```
1. 创建平面 → Unwrap
2. 加载 arm_L.png
3. 设置材质和透明度
4. 调整位置：
   - G → X → 向左移动
   - G → Z → 调整高度
5. 重命名为 "arm_L"
```

#### 右臂（Arm_R）

```
1. 创建平面 → Unwrap
2. 加载 arm_R.png
3. 设置材质和透明度
4. 调整位置：
   - G → X → 向右移动
   - G → Z → 调整高度
5. 重命名为 "arm_R"
```

#### 左腿（Leg_L）

```
1. 创建平面 → Unwrap
2. 加载 leg_L.png
3. 设置材质和透明度
4. 调整位置：
   - G → X → 稍微向左
   - G → Z → 向下移动
5. 重命名为 "leg_L"
```

#### 右腿（Leg_R）

```
1. 创建平面 → Unwrap
2. 加载 leg_R.png
3. 设置材质和透明度
4. 调整位置：
   - G → X → 稍微向右
   - G → Z → 向下移动
5. 重命名为 "leg_R"
```

---

### 2.5 整理场景

```
1. 切换回 Layout 工作区
2. 在 Outliner 中检查所有对象：
   ☑ head
   ☑ body
   ☑ arm_L
   ☑ arm_R
   ☑ leg_L
   ☑ leg_R

3. 调整视图查看整体效果：
   - 小键盘 1（前视图）
   - 滚轮缩放
   - 中键拖动旋转
```

---

## 第三部分：创建骨骼

### 3.1 添加骨架

```
1. Shift + A → Armature → Single Bone
2. 骨骼出现在原点
3. Tab 进入骨架编辑模式
```

### 3.2 调整 Root 骨骼

```
1. 选中骨骼
2. G 键移动到角色中心底部
3. S 键缩放到合适大小
4. 在属性面板 → Bone 标签
5. 重命名为 "root"
```

### 3.3 创建骨骼层级

**Spine 骨骼**
```
1. 选中 root 骨骼的顶端（小球）
2. E 键挤出
3. G → Z → 向上移动到身体中心
4. 重命名为 "spine"
```

**Head 骨骼**
```
1. 选中 spine 顶端
2. E 键挤出
3. G → Z → 移动到头部中心
4. 重命名为 "head"
```

**Arm_L 骨骼**
```
1. 选中 spine 骨骼（点击骨骼中间）
2. Shift + A → Single Bone（添加新骨骼）
3. 新骨骼会出现在 spine 位置
4. G 键移动到左臂位置
5. 设置父级：
   - 选中新骨骼
   - Shift + 选中 spine
   - Ctrl + P → Keep Offset
6. 重命名为 "arm_L"
```

**Arm_R 骨骼**
```
1. 重复左臂步骤
2. 移动到右臂位置
3. 父级设为 spine
4. 重命名为 "arm_R"
```

**Leg_L 骨骼**
```
1. 选中 root 骨骼
2. Shift + A → Single Bone
3. G 键移动到左腿位置
4. 父级设为 root
5. 重命名为 "leg_L"
```

**Leg_R 骨骼**
```
1. 重复左腿步骤
2. 移动到右腿位置
3. 父级设为 root
4. 重命名为 "leg_R"
```

### 3.4 骨骼层级结构

```
最终结构：
root
├── spine
│   ├── head
│   ├── arm_L
│   └── arm_R
├── leg_L
└── leg_R
```

### 3.5 退出编辑模式

```
Tab 键退出骨架编辑模式
```

---

## 第四部分：绑定网格到骨骼

### 4.1 绑定每个部件

**绑定头部**
```
1. 在对象模式（Object Mode）
2. 点击选中 head 网格
3. Shift + 点击选中骨架（Armature）
4. Ctrl + P → Armature Deform → With Automatic Weights
5. 等待计算完成
```

**绑定其他部件**
```
重复上述步骤：
- body + Armature → Ctrl + P → Automatic Weights
- arm_L + Armature → Ctrl + P → Automatic Weights
- arm_R + Armature → Ctrl + P → Automatic Weights
- leg_L + Armature → Ctrl + P → Automatic Weights
- leg_R + Armature → Ctrl + P → Automatic Weights
```

### 4.2 测试绑定

```
1. 选中骨架
2. Ctrl + Tab 进入姿态模式（Pose Mode）
3. 选中一个骨骼（如 arm_L）
4. R 键旋转骨骼
5. 检查对应的网格是否跟随
6. Ctrl + Z 撤销旋转
7. 测试其他骨骼
8. Ctrl + Tab 退出姿态模式
```

---

## 第五部分：制作动画

### 5.1 切换到动画工作区

```
1. 点击顶部 "Animation" 标签
2. 或者手动调整布局
```

### 5.2 创建动作

```
1. 选中骨架
2. 在 Dope Sheet 编辑器
3. 切换模式：Dope Sheet → Action Editor
4. 点击 "+ New" 创建新动作
5. 命名为 "idle"（或其他动画名）
```

### 5.3 制作简单呼吸动画

**第 1 帧 - 初始姿势**
```
1. 时间轴移到第 1 帧
2. Ctrl + Tab 进入姿态模式
3. A 全选所有骨骼
4. I 键 → Location & Rotation & Scale
```

**第 20 帧 - 吸气**
```
1. 时间轴移到第 20 帧
2. 选中 spine 骨骼
3. S → Z → 输入 1.05 → Enter（稍微拉伸）
4. I 键 → Location & Rotation & Scale
```

**第 40 帧 - 呼气（回到初始）**
```
1. 时间轴移到第 40 帧
2. 选中 spine 骨骼
3. S → Z → 输入 1.0 → Enter（恢复）
4. I 键 → Location & Rotation & Scale
```

### 5.4 设置循环

```
1. 在时间轴设置：
   - Start: 1
   - End: 40
2. 空格键播放预览
3. 检查动画是否流畅
```

---

## 第六部分：导出到 Spine

### 6.1 保存 Blender 文件

```
⚠️ 重要：必须先保存！
1. File → Save As
2. 命名：my_character.blend
3. 选择保存位置
4. 点击 "Save As"
```

### 6.2 应用所有变换

```
1. A 全选所有对象
2. Ctrl + A → All Transforms
3. 这确保导出时坐标正确
```

### 6.3 打开导出面板

```
1. 切换回 Layout 工作区
2. 按 N 键打开侧边栏
3. 找到 "Blender_to_Spine_2D_Mesh_Exporter" 标签
```

### 6.4 配置导出设置

```
【Output Settings】
- Output Directory: 选择输出文件夹
- Project Name: my_character

【Mesh Segmentation】
- Segmentation Mode: Auto
- Angle Threshold: 30
- Min Segment Size: 0.01

【Texture Baking】
☑ Enable Texture Baking
- Texture Size: 2048（根据需要调整）
- Bake Mode: DIFFUSE
- Margin: 2

【Armature Export】
☑ Export Armature
☑ Include Animations
- Animation Name: idle（或留空使用动作名）
```

### 6.5 选择导出对象

```
1. A 全选所有对象
2. 或者只选择：
   - 所有网格对象（head, body, arm_L, arm_R, leg_L, leg_R）
   - 骨架对象（Armature）
```

### 6.6 执行导出

```
1. 点击 "Export to Spine2D" 按钮
2. 等待处理（可能需要几秒到几分钟）
3. 查看 Blender 控制台输出
4. 完成后检查输出文件夹
```

### 6.7 检查导出文件

```
输出文件夹应该有：
- my_character.json（Spine 骨骼和动画数据）
- my_character.atlas（图集配置文件）
- my_character.png（打包的纹理图集）

检查：
- JSON 文件不为空
- PNG 包含所有身体部件
- Atlas 文件正确引用 PNG
```

---

## 第七部分：Spine 导入测试

### 7.1 导入到 Spine

```
1. 打开 Spine
2. File → Import Data
3. 选择 my_character.json
4. 点击 "Import"
```

### 7.2 检查导入结果

```
检查项目：
☑ 骨骼层级正确显示
☑ 网格正确绑定到骨骼
☑ 纹理正确显示
☑ 动画可以播放
☑ 透明度正确
```

### 7.3 测试动画

```
1. 在 Spine 动画列表找到 "idle"
2. 点击播放
3. 检查动画是否流畅
4. 调整播放速度测试
```

---

## 常见问题排查

### 问题 1：图片不显示

**原因**：
- 材质未设置 Alpha Blend
- 节点连接错误
- 视图模式不对

**解决**：
1. 检查材质设置 → Blend Mode: Alpha Blend
2. 确认 Color 和 Alpha 都已连接
3. 切换到 Material Preview 模式（Z → 4）

---

### 问题 2：导出后纹理丢失

**原因**：
- 未启用纹理烘焙
- 材质不兼容

**解决**：
1. 确保勾选 "Enable Texture Baking"
2. 使用 Principled BSDF 材质
3. 图片纹理直接连接到 Base Color

---

### 问题 3：骨骼绑定不正确

**原因**：
- 自动权重计算失败
- 网格离骨骼太远

**解决**：
1. 调整网格位置靠近对应骨骼
2. 手动调整权重：
   - Tab 进入编辑模式
   - 切换到 Weight Paint 模式
   - 手动绘制权重

---

### 问题 4：动画不导出

**原因**：
- 未选中骨架
- 未勾选 "Include Animations"

**解决**：
1. 确保骨架被选中
2. 勾选导出设置中的 "Include Animations"
3. 确认动作已保存（Action Editor 中有动作）

---

### 问题 5：Spine 导入后变形

**原因**：
- 未应用变换
- 骨骼坐标系问题

**解决**：
1. 导出前：Ctrl + A → All Transforms
2. 检查骨架原点位置
3. 确保所有对象在世界坐标系中

---

## 优化建议

### 纹理优化
```
- 使用 2 的幂次方尺寸（512, 1024, 2048）
- 移动端建议 1024 或更小
- PC/主机可以用 2048 或 4096
```

### 性能优化
```
- 减少不必要的顶点
- 合并相似材质
- 使用简单的骨骼层级
```

### 工作流优化
```
- 在 Photoshop 中规范命名
- 保持图层顺序一致
- 使用图层组管理复杂角色
```

---

## 下一步

完成基础流程后可以尝试：

1. **添加更多动画**
   - walk（行走）
   - run（奔跑）
   - jump（跳跃）
   - attack（攻击）

2. **优化骨骼**
   - 添加手部骨骼
   - 添加脚部骨骼
   - 添加面部骨骼（眼睛、嘴巴）

3. **高级功能**
   - 使用 IK 约束
   - 添加物理模拟
   - 制作表情动画（Slot 切换）

4. **批量处理**
   - 创建多个角色
   - 复用骨架
   - 批量导出

---

## 相关文档

- [测试案例-简单2D角色导出Spine.md](./测试案例-简单2D角色导出Spine.md)
- [FBX2Spine 详细制作方案](D:\G_GitHub\Kiro-Central-KB\solutions\20260106-fbx2spine-blender-to-spine-tutorial.md)
- [Blender to Spine Addon 详细制作方案](D:\G_GitHub\Kiro-Central-KB\solutions\20260106-blender-to-spine-addon-tutorial.md)

---

完成后告诉我结果，遇到问题随时问我！
