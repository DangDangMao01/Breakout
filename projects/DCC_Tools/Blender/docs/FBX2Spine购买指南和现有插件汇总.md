# FBX2Spine 购买指南 & Blender 现有插件汇总

---

## 第一部分：FBX2Spine 购买信息

### Steam 购买（推荐）

**产品信息**
- 名称：FBX2SPINE - 3D Mocap to 2D Animation Transfer Tool
- 开发商：LizardWish
- 发布日期：2023 年 7 月 2 日

**价格**
- 原价：HK$ 125.00（约 ¥115 / $16）
- 当前折扣：-25% 优惠
- 折扣价：HK$ 93.75（约 ¥86 / $12）
- ⏰ 优惠截止：2026 年 1 月 12 日

**Steam 链接**
```
https://store.steampowered.com/app/2467960/FBX2SPINE__3D_Mocap_to_2D_Animation_Transfer_Tool
```

**购买步骤**
```
1. 打开 Steam 客户端或网页
2. 搜索 "FBX2SPINE"
3. 点击 "Add to Cart"（添加到购物车）
4. 选择支付方式：
   - 支付宝
   - 微信支付
   - Steam 钱包
   - 信用卡
5. 完成支付
6. 在 Steam 库中下载安装
```

---

### itch.io 购买（备选）

**链接**
```
https://lizardwish.itch.io/fbx2spine
```

**价格**
- 通常与 Steam 价格相同
- 可能有独立促销

---

### 系统要求

**最低配置**
- 操作系统：Windows 10（64 位）
- 处理器：Intel i5
- 内存：4 GB RAM
- 显卡：集成显卡
- DirectX：版本 11
- 存储空间：50 MB

**推荐配置**
- 操作系统：Windows 10（64 位）
- 处理器：Intel i5
- 内存：8 GB RAM
- 显卡：GTX 1050 TI
- DirectX：版本 11
- 存储空间：50 MB

---

### 功能特性

✅ **支持 Spine 版本**
- Spine 4 Essential（不需要 Pro！）
- Spine 4 Pro 及以上

✅ **支持所有 FBX 骨骼**
- 人形角色
- 动物
- 怪物
- 自定义骨骼

✅ **工作流程**
1. 导入 Spine 项目（JSON）
2. 导入 FBX 动画
3. 链接骨骼系统
4. 导出到 Spine

✅ **后期编辑**
- 导出的动画可以在 Spine 中继续编辑

---

### 用户评价

- Steam 评分：4 条评价（需要更多评价生成分数）
- 适合：快速将 3D 动画转为 2D
- 注意：需要手动链接骨骼

---

## 第二部分：Blender 现有插件汇总

### 1. Import Images as Planes（官方插件）

**功能**
- 将图片导入为平面
- 自动创建材质
- 支持透明度

**获取方式**
```
Blender 内置插件：
1. Edit → Preferences → Add-ons
2. 搜索 "Import Images as Planes"
3. 勾选启用
```

**使用**
```
File → Import → Images as Planes
- 选择多个 PNG 文件
- 自动创建平面 + 材质
```

**优点**
- ✅ 免费内置
- ✅ 支持批量导入
- ✅ 自动设置透明度

**缺点**
- ❌ 不会自动排列位置
- ❌ 不会创建骨骼
- ❌ 需要手动调整

---

### 2. Rigify（官方插件）

**功能**
- 自动生成骨骼系统
- 预设人形骨架
- IK/FK 切换

**获取方式**
```
Blender 内置插件：
1. Edit → Preferences → Add-ons
2. 搜索 "Rigify"
3. 勾选启用
```

**使用**
```
1. Shift + A → Armature → Basic → Basic Human (Meta-Rig)
2. 调整骨骼位置
3. 点击 "Generate Rig"
```

**优点**
- ✅ 免费内置
- ✅ 专业级骨架
- ✅ 自动生成控制器

**缺点**
- ❌ 主要为 3D 设计
- ❌ 对 2D 工作流过于复杂
- ❌ 需要大量调整

---

### 3. COA Tools（第三方免费）

**功能**
- 2D 剪纸动画工具
- Photoshop 图层导入
- 类似 Spine 的工作流
- 导出到 Godot

**获取方式**
```
GitHub 下载：
https://github.com/ndee85/coa_tools

安装：
1. 下载 ZIP
2. Blender → Edit → Preferences → Add-ons
3. Install from File
4. 选择 coa_tools.zip
```

**功能详情**
- Photoshop 图层导出脚本
- Blender 2D 动画工具
- Godot 导入器

**优点**
- ✅ 完全免费
- ✅ 专为 2D 设计
- ✅ 支持 Photoshop 导入
- ✅ 完整工作流

**缺点**
- ❌ 不直接支持 Spine 导出
- ❌ 主要为 Godot 设计
- ❌ 学习曲线陡峭

**适用场景**
- Blender → Godot 工作流
- 不适合 Blender → Spine

---

### 4. Auto-Rig Pro（付费）

**功能**
- 自动骨骼绑定
- 支持人形和动物
- 面部绑定

**获取方式**
```
Blender Market 购买：
https://blendermarket.com/products/auto-rig-pro

价格：约 $40
```

**优点**
- ✅ 强大的自动绑定
- ✅ 支持多种角色类型
- ✅ 专业级工具

**缺点**
- ❌ 需要付费
- ❌ 主要为 3D 设计
- ❌ 对 2D 工作流过于复杂

---

### 5. Mixamo Auto-Rigger（在线服务）

**功能**
- 在线自动绑定
- 免费动作库
- 导出 FBX

**获取方式**
```
网站：https://www.mixamo.com
- 免费注册 Adobe 账号
- 上传 3D 模型
- 自动绑定
- 下载 FBX
```

**工作流**
```
1. Blender 导出 OBJ/FBX
2. Mixamo 上传 → 自动绑定
3. 选择动画
4. 下载 FBX
5. Blender 导入
6. 使用 FBX2Spine 转换
```

**优点**
- ✅ 完全免费
- ✅ 自动绑定
- ✅ 大量免费动画
- ✅ 可与 FBX2Spine 配合

**缺点**
- ❌ 需要上传模型
- ❌ 只支持人形角色
- ❌ 需要网络连接

---

### 6. Blender to Spine 2D Mesh Exporter（免费）

**功能**
- 直接导出 Spine JSON
- 自动纹理烘焙
- 网格分割

**获取方式**
```
GitHub：
https://github.com/maximsokal/Blender_to_Spine_2D_Mesh_Export_Addon

已下载到：
E:\K_Kiro_Work\incubator\Blender\Blender_to_Spine_2D_Mesh_Export_Addon-main\
```

**优点**
- ✅ 完全免费
- ✅ 直接导出 Spine
- ✅ 我们已经安装

**缺点**
- ❌ Beta 阶段
- ❌ 需要 Blender 4.4+
- ❌ 材质支持有限

---

## 第三部分：推荐工作流组合

### 组合 A：完全免费（推荐新手）

```
工具：
- Import Images as Planes（内置）
- 手动创建骨骼
- Blender to Spine Addon（已安装）

优势：
✅ 零成本
✅ 完全控制
✅ 学习 Blender 基础

劣势：
❌ 需要手动工作
❌ 耗时较长
```

---

### 组合 B：半自动化（推荐项目）

```
工具：
- Import Images as Planes（内置）
- 自定义 Python 脚本（我们开发）
- Blender to Spine Addon（已安装）

优势：
✅ 自动化程度高
✅ 可定制
✅ 适合批量处理

劣势：
❌ 需要开发脚本
❌ 初期投入时间
```

---

### 组合 C：FBX2Spine 工作流（推荐动捕）

```
工具：
- Blender 手动/Mixamo 自动绑定
- FBX2Spine（$12，当前折扣）
- Spine

优势：
✅ 可使用动捕数据
✅ 可使用 Mixamo 免费动画
✅ 工作流成熟

劣势：
❌ 需要购买 FBX2Spine
❌ 需要已有 Spine 角色
```

---

### 组合 D：混合工作流（推荐专业）

```
工具：
- COA Tools（Photoshop 导入）
- 自定义脚本（自动化）
- Blender to Spine Addon
- FBX2Spine（动捕动画）

优势：
✅ 最灵活
✅ 适合各种场景
✅ 专业级产出

劣势：
❌ 学习曲线陡峭
❌ 需要多个工具
```

---

## 第四部分：立即可用的方案

### 方案 1：使用内置插件（今天就能用）

```
步骤：
1. 启用 "Import Images as Planes"
2. 导入 PNG 图层
3. 手动创建骨骼
4. 手动绑定
5. 使用 Blender to Spine Addon 导出

时间：2-3 小时/角色
成本：免费
```

---

### 方案 2：购买 FBX2Spine（推荐）

```
步骤：
1. Steam 购买 FBX2Spine（趁折扣）
2. Blender 制作动画
3. 导出 FBX
4. Spine 创建角色
5. FBX2Spine 转换动画

时间：1-2 小时/角色
成本：$12（折扣价）
```

---

### 方案 3：开发自动化脚本（长期投资）

```
步骤：
1. 我帮你写 Python 脚本
2. 自动化导入、绑定、导出
3. 建立标准化工作流

时间：初期 1 周开发，后续 30 分钟/角色
成本：开发时间
```

---

## 第五部分：我的建议

### 立即行动

**1. 购买 FBX2Spine（趁折扣）**
```
- 现在折扣 25%
- 1 月 12 日截止
- 只需 $12
- 立即可用
```

**2. 启用内置插件**
```
- Import Images as Planes
- 立即测试基础工作流
```

**3. 测试两种工作流**
```
A. Blender to Spine Addon（免费）
B. FBX2Spine（付费但成熟）
```

---

### 长期规划

**1. 开发自动化脚本**
```
- PSD Layer Importer
- Auto Rigger
- Animation Templates
```

**2. 建立标准化流程**
```
- 命名规范
- 文件夹结构
- 导出预设
```

**3. 积累资源库**
```
- 动画模板
- 骨骼预设
- 材质库
```

---

## 下一步

你想：

**A. 立即购买 FBX2Spine**
- 我给你详细的使用教程
- 准备测试案例

**B. 先测试免费方案**
- 使用 Import Images as Planes
- 测试 Blender to Spine Addon

**C. 两个都做**
- 购买 FBX2Spine
- 同时测试免费工作流
- 对比效果

选哪个？
