"""
智能体测试
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

import unittest
from unittest.mock import Mock, patch
from core.llm_client import OllamaClient
from core.memory import MemorySystem
from agents.blender_agent import BlenderAgent


class TestOllamaClient(unittest.TestCase):
    """测试 Ollama 客户端"""
    
    def setUp(self):
        self.client = OllamaClient(host="http://localhost:11434", model="qwen2.5:32b")
        
    def test_initialization(self):
        """测试初始化"""
        self.assertEqual(self.client.host, "http://localhost:11434")
        self.assertEqual(self.client.model, "qwen2.5:32b")
        self.assertEqual(len(self.client.conversation_history), 0)
        
    def test_clear_history(self):
        """测试清空历史"""
        self.client.conversation_history = [{"role": "user", "content": "test"}]
        self.client.clear_history()
        self.assertEqual(len(self.client.conversation_history), 0)


class TestMemorySystem(unittest.TestCase):
    """测试记忆系统"""
    
    def setUp(self):
        self.memory = MemorySystem(
            persist_directory="./test_memory",
            collection_name="test_collection"
        )
        
    def tearDown(self):
        """清理测试数据"""
        self.memory.clear_all()
        
    def test_add_memory(self):
        """测试添加记忆"""
        memory_id = self.memory.add_memory(
            content="测试记忆内容",
            category="test"
        )
        self.assertIsNotNone(memory_id)
        self.assertIsInstance(memory_id, str)
        
    def test_search_memory(self):
        """测试搜索记忆"""
        # 添加测试记忆
        self.memory.add_memory("Blender 创建立方体", category="command")
        self.memory.add_memory("Maya 创建球体", category="command")
        
        # 搜索
        results = self.memory.search_memory("立方体", n_results=1)
        self.assertGreater(len(results), 0)
        self.assertIn("立方体", results[0]["content"])
        
    def test_get_stats(self):
        """测试统计信息"""
        stats = self.memory.get_stats()
        self.assertIn("total_memories", stats)
        self.assertIn("collection_name", stats)


class TestBlenderAgent(unittest.TestCase):
    """测试 Blender 智能体"""
    
    def setUp(self):
        self.llm = Mock(spec=OllamaClient)
        self.agent = BlenderAgent(self.llm)
        
    def test_initialization(self):
        """测试初始化"""
        self.assertEqual(self.agent.name, "BlenderAgent")
        self.assertIsNotNone(self.agent.system_prompt)
        self.assertGreater(len(self.agent.tools), 0)
        
    def test_tools_registered(self):
        """测试工具注册"""
        expected_tools = [
            "create_cube",
            "create_sphere",
            "add_modifier",
            "set_material",
            "render_scene"
        ]
        
        for tool in expected_tools:
            self.assertIn(tool, self.agent.tools)


if __name__ == "__main__":
    unittest.main()
