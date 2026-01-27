"""
Blender 工具集
封装 Blender Python API 常用操作
"""

import logging
from typing import List, Dict, Tuple, Optional

logger = logging.getLogger(__name__)

# 注意：这些函数需要在 Blender 内部运行
# 在外部调用时，需要通过 RPC 或命令行方式与 Blender 通信


def create_cube(name: str = "Cube", location: Tuple[float, float, float] = (0, 0, 0)) -> Dict:
    """创建立方体"""
    try:
        import bpy
        bpy.ops.mesh.primitive_cube_add(location=location)
        obj = bpy.context.active_object
        obj.name = name
        return {"success": True, "object": name, "location": location}
    except Exception as e:
        return {"success": False, "error": str(e)}


def create_sphere(name: str = "Sphere", location: Tuple[float, float, float] = (0, 0, 0), 
                  radius: float = 1.0) -> Dict:
    """创建球体"""
    try:
        import bpy
        bpy.ops.mesh.primitive_uv_sphere_add(radius=radius, location=location)
        obj = bpy.context.active_object
        obj.name = name
        return {"success": True, "object": name, "location": location, "radius": radius}
    except Exception as e:
        return {"success": False, "error": str(e)}


def add_modifier(object_name: str, modifier_type: str, **kwargs) -> Dict:
    """
    添加修改器
    
    Args:
        object_name: 对象名称
        modifier_type: 修改器类型 (SUBSURF, ARRAY, MIRROR, etc.)
        **kwargs: 修改器参数
    """
    try:
        import bpy
        obj = bpy.data.objects.get(object_name)
        if not obj:
            return {"success": False, "error": f"对象不存在: {object_name}"}
            
        modifier = obj.modifiers.new(name=modifier_type, type=modifier_type)
        
        # 设置参数
        for key, value in kwargs.items():
            if hasattr(modifier, key):
                setattr(modifier, key, value)
                
        return {"success": True, "object": object_name, "modifier": modifier_type}
    except Exception as e:
        return {"success": False, "error": str(e)}


def set_material(object_name: str, color: Tuple[float, float, float, float] = (1, 0, 0, 1)) -> Dict:
    """设置材质颜色"""
    try:
        import bpy
        obj = bpy.data.objects.get(object_name)
        if not obj:
            return {"success": False, "error": f"对象不存在: {object_name}"}
            
        # 创建材质
        mat = bpy.data.materials.new(name=f"{object_name}_Material")
        mat.use_nodes = True
        nodes = mat.node_tree.nodes
        bsdf = nodes.get("Principled BSDF")
        if bsdf:
            bsdf.inputs["Base Color"].default_value = color
            
        # 分配材质
        if obj.data.materials:
            obj.data.materials[0] = mat
        else:
            obj.data.materials.append(mat)
            
        return {"success": True, "object": object_name, "color": color}
    except Exception as e:
        return {"success": False, "error": str(e)}


def render_scene(output_path: str, resolution: Tuple[int, int] = (1920, 1080)) -> Dict:
    """渲染场景"""
    try:
        import bpy
        scene = bpy.context.scene
        scene.render.resolution_x = resolution[0]
        scene.render.resolution_y = resolution[1]
        scene.render.filepath = output_path
        bpy.ops.render.render(write_still=True)
        return {"success": True, "output": output_path, "resolution": resolution}
    except Exception as e:
        return {"success": False, "error": str(e)}


def delete_object(object_name: str) -> Dict:
    """删除对象"""
    try:
        import bpy
        obj = bpy.data.objects.get(object_name)
        if not obj:
            return {"success": False, "error": f"对象不存在: {object_name}"}
        bpy.data.objects.remove(obj, do_unlink=True)
        return {"success": True, "object": object_name}
    except Exception as e:
        return {"success": False, "error": str(e)}


def list_objects() -> Dict:
    """列出所有对象"""
    try:
        import bpy
        objects = [obj.name for obj in bpy.data.objects]
        return {"success": True, "objects": objects, "count": len(objects)}
    except Exception as e:
        return {"success": False, "error": str(e)}


def save_file(filepath: str) -> Dict:
    """保存文件"""
    try:
        import bpy
        bpy.ops.wm.save_as_mainfile(filepath=filepath)
        return {"success": True, "filepath": filepath}
    except Exception as e:
        return {"success": False, "error": str(e)}


def execute_python_script(script: str) -> Dict:
    """执行 Python 脚本"""
    try:
        import bpy
        exec(script)
        return {"success": True, "message": "脚本执行成功"}
    except Exception as e:
        return {"success": False, "error": str(e)}


# RPC 通信相关函数

def send_command_to_blender(command: str, params: Dict) -> Dict:
    """
    通过 RPC 向 Blender 发送命令
    这是外部调用 Blender 的接口
    """
    # TODO: 实现 RPC 客户端
    # 可以使用 XML-RPC, JSON-RPC, 或 Socket 通信
    pass
