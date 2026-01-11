"""
记忆系统
使用 ChromaDB 实现向量记忆
"""

import chromadb
from chromadb.config import Settings
from typing import List, Dict, Optional
import logging
from datetime import datetime
import hashlib

logger = logging.getLogger(__name__)


class MemorySystem:
    """向量记忆系统"""
    
    def __init__(self, 
                 persist_directory: str = "./data/memory",
                 collection_name: str = "agent_memory"):
        self.persist_directory = persist_directory
        self.collection_name = collection_name
        
        # 初始化 ChromaDB
        self.client = chromadb.Client(Settings(
            persist_directory=persist_directory,
            anonymized_telemetry=False
        ))
        
        # 获取或创建集合
        self.collection = self.client.get_or_create_collection(
            name=collection_name,
            metadata={"description": "DCC Agent Memory"}
        )
        
    def add_memory(self, 
                   content: str, 
                   metadata: Optional[Dict] = None,
                   category: str = "general") -> str:
        """
        添加记忆
        
        Args:
            content: 记忆内容
            metadata: 元数据
            category: 分类（general/command/preference/workflow）
            
        Returns:
            记忆 ID
        """
        # 生成唯一 ID
        memory_id = self._generate_id(content)
        
        # 准备元数据
        meta = metadata or {}
        meta.update({
            "category": category,
            "timestamp": datetime.now().isoformat(),
        })
        
        # 添加到向量库
        self.collection.add(
            documents=[content],
            metadatas=[meta],
            ids=[memory_id]
        )
        
        logger.info(f"添加记忆: {memory_id[:8]}... ({category})")
        return memory_id
        
    def search_memory(self, 
                      query: str, 
                      n_results: int = 5,
                      category: Optional[str] = None) -> List[Dict]:
        """
        搜索相关记忆
        
        Args:
            query: 查询文本
            n_results: 返回结果数量
            category: 过滤分类
            
        Returns:
            相关记忆列表
        """
        where = {"category": category} if category else None
        
        results = self.collection.query(
            query_texts=[query],
            n_results=n_results,
            where=where
        )
        
        memories = []
        if results["documents"]:
            for i, doc in enumerate(results["documents"][0]):
                memories.append({
                    "content": doc,
                    "metadata": results["metadatas"][0][i],
                    "distance": results["distances"][0][i] if "distances" in results else None
                })
                
        return memories
        
    def get_recent_memories(self, n: int = 10, category: Optional[str] = None) -> List[Dict]:
        """
        获取最近的记忆
        
        Args:
            n: 数量
            category: 过滤分类
            
        Returns:
            记忆列表
        """
        where = {"category": category} if category else None
        
        results = self.collection.get(
            where=where,
            limit=n
        )
        
        memories = []
        if results["documents"]:
            for i, doc in enumerate(results["documents"]):
                memories.append({
                    "content": doc,
                    "metadata": results["metadatas"][i]
                })
                
        # 按时间戳排序
        memories.sort(key=lambda x: x["metadata"].get("timestamp", ""), reverse=True)
        return memories[:n]
        
    def delete_memory(self, memory_id: str):
        """删除记忆"""
        self.collection.delete(ids=[memory_id])
        logger.info(f"删除记忆: {memory_id[:8]}...")
        
    def clear_all(self):
        """清空所有记忆"""
        self.client.delete_collection(self.collection_name)
        self.collection = self.client.create_collection(
            name=self.collection_name,
            metadata={"description": "DCC Agent Memory"}
        )
        logger.warning("已清空所有记忆")
        
    def _generate_id(self, content: str) -> str:
        """生成记忆 ID"""
        timestamp = datetime.now().isoformat()
        raw = f"{content}_{timestamp}"
        return hashlib.md5(raw.encode()).hexdigest()
        
    def get_stats(self) -> Dict:
        """获取记忆统计"""
        count = self.collection.count()
        return {
            "total_memories": count,
            "collection_name": self.collection_name,
            "persist_directory": self.persist_directory
        }
