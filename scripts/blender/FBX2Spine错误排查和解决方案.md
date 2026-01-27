# FBX2Spine 错误排查和解决方案

> 错误：Variable Index [0] out of range [0] - FBXSourceFolderFilenames

---

## 错误分析

### 错误信息
```
ERROR in action number 1
of Step Event0 for object MainController:
Push :: Execution Error - Variable Index [0] out of range [0] 
- -9.FBXSourceFolderFilenames(100436,0)
at gml_Script_UI_FBXSource
```

### 问题原因
这是 FBX2Spine 启动时的初始化错误，说明：
1. 软件尝试读取一个配置文件或文件夹
2. 该文件夹路径不存在或为空
3. 数组越界错误

---

## 解决方案

### 方案 1：创建必要的文件夹

FBX2Spine 可能需要特定的文件夹结构。

```
步骤：
1. 找到 FBX2Spine 安装目录
   例如：C:\FBX2Spine\

2. 在安装目录创建以下文件夹：
   C:\FBX2Spine\FBX\
   C:\FBX2Spine\Spine\
   C:\FBX2Spine\Output\
   C:\FBX2Spine\Temp\

3. 重新启动 FBX2Spine
```

---

### 方案 2：以管理员身份运行

```
步骤：
1. 右键点击 FBX2Spine 快捷方式
2. 选择"以管理员身份运行"
3. 查看是否还有错误
```

---

### 方案 3：检查 Steam 文件完整性

```
步骤：
1. 打开 Steam 库
2. 右键点击 FBX2SPINE
3. 属性 → 本地文件 → 验证游戏文件完整性
4. 等待验证完成
5. 重新启动
```

---

### 方案 4：删除配置文件

FBX2Spine 可能有损坏的配置文件。

```
查找并删除配置文件：

可能位置：
1. C:\Users\Administrator\AppData\Local\FBX2SPINE\
2. C:\Users\Administrator\AppData\Roaming\FBX2SPINE\
3. 安装目录下的 config 或 settings 文件

步骤：
1. 关闭 FBX2Spine
2. 删除上述文件夹
3. 重新启动（会重新生成配置）
```

---

### 方案 5：使用 Mixamo 测试文件

可能是因为没有导入任何文件就启动导致的错误。

```
步骤：
1. 先从 Mixamo 下载一个标准 FBX
2. 准备一个简单的 Spine JSON
3. 将文件放在简单路径：
   C:\test\walk.fbx
   C:\test\character.json
4. 启动 FBX2Spine
5. 立即导入文件
```

---

### 方案 6：联系开发者

如果以上方案都不行，这可能是软件 bug。

```
Steam 社区：
1. 打开 FBX2Spine Steam 页面
2. 点击"社区中心"
3. 发帖描述问题
4. 附上错误截图

开发者联系：
- Steam 讨论区
- 可能有 Discord 或邮箱
```

---

## 临时替代方案

如果 FBX2Spine 无法使用，可以使用免费方案：

### 使用 Blender to Spine Addon

```
优势：
✅ 完全免费
✅ 已经安装
✅ 直接导出 Spine

步骤：
1. 使用 Mixamo 获取动画
2. Blender 导入 FBX
3. 使用 Addon 导出 Spine JSON
4. 跳过 FBX2Spine
```

---

## 立即测试步骤

### 步骤 1：创建测试环境

```powershell
# 在 PowerShell 中运行
New-Item -ItemType Directory -Path "C:\FBX2Spine_Test" -Force
New-Item -ItemType Directory -Path "C:\FBX2Spine_Test\FBX" -Force
New-Item -ItemType Directory -Path "C:\FBX2Spine_Test\Spine" -Force
New-Item -ItemType Directory -Path "C:\FBX2Spine_Test\Output" -Force
```

### 步骤 2：下载 Mixamo 测试文件

```
1. 访问 https://www.mixamo.com
2. 登录 Adobe 账号
3. 选择一个角色（如 Y Bot）
4. 选择动画（如 Walking）
5. 下载设置：
   - Format: FBX for Unity
   - Skin: With Skin
   - FPS: 30
6. 保存到：C:\FBX2Spine_Test\FBX\walk.fbx
```

### 步骤 3：创建简单 Spine JSON

```
1. 打开 Spine
2. 创建最简单的骨骼：
   - root
   - spine
   - head
3. 不需要绑定图片
4. 导出 JSON：
   File → Export → JSON
5. 保存到：C:\FBX2Spine_Test\Spine\test.json
```

### 步骤 4：重新测试 FBX2Spine

```
1. 以管理员身份运行 FBX2Spine
2. 如果还是报错，尝试：
   - 点击任意菜单
   - 尝试导入文件
   - 查看是否能继续使用
```

---

## 如果仍然无法解决

### 选项 A：申请退款

```
Steam 退款政策：
- 购买后 14 天内
- 游戏时间少于 2 小时
- 可以申请退款

步骤：
1. Steam → 帮助 → Steam 客服
2. 选择 FBX2SPINE
3. 选择"我想申请退款"
4. 说明无法启动的问题
```

### 选项 B：使用免费替代方案

```
完全免费的工作流：
Mixamo → Blender → Blender to Spine Addon → Spine

优势：
✅ 零成本
✅ 已经安装
✅ 功能完整
```

---

## 我的建议

### 立即尝试

1. **创建测试文件夹**
   ```
   C:\FBX2Spine_Test\FBX\
   C:\FBX2Spine_Test\Spine\
   C:\FBX2Spine_Test\Output\
   ```

2. **以管理员身份运行**
   - 右键 → 以管理员身份运行

3. **验证 Steam 文件**
   - Steam → 属性 → 验证文件完整性

---

### 如果还是不行

**切换到免费方案**
- 使用 Blender to Spine Addon
- 已经安装，立即可用
- 功能完整，质量保证

---

### 长期方案

**等待软件更新**
- 这可能是软件 bug
- 在 Steam 社区反馈
- 等待开发者修复

---

## 下一步

你想：

**A. 继续排查 FBX2Spine**
- 我帮你创建测试文件夹
- 逐步排查问题

**B. 切换到免费方案**
- 测试 Blender to Spine Addon
- 使用 Mixamo 动画
- 验证完整工作流

**C. 申请退款**
- Steam 退款
- 使用免费方案

选哪个？
