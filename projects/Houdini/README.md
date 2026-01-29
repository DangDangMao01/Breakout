# Houdini 项目

**用途**: 程序化建模、特效制作、破碎模拟

---

## 📁 文件夹结构

```
Houdini/
├── hip/              # Houdini 项目文件 (.hip)
├── hda/              # Houdini Digital Assets
├── scripts/          # Python/VEX 脚本
├── exports/          # 导出的模型和缓存
│   ├── fbx/         # FBX 文件
│   ├── alembic/     # Alembic 缓存
│   └── vdb/         # VDB 体积
├── presets/          # 预设和模板
└── docs/            # 文档和教程
```

---

## 🎯 主要用途

### 1. 程序化建模
- 建筑生成
- 地形生成
- 植被分布
- 城市布局

### 2. 破碎特效
- RBD 刚体破碎
- Voronoi 破碎
- 布料撕裂
- 玻璃破碎

### 3. 粒子特效
- 爆炸效果
- 烟雾模拟
- 火焰效果
- 流体模拟

### 4. 动画工具
- 程序化动画
- 群集动画
- 约束系统
- 动力学模拟

---

## 🔧 工作流

### 破碎特效流程
```
导入模型 → Voronoi 破碎 → RBD 模拟 → 导出缓存 → 导入引擎
```

### 程序化建模流程
```
设计规则 → 生成几何体 → 优化拓扑 → 导出 FBX → 引擎集成
```

### 与其他工具集成
```
Houdini → Alembic → Unity/Unreal
Houdini → FBX → 3ds Max/Blender
Houdini → VDB → 渲染器
```

---

## 🐍 Python 脚本

### 常用脚本
- 批量导出 FBX
- 自动化破碎流程
- 参数化建模
- 缓存管理

---

## 📚 学习资源

- Houdini 官方文档
- VEX 编程指南
- 程序化建模教程
- 特效制作案例

---

## 🎮 游戏引擎集成

### Unity
- Houdini Engine for Unity
- 实时程序化生成
- 地形工具

### Unreal Engine
- Houdini Engine for Unreal
- 程序化资源
- 破碎系统

---

**创建日期**: 2026-01-29  
**维护**: 美术技术团队
