#!/usr/bin/env python3
"""
Spine MCP 服务器
提供 Spine 项目管理和导出功能
"""

import os
import json
import subprocess
from pathlib import Path
from typing import Any
import asyncio

from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

# 创建服务器实例
server = Server("spine-mcp")

# 获取 Spine 路径
SPINE_PATH = os.getenv("SPINE_PATH", "C:/Program Files/Spine/Spine.exe")


def find_spine_files(folder: str) -> list[dict[str, Any]]:
    """查找文件夹中的所有 .spine 文件"""
    folder_path = Path(folder)
    if not folder_path.exists():
        return []
    
    spine_files = []
    for file in folder_path.glob("*.spine"):
        spine_files.append({
            "name": file.name,
            "path": str(file.absolute()),
            "size": file.stat().st_size,
            "modified": file.stat().st_mtime
        })
    
    return spine_files


def get_spine_info(spine_file: str) -> dict[str, Any]:
    """获取 Spine 项目基本信息"""
    file_path = Path(spine_file)
    if not file_path.exists():
        return {"error": "文件不存在"}
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # 提取基本信息
        info = {
            "skeleton": data.get("skeleton", {}),
            "bones_count": len(data.get("bones", [])),
            "slots_count": len(data.get("slots", [])),
            "skins_count": len(data.get("skins", [])),
            "animations": list(data.get("animations", {}).keys()),
            "animations_count": len(data.get("animations", {}))
        }
        
        return info
    except Exception as e:
        return {"error": str(e)}


def export_spine_project(
    input_file: str,
    output_folder: str,
    export_format: str = "json",
    pack_atlas: bool = True,
    clean: bool = False
) -> dict[str, Any]:
    """导出 Spine 项目"""
    
    # 检查 Spine 是否存在
    if not Path(SPINE_PATH).exists():
        return {
            "success": False,
            "error": f"找不到 Spine: {SPINE_PATH}"
        }
    
    # 检查输入文件
    input_path = Path(input_file)
    if not input_path.exists():
        return {
            "success": False,
            "error": f"输入文件不存在: {input_file}"
        }
    
    # 创建输出文件夹
    output_path = Path(output_folder)
    output_path.mkdir(parents=True, exist_ok=True)
    
    # 构建命令
    args = [
        SPINE_PATH,
        "--input", str(input_path.absolute()),
        "--output", str(output_path.absolute()),
        "--export", export_format
    ]
    
    if pack_atlas:
        args.append("--pack")
    
    if clean:
        args.append("--clean")
    
    # 执行导出
    try:
        result = subprocess.run(
            args,
            capture_output=True,
            text=True,
            encoding='utf-8',
            timeout=60
        )
        
        return {
            "success": result.returncode == 0,
            "exit_code": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
            "output_folder": str(output_path.absolute())
        }
    except subprocess.TimeoutExpired:
        return {
            "success": False,
            "error": "导出超时（60秒）"
        }
    except Exception as e:
        return {
            "success": False,
            "error": str(e)
        }


@server.list_tools()
async def list_tools() -> list[Tool]:
    """列出所有可用工具"""
    return [
        Tool(
            name="list_spine_projects",
            description="列出指定文件夹中的所有 Spine 项目文件",
            inputSchema={
                "type": "object",
                "properties": {
                    "folder": {
                        "type": "string",
                        "description": "要搜索的文件夹路径"
                    }
                },
                "required": ["folder"]
            }
        ),
        Tool(
            name="get_spine_info",
            description="获取 Spine 项目的详细信息（骨骼数、动画列表等）",
            inputSchema={
                "type": "object",
                "properties": {
                    "spine_file": {
                        "type": "string",
                        "description": "Spine 项目文件路径 (.spine)"
                    }
                },
                "required": ["spine_file"]
            }
        ),
        Tool(
            name="export_spine",
            description="导出单个 Spine 项目为 JSON 或 Binary 格式",
            inputSchema={
                "type": "object",
                "properties": {
                    "input_file": {
                        "type": "string",
                        "description": "输入的 .spine 文件路径"
                    },
                    "output_folder": {
                        "type": "string",
                        "description": "输出文件夹路径"
                    },
                    "export_format": {
                        "type": "string",
                        "enum": ["json", "binary"],
                        "default": "json",
                        "description": "导出格式：json 或 binary"
                    },
                    "pack_atlas": {
                        "type": "boolean",
                        "default": True,
                        "description": "是否打包图集"
                    },
                    "clean": {
                        "type": "boolean",
                        "default": False,
                        "description": "导出前是否清理输出目录"
                    }
                },
                "required": ["input_file", "output_folder"]
            }
        ),
        Tool(
            name="batch_export_spine",
            description="批量导出文件夹中的所有 Spine 项目",
            inputSchema={
                "type": "object",
                "properties": {
                    "input_folder": {
                        "type": "string",
                        "description": "包含 .spine 文件的文件夹"
                    },
                    "output_folder": {
                        "type": "string",
                        "description": "输出文件夹路径"
                    },
                    "export_format": {
                        "type": "string",
                        "enum": ["json", "binary"],
                        "default": "json",
                        "description": "导出格式"
                    },
                    "pack_atlas": {
                        "type": "boolean",
                        "default": True,
                        "description": "是否打包图集"
                    }
                },
                "required": ["input_folder", "output_folder"]
            }
        )
    ]


@server.call_tool()
async def call_tool(name: str, arguments: Any) -> list[TextContent]:
    """处理工具调用"""
    
    if name == "list_spine_projects":
        folder = arguments.get("folder")
        files = find_spine_files(folder)
        
        return [TextContent(
            type="text",
            text=json.dumps(files, indent=2, ensure_ascii=False)
        )]
    
    elif name == "get_spine_info":
        spine_file = arguments.get("spine_file")
        info = get_spine_info(spine_file)
        
        return [TextContent(
            type="text",
            text=json.dumps(info, indent=2, ensure_ascii=False)
        )]
    
    elif name == "export_spine":
        result = export_spine_project(
            input_file=arguments.get("input_file"),
            output_folder=arguments.get("output_folder"),
            export_format=arguments.get("export_format", "json"),
            pack_atlas=arguments.get("pack_atlas", True),
            clean=arguments.get("clean", False)
        )
        
        return [TextContent(
            type="text",
            text=json.dumps(result, indent=2, ensure_ascii=False)
        )]
    
    elif name == "batch_export_spine":
        input_folder = arguments.get("input_folder")
        output_folder = arguments.get("output_folder")
        export_format = arguments.get("export_format", "json")
        pack_atlas = arguments.get("pack_atlas", True)
        
        # 查找所有文件
        files = find_spine_files(input_folder)
        
        results = []
        for file_info in files:
            result = export_spine_project(
                input_file=file_info["path"],
                output_folder=output_folder,
                export_format=export_format,
                pack_atlas=pack_atlas,
                clean=False
            )
            results.append({
                "file": file_info["name"],
                "result": result
            })
        
        return [TextContent(
            type="text",
            text=json.dumps(results, indent=2, ensure_ascii=False)
        )]
    
    else:
        return [TextContent(
            type="text",
            text=f"未知工具: {name}"
        )]


async def main():
    """主函数"""
    async with stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            server.create_initialization_options()
        )


if __name__ == "__main__":
    asyncio.run(main())
