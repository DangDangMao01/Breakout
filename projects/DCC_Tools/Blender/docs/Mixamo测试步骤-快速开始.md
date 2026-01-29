# Mixamo 测试步骤 - 快速开始

> 目标：30 分钟完成 Mixamo → Blender → FBX2Spine → Spine 完整流程

---

## 准备工作

### 你需要：
- ✅ Blender 5.01（已安装）
- ✅ FBX2Spine（已购买安装）
- ✅ Spine 4（已有）
- ✅ Adobe 账号（免费注册）
- ✅ 网络连接

---

## 第一步：注册 Mixamo（5 分钟）

### 1.1 访问网站

```
打开浏览器，访问：
https://www.mixamo.com
```

### 1.2 注册账号

```
1. 点击右上角 "Sign In"
2. 选择 "Create an account"
3. 填写信息：
   - Email（邮箱）
   - Password（密码）
   - First Name（名字）
   - Last Name（姓氏）
4. 勾选同意条款
5. 点击 "Sign Up"
6. 检查邮箱验证邮件
7. 点击验证链接
8. 登录 Mixamo
```

**⚠️ 如果已有 Adobe 账号**
- 直接登录即可
- 无需重新注册

---

## 第二步：使用 Mixamo 预设角色（最快）

### 2.1 选择预设角色

```
1. 登录后，在 Mixamo 首页
2. 左侧会显示默认角色（Y Bot）
3. 或点击 "Characters" 标签
4. 选择任意预设角色
5. 点击角色缩略图
```

**推荐角色**
- Y Bot（默认，最常用）
- X Bot
- Mannequin

### 2.2 选择动画

```
1. 点击顶部 "Animations" 标签
2. 浏览动画库
3. 或搜索框输入：
   - "walk"（行走）
   - "run"（奔跑）
   - "idle"（待机）
   - "jump"（跳跃）

4. 点击动画缩略图预览
5. 角色会自动播放动画
```

### 2.3 调整动画参数（可选）

```
右侧参数面板：

【Character Arm-Space】
- 调整手臂空间
- 范围：0-100
- 默认：50

【Overdrive】
- 动作夸张程度
- 范围：0-100
- 默认：0（原始动作）

【Trim】
- 裁剪动画时长
- 拖动滑块调整起止帧

调整后实时预览
```

### 2.4 下载动画

```
1. 点击右上角橙色 "Download" 按钮

下载设置：
2. Format: FBX for Unity
3. Skin: With Skin
4. Frames per second: 30
5. Keyframe Reduction: none
6. 点击 "Download"

7. 等待下载完成
8. 文件名类似：Y Bot.fbx
```

---

## 第三步：Blender 导入（5 分钟）

### 3.1 导入 FBX

```
1. 打开 Blender 5.01
2. 删除默认场景（可选）
   - X 键删除立方体
   - X 键删除灯光
   - X 键删除相机

3. File → Import → FBX (.fbx)
4. 浏览到下载的 Mixamo FBX
5. 选择文件（如 Y Bot.fbx）

导入设置（保持默认即可）：
- ☑ Automatic Bone Orientation
- ☑ Import Animation
- Scale: 1.0

6. 点击 "Import FBX"
7. 等待导入完成
```

### 3.2 检查导入结果

```
1. 在 3D 视图中应该看到角色模型
2. 在 Outliner（右上角）看到：
   - Armature（骨架）
   - Mesh（网格）

3. 选中 Armature
4. 切换到 Animation 工作区（顶部标签）
5. 空格键播放动画
6. 确认动画正常播放
```

---

## 第四步：调整为 2D 风格（10 分钟）

### 4.1 切换到正交视图

```
1. 按小键盘 1（前视图）
2. 按小键盘 5（切换正交/透视）
3. 确保是正交视图
```

### 4.2 清理 Z 轴运动（重要！）

**方法 A：简单方法（推荐）**

```
1. 选中 Armature
2. 在属性面板 → Object Properties
3. Transform → Location
4. 将 Z 值设为 0
5. 锁定 Z 轴（点击锁图标）
```

**方法 B：精确方法（Graph Editor）**

```
1. 选中 Armature
2. 切换到 Animation 工作区
3. 在 Graph Editor（图表编辑器）
4. 在左侧通道列表：
   - 找到所有骨骼的 "Z Location" 通道
   - 选中这些通道
5. 按 X 键 → Delete Keyframes
6. 或者全部设为 0

这样可以移除深度运动，保持 2D 效果
```

### 4.3 调整视角

```
1. 确保角色正面朝向摄像机
2. 如果需要旋转：
   - 选中 Armature
   - R 键 → Z 键 → 输入角度（如 90）
   - Enter 确认
```

---

## 第五步：导出 FBX（3 分钟）

### 5.1 选择导出对象

```
1. 在 Outliner 中
2. 选中 Armature（骨架）
3. Shift + 选中 Mesh（网格）
4. 或者 A 全选
```

### 5.2 导出设置

```
1. File → Export → FBX (.fbx)
2. 选择保存位置
3. 文件名：walk_2d.fbx

导出设置（重要！）：
【Include】
☑ Selected Objects

【Transform】
- Forward: -Z Forward
- Up: Y Up
- Scale: 1.0
☑ Apply Transform

【Armature】
☑ Add Leaf Bones

【Animation】
☑ Baked Animation
☑ Key All Bones
☑ NLA Strips
☑ All Actions
- Sampling Rate: 1.0
- Simplify: 0.0

4. 点击 "Export FBX"
```

---

## 第六步：准备 Spine 角色（5 分钟）

### 6.1 创建简单 Spine 角色

**如果你已有 Spine 角色**
- 跳过此步骤
- 直接使用现有角色

**如果需要新建**

```
1. 打开 Spine
2. 创建新项目
3. 导入简单图片：
   - 头部
   - 身体
   - 左臂、右臂
   - 左腿、右腿

4. 创建骨骼（与 Mixamo 对应）：
   - root
   - hip
   - spine
   - chest
   - neck
   - head
   - shoulder_L → upper_arm_L → forearm_L → hand_L
   - shoulder_R → upper_arm_R → forearm_R → hand_R
   - thigh_L → calf_L → foot_L
   - thigh_R → calf_R → foot_R

5. 绑定图片到骨骼
6. 保存项目：test_character.spine
```

### 6.2 导出 Spine JSON

```
1. Spine → Export → JSON
2. 设置：
   - Format: JSON
   - ☑ Nonessential data
3. 保存为：test_character.json
```

---

## 第七步：FBX2Spine 转换（5 分钟）

### 7.1 启动 FBX2Spine

```
1. 从 Steam 库启动 FBX2SPINE
2. 等待程序打开
```

### 7.2 导入文件

```
1. 点击左上角 "Import FBX"
2. 选择：walk_2d.fbx
3. 等待加载

4. 点击右上角 "Import Spine"
5. 选择：test_character.json
6. 等待加载
```

### 7.3 链接骨骼

```
逐个链接骨骼：

FBX 骨骼 → Spine 骨骼
─────────────────────
1. 左侧点击 "mixamorig:Hips" → 右侧点击 "hip" → 点击 Link
2. 左侧点击 "mixamorig:Spine" → 右侧点击 "spine" → 点击 Link
3. 左侧点击 "mixamorig:Spine1" → 右侧点击 "chest" → 点击 Link
4. 左侧点击 "mixamorig:Neck" → 右侧点击 "neck" → 点击 Link
5. 左侧点击 "mixamorig:Head" → 右侧点击 "head" → 点击 Link

左臂：
6. mixamorig:LeftShoulder → shoulder_L
7. mixamorig:LeftArm → upper_arm_L
8. mixamorig:LeftForeArm → forearm_L
9. mixamorig:LeftHand → hand_L

右臂：
10. mixamorig:RightShoulder → shoulder_R
11. mixamorig:RightArm → upper_arm_R
12. mixamorig:RightForeArm → forearm_R
13. mixamorig:RightHand → hand_R

左腿：
14. mixamorig:LeftUpLeg → thigh_L
15. mixamorig:LeftLeg → calf_L
16. mixamorig:LeftFoot → foot_L

右腿：
17. mixamorig:RightUpLeg → thigh_R
18. mixamorig:RightLeg → calf_R
19. mixamorig:RightFoot → foot_R

⚠️ Mixamo 骨骼名称前缀是 "mixamorig:"
```

### 7.4 导出

```
1. 确认所有骨骼已链接
2. 点击 "Export" 按钮
3. 选择保存位置
4. 文件名：test_character_walk.json
5. 点击 "Save"
6. 等待导出完成
```

---

## 第八步：Spine 导入验证（2 分钟）

### 8.1 导入动画

```
1. 打开 Spine
2. 打开原角色项目
3. File → Import Data
4. 选择：test_character_walk.json
5. 导入设置：
   - ☑ Animations
   - Merge Mode: New
6. 点击 "Import"
```

### 8.2 播放测试

```
1. 在动画列表找到新动画
2. 点击选中
3. 空格键播放
4. 检查效果
```

---

## 快速测试清单

```
☐ 注册 Mixamo 账号
☐ 选择预设角色（Y Bot）
☐ 选择动画（walk）
☐ 下载 FBX
☐ Blender 导入
☐ 检查动画播放
☐ 清理 Z 轴运动
☐ 导出 FBX
☐ 准备 Spine 角色
☐ 导出 Spine JSON
☐ FBX2Spine 导入文件
☐ 链接骨骼
☐ 导出到 Spine
☐ Spine 导入验证
☐ 播放测试
```

---

## 常见问题

### 问题 1：Mixamo 下载很慢

**解决**
- 使用代理或 VPN
- 或者等待非高峰时段
- 文件通常只有几 MB

---

### 问题 2：Blender 导入后看不到模型

**解决**
1. 按小键盘 .（句号）聚焦到对象
2. 或者滚轮缩小视图
3. 检查 Outliner 是否有对象

---

### 问题 3：动画播放不流畅

**解决**
1. 检查时间轴范围
2. 确保帧率设置为 30fps
3. 在 Blender 中重新烘焙动画

---

### 问题 4：FBX2Spine 骨骼名称不匹配

**解决**
1. Mixamo 骨骼前缀是 "mixamorig:"
2. 需要手动链接到 Spine 骨骼
3. 按照上面的对应表逐个链接

---

### 问题 5：Spine 导入后动画变形

**解决**
1. 检查骨骼层级是否一致
2. 在 Blender 中应用所有变换
3. 确保 Z 轴运动已清理

---

## 优化技巧

### 技巧 1：批量下载动画

```
1. 在 Mixamo 选择多个动画
2. 分别下载
3. 在 Blender 中逐个导入
4. 使用 NLA Editor 管理多个动画
5. 批量导出
```

---

### 技巧 2：保存 Mixamo 角色

```
1. 第一次上传自定义角色后
2. Mixamo 会保存你的角色
3. 下次直接选择使用
4. 无需重新上传
```

---

### 技巧 3：动画混合

```
在 Blender 中：
1. 导入多个 Mixamo 动画
2. 使用 NLA Editor 混合
3. 创建过渡动画
4. 导出完整序列
```

---

## 下一步

完成测试后：

### 如果成功
```
1. 尝试更多 Mixamo 动画
2. 测试不同角色
3. 优化工作流
4. 建立动画库
```

### 如果遇到问题
```
1. 记录具体错误
2. 检查每个步骤
3. 告诉我问题
4. 我帮你排查
```

---

## 预期结果

完成后你应该有：
- ✅ 一个 Spine 角色
- ✅ 带有 Mixamo 行走动画
- ✅ 可以在 Spine 中播放
- ✅ 可以导出到游戏

---

## 时间估算

```
第一次：30-45 分钟
熟练后：10-15 分钟/动画
```

---

准备好了吗？开始测试！遇到问题随时告诉我。
