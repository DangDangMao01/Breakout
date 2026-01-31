# Cocos Creator 3.8.x 打砖块游戏 - 场景搭建详细指南 (1080x2160 竖屏版)

本文档将指导你如何在 Cocos Creator 编辑器中搭建 **1080x2160 (竖屏)** 分辨率的打砖块游戏。

## 1. 项目基础设置

### 1.1 分辨率设置
1. 点击顶部菜单 **Project (项目)** -> **Project Settings (项目设置)**。
2. 在左侧选择 **Project Data (项目数据)**。
3. 设置 **Design Width** 为 `1080`。
4. 设置 **Design Height** 为 `2160`。
5. 勾选 **Fit Width** (适配宽度)，建议同时勾选 **Fit Height** 或根据需求选择适配策略。

### 1.2 创建物理材质 (Physics Material)
为了让小球能够完全反弹且不损失速度，我们需要创建一个无摩擦、完全弹性的材质。
1. 在 **Assets (资源管理器)** 面板中，右键点击 -> **Create (创建)** -> **Physics Material (物理材质)**。
2. 命名为 `BouncyMaterial`。
3. 选中它，在 **Inspector (属性检查器)** 中设置：
   - **Friction (摩擦力)**: `0`
   - **Restitution (弹性系数)**: `1` (表示 100% 反弹)

---

## 2. 制作砖块预制体 (Brick Prefab)

1. **创建节点**: 在 **Hierarchy (层级管理器)** 中右键 -> **Create** -> **2D Object** -> **Sprite (单色)**，命名为 `Brick`。
2. **设置外观**: 在属性检查器中设置 `Content Size` 为 `80 x 30`。
3. **添加碰撞体**:
   - 点击 **Add Component** -> 搜索 `BoxCollider2D`。
   - 勾选 `Sensor`: **False**。
   - `Physics Material`: 拖入 `BouncyMaterial`。
4. **添加刚体**:
   - 点击 **Add Component** -> 搜索 `RigidBody2D`。
   - **Type**: `Static`。
5. **添加脚本**:
   - 点击 **Add Component** -> `Custom Script` -> 选择 `Brick`。
6. **保存为 Prefab**:
   - 拖动到 **Assets**，并从场景删除。

---

## 3. 搭建游戏场景 (Game Scene)

### 3.1 墙壁 (Walls)
我们需要三面墙（左、右、上）。
1. 在 `Canvas` 下创建一个空节点命名为 `Walls`。
2. **LeftWall**:
   - Position: `X = -540`, `Y = 0`.
   - Size: `20 x 2160` (高度填满屏幕).
   - 组件: `BoxCollider2D`, `RigidBody2D` (Static). 材质: `BouncyMaterial`.
3. **RightWall**:
   - Position: `X = 540`, `Y = 0`.
   - Size: `20 x 2160`.
   - 组件同上。
4. **TopWall**:
   - Position: `X = 0`, `Y = 1080`.
   - Size: `1080 x 20`.
   - 组件同上。

### 3.2 挡板 (Paddle)
1. 在 `Canvas` 下创建 Sprite，命名为 `Paddle`。
2. **外观**: Size `100 x 20`。
3. **位置**: `Y = -900` (放在屏幕底部区域).
4. **组件**:
   - `BoxCollider2D`: Size `100 x 20`, Material `BouncyMaterial`。
   - `RigidBody2D`: **Type** `Kinematic`.
   - `Paddle` 脚本:
     - `Speed`: `1` (或更高，如 1.5，适应更宽屏幕)。
     - `X Limit`: `490` (屏幕半宽 540 - 挡板半宽 50).

### 3.3 小球 (Ball)
1. 在 `Canvas` 下创建 Sprite (Circle)，命名为 `Ball`。
2. **外观**: Size `30 x 30`。
3. **组件**:
   - `CircleCollider2D`: Radius `15`, Material `BouncyMaterial`.
   - `RigidBody2D`: `Dynamic`, `Gravity Scale: 0`, `Fixed Rotation: true`, `Damping: 0`.
   - `Ball` 脚本:
     - `Speed`: `20` (分辨率变大，速度可能需要稍微调快).
     - `Min Y`: `-1100` (屏幕底边之下).

### 3.4 砖块容器 (BrickContainer)
1. 在 `Canvas` 下创建空节点 `BrickContainer`。
2. **布局**:
   - 位置设为 `Y = 600` (屏幕上方区域).
   - Add Component -> `Layout`。
   - **Type**: `GRID`。
   - **Resize Mode**: `CONTAINER`.
   - **Start Axis**: `HORIZONTAL`.
   - **Padding Left**: `95` (用于居中: (1080 - 890)/2 ≈ 95).
   - **Spacing X/Y**: `10`, `10`.
   - **Constraint**: `FIXED_COL`.
   - **Constraint Num**: `10`.

---

## 4. UI 界面搭建

### 4.1 HUD
1. `ScoreLabel`: 位置 `X = -450, Y = 1000` (左上角).
2. `LivesLabel`: 位置 `X = 450, Y = 1000` (右上角).

### 4.2 菜单
1. `StartMenu`, `GameOverMenu`, `GameWinMenu` 居中显示即可。
2. 背景最好做一个全屏遮罩 (Size 1080 x 2160)。

---

## 5. 逻辑绑定 (GameManager)
(同前)
1. 创建 `GameManager` 节点并挂载脚本。
2. 拖入所有对应的 Prefab、UI 节点。
3. 绑定按钮事件。

---

祝你开发愉快！
