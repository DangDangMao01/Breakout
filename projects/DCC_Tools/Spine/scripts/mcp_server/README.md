# Spine MCP 服务器

Spine MCP 服务器允许 Kiro 通过 MCP 协议操作 Spine 项目。

## 功能

- 📁 列出 Spine 项目文件
- 📤 批量导出项目（JSON/Binary）
- 📊 查询项目信息
- ✅ 验证项目有效性

## 安装

```bash
# 安装依赖
pip install mcp

# 或使用 uv
uv pip install mcp
```

## 配置

在 Kiro 的 MCP 配置中添加：

```json
{
  "mcpServers": {
    "spine": {
      "command": "python",
      "args": ["E:/K_Kiro_Work/incubator/Spine_Script/SpineMCP/server.py"],
      "env": {
        "SPINE_PATH": "C:/Program Files/Spine/Spine.exe"
      }
    }
  }
}
```

## 使用

在 Kiro 中可以使用以下工具：

- `list_spine_projects` - 列出文件夹中的 .spine 文件
- `export_spine` - 导出单个 Spine 项目
- `batch_export_spine` - 批量导出
- `get_spine_info` - 获取项目基本信息

## 环境变量

- `SPINE_PATH` - Spine 可执行文件路径（必需）
