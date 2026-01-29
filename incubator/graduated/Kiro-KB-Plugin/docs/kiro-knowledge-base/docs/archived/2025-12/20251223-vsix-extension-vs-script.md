---
date: 2025-12-23
domain: kiro
tags: [vsix, extension, plugin, typescript]
status: in_progress
---

# VSIX 扩展开发方案

## 背景

将 PowerShell 脚本插件改为 VSIX 格式，支持跨设备安装使用。

## 项目结构

```
kiro-kb-plugin/extension/
├── src/
│   └── extension.ts    # 扩展入口
├── package.json        # 扩展清单
├── tsconfig.json       # TypeScript 配置
├── .vscodeignore       # 打包忽略文件
└── README.md           # 扩展说明
```

## 功能命令

| 命令 | 功能 |
|------|------|
| Kiro KB: Setup Knowledge Base | 初始化设置 |
| Kiro KB: Sync to Central Repository | 同步到中央库 |
| Kiro KB: Generate Index | 生成索引 |
| Kiro KB: Open Knowledge Base | 打开知识库 |

## 配置项

- `kiro-kb.centralPath`: 中央知识库路径
- `kiro-kb.autoSave`: 自动保存开关

## 打包步骤

```powershell
cd kiro-kb-plugin/extension
npm install
npm run compile
npm run package
```

生成 `kiro-knowledge-base-1.0.0.vsix`

## 打包结果

✅ 成功生成：`kiro-kb-plugin/extension/kiro-knowledge-base-1.0.0.vsix`

## 安装方式

1. 在 Kiro/VS Code 中打开扩展面板
2. 点击右上角 `...` → `从 VSIX 安装`
3. 选择 `kiro-knowledge-base-1.0.0.vsix`
4. 重启后运行命令 `Kiro KB: Setup Knowledge Base`
