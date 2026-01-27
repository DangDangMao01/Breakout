"""
智能体基类
所有 DCC 软件智能体的基础类
"""

from abc import ABC, abstractmethod
from typing import Dict, List, Optional, Any
import logging
from .llm_client import OllamaClient

logger = logging.getLogger(__name__)


class AgentBase(ABC):
    """智能体基类"""
    
    def __init__(self, 
                 name: str,
                 llm_client: OllamaClient,
                 system_prompt: Optional[str] = None):
        self.name = name
        self.llm = llm_client
        self.system_prompt = system_prompt or self._default_system_prompt()
        self.tools: Dict[str, callable] = {}
        self._register_tools()
        
    @abstractmethod
    def _default_system_prompt(self) -> str:
        """返回默认系统提示词"""
        pass
        
    @abstractmethod
    def _register_tools(self):
        """注册可用工具"""
        pass
        
    def execute(self, command: str, **kwargs) -> Dict[str, Any]:
        """
        执行用户命令
        
        Args:
            command: 用户输入的自然语言命令
            **kwargs: 额外参数
            
        Returns:
            执行结果字典
        """
        try:
            # 1. 理解用户意图
            intent = self._parse_intent(command)
            
            # 2. 选择工具
            tool_name = intent.get("tool")
            if not tool_name or tool_name not in self.tools:
                return {
                    "success": False,
                    "error": f"无法识别命令或工具不存在: {command}"
                }
                
            # 3. 执行工具
            tool_func = self.tools[tool_name]
            result = tool_func(**intent.get("params", {}))
            
            # 4. 返回结果
            return {
                "success": True,
                "tool": tool_name,
                "result": result
            }
            
        except Exception as e:
            logger.error(f"执行命令失败: {e}")
            return {
                "success": False,
                "error": str(e)
            }
            
    def _parse_intent(self, command: str) -> Dict[str, Any]:
        """
        解析用户意图
        使用 LLM 将自然语言转换为工具调用
        """
        tools_desc = self._get_tools_description()
        
        prompt = f"""
你是一个命令解析助手。用户输入了一个命令，你需要将其转换为工具调用。

可用工具：
{tools_desc}

用户命令：{command}

请以 JSON 格式返回：
{{
    "tool": "工具名称",
    "params": {{
        "参数名": "参数值"
    }}
}}

只返回 JSON，不要其他内容。
"""
        
        response = self.llm.chat(prompt, system_prompt=self.system_prompt)
        
        # 解析 JSON
        import json
        try:
            # 提取 JSON 部分
            start = response.find('{')
            end = response.rfind('}') + 1
            if start != -1 and end > start:
                json_str = response[start:end]
                return json.loads(json_str)
            else:
                return {"tool": None, "params": {}}
        except:
            return {"tool": None, "params": {}}
            
    def _get_tools_description(self) -> str:
        """获取工具描述"""
        descriptions = []
        for name, func in self.tools.items():
            doc = func.__doc__ or "无描述"
            descriptions.append(f"- {name}: {doc.strip()}")
        return "\n".join(descriptions)
        
    def register_tool(self, name: str, func: callable):
        """注册新工具"""
        self.tools[name] = func
        logger.info(f"注册工具: {name}")
        
    def chat(self, message: str) -> str:
        """
        与智能体对话（不执行工具）
        """
        return self.llm.chat(message, system_prompt=self.system_prompt)
