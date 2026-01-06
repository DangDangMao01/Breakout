# Mixamo + Blender + Spine Addon 完整测试流程

> 完全免费的工作流，从动画获取到 Spine 导入

---

## 准备工作检查

### 你需要：
- ✅ Blender 5.01（已安装）
- ✅ Blender to Spine Addon（已安装）
- ✅ Spine 4（已有）
- ⏳ Adobe 账号（免费注册）
- ⏳ Mixamo 账号（使用 Adobe 账号登录）

---

## 第一步：Mixamo 获取动画（15 分钟）

### 1.1 注册/登录 Mixamo

```
1. 访问：https://www.mixamo.com
2. 点击右上角 "Sign In"
3. 使用 Adobe 账号登录
   - 如果没有，点击 "Get an Adobe ID"
   - 免费注册
4. 登录成功后进入 Mixamo 主页
```

---

### 1.2 选择角色

```
方法 A：使用默认角色（推荐，最简单）

1. Mixamo 主页左侧有默认角色列表
2. 点击任意角色（推荐 "Y Bot"）
3. 角色会显示在中间预览区

方法 B：上传自己的角色（可选）

1. 点击 "Upload Character"
2. 选择 Blender 导出的 FBX 文件
3. 等待自动绑定
4. 调整标记点
5. 完成绑定
```

---

### 1.3 选择动画

```
1. 在左侧搜索框输入 "walk"
2. 浏览动画列表
3. 点击一个动画预览
4. 角色会播放该动画

推荐测试动画：
- Walking（行走）
- Running（奔跑）
- Idle（待机）
- Jump（跳跃）

先选择 "Walking" 测试
```

---

### 1.4 调整动画参数（可选）

```
右侧参数面板：

【Overdrive】
- 控制动作夸张程度
- 默认：100%
- 建议：保持默认

【Arm Space】
- 手臂空间
- 默认：0
- 建议：保持默认

【Character Arm-Space】
- 角色手臂空间
- 建议：保持默认

预览满意后继续
```

---

### 1.5 下载 FBX

```
1. 点击右上角橙色 "Download" 按钮

2. 下载设置：
   【Format】
   - 选择：FBX for Unity

   【Skin】
   - 选择：With Skin

   【Frames per second】
   - 选择：30

   【Keyframe Reduction】
   - 选择：none（不简化关键帧）

3. 点击 "Download"

4. 保存到：
   C:\FBX2Spine_Test\FBX\walk.fbx
   （或你喜欢的位置）

5. 等待下载完成
```

---

## 第二步：Blender 导入和调整（20 分钟）

### 2.1 导入 FBX

```
1. 打开 Blender 5.01
2. 删除默认场景（可选）：
   - 选中立方体、灯光、相机
   - X 键 → Delete

3. 导入 FBX：
   File → Import → FBX (.fbx)

4. 浏览到下载的文件：
   C:\FBX2Spine_Test\FBX\walk.fbx

5. 导入设置（保持默认即可）：
   - ☑ Automatic Bone Orientation
   - ☑ Import Animation

6. 点击 "Import FBX"

7. 等待导入完成
```

---

### 2.2 检查导入结果

```
1. 在 3D 视图中应该看到角色模型

2. 检查骨架：
   - 在 Outliner（右上角）找到 Armature
   - 点击展开，查看骨骼列表

3. 检查动画：
   - 切换到 Animation 工作区（顶部标签）
   - 在时间轴按空格键播放
   - 角色应该播放行走动画

4. 如果看不到角色：
   - 按小键盘 7（顶视图）
   - 滚轮缩放
   - 找到角色位置
```

---

### 2.3 调整为 2D 风格（重要！）

```
⚠️ 关键步骤：Mixamo 动画是 3D 的，需要调整为 2D

方法 A：简单方法（推荐）

1. 切换到正交前视图：
   - 按小键盘 1（前视图）
   - 按小键盘 5（正交/透视切换）

2. 选中骨架（Armature）

3. 在属性面板 → Object Properties
   - Location Z: 0
   - Rotation X: 0
   - Rotation Z: 0

4. 这样角色就是正面朝向了

方法 B：高级方法（可选）

1. 选中骨架
2. 切换到 Graph Editor
3. 删除或减少 Z 轴的运动：
   - 选择 Location Z 曲线
   - 删除或设为 0
4. 保留 X 和 Y 的运动
```

---

### 2.4 保存 Blender 文件

```
⚠️ 重要：必须先保存 .blend 文件！

1. File → Save As
2. 保存位置：
   C:\FBX2Spine_Test\walk_test.blend
3. 点击 "Save As"
```

---

## 第三步：使用 Blender to Spine Addon 导出（10 分钟）

### 3.1 打开导出面板

```
1. 确保在 Layout 工作区
2. 按 N 键打开侧边栏
3. 找到 "Blender_to_Spine_2D_Mesh_Exporter" 标签
4. 点击展开

如果没有看到：
- 检查插件是否启用
- Edit → Preferences → Add-ons
- 搜索 "Spine"
- 确保勾选启用
```

---

### 3.2 配置导出设置

```
在导出面板中设置：

【Output Settings】
- Output Directory: 
  点击文件夹图标，选择：
  C:\FBX2Spine_Test\Output\

- Project Name: 
  输入：walk_test

【Mesh Segmentation】（网格分割）
- Segmentation Mode: Auto
- Angle Threshold: 30
- Min Segment Size: 0.01

【Texture Baking】（纹理烘焙）
☑ Enable Texture Baking
- Texture Size: 1024
  （如果角色复杂，可以选 2048）
- Bake Mode: DIFFUSE
- Margin: 2

【Armature Export】（骨架导出）
☑ Export Armature
☑ Include Animations
- Animation Name: walk
  （或留空使用默认名称）
```

---

### 3.3 选择导出对象

```
1. 在 3D 视图中：
   - 点击选中角色网格（Mesh）
   - Shift + 点击选中骨架（Armature）
   - 两者都应该高亮显示

或者：
   - 按 A 键全选所有对象
```

---

### 3.4 执行导出

```
1. 确认所有设置正确
2. 确认对象已选中
3. 点击面板底部的 "Export to Spine2D" 按钮
4. 等待处理（可能需要几秒到几分钟）
5. 查看 Blender 控制台输出（如果有错误会显示）
6. 完成后会有提示

导出的文件：
C:\FBX2Spine_Test\Output\
  ├── walk_test.json（Spine 骨骼和动画数据）
  ├── walk_test.atlas（图集配置）
  └── walk_test.png（纹理图集）
```

---

## 第四步：Spine 导入验证（5 分钟）

### 4.1 导入到 Spine

```
1. 打开 Spine

2. 创建新项目或打开现有项目

3. File → Import Data

4. 浏览到导出的 JSON 文件：
   C:\FBX2Spine_Test\Output\walk_test.json

5. 导入设置：
   【Import Options】
   ☑ Animations
   ☑ Skins
   ☑ Events

   【Merge Mode】
   - 选择：New（创建新内容）

6. 点击 "Import"

7. 等待导入完成
```

---

### 4.2 查看结果

```
1. 检查骨骼：
   - 在 Spine 左侧树形视图
   - 应该看到完整的骨骼层级

2. 检查网格：
   - 在视图中应该看到角色
   - 检查纹理是否正确显示

3. 检查动画：
   - 在左下角动画列表
   - 找到 "walk" 动画
   - 点击选中

4. 播放动画：
   - 按空格键播放
   - 观察动画是否流畅
   - 检查是否有异常
```

---

### 4.3 可能需要的调整

```
如果动画不理想：

1. 旋转问题：
   - 选中根骨骼
   - 调整旋转角度

2. 位置偏移：
   - 调整根骨骼位置

3. 缩放问题：
   - 调整根骨骼缩放

4. 动画速度：
   - 在 Spine 中调整动画时长
   - 或调整播放速度
```

---

## 常见问题排查

### 问题 1：Blender 导入 FBX 后看不到角色

**解决**：
```
1. 按小键盘 7（顶视图）
2. 按小键盘 .（聚焦到选中对象）
3. 滚轮缩放
4. 或者按 Home 键（查看全部）
```

---

### 问题 2：导出面板找不到

**解决**：
```
1. Edit → Preferences → Add-ons
2. 搜索 "Spine"
3. 确保 "Blender_to_Spine_2D_Mesh_Exporter" 已勾选
4. 如果没有，重新安装插件
```

---

### 问题 3：导出时报错

**解决**：
```
1. 确保已保存 .blend 文件
2. 确保选中了网格和骨架
3. 检查输出路径是否存在
4. 查看 Blender 控制台的详细错误信息
```

---

### 问题 4：Spine 导入后没有动画

**解决**：
```
1. 检查导出设置中是否勾选 "Include Animations"
2. 确保 Blender 中有动画数据
3. 重新导出，确认动画名称
```

---

### 问题 5：纹理丢失或错误

**解决**：
```
1. 确保勾选 "Enable Texture Baking"
2. 增加 Texture Size（如 2048）
3. 检查材质是否使用 Principled BSDF
4. 确保图片纹理已加载
```

---

## 成功标准

完成测试后，你应该：

✅ 从 Mixamo 下载了动画 FBX
✅ Blender 成功导入并播放动画
✅ 使用 Addon 导出了 Spine 文件
✅ Spine 成功导入并播放动画
✅ 动画质量可接受

---

## 下一步

### 如果测试成功

1. **尝试更多动画**
   - 从 Mixamo 下载其他动画
   - 重复流程
   - 建立动画库

2. **优化工作流**
   - 创建 Blender 模板文件
   - 保存导出预设
   - 标准化命名规则

3. **开发自动化脚本**
   - 批量处理
   - 自动化导入导出

---

### 如果遇到问题

1. **检查每一步**
   - 按照文档逐步操作
   - 不要跳过步骤

2. **查看错误信息**
   - Blender 控制台
   - Spine 导入日志

3. **寻求帮助**
   - 截图错误信息
   - 描述具体步骤
   - 我随时帮你排查

---

## 时间估算

- Mixamo 下载：5-10 分钟
- Blender 导入调整：10-15 分钟
- Addon 导出：5-10 分钟
- Spine 导入验证：5 分钟

**总计：25-40 分钟**（首次）

熟练后：10-15 分钟/动画

---

## 准备好了吗？

现在开始：

1. **打开浏览器**
   - 访问 https://www.mixamo.com
   - 登录 Adobe 账号

2. **选择角色和动画**
   - 使用默认角色 "Y Bot"
   - 选择 "Walking" 动画

3. **下载 FBX**
   - 按照上面的设置下载

4. **告诉我进度**
   - 遇到问题随时问我
   - 我会帮你排查

开始吧！🚀
