# TestButton 配置说明

## 节点结构
```
Canvas
├── CoinManager (挂载 CoinFlyAnimation_RoyalMatch)
├── CoinIcon (金币图标)
└── TestButton (测试按钮) ← 我们要配置这个
```

---

## TestButton 需要的组件

TestButton 节点需要 **2 个组件**：

### 1️⃣ Button 组件（Cocos Creator 自带）

这是 Cocos 的 UI 组件，用于处理点击事件。

#### 如何添加：
1. 选中 `TestButton` 节点
2. 点击 **添加组件**
3. 选择 **UI 组件 → Button**

#### 属性设置：
| 属性 | 值 | 说明 |
|------|-----|------|
| **Target** | TestButton | 点击目标（自己） |
| **Interactable** | ✅ 勾选 | 是否可交互 |
| **Transition** | SCALE | 点击时的过渡效果 |
| **Duration** | 0.1 | 过渡时间 |
| **Zoom Scale** | 1.1 | 缩放比例 |

#### 截图示例：
```
Button 组件
├─ Target: TestButton
├─ Interactable: ✅
├─ Transition: SCALE
├─ Duration: 0.1
└─ Zoom Scale: 1.1
```

---

### 2️⃣ onChestOpen 脚本（你的自定义脚本）

这是你创建的脚本，用于触发金币飞行。

#### 脚本代码（CoinTest.js）：
```javascript
cc.Class({
    extends: cc.Component,

    properties: {
        coinFlyAnim: {
            default: null,
            type: cc.Component,
            tooltip: "CoinFlyAnimation 组件"
        },
        coinIcon: {
            default: null,
            type: cc.Node,
            tooltip: "金币图标节点"
        },
        coinAmount: {
            default: 100,
            tooltip: "金币数量"
        }
    },

    onLoad() {
        // 绑定按钮点击事件
        this.node.on('click', this.onChestOpen, this);
    },

    onChestOpen() {
        console.log("宝箱打开！");
        
        if (!this.coinFlyAnim || !this.coinIcon) {
            console.error("组件未设置！");
            return;
        }

        // 获取位置
        let startPos = this.node.convertToWorldSpaceAR(cc.v2(0, 0));
        let endPos = this.coinIcon.convertToWorldSpaceAR(cc.v2(0, 0));

        // 飞行金币
        this.coinFlyAnim.flyCoins(startPos, endPos, 10, () => {
            console.log("金币飞行完成！");
            
            // 金币图标反馈
            this.coinIcon.runAction(cc.sequence(
                cc.scaleTo(0.1, 1.2),
                cc.scaleTo(0.1, 1.0)
            ));
        });
    }
});
```

#### 属性设置：
| 属性 | 拖拽的节点 | 说明 |
|------|-----------|------|
| **Coin Fly Anim** | CoinManager | 金币飞行组件 |
| **Coin Icon** | CoinIcon | 金币图标节点 |
| **Coin Amount** | 100 | 金币数量 |

---

## 完整配置步骤

### 步骤 1: 添加 Button 组件
1. 选中 `TestButton` 节点
2. 点击 **添加组件**
3. 选择 **UI 组件 → Button**
4. 设置：
   - Target: TestButton
   - Interactable: ✅
   - Transition: SCALE

### 步骤 2: 添加 Sprite 组件（如果没有）
1. 如果 TestButton 没有图片，添加 **Sprite** 组件
2. 拖拽一个按钮图片到 **SpriteFrame**

### 步骤 3: 添加 onChestOpen 脚本
1. 点击 **添加组件**
2. 选择 **自定义组件 → onChestOpen**（或你的脚本名）
3. 拖拽节点到属性：
   - Coin Fly Anim → CoinManager
   - Coin Icon → CoinIcon
   - Coin Amount → 100

### 步骤 4: 测试
1. 点击 **运行** 按钮（Ctrl+P）
2. 点击 TestButton
3. 观察金币飞行效果

---

## 常见问题

### Q1: 点击按钮没反应？

**检查清单**：
- [ ] Button 组件的 `Interactable` 是否勾选？
- [ ] 按钮是否有 Sprite 组件和图片？
- [ ] 按钮的 Size 是否太小？（建议 120x60）
- [ ] 按钮是否被其他节点遮挡？

**调试方法**：
```javascript
onLoad() {
    console.log("脚本已加载");
    this.node.on('click', () => {
        console.log("按钮被点击！");
    });
}
```

### Q2: 控制台显示 "组件未设置"？

**原因**：onChestOpen 脚本的属性没有拖拽节点

**解决方案**：
1. 选中 TestButton
2. 找到 onChestOpen 组件
3. 拖拽对应节点到属性

### Q3: 金币不飞？

**检查**：
1. CoinManager 是否设置了 Coin Prefab？
2. 控制台有什么错误信息？

---

## 属性检查器截图示例

### TestButton 节点应该有这些组件：

```
TestButton (节点)
│
├─ Node (节点属性)
│  ├─ Position: (0, -200)
│  └─ Size: (120, 60)
│
├─ Sprite (渲染组件)
│  └─ SpriteFrame: button_normal
│
├─ Button (UI 组件)
│  ├─ Target: TestButton
│  ├─ Interactable: ✅
│  ├─ Transition: SCALE
│  └─ Zoom Scale: 1.1
│
└─ onChestOpen (自定义脚本)
   ├─ Coin Fly Anim: CoinManager
   ├─ Coin Icon: CoinIcon
   └─ Coin Amount: 100
```

---

## 快速检查命令

在控制台输入以下代码检查配置：

```javascript
// 检查 TestButton
let btn = cc.find("Canvas/TestButton");
console.log("TestButton 存在:", !!btn);
console.log("Button 组件:", btn.getComponent(cc.Button));
console.log("自定义脚本:", btn.getComponent("onChestOpen"));

// 检查 CoinManager
let manager = cc.find("Canvas/CoinManager");
console.log("CoinManager 存在:", !!manager);
console.log("金币飞行组件:", manager.getComponent("CoinFlyAnimation_RoyalMatch"));
```

---

## 总结

TestButton 需要：
1. ✅ Button 组件（Cocos 自带）
2. ✅ Sprite 组件（显示按钮图片）
3. ✅ onChestOpen 脚本（触发金币飞行）

配置完成后，点击按钮就能看到金币飞行效果了！

---

**创建时间**: 2026-01-27  
**用途**: TestButton 配置说明
