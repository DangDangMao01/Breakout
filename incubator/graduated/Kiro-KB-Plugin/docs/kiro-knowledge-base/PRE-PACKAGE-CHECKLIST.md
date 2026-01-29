# 打包前检查清单

> 每次打包 VSIX 前必须完成以下检查，防止跨设备开发导致的问题

---

## ✅ 必须检查项

### 1. 版本号检查
- [ ] `package.json` 中的 `version` 已更新
- [ ] `extension.ts` 中的 `PLUGIN_VERSION` 与 `package.json` 一致
- [ ] `CHANGELOG.md` 已添加新版本记录

### 2. 代码检查
- [ ] `npm run compile` 无错误
- [ ] 所有新文件已正确导入到 `extension.ts`
- [ ] 新增的命令已在 `package.json` 的 `contributes.commands` 中注册
- [ ] 新增的命令已在 `extension.ts` 的 `activate` 函数中注册处理函数

### 3. 功能检查
- [ ] 侧边栏正常显示
- [ ] 所有命令可用（命令面板测试）
- [ ] 新功能测试通过

### 4. 文档检查
- [ ] `SESSION-STATE.md` 已更新当前进度
- [ ] `RELEASE-NOTES-vX.XX.X.md` 已创建（如果是新版本）

---

## 📦 打包命令

```bash
cd kiro-knowledge-base/extension
npm run compile
npm run package
```

## 🧪 验证命令

```bash
# 在 Kiro/VSCode 中安装测试
# Ctrl+Shift+P → "Extensions: Install from VSIX"
# 选择生成的 .vsix 文件
# 重新加载窗口
```

## ⚠️ 常见问题

### 侧边栏空白
- 检查 `activate` 函数是否有未捕获的异常
- 检查新模块的导入是否正确
- 查看输出面板的错误日志

### 命令不可用
- 检查 `package.json` 中是否注册了命令
- 检查 `extension.ts` 中是否注册了命令处理函数

### 版本号不一致
- 同步更新 `package.json` 和 `extension.ts` 中的版本号

---

**最后更新**: 2026-01-12
