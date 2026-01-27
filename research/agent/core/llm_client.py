"""
Ollama LLM 客户端封装
支持本地 Ollama 服务调用
"""

import requests
import json
from typing import Dict, List, Optional, Generator
import logging

logger = logging.getLogger(__name__)


class OllamaClient:
    """Ollama 客户端，封装与 Ollama API 的交互"""
    
    def __init__(self, host: str = "http://localhost:11434", model: str = "qwen2.5:32b"):
        self.host = host.rstrip('/')
        self.model = model
        self.conversation_history: List[Dict] = []
        
    def chat(self, 
             prompt: str, 
             system_prompt: Optional[str] = None,
             temperature: float = 0.7,
             max_tokens: int = 2048,
             stream: bool = False) -> str:
        """
        发送聊天请求到 Ollama
        
        Args:
            prompt: 用户输入
            system_prompt: 系统提示词
            temperature: 温度参数
            max_tokens: 最大生成长度
            stream: 是否流式输出
            
        Returns:
            模型回复
        """
        messages = []
        
        if system_prompt:
            messages.append({"role": "system", "content": system_prompt})
            
        # 添加历史对话
        messages.extend(self.conversation_history)
        
        # 添加当前输入
        messages.append({"role": "user", "content": prompt})
        
        try:
            if stream:
                return self._chat_stream(messages, temperature, max_tokens)
            else:
                return self._chat_sync(messages, temperature, max_tokens)
        except Exception as e:
            logger.error(f"Ollama 调用失败: {e}")
            raise
            
    def _chat_sync(self, messages: List[Dict], temperature: float, max_tokens: int) -> str:
        """同步聊天"""
        url = f"{self.host}/api/chat"
        payload = {
            "model": self.model,
            "messages": messages,
            "stream": False,
            "options": {
                "temperature": temperature,
                "num_predict": max_tokens
            }
        }
        
        response = requests.post(url, json=payload, timeout=120)
        response.raise_for_status()
        
        result = response.json()
        assistant_message = result["message"]["content"]
        
        # 更新对话历史
        self.conversation_history.append({"role": "user", "content": messages[-1]["content"]})
        self.conversation_history.append({"role": "assistant", "content": assistant_message})
        
        return assistant_message
        
    def _chat_stream(self, messages: List[Dict], temperature: float, max_tokens: int) -> Generator:
        """流式聊天"""
        url = f"{self.host}/api/chat"
        payload = {
            "model": self.model,
            "messages": messages,
            "stream": True,
            "options": {
                "temperature": temperature,
                "num_predict": max_tokens
            }
        }
        
        response = requests.post(url, json=payload, stream=True, timeout=120)
        response.raise_for_status()
        
        full_response = ""
        for line in response.iter_lines():
            if line:
                data = json.loads(line)
                if "message" in data:
                    chunk = data["message"]["content"]
                    full_response += chunk
                    yield chunk
                    
        # 更新对话历史
        self.conversation_history.append({"role": "user", "content": messages[-1]["content"]})
        self.conversation_history.append({"role": "assistant", "content": full_response})
        
    def clear_history(self):
        """清空对话历史"""
        self.conversation_history = []
        
    def check_connection(self) -> bool:
        """检查 Ollama 服务是否可用"""
        try:
            response = requests.get(f"{self.host}/api/tags", timeout=5)
            return response.status_code == 200
        except:
            return False
            
    def list_models(self) -> List[str]:
        """列出可用模型"""
        try:
            response = requests.get(f"{self.host}/api/tags", timeout=5)
            response.raise_for_status()
            data = response.json()
            return [model["name"] for model in data.get("models", [])]
        except Exception as e:
            logger.error(f"获取模型列表失败: {e}")
            return []
