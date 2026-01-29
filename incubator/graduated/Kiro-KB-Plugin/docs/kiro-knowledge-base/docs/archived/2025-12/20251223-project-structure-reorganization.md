---
date: 2025-12-23
domain: kiro
tags: [project, structure, organization]
status: completed
---

# 项目结构重新整理

## 背景

项目最初是知识库储备，后来增加了插件开发功能，需要分离两者。

## 新结构

```
E:\K_Kiro_Work\
├── kiro-kb-plugin/          # 插件开发
│   ├── scripts/             # 所有脚本
│   ├── docs/                # 设计文档
│   ├── tests/               # 测试文件
│   ├── Kiro-KB-Setup.bat    # 安装入口
│   └── README.md
│
├── knowledge-base/          # 知识库（纯知识内容）
│   ├── discussions/
│   ├── solutions/
│   └── notes/
│
├── Kiro_Tu/                 # 截图
└── .kiro/                   # Kiro 配置
```

## 配置更新

Steering 规则中的脚本路径已更新：
- 旧路径：`E:\K_Kiro_Work\.kiro\scripts\`
- 新路径：`E:\K_Kiro_Work\kiro-kb-plugin\scripts\`

已删除旧的 `.kiro/scripts/` 目录避免混淆。
