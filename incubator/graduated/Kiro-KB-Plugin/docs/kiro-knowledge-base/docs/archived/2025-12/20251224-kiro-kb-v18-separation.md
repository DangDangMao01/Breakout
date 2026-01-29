---
date: 2025-12-24
domain: kiro
tags: [plugin, v1.8.0, knowledge-base, separation]
status: completed
---

# Kiro KB 插件 v1.8.0 开发 & 项目分离

## 完成内容

### 1. 项目分离
- 插件开发项目: `E:\K_Kiro_Work`  https://github.com/DangDangMao01/Kiro_work
- 中央知识库: `D:\G_GitHub\KiroKnowledgeBase`  https://github.com/DangDangMao01/KiroKnowledgeBase
- 清理了重复文件（K_Kiro_Work- 前缀）
- 更新了全局 Steering 规则指向新路径

### 2. v1.8.0 新功能：智能空闲提醒
- 追踪会话编辑次数和工作时长
- 只有在有足够工作量时才提醒（至少编辑 20 次，工作 5 分钟）
- 显示会话统计信息
- 新增 "本次不再提醒" 选项

### 3. Steering 规则更新
增加对话质量评估标准：
- 优质内容（解决方案、代码、新知识） 主动提示保存
- 一般内容（简单问答、临时调试） 不提示

## 关键代码

`	ypescript
let sessionEditCount: number = 0;
let sessionStartTime: number = Date.now();
const MIN_EDITS_FOR_REMINDER = 20;
const MIN_SESSION_MINUTES = 5;

function checkIdle() {
    const sessionMinutes = (Date.now() - sessionStartTime) / 60000;
    if (sessionEditCount >= MIN_EDITS_FOR_REMINDER && sessionMinutes >= MIN_SESSION_MINUTES) {
        showSaveReminder();
    }
}
`

## 版本历史
- v1.7.0: 智能识别中央知识库
- v1.8.0: 智能空闲提醒（根据工作量判断）
