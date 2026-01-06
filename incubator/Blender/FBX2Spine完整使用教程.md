# FBX2Spine 完整使用教程

> 从 Blender 制作动画到 Spine 导入的完整流程

---

## 准备工作

### 你需要：
- ✅ Blender 5.01（已安装）
- ✅ FBX2Spine（刚购买，正在安装）
- ✅ Spine 4 Essential 或 Pro
- ✅ 一个 Spine 角色项目

---

## 工作流程概览

```
1. Blender 制作 3D 骨骼动画
     ↓
2. 导出 FBX 文件
     ↓
3. Spine 创建 2D 角色（已绑定骨骼）
     ↓
4. Spine 导出 JSON
     ↓
5. FBX2Spine 链接骨骼
     ↓
6. 导出新的 Spine JSON（带动画）
     ↓
7. Spine 导入查看
```

---

## 第一部分：Blender 制作动画

### 1.1 创建简单骨架

```
步骤：
1. 打开 Blender
2. 删除默认立方体（X 键）
3. Shift + A → Armature → Single Bone
4. Tab 进入编辑模式
5. 创建基础骨骼结构
```

### 1.2 推荐骨骼结构（与 Spine 对应）

```
root (根骨骼)
├── hip (臀部)
│   ├── spine (脊椎)
│   │   ├── chest (胸部)
│   │   │   ├── neck (脖子)
│   │   │   │   └── head (头)
│   │   │   ├── shoulder_L (左肩)
│   │   │   │   └── upper_arm_L (左上臂)
│   │   │   │       └── forearm_L (左前臂)
│   │   │   │           └── hand_L (左手)
│   │   │   └── shoulder_R (右肩)
│   │   │       └── upper_arm_R (右上臂)
│   │   │           └── forearm_R (右前臂)
│   │   │               └── hand_R (右手)
│   ├── thigh_L (左大腿)
│   │   └── calf_L (左小腿)
│   │       └── foot_L (左脚)
│   └── thigh_R (右大腿)
│       └── calf_R (右小腿)
│           └── foot_R (右脚)
```

**⚠️ 重要：骨骼命名要清晰，方便后续在 FBX2Spine 中链接**

---

### 1.3 制作动画

#### 示例：简单行走动画

```
第 1 帧 - 左脚前，右脚后：
1. 时间轴移到第 1 帧
2. Ctrl + Tab 进入姿态模式
3. 调整骨骼姿势：
   - thigh_L 向前旋转 30°
   - thigh_R 向后旋转 30°
   - upper_arm_L 向后旋转 20°
   - upper_arm_R 向前旋转 20°
4. A 全选所有骨骼
5. I 键 → Location & Rotation

第 15 帧 - 中间姿势：
1. 时间轴移到第 15 帧
2. 调整为中立姿势
3. I 键插入关键帧

第 30 帧 - 右脚前，左脚后：
1. 时间轴移到第 30 帧
2. 调整姿势（与第 1 帧相反）
3. I 键插入关键帧

预览：
- 设置时间轴范围 1-30
- 空格键播放
- 调整直到满意
```

---

### 1.4 导出 FBX

```
步骤：
1. 选中骨架对象
2. File → Export → FBX (.fbx)

导出设置（重要！）：
【Include】
☑ Selected Objects（只导出选中的）
或
☑ Armature（导出骨架）

【Transform】
- Forward: -Z Forward
- Up: Y Up
- Scale: 1.0
☑ Apply Transform

【Armature】
☑ Add Leaf Bones（可选）
- Primary Bone Axis: Y Axis
- Secondary Bone Axis: X Axis

【Animation】
☑ Baked Animation
☑ Key All Bones
☑ NLA Strips
☑ All Actions
- Sampling Rate: 1.0
- Simplify: 0.0

3. 保存为：walk_animation.fbx
```

**⚠️ 关键设置**
- 必须勾选 "Baked Animation"
- 必须勾选 "Key All Bones"
- 确保坐标系设置正确

---

## 第二部分：Spine 准备角色

### 2.1 创建 Spine 角色

```
如果你已有角色：
- 跳过此步骤
- 确保骨骼已绑定

如果需要新建：
1. 打开 Spine
2. 导入角色图片（分层 PNG）
3. 创建骨骼结构（与 Blender 对应）
4. 绑定图片到骨骼
```

### 2.2 Spine 骨骼命名（与 Blender 对应）

```
⚠️ 重要：命名要与 Blender 一致或相似

Blender 骨骼    →    Spine 骨骼
─────────────────────────────────
root            →    root
hip             →    hip
spine           →    spine
chest           →    chest
neck            →    neck
head            →    head
shoulder_L      →    shoulder_L
upper_arm_L     →    upper_arm_L
forearm_L       →    forearm_L
hand_L          →    hand_L
（右侧同理）
thigh_L         →    thigh_L
calf_L          →    calf_L
foot_L          →    foot_L
（右侧同理）
```

### 2.3 导出 Spine JSON

```
步骤：
1. Spine → Export → JSON
2. 设置：
   - Format: JSON
   - ☑ Nonessential data（推荐勾选）
   - ☑ Pretty print（可选，方便查看）
3. 保存为：character.json
```

---

## 第三部分：FBX2Spine 转换

### 3.1 启动 FBX2Spine

```
1. 从 Steam 库启动 FBX2SPINE
2. 等待程序打开
```

### 3.2 界面说明

```
程序界面分为三个区域：

┌─────────────────────────────────────────┐
│  FBX 骨骼列表  │  链接区域  │  Spine 骨骼列表  │
│   (左侧)      │   (中间)   │    (右侧)       │
│               │            │                │
│  - root       │            │  - root        │
│  - hip        │   [Link]   │  - hip         │
│  - spine      │   按钮     │  - spine       │
│  - ...        │            │  - ...         │
└─────────────────────────────────────────┘
```

---

### 3.3 导入文件

#### 步骤 1：导入 FBX

```
1. 点击左上角 "Import FBX" 按钮
2. 浏览到 Blender 导出的 FBX 文件
3. 选择：walk_animation.fbx
4. 点击 "Open"
5. 等待加载完成
6. 左侧显示 FBX 骨骼树
```

#### 步骤 2：导入 Spine JSON

```
1. 点击右上角 "Import Spine" 按钮
2. 浏览到 Spine 导出的 JSON 文件
3. 选择：character.json
4. 点击 "Open"
5. 等待加载完成
6. 右侧显示 Spine 骨骼树
```

---

### 3.4 链接骨骼（核心步骤）

#### 链接方法

```
为每个骨骼重复以下步骤：

1. 在左侧 FBX 骨骼列表中点击一个骨骼
   例如：点击 "root"

2. 在右侧 Spine 骨骼列表中点击对应的骨骼
   例如：点击 "root"

3. 点击中间的 "Link" 按钮
   或者按快捷键（如果有）

4. 链接成功后：
   - 两个骨骼会高亮显示
   - 或者显示连接线
   - 或者改变颜色（绿色表示已链接）

5. 重复直到所有骨骼链接完成
```

#### 完整链接列表

```
FBX 骨骼          →    Spine 骨骼         操作
─────────────────────────────────────────────
root              →    root              点击 Link
hip               →    hip               点击 Link
spine             →    spine             点击 Link
chest             →    chest             点击 Link
neck              →    neck              点击 Link
head              →    head              点击 Link
shoulder_L        →    shoulder_L        点击 Link
upper_arm_L       →    upper_arm_L       点击 Link
forearm_L         →    forearm_L         点击 Link
hand_L            →    hand_L            点击 Link
shoulder_R        →    shoulder_R        点击 Link
upper_arm_R       →    upper_arm_R       点击 Link
forearm_R         →    forearm_R         点击 Link
hand_R            →    hand_R            点击 Link
thigh_L           →    thigh_L           点击 Link
calf_L            →    calf_L            点击 Link
foot_L            →    foot_L            点击 Link
thigh_R           →    thigh_R           点击 Link
calf_R            →    calf_R            点击 Link
foot_R            →    foot_R            点击 Link
```

**⚠️ 注意**
- 必须链接所有骨骼
- 未链接的骨骼不会有动画数据
- 检查是否有遗漏

---

### 3.5 配置导出设置

```
在导出前检查设置：

【Animation Name】
- 输入动画名称：walk
- 或使用默认名称

【Frame Range】（如果有此选项）
- Start Frame: 1
- End Frame: 30
- 或使用 FBX 中的完整范围

【Export Options】（如果有）
- ☑ Include Rotation
- ☑ Include Translation
- ☑ Include Scale（可选）
```

---

### 3.6 导出到 Spine

```
步骤：
1. 确认所有骨骼已链接（显示绿色或连接线）
2. 点击 "Export" 或 "Export to Spine" 按钮
3. 选择保存位置
4. 文件名：character_with_walk.json
5. 点击 "Save"
6. 等待导出完成
7. 看到成功提示
```

---

## 第四部分：Spine 导入动画

### 4.1 导入到 Spine

```
步骤：
1. 打开 Spine
2. 打开原角色项目（character.spine）
3. File → Import Data
4. 选择 FBX2Spine 导出的 JSON
   文件：character_with_walk.json
5. 点击 "Import"
```

### 4.2 导入设置

```
Import Data 对话框：

【Import Options】
☑ Animations（导入动画）
☑ Skins（如果有）
☑ Events（如果有）

【Merge Mode】
- New（创建新动画）
- Replace（替换同名动画）
- 推荐选择：New

点击 "Import" 确认
```

---

### 4.3 查看动画

```
步骤：
1. 在 Spine 左下角动画列表
2. 找到新导入的动画：walk
3. 点击选中
4. 按空格键播放
5. 检查动画效果
```

---

### 4.4 调整和优化

```
可能需要的调整：

1. 旋转偏移
   - 某些骨骼旋转方向可能不对
   - 在 Spine 中手动调整关键帧

2. 位置偏移
   - 检查根骨骼位置
   - 调整 Y 轴偏移

3. 动画速度
   - 在 Spine 中调整动画时长
   - 或调整播放速度

4. 缓动曲线
   - FBX2Spine 导入的是线性曲线
   - 在 Spine 中添加缓动
```

---

## 第五部分：完整测试案例

### 测试案例：简单行走动画

#### Blender 部分（30 分钟）

```
1. 创建人形骨架（10 分钟）
   - 使用上面的骨骼结构
   - 命名清晰

2. 制作行走动画（15 分钟）
   - 30 帧循环
   - 左右脚交替
   - 手臂摆动

3. 导出 FBX（5 分钟）
   - 检查导出设置
   - 保存为 walk.fbx
```

#### Spine 部分（20 分钟）

```
1. 创建简单角色（10 分钟）
   - 使用简单形状或图片
   - 创建对应骨骼
   - 绑定

2. 导出 JSON（5 分钟）
   - 保存为 character.json

3. 检查骨骼命名（5 分钟）
   - 确保与 Blender 一致
```

#### FBX2Spine 部分（10 分钟）

```
1. 导入文件（2 分钟）
   - 导入 walk.fbx
   - 导入 character.json

2. 链接骨骼（5 分钟）
   - 逐个链接
   - 检查完整性

3. 导出（3 分钟）
   - 导出新 JSON
   - 保存
```

#### Spine 验证（5 分钟）

```
1. 导入动画（2 分钟）
2. 播放查看（2 分钟）
3. 微调（1 分钟）
```

**总计：约 65 分钟**

---

## 常见问题

### 问题 1：骨骼链接后动画仍然不对

**原因**
- 骨骼坐标系不匹配
- 旋转轴不一致

**解决**
1. 在 Blender 导出时检查坐标系设置
2. 尝试不同的 Forward/Up 组合
3. 在 Spine 中手动调整偏移

---

### 问题 2：某些骨骼没有动画

**原因**
- 骨骼未链接
- FBX 中该骨骼没有关键帧

**解决**
1. 检查 FBX2Spine 中是否所有骨骼都已链接
2. 在 Blender 中确保所有骨骼都有关键帧
3. 重新导出 FBX，勾选 "Key All Bones"

---

### 问题 3：动画速度不对

**原因**
- 帧率不匹配
- 时间轴设置不同

**解决**
1. Blender 和 Spine 使用相同帧率（通常 30fps）
2. 在 Spine 中调整动画时长
3. 或在 FBX2Spine 导出时调整帧范围

---

### 问题 4：导入后角色变形

**原因**
- 骨骼层级不匹配
- 父子关系不同

**解决**
1. 确保 Blender 和 Spine 的骨骼层级完全一致
2. 检查父子关系
3. 在 Spine 中重新调整骨骼层级

---

### 问题 5：FBX2Spine 无法打开 FBX

**原因**
- FBX 版本不兼容
- 文件损坏

**解决**
1. Blender 导出时选择 FBX 7.4 Binary
2. 检查文件大小是否正常
3. 尝试重新导出

---

## 优化技巧

### 技巧 1：标准化命名

```
建立命名规范：
- 左侧：_L 或 .L
- 右侧：_R 或 .R
- 使用英文命名
- 避免特殊字符

示例：
✅ arm_L, arm_R
✅ leg.L, leg.R
❌ 左臂, 右臂
❌ arm-left, arm-right
```

---

### 技巧 2：使用骨骼模板

```
在 Blender 中：
1. 创建标准骨架
2. 保存为 .blend 文件
3. 每次新项目导入此模板

在 Spine 中：
1. 创建标准骨架
2. 保存为模板项目
3. 复用骨骼结构
```

---

### 技巧 3：批量处理

```
如果有多个动画：
1. Blender 中创建多个 Action
2. 分别导出为不同 FBX
3. 在 FBX2Spine 中逐个转换
4. Spine 中批量导入
```

---

### 技巧 4：使用 Mixamo

```
快速获取动画：
1. Blender 导出角色为 FBX
2. 上传到 Mixamo.com
3. 选择动画
4. 下载 FBX
5. 使用 FBX2Spine 转换
6. 导入 Spine

优势：
✅ 免费动画库
✅ 自动绑定
✅ 专业质量
```

---

## 下一步

安装完成后：

1. **启动 FBX2Spine**
   - 熟悉界面
   - 查看菜单选项

2. **准备测试文件**
   - 我可以帮你创建简单的 Blender 测试文件
   - 或使用你现有的 Spine 角色

3. **第一次测试**
   - 跟着教程走一遍完整流程
   - 记录遇到的问题

---

安装好了吗？要开始第一次测试吗？
