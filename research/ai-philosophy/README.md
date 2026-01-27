# Kiro Knowledge Base Plugin

自动保存和检索 Kiro 对话知识的插件。

## 功能

- 自动保存有价值的对话内容
- 智能检索历史解决方案
- 跨项目知识同步
- 进度追踪

## 安装

**方式一：运行安装脚本（推荐）**
```powershell
powershell -ExecutionPolicy Bypass -File "E:\K_Kiro_Work\kiro-kb-plugin\scripts\install-knowledge-base.ps1"
```

**方式二：双击运行**
```
cd E:\K_Kiro_Work\kiro-kb-plugin
双击 Kiro-KB-Setup.bat
```

**注意：** 安装后会配置全局 Steering 规则，新项目打开后 Kiro 自动生效，无需重复安装。

## 目录结构

```
kiro-kb-plugin/
├── scripts/          # PowerShell 脚本
├── docs/             # 设计文档
├── tests/            # 测试文件
├── Kiro-KB-Setup.bat # 安装入口
└── README.md
```

## 脚本说明

| 脚本 | 功能 |
|------|------|
| install-knowledge-base.ps1 | 一键安装 |
| sync-to-central.ps1 | 同步到中央库 |
| generate-index.ps1 | 生成索引 |
| init-knowledge-base.ps1 | 初始化新项目 |
| report-test-issue.ps1 | 测试问题回传 |
| setup-new-device.ps1 | 新设备配置 |

## 开发状态

🧪 测试中
