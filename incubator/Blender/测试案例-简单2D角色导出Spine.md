# Blender to Spine Addon 测试案例

> 目标：创建一个简单的 2D 角色，导出到 Spine

---

## 第一步：创建简单角色模型

### 1.1 新建 2D Animation 项目
```
1. 打开 Blender 5.01
2. File → New → General（或直接用默认场景）
3. 删除默认立方体（X 键 → Delete）
```

### 1.2 创建身体部件

**创建身体（Body）**
```
1. Shift + A → Mesh → Plane
2. Tab 进入编辑模式
3. S 键缩放 → 输入 0.5 → Enter（缩小一半）
4. Tab 退出编辑模式
5. 在 Outliner 中重命名为 "body"
```

**创建头部（Head）**
```
1. Shift + A → Mesh → Plane
2. Tab 进入编辑模式
3. S 键缩放 → 输入 0.3 → Enter
4. G 键移动 → Z 键限制 Z 轴 → 输入 0.8 → Enter（向上移动）
5. Tab 退出编辑模式
6. 重命名为 "head"
```

**创建左臂（Arm_L）**
```
1. Shift + A → Mesh → Plane
2. Tab 进入编辑模式
3. S 键 → X 键 → 输入 0.3 → Enter（X 轴缩小）
4. S 键 → Y 键 → 输入 0.6 → Enter（Y 轴拉长）
5. G 键 → X 键 → 输入 -0.6 → Enter（向左移动）
6. G 键 → Z 键 → 输入 0.3 → Enter（向上移动）
7. Tab 退出编辑模式
8. 重命名为 "arm_L"
```

**创建右臂（Arm_R）**
```
1. 选中 arm_L
2. Shift + D 复制 → X 键 → 输入 1.2 → Enter（向右移动）
3. 重命名为 "arm_R"
```

**创建左腿（Leg_L）**
```
1. Shift + A → Mesh → Plane
2. Tab 进入编辑模式
3. S 键 → X 键 → 输入 0.3 → Enter
4. S 键 → Y 键 → 输入 0.7 → Enter
5. G 键 → X 键 → 输入 -0.2 → Enter
6. G 键 → Z 键 → 输入 -0.8 → Enter（向下移动）
7. Tab 退出编辑模式
8. 重命名为 "leg_L"
```

**创建右腿（Leg_R）**
```
1. 选中 leg_L
2. Shift + D → X 键 → 输入 0.4 → Enter
3. 重命名为 "leg_R"
```

---

## 第二步：添加简单材质

### 2.1 给每个部件添加颜色

**身体 - 蓝色**
```
1. 选中 body
2. 切换到 Shading 工作区（顶部标签）
3. 在 Shader Editor 中点击 "New" 创建材质
4. 找到 Principled BSDF 节点
5. 点击 Base Color 颜色块 → 选择蓝色
6. 切换回 Layout 工作区
```

**头部 - 肤色**
```
1. 选中 head
2. 材质属性 → New
3. Base Color → 浅粉色/肤色
```

**手臂 - 肤色**
```
1. 选中 arm_L 和 arm_R
2. 材质属性 → New
3. Base Color → 肤色
```

**腿部 - 深蓝色**
```
1. 选中 leg_L 和 leg_R
2. 材质属性 → New
3. Base Color → 深蓝色
```

---

## 第三步：创建骨骼

### 3.1 添加骨架

```
1. Shift + A → Armature → Single Bone
2. 骨骼会出现在原点
3. Tab 进入骨架编辑模式
```

### 3.2 创建骨骼层级

**Root 骨骼（已存在）**
```
1. 选中骨骼
2. 在属性面板 → Bone 标签
3. 重命名为 "root"
4. 调整位置到角色中心（G 键移动）
```

**创建 Spine 骨骼**
```
1. 选中 root 骨骼的顶端（小球）
2. E 键挤出
3. G 键 → Z 键 → 向上移动到身体中心
4. 重命名为 "spine"
```

**创建 Head 骨骼**
```
1. 选中 spine 顶端
2. E 键挤出
3. G 键 → Z 键 → 移动到头部位置
4. 重命名为 "head"
```

**创建左臂骨骼**
```
1. 选中 spine 骨骼
2. Shift + A → Single Bone（添加新骨骼）
3. 设置父级：选中新骨骼 → Shift + 选中 spine → Ctrl + P → Keep Offset
4. 调整位置到左臂
5. 重命名为 "arm_L"
```

**创建右臂骨骼**
```
1. 重复左臂步骤
2. 调整到右臂位置
3. 重命名为 "arm_R"
```

**创建腿部骨骼**
```
1. 选中 root 骨骼
2. 添加两个子骨骼
3. 调整到左右腿位置
4. 重命名为 "leg_L" 和 "leg_R"
```

### 3.3 骨骼层级结构

```
root
├── spine
│   ├── head
│   ├── arm_L
│   └── arm_R
├── leg_L
└── leg_R
```

---

## 第四步：绑定网格到骨骼

### 4.1 自动权重绑定

**绑定身体**
```
1. Tab 退出骨架编辑模式
2. 选中 body 网格
3. Shift + 选中骨架
4. Ctrl + P → Armature Deform → With Automatic Weights
```

**绑定其他部件**
```
重复上述步骤绑定：
- head → 骨架
- arm_L → 骨架
- arm_R → 骨架
- leg_L → 骨架
- leg_R → 骨架
```

### 4.2 测试绑定

```
1. 选中骨架
2. Ctrl + Tab 进入姿态模式
3. 旋转骨骼（R 键）
4. 检查网格是否跟随
5. Ctrl + Tab 退出姿态模式
```

---

## 第五步：创建简单动画

### 5.1 创建 Idle 动画

```
1. 选中骨架
2. 切换到 Animation 工作区
3. 在 Dope Sheet 切换到 Action Editor
4. 点击 "New" 创建动作
5. 命名为 "idle"
```

### 5.2 K 帧动画

**第 1 帧 - 初始姿势**
```
1. 时间轴移到第 1 帧
2. Ctrl + Tab 进入姿态模式
3. A 全选所有骨骼
4. I 键 → Location & Rotation
```

**第 20 帧 - 呼吸动作**
```
1. 时间轴移到第 20 帧
2. 选中 spine 骨骼
3. S 键 → Z 键 → 输入 1.1 → Enter（稍微拉伸）
4. I 键 → Location & Rotation & Scale
```

**第 40 帧 - 回到初始**
```
1. 时间轴移到第 40 帧
2. 恢复初始姿势
3. I 键插入关键帧
```

### 5.3 预览动画

```
1. 设置时间轴范围：1-40
2. 空格键播放
3. 检查动画是否流畅
```

---

## 第六步：导出到 Spine

### 6.1 保存 Blender 文件

```
⚠️ 重要：必须先保存文件！
File → Save As → test_character.blend
```

### 6.2 打开导出面板

```
1. 在 3D 视图按 N 键
2. 找到 "Blender_to_Spine_2D_Mesh_Exporter" 标签
3. 点击展开面板
```

### 6.3 配置导出设置

```
【基本设置】
- Output Directory: 选择输出文件夹
- Project Name: test_character

【网格分割】
- Segmentation Mode: Auto
- Angle Threshold: 30

【纹理烘焙】
☑ Enable Texture Baking
- Texture Size: 1024
- Bake Mode: DIFFUSE

【骨骼动画】
☑ Export Armature
☑ Include Animations
```

### 6.4 执行导出

```
1. A 全选所有对象（网格 + 骨架）
2. 点击 "Export to Spine2D" 按钮
3. 等待处理完成
4. 检查输出文件夹
```

### 6.5 导出文件

```
输出文件：
- test_character.json (Spine 骨骼数据)
- test_character.atlas (图集配置)
- test_character.png (纹理图集)
```

---

## 第七步：Spine 导入测试

### 7.1 导入到 Spine

```
1. 打开 Spine
2. File → Import Data
3. 选择 test_character.json
4. 检查导入结果
```

### 7.2 检查项目

```
检查：
☑ 骨骼层级正确
☑ 网格显示正常
☑ 动画可以播放
☑ 纹理正确显示
```

---

## 常见问题

### 导出失败
- 确保已保存 .blend 文件
- 检查是否选中了网格和骨架
- 查看 Blender 控制台错误信息

### 纹理丢失
- 确保材质使用 Principled BSDF
- 启用纹理烘焙选项

### 骨骼错位
- 检查骨架原点位置
- 应用所有变换（Ctrl + A → All Transforms）

### 动画不导出
- 确保选中了骨架
- 勾选 "Include Animations"

---

## 下一步

测试成功后可以尝试：
1. 添加更多身体部件
2. 创建更复杂的动画
3. 使用图片纹理替代纯色
4. 制作多个动画动作

---

完成后告诉我结果！
