"""
记忆系统使用示例
演示如何使用向量记忆系统
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from core.memory import MemorySystem
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def main():
    """主函数"""
    print("=" * 60)
    print("记忆系统示例")
    print("=" * 60)
    
    # 1. 初始化记忆系统
    print("\n[1] 初始化记忆系统...")
    memory = MemorySystem(
        persist_directory="./data/memory",
        collection_name="demo_memory"
    )
    print("✅ 记忆系统初始化成功")
    
    # 2. 添加记忆
    print("\n[2] 添加记忆...")
    
    memories = [
        {
            "content": "用户喜欢使用快捷键 Shift+A 添加对象",
            "category": "preference",
            "metadata": {"software": "blender"}
        },
        {
            "content": "创建立方体的命令是 bpy.ops.mesh.primitive_cube_add()",
            "category": "command",
            "metadata": {"software": "blender", "type": "modeling"}
        },
        {
            "content": "用户经常制作破碎动画，使用 Cell Fracture 插件",
            "category": "workflow",
            "metadata": {"software": "blender", "type": "animation"}
        },
        {
            "content": "渲染输出路径通常设置为 E:/Render/output.png",
            "category": "preference",
            "metadata": {"software": "blender", "type": "render"}
        }
    ]
    
    for mem in memories:
        memory_id = memory.add_memory(
            content=mem["content"],
            category=mem["category"],
            metadata=mem["metadata"]
        )
        print(f"✅ 添加记忆: {memory_id[:8]}... - {mem['content'][:30]}...")
    
    # 3. 搜索记忆
    print("\n[3] 搜索相关记忆...")
    
    queries = [
        "如何创建立方体？",
        "用户的渲染偏好是什么？",
        "破碎动画怎么做？"
    ]
    
    for query in queries:
        print(f"\n查询: {query}")
        results = memory.search_memory(query, n_results=2)
        
        for i, result in enumerate(results, 1):
            print(f"  结果 {i}:")
            print(f"    内容: {result['content']}")
            print(f"    分类: {result['metadata']['category']}")
            print(f"    相似度: {1 - result['distance']:.2f}")
    
    # 4. 获取最近记忆
    print("\n[4] 获取最近记忆...")
    recent = memory.get_recent_memories(n=3)
    
    for i, mem in enumerate(recent, 1):
        print(f"  {i}. {mem['content'][:50]}...")
        print(f"     分类: {mem['metadata']['category']}")
    
    # 5. 统计信息
    print("\n[5] 记忆统计...")
    stats = memory.get_stats()
    print(f"  总记忆数: {stats['total_memories']}")
    print(f"  集合名称: {stats['collection_name']}")
    print(f"  存储路径: {stats['persist_directory']}")
    
    print("\n" + "=" * 60)
    print("示例完成")
    print("=" * 60)


if __name__ == "__main__":
    main()
