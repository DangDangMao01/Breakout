# 跨设备上下文恢复测试计划

**目标**: 2月前必须解决跨设备开发的上下文断裂问题  
**优先级**: 🔴 最高（阻塞 DevBrain-App 和游戏开发）  
**测试时间**: 2026-01-29 晚上  
**测试设备**: 家里的设备

---

## 🎯 为什么这个必须先解决

1. **DevBrain-App 开发** - 需要在多台设备间切换
2. **游戏开发** - 工作室和家里两地开发
3. **避免记忆断层** - 不能只靠你自己记问题
4. **2月正式实施** - 必须在自然月2月前完成测试

---

## 📋 测试清单

### 测试 1: Steering 规则是否生效

**在公司（当前设备）**:
```bash
# 1. 确认 Steering 规则已创建
ls .kiro/steering/auto-kb-sync.md
ls .kiro/steering/kb-link.md
ls .kiro/steering/check-knowledge-base.md

# 2. 提交所有更改
git add .
git commit -m "Test: 跨设备上下文恢复机制"
git push
```

**在家里（测试设备）**:
```bash
# 1. 拉取最新代码
cd D:\G_GitHub\K_Kiro_Work
git pull

# 2. 打开 Kiro，测试自动检索
```

**测试提示词**:
```
Hook 可以实现跨设备上下文恢复吗？
```

**预期结果**:
- ✅ Kiro 自动检测到关键词"Hook"和"跨设备"
- ✅ Kiro 主动说："我发现这个话题之前可能讨论过"
- ✅ Kiro 读取 `incubator/graduated/Kiro-KB-Plugin/docs/CROSS-DEVICE-CONTEXT-RECOVERY.md`
- ✅ Kiro 引用历史讨论

**如果失败**:
- 检查 Steering 规则文件是否存在
- 检查文件开头是否有 `---\ninclusion: always\n---`
- 重启 Kiro IDE

---

### 测试 2: 中央知识库检索

**测试提示词**:
```
我们之前讨论过 Clawdbot 和超长记忆上下文吗？
```

**预期结果**:
- ✅ Kiro 检索中央知识库 `D:\G_GitHub\Kiro-Central-KB\INDEX.md`
- ✅ Kiro 找到相关文档并读取
- ✅ Kiro 引用之前的讨论

**如果失败**:
- 检查中央知识库路径是否正确
- 检查 INDEX.md 是否存在
- 手动告诉 Kiro 读取中央知识库

---

### 测试 3: 对话保存和同步

**测试提示词**:
```
保存到知识库
```

**预期结果**:
- ✅ Kiro 评估对话质量
- ✅ Kiro 确定保存位置（solutions/notes/discussions）
- ✅ Kiro 生成文件名（格式：YYYYMMDD-主题.md）
- ✅ Kiro 添加元数据（domain, tags, source_project）
- ✅ Kiro 提醒同步到中央知识库

**如果失败**:
- 检查 Steering 规则是否生效
- 手动保存对话到知识库

---

### 测试 4: 跨设备工作流完整测试

**在公司（离开前）**:
```bash
# 1. 更新今日总结
# 编辑 knowledge-base/notes/20260129-今日对话总结.md

# 2. 提交更改
git add .
git commit -m "Work session: 跨设备上下文恢复机制测试"
git push

# 3. 同步到中央知识库
Copy-Item "knowledge-base\notes\20260129-*.md" "D:\G_GitHub\Kiro-Central-KB\notes\"
cd D:\G_GitHub\Kiro-Central-KB
git add .
git commit -m "Sync: K_Kiro_Work 2026-01-29"
git push
```

**在家里（到达后）**:
```bash
# 1. 拉取 K_Kiro_Work
cd D:\G_GitHub\K_Kiro_Work
git pull

# 2. 拉取中央知识库
cd D:\G_GitHub\Kiro-Central-KB
git pull

# 3. 打开 Kiro，测试恢复
```

**测试提示词**:
```
继续开发
```

**预期结果**:
- ✅ Kiro 自动读取今日总结
- ✅ Kiro 恢复上下文
- ✅ Kiro 告诉你当前状态和下一步

---

## 🔧 故障排除

### 问题 1: Steering 规则不生效

**症状**: Kiro 没有自动检索知识库

**解决方案**:
1. 检查文件开头是否有 frontmatter:
   ```yaml
   ---
   inclusion: always
   ---
   ```
2. 重启 Kiro IDE
3. 手动触发：在聊天中说"检索知识库"

### 问题 2: 找不到中央知识库

**症状**: Kiro 说找不到 `D:\G_GitHub\Kiro-Central-KB\INDEX.md`

**解决方案**:
1. 确认路径是否正确（家里的路径可能不同）
2. 如果路径不同，更新 Steering 规则中的路径
3. 手动告诉 Kiro 正确的路径

### 问题 3: Git 同步失败

**症状**: `git push` 失败

**解决方案**:
```bash
# 1. 检查网络连接
ping github.com

# 2. 检查 Git 配置
git config --list

# 3. 如果有冲突，先 pull 再 push
git pull --rebase
git push
```

### 问题 4: Kiro 理解错了上下文

**症状**: Kiro 给出的建议和之前不一致

**解决方案**:
```
我们之前的决策是 [具体决策]。
请更新你的理解，并基于这个决策继续。
```

---

## 📊 成功标准

测试成功的标志：

- ✅ **自动检索**: Kiro 能自动检测关键词并检索知识库
- ✅ **引用历史**: Kiro 能引用之前的讨论，避免重复
- ✅ **自动保存**: Kiro 能自动保存有价值的对话
- ✅ **跨设备恢复**: 在新设备上能快速恢复上下文（5分钟内）
- ✅ **上下文准确**: Kiro 理解的上下文和实际情况一致（80%+）

---

## 🎯 下一步（测试成功后）

1. **文档化经验** - 记录测试中发现的问题和解决方案
2. **优化流程** - 简化同步步骤（考虑自动化脚本）
3. **应用到其他项目** - DevBrain-App、游戏开发项目
4. **2月正式实施** - 在所有项目中使用这个工作流

---

## 📝 测试记录模板

```markdown
# 跨设备上下文恢复测试记录

**测试时间**: 2026-01-29 晚上  
**测试设备**: 家里的设备  
**测试人**: [你的名字]

## 测试结果

### 测试 1: Steering 规则
- [ ] 通过 / [ ] 失败
- 问题: 
- 解决方案:

### 测试 2: 中央知识库检索
- [ ] 通过 / [ ] 失败
- 问题:
- 解决方案:

### 测试 3: 对话保存和同步
- [ ] 通过 / [ ] 失败
- 问题:
- 解决方案:

### 测试 4: 跨设备工作流
- [ ] 通过 / [ ] 失败
- 问题:
- 解决方案:

## 总结

- 成功率: ___%
- 主要问题:
- 改进建议:
- 下一步:
```

---

**创建时间**: 2026-01-29  
**优先级**: 🔴 最高  
**截止日期**: 2026-02-01（2月前）
