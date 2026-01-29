# 金币飞行动画系统

Cocos Creator 金币飞行动画组件，支持单个/批量金币飞行，贝塞尔曲线轨迹，对象池优化。

---

## 📋 功能特性

- ✅ **贝塞尔曲线飞行** - 平滑的抛物线轨迹
- ✅ **批量飞行** - 支持一次飞多个金币
- ✅ **缩放动画** - 飞行过程中先变大再变小
- ✅ **旋转效果** - 金币旋转飞行（可选）
- ✅ **淡出效果** - 到达终点时淡出
- ✅ **音效支持** - 发射音效 + 收集音效
- ✅ **对象池优化** - 自动管理金币对象池
- ✅ **随机偏移** - 批量飞行时自动添加随机偏移
- ✅ **完成回调** - 单个/全部完成回调

---

## 🚀 快速开始

### 1. 创建金币预制体

1. 创建一个 Sprite 节点
2. 设置金币图片
3. 保存为预制体（Prefab）

### 2. 添加组件

1. 在场景中选择 Canvas 节点（或其他节点）
2. 添加 `CoinFlyAnimation` 组件
3. 拖拽金币预制体到 `coinPrefab` 属性

### 3. 调用飞行

```javascript
// 获取组件
let coinFlyAnim = this.node.getComponent('CoinFlyAnimation');

// 飞行10个金币
let startPos = cc.v2(100, 100);  // 起始位置
let endPos = cc.v2(500, 500);    // 结束位置

coinFlyAnim.flyCoins(startPos, endPos, 10, () => {
    console.log("所有金币飞行完成");
    // 增加金币数量
    this.addCoins(10);
});
```

---

## 📖 API 文档

### CoinFlyAnimation 组件

#### 属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| coinPrefab | cc.Prefab | null | 金币预制体（必须） |
| flyDuration | Number | 0.8 | 飞行时间（秒） |
| flyInterval | Number | 0.05 | 批量飞行间隔（秒） |
| curveOffset | cc.Vec2 | (0, 200) | 贝塞尔曲线控制点偏移 |
| scaleStart | Number | 1.0 | 起始缩放 |
| scaleMiddle | Number | 1.5 | 中间缩放（最大） |
| scaleEnd | Number | 0.5 | 结束缩放 |
| coinSound | cc.AudioClip | null | 发射音效 |
| collectSound | cc.AudioClip | null | 收集音效 |
| enableRotation | Boolean | true | 是否旋转 |
| rotationSpeed | Number | 360 | 旋转速度（度/秒） |

#### 方法

##### flyCoin(startPos, endPos, callback)

飞行单个金币

**参数**：
- `startPos` (cc.Vec2) - 起始位置（世界坐标）
- `endPos` (cc.Vec2) - 结束位置（世界坐标）
- `callback` (Function) - 完成回调

**示例**：
```javascript
coinFlyAnim.flyCoin(startPos, endPos, () => {
    console.log("金币飞行完成");
});
```

##### flyCoins(startPos, endPos, count, allCompleteCallback)

批量飞行金币

**参数**：
- `startPos` (cc.Vec2) - 起始位置（世界坐标）
- `endPos` (cc.Vec2) - 结束位置（世界坐标）
- `count` (Number) - 金币数量
- `allCompleteCallback` (Function) - 全部完成回调

**示例**：
```javascript
coinFlyAnim.flyCoins(startPos, endPos, 10, () => {
    console.log("所有金币飞行完成");
});
```

##### flyFromNodeToNode(startNode, endNode, count, callback)

从节点飞向节点

**参数**：
- `startNode` (cc.Node) - 起始节点
- `endNode` (cc.Node) - 结束节点
- `count` (Number) - 金币数量
- `callback` (Function) - 完成回调

**示例**：
```javascript
coinFlyAnim.flyFromNodeToNode(chestNode, coinIconNode, 5, () => {
    console.log("金币飞行完成");
});
```

##### stopAll()

停止所有飞行动画

**示例**：
```javascript
coinFlyAnim.stopAll();
```

##### getFlyingCount()

获取当前飞行中的金币数量

**返回**：Number

**示例**：
```javascript
let count = coinFlyAnim.getFlyingCount();
console.log("飞行中的金币：" + count);
```

---

## 🎮 使用示例

### 示例1：宝箱开启获得金币

```javascript
// 宝箱节点
let chestNode = this.node.getChildByName("Chest");
// UI金币图标节点
let coinIconNode = cc.find("Canvas/UI/CoinIcon");

// 飞行20个金币
this.coinFlyAnim.flyFromNodeToNode(chestNode, coinIconNode, 20, () => {
    // 增加金币数量
    this.playerCoins += 20;
    this.updateCoinUI();
});
```

### 示例2：击杀怪物掉落金币

```javascript
// 怪物死亡位置
let monsterPos = monster.node.convertToWorldSpaceAR(cc.v2(0, 0));
// UI金币图标位置
let coinIconPos = this.coinIcon.convertToWorldSpaceAR(cc.v2(0, 0));

// 根据怪物等级掉落不同数量金币
let coinCount = monster.level * 5;

this.coinFlyAnim.flyCoins(monsterPos, coinIconPos, coinCount, () => {
    this.addCoins(coinCount);
});
```

### 示例3：商店购买（金币飞出）

```javascript
// 从UI金币图标飞向商品
let coinIconPos = this.coinIcon.convertToWorldSpaceAR(cc.v2(0, 0));
let itemPos = itemNode.convertToWorldSpaceAR(cc.v2(0, 0));

// 反向飞行（金币飞出）
this.coinFlyAnim.flyCoins(coinIconPos, itemPos, price, () => {
    // 扣除金币
    this.playerCoins -= price;
    this.updateCoinUI();
    
    // 购买成功
    this.buyItem(itemId);
});
```

### 示例4：任务奖励领取

```javascript
// 任务按钮位置
let taskBtnPos = taskBtn.convertToWorldSpaceAR(cc.v2(0, 0));
// UI金币图标位置
let coinIconPos = this.coinIcon.convertToWorldSpaceAR(cc.v2(0, 0));

// 领取奖励
this.coinFlyAnim.flyCoins(taskBtnPos, coinIconPos, reward, () => {
    this.addCoins(reward);
    this.showToast("获得金币 +" + reward);
});
```

### 示例5：连续获得金币（连击效果）

```javascript
// 连续击杀，连续掉落金币
let comboCount = 5;
for (let i = 0; i < comboCount; i++) {
    this.scheduleOnce(() => {
        this.coinFlyAnim.flyCoins(monsterPos, coinIconPos, 3, () => {
            this.addCoins(3);
        });
    }, i * 0.3);
}
```

---

## 🎨 自定义配置

### 调整飞行轨迹

```javascript
// 更高的抛物线
this.coinFlyAnim.curveOffset = cc.v2(0, 300);

// 向左偏移的抛物线
this.coinFlyAnim.curveOffset = cc.v2(-100, 200);

// 向右偏移的抛物线
this.coinFlyAnim.curveOffset = cc.v2(100, 200);
```

### 调整飞行速度

```javascript
// 更快的飞行
this.coinFlyAnim.flyDuration = 0.5;

// 更慢的飞行
this.coinFlyAnim.flyDuration = 1.2;

// 更快的批量发射
this.coinFlyAnim.flyInterval = 0.02;
```

### 调整缩放效果

```javascript
// 更夸张的缩放
this.coinFlyAnim.scaleStart = 0.8;
this.coinFlyAnim.scaleMiddle = 2.0;
this.coinFlyAnim.scaleEnd = 0.3;

// 无缩放效果
this.coinFlyAnim.scaleStart = 1.0;
this.coinFlyAnim.scaleMiddle = 1.0;
this.coinFlyAnim.scaleEnd = 1.0;
```

### 禁用旋转

```javascript
this.coinFlyAnim.enableRotation = false;
```

---

## 🔧 高级用法

### 自定义金币样式

创建不同的金币预制体，动态切换：

```javascript
// 金币预制体
this.coinFlyAnim.coinPrefab = this.goldCoinPrefab;
this.coinFlyAnim.flyCoins(startPos, endPos, 10);

// 钻石预制体
this.coinFlyAnim.coinPrefab = this.diamondPrefab;
this.coinFlyAnim.flyCoins(startPos, endPos, 5);
```

### 监听飞行进度

```javascript
let totalCoins = 10;
let collectedCoins = 0;

for (let i = 0; i < totalCoins; i++) {
    this.scheduleOnce(() => {
        this.coinFlyAnim.flyCoin(startPos, endPos, () => {
            collectedCoins++;
            let progress = collectedCoins / totalCoins;
            console.log("进度：" + (progress * 100) + "%");
            
            if (progress === 1.0) {
                console.log("全部收集完成");
            }
        });
    }, i * 0.05);
}
```

### 性能优化

```javascript
// 大量金币时，增加间隔，减少同时飞行的数量
if (coinCount > 50) {
    this.coinFlyAnim.flyInterval = 0.1;
}

// 或者分批飞行
let batchSize = 20;
let batches = Math.ceil(coinCount / batchSize);

for (let i = 0; i < batches; i++) {
    this.scheduleOnce(() => {
        let count = Math.min(batchSize, coinCount - i * batchSize);
        this.coinFlyAnim.flyCoins(startPos, endPos, count);
    }, i * 0.5);
}
```

---

## 🐛 常见问题

### Q1: 金币不显示？

**A**: 检查以下几点：
1. 是否设置了 `coinPrefab`？
2. 金币预制体是否有 Sprite 组件和图片？
3. 起始位置和结束位置是否正确？

### Q2: 金币飞行轨迹不对？

**A**: 调整 `curveOffset` 属性：
- Y 值越大，抛物线越高
- X 值控制左右偏移

### Q3: 金币飞行太快/太慢？

**A**: 调整 `flyDuration` 属性：
- 默认 0.8 秒
- 可以设置为 0.5 ~ 1.5 秒

### Q4: 批量飞行时金币重叠？

**A**: 组件会自动添加随机偏移，如果还是重叠：
- 增加 `flyInterval`（发射间隔）
- 或者手动添加更大的随机偏移

### Q5: 性能问题？

**A**: 
- 组件已使用对象池优化
- 避免同时飞行超过 100 个金币
- 可以分批飞行

---

## 📝 注意事项

1. **坐标系统**：
   - `flyCoin()` 和 `flyCoins()` 使用世界坐标
   - `flyFromNodeToNode()` 自动转换坐标

2. **对象池**：
   - 组件自动管理对象池
   - 不需要手动创建/销毁金币

3. **音效**：
   - 音效是可选的
   - 建议使用短音效（< 0.5秒）

4. **性能**：
   - 单次飞行建议不超过 50 个金币
   - 大量金币建议分批飞行

---

## 🎉 完整示例场景

查看 `CoinFlyExample.js` 获取完整的使用示例，包括：
- 单个金币飞行
- 批量金币飞行
- 节点到节点飞行
- 大量金币飞行
- 连续飞行
- 随机位置飞行

---

**创建时间**: 2026-01-27  
**Cocos Creator 版本**: 2.x / 3.x  
**作者**: Kiro AI Assistant
