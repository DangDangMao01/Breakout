# Cocos3D 项目

Cocos Creator 3.x 版本项目，支持 2D 和 3D 游戏开发。

---

## 📋 目录结构

```
Cocos3D/
├── docs/           # 文档和教程
├── plugins/        # Cocos Creator 插件
├── projects/       # 完整的游戏项目
└── scripts/        # 可复用的脚本和组件
    ├── components/ # 游戏组件
    ├── effects/    # 特效脚本
    ├── ui/         # UI 组件
    ├── utils/      # 工具函数
    └── 3d/         # 3D 相关脚本
```

---

## 🎮 Cocos Creator 3.x 新特性

### 3D 支持

- ✅ 完整的 3D 渲染管线
- ✅ 物理引擎（Bullet / Cannon.js）
- ✅ 光照和阴影
- ✅ 粒子系统
- ✅ 骨骼动画

### 2D 增强

- ✅ 保持 2D 游戏开发的简洁性
- ✅ 更好的性能
- ✅ 更强大的动画系统

### TypeScript 支持

- ✅ 完整的 TypeScript 支持
- ✅ 类型安全
- ✅ 更好的 IDE 支持

---

## 📚 相关资源

- [Cocos Creator 3.x 官方文档](https://docs.cocos.com/creator/3.8/manual/zh/)
- [Cocos Creator 3.x API 文档](https://docs.cocos.com/creator/3.8/api/zh/)
- [Cocos Creator 论坛](https://forum.cocos.org/)

---

## 🚀 快速开始

### 安装 Cocos Creator 3.x

1. 下载 [Cocos Dashboard](https://www.cocos.com/creator-download)
2. 通过 Dashboard 安装 Cocos Creator 3.x
3. 创建新项目或打开现有项目

### 创建第一个 3D 场景

```typescript
import { _decorator, Component, Node } from 'cc';
const { ccclass, property } = _decorator;

@ccclass('HelloWorld3D')
export class HelloWorld3D extends Component {
    start() {
        console.log('Hello Cocos3D!');
    }

    update(deltaTime: number) {
        // 每帧更新
    }
}
```

---

## 📝 项目列表

### 2D 项目

- 待添加

### 3D 项目

- 待添加

### 2D + 3D 混合项目

- 待添加

---

**创建时间**: 2026-01-31  
**用途**: Cocos Creator 3.x 项目开发
