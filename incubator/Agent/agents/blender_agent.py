"""
Blender 智能体
控制 Blender 进行建模、动画、渲染等操作
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from core.agent_base import AgentBase
from core.llm_client import OllamaClient
from tools import blender_tools
import logging

logger = logging.getLogger(__name__)


class BlenderAgent(AgentBase):
    """Blender 智能体"""
    
    def __init__(self, llm_client: OllamaClient):
        super().__init__(name="BlenderAgent", llm_client=llm_client)
        
    def _default_system_prompt(self) -> str:
        return """你是一个 Blender 3D 建模助手。你可以帮助用户：
- 创建基础几何体（立方体、球体、圆柱等）
- 添加修改器（细分、阵列、镜像等）
- 设置材质和颜色
- 渲染场景
- 管理对象（删除、重命名、列表）

你需要将用户的自然语言命令转换为具体的工具调用。
保持专业、准确，如果命令不清楚，请要求用户提供更多信息。"""
        
    def _register_tools(self):
        """注册 Blender 工具"""
        self.register_tool("create_cube", blender_tools.create_cube)
        self.register_tool("create_sphere", blender_tools.create_sphere)
        self.register_tool("add_modifier", blender_tools.add_modifier)
        self.register_tool("set_material", blender_tools.set_material)
        self.register_tool("render_scene", blender_tools.render_scene)
        self.register_tool("delete_object", blender_tools.delete_object)
        self.register_tool("list_objects", blender_tools.list_objects)
        self.register_tool("save_file", blender_tools.save_file)
        self.register_tool("execute_script", blender_tools.execute_python_script)
        
    def create_basic_scene(self) -> dict:
        """创建基础场景（示例工作流）"""
        results = []
        
        # 创建立方体
        result = self.execute("创建一个立方体")
        results.append(result)
        
        # 添加细分修改器
        result = self.execute("给立方体添加细分修改器")
        results.append(result)
        
        # 设置材质
        result = self.execute("给立方体设置红色材质")
        results.append(result)
        
        return {
            "success": all(r.get("success") for r in results),
            "steps": results
        }


# 示例使用
if __name__ == "__main__":
    # 初始化 LLM 客户端
    llm = OllamaClient(host="http://localhost:11434", model="qwen2.5:32b")
    
    # 创建 Blender 智能体
    agent = BlenderAgent(llm)
    
    # 测试命令
    commands = [
        "创建一个立方体",
        "给立方体添加细分修改器",
        "设置红色材质",
        "列出所有对象"
    ]
    
    for cmd in commands:
        print(f"\n执行命令: {cmd}")
        result = agent.execute(cmd)
        print(f"结果: {result}")
