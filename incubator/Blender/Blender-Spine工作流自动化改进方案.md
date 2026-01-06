# Blender → Spine 工作流自动化改进方案

> 目标：让 Blender 到 Spine 的工作流更智能、更自动化

---

## 当前工作流的痛点

### 手动步骤太多

```
❌ 手动创建每个平面
❌ 手动加载每个图片
❌ 手动设置每个材质
❌ 手动创建骨骼
❌ 手动绑定每个部件
❌ 手动 K 帧动画
❌ 手动配置导出设置
```

---

## 改进方案：分阶段自动化

---

## 阶段 1：PSD 自动导入（可实现）

### 目标
一键从 PSD 创建所有平面 + 材质 + 纹理

### 实现方式

#### 方案 A：Blender Python 脚本

```python
# 伪代码示例
import bpy
import os

def auto_import_psd_layers(psd_folder):
    """
    自动导入 PSD 导出的 PNG 图层
    """
    # 1. 扫描文件夹中的所有 PNG
    png_files = [f for f in os.listdir(psd_folder) if f.endswith('.png')]
    
    # 2. 为每个 PNG 创建平面
    for png_file in png_files:
        # 创建平面
        bpy.ops.mesh.primitive_plane_add()
        plane = bpy.context.active_object
        plane.name = png_file.replace('.png', '')
        
        # UV 展开
        bpy.ops.object.mode_set(mode='EDIT')
        bpy.ops.uv.unwrap()
        bpy.ops.object.mode_set(mode='OBJECT')
        
        # 创建材质
        mat = bpy.data.materials.new(name=plane.name + "_mat")
        mat.use_nodes = True
        plane.data.materials.append(mat)
        
        # 加载图片纹理
        nodes = mat.node_tree.nodes
        bsdf = nodes.get("Principled BSDF")
        
        # 添加图片纹理节点
        tex_image = nodes.new('ShaderNodeTexImage')
        tex_image.image = bpy.data.images.load(os.path.join(psd_folder, png_file))
        
        # 连接节点
        mat.node_tree.links.new(bsdf.inputs['Base Color'], tex_image.outputs['Color'])
        mat.node_tree.links.new(bsdf.inputs['Alpha'], tex_image.outputs['Alpha'])
        
        # 设置透明度
        mat.blend_method = 'BLEND'
        
        # 根据图片尺寸调整平面大小
        img = tex_image.image
        ratio = img.size[0] / img.size[1]
        plane.scale = (ratio, 1, 1)
    
    print(f"成功导入 {len(png_files)} 个图层")

# 使用
auto_import_psd_layers("E:/character_parts/")
```

#### 方案 B：Blender Addon

```
功能：
- 菜单：File → Import → PSD Layers
- 自动扫描文件夹
- 批量创建平面 + 材质
- 智能命名
- 自动排列位置（根据命名规则）
```

---

## 阶段 2：智能骨骼生成（可实现）

### 目标
根据图层命名自动创建骨骼层级

### 实现方式

#### 命名规则识别

```
图层命名规则：
- head → 创建 head 骨骼，父级 spine
- body → 创建 spine 骨骼，父级 root
- arm_L → 创建 arm_L 骨骼，父级 spine
- arm_R → 创建 arm_R 骨骼，父级 spine
- leg_L → 创建 leg_L 骨骼，父级 root
- leg_R → 创建 leg_R 骨骼，父级 root
```

#### Python 脚本

```python
def auto_create_skeleton(mesh_objects):
    """
    根据网格对象自动创建骨架
    """
    # 骨骼层级规则
    bone_hierarchy = {
        'root': None,  # 根骨骼
        'spine': 'root',
        'head': 'spine',
        'arm_L': 'spine',
        'arm_R': 'spine',
        'leg_L': 'root',
        'leg_R': 'root',
    }
    
    # 创建骨架
    bpy.ops.object.armature_add()
    armature = bpy.context.active_object
    armature.name = "Character_Rig"
    
    bpy.ops.object.mode_set(mode='EDIT')
    edit_bones = armature.data.edit_bones
    
    # 删除默认骨骼
    edit_bones.remove(edit_bones[0])
    
    # 创建骨骼
    bones = {}
    for mesh_obj in mesh_objects:
        bone_name = mesh_obj.name
        
        if bone_name in bone_hierarchy:
            # 创建骨骼
            bone = edit_bones.new(bone_name)
            
            # 设置位置（根据网格位置）
            bone.head = mesh_obj.location
            bone.tail = mesh_obj.location + Vector((0, 0, 0.5))
            
            bones[bone_name] = bone
    
    # 设置父子关系
    for bone_name, parent_name in bone_hierarchy.items():
        if parent_name and bone_name in bones and parent_name in bones:
            bones[bone_name].parent = bones[parent_name]
    
    bpy.ops.object.mode_set(mode='OBJECT')
    return armature
```

---

## 阶段 3：自动绑定（可实现）

### 目标
自动将网格绑定到对应骨骼

### 实现方式

```python
def auto_bind_meshes(armature, mesh_objects):
    """
    自动绑定网格到骨架
    """
    for mesh_obj in mesh_objects:
        # 选择网格和骨架
        bpy.ops.object.select_all(action='DESELECT')
        mesh_obj.select_set(True)
        armature.select_set(True)
        bpy.context.view_layer.objects.active = armature
        
        # 自动权重绑定
        bpy.ops.object.parent_set(type='ARMATURE_AUTO')
        
    print(f"成功绑定 {len(mesh_objects)} 个网格")
```

---

## 阶段 4：AI 辅助动画（部分可实现）

### 4.1 动画模板库

```
预设动画库：
- idle（待机）
- walk（行走）
- run（奔跑）
- jump（跳跃）
- attack（攻击）

一键应用：
1. 选择骨架
2. 选择动画模板
3. 自动生成关键帧
```

#### 实现方式

```python
# 动画模板数据结构
animation_templates = {
    'idle': {
        'duration': 40,
        'keyframes': {
            1: {'spine': {'scale_z': 1.0}},
            20: {'spine': {'scale_z': 1.05}},
            40: {'spine': {'scale_z': 1.0}},
        }
    },
    'walk': {
        'duration': 30,
        'keyframes': {
            # ... 预定义的关键帧数据
        }
    }
}

def apply_animation_template(armature, template_name):
    """
    应用动画模板
    """
    template = animation_templates[template_name]
    
    # 创建动作
    action = bpy.data.actions.new(name=template_name)
    armature.animation_data_create()
    armature.animation_data.action = action
    
    # 应用关键帧
    for frame, bone_data in template['keyframes'].items():
        bpy.context.scene.frame_set(frame)
        
        for bone_name, transforms in bone_data.items():
            bone = armature.pose.bones[bone_name]
            
            if 'scale_z' in transforms:
                bone.scale.z = transforms['scale_z']
                bone.keyframe_insert(data_path="scale", frame=frame)
```

---

### 4.2 AI 动作生成（未来方向）

```
可能的技术：
- 使用 Mixamo 动作库（3D）
- 训练 2D 动作生成模型
- 使用 Motion Matching 技术
- 集成 OpenPose 骨骼检测

⚠️ 需要大量开发工作
```

---

## 阶段 5：批量导出自动化（可实现）

### 目标
一键导出多个角色/多个动画

### 实现方式

```python
def batch_export_to_spine(characters, output_folder):
    """
    批量导出到 Spine
    """
    for char_name, char_data in characters.items():
        # 选择角色对象
        select_character_objects(char_data['meshes'], char_data['armature'])
        
        # 配置导出设置
        export_settings = {
            'output_directory': output_folder,
            'project_name': char_name,
            'texture_size': 2048,
            'enable_baking': True,
            'export_armature': True,
            'include_animations': True,
        }
        
        # 执行导出
        bpy.ops.spine.export_mesh(export_settings)
        
        print(f"导出完成: {char_name}")
```

---

## 完整自动化工作流设计

### 工作流 A：完全自动化（理想状态）

```
1. 准备 PSD 分层文件
     ↓
2. 运行自动化脚本
     ↓ (自动)
   - 导出 PNG 图层
   - 导入到 Blender
   - 创建材质和纹理
   - 生成骨骼
   - 绑定网格
     ↓
3. 选择动画模板
     ↓ (自动)
   - 应用预设动画
   - 生成关键帧
     ↓
4. 一键导出 Spine
     ↓
5. 完成！
```

### 工作流 B：半自动化（现实可行）

```
1. Photoshop 手动导出 PNG
     ↓
2. Blender 运行导入脚本（自动）
   - 创建平面 + 材质
     ↓
3. 运行骨骼生成脚本（自动）
   - 创建骨骼层级
     ↓
4. 运行绑定脚本（自动）
   - 绑定网格到骨骼
     ↓
5. 手动制作动画（或应用模板）
     ↓
6. 一键导出 Spine（自动）
```

---

## 需要开发的工具

### 工具 1：PSD Layer Importer Addon

```
功能：
- 扫描文件夹中的 PNG
- 批量创建平面
- 自动设置材质和纹理
- 智能排列位置

技术：
- Blender Python API
- 图像处理库（PIL/Pillow）

开发时间：2-3 天
```

### 工具 2：Auto Rigger Addon

```
功能：
- 根据命名规则创建骨骼
- 自动设置骨骼层级
- 自动绑定网格

技术：
- Blender Python API
- 骨骼系统 API

开发时间：3-5 天
```

### 工具 3：Animation Template Library

```
功能：
- 预设动画库
- 一键应用动画
- 自定义模板

技术：
- Blender Python API
- JSON 数据存储

开发时间：2-3 天
```

### 工具 4：Batch Export Manager

```
功能：
- 批量导出多个角色
- 预设配置管理
- 导出队列

技术：
- Blender Python API
- 集成 Spine Export Addon

开发时间：1-2 天
```

---

## 开发优先级

### 第一阶段（立即可做）

```
✅ PSD Layer Importer
   - 最大痛点
   - 节省最多时间
   - 技术难度低

✅ Auto Rigger
   - 第二大痛点
   - 标准化骨骼结构
   - 技术难度中等
```

### 第二阶段（短期）

```
✅ Animation Template Library
   - 提高动画效率
   - 可复用性强
   - 技术难度低

✅ Batch Export Manager
   - 批量处理
   - 提高生产力
   - 技术难度低
```

### 第三阶段（长期）

```
🔮 AI 动作生成
   - 需要研究
   - 技术难度高
   - 效果不确定

🔮 表情动画自动化
   - 需要 Slot 系统
   - 技术难度高
```

---

## 技术可行性分析

| 功能 | 可行性 | 难度 | 价值 |
|------|--------|------|------|
| PSD 自动导入 | ✅ 100% | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| 智能骨骼生成 | ✅ 100% | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 自动绑定 | ✅ 100% | ⭐⭐ | ⭐⭐⭐⭐ |
| 动画模板库 | ✅ 100% | ⭐⭐ | ⭐⭐⭐⭐ |
| 批量导出 | ✅ 100% | ⭐ | ⭐⭐⭐ |
| AI 动作生成 | ⚠️ 50% | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

---

## 预期效果

### 时间节省

```
当前工作流：
- 导入图层：30 分钟
- 创建骨骼：20 分钟
- 绑定网格：15 分钟
- 制作动画：60 分钟
- 导出：5 分钟
总计：130 分钟

自动化后：
- 导入图层：2 分钟（自动）
- 创建骨骼：1 分钟（自动）
- 绑定网格：1 分钟（自动）
- 制作动画：30 分钟（模板辅助）
- 导出：1 分钟（自动）
总计：35 分钟

节省：73% 时间
```

---

## 下一步行动

### 立即可做

1. **编写 PSD Layer Importer 脚本**
   - 我可以帮你写 Python 脚本
   - 测试导入功能
   - 优化和调试

2. **编写 Auto Rigger 脚本**
   - 定义命名规则
   - 实现骨骼生成逻辑
   - 测试绑定功能

3. **创建动画模板库**
   - 收集常用动画
   - 转换为模板数据
   - 编写应用脚本

---

## 我的建议

### 分步实施

```
第 1 周：
- 开发 PSD Layer Importer
- 测试基础功能

第 2 周：
- 开发 Auto Rigger
- 集成到工作流

第 3 周：
- 创建动画模板库
- 完善批量导出

第 4 周：
- 整合所有工具
- 编写使用文档
- 培训和优化
```

---

## 要开始吗？

我可以立即帮你：

**A. 编写 PSD Layer Importer 脚本**
- 完整的 Python 代码
- 使用说明
- 测试案例

**B. 编写 Auto Rigger 脚本**
- 智能骨骼生成
- 自动绑定
- 命名规则配置

**C. 两个都做**
- 完整的自动化工具包
- 集成测试

选哪个？
