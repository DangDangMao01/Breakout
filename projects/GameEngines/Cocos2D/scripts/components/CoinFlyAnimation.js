/**
 * 金币飞行动画组件
 * 
 * 功能：
 * - 金币从起点飞向终点（贝塞尔曲线）
 * - 支持批量金币飞行
 * - 支持音效和粒子效果
 * - 飞行完成回调
 * 
 * 使用方法：
 * 1. 将此脚本挂载到场景中的任意节点（建议挂到 Canvas）
 * 2. 设置金币预制体（coinPrefab）
 * 3. 调用 flyCoins() 方法
 * 
 * 示例：
 * this.coinFlyAnim.flyCoins(startPos, endPos, 10, () => {
 *     console.log("金币飞行完成");
 * });
 */

cc.Class({
    extends: cc.Component,

    properties: {
        // 金币预制体
        coinPrefab: {
            default: null,
            type: cc.Prefab,
            tooltip: "金币预制体（必须）"
        },

        // 飞行时间（秒）
        flyDuration: {
            default: 0.8,
            tooltip: "单个金币飞行时间"
        },

        // 批量飞行时的间隔（秒）
        flyInterval: {
            default: 0.05,
            tooltip: "多个金币之间的发射间隔"
        },

        // 贝塞尔曲线控制点偏移
        curveOffset: {
            default: cc.v2(0, 200),
            tooltip: "贝塞尔曲线的控制点偏移（制造抛物线效果）"
        },

        // 飞行过程中的缩放
        scaleStart: {
            default: 1.0,
            tooltip: "起始缩放"
        },

        scaleMiddle: {
            default: 1.5,
            tooltip: "中间缩放（最大）"
        },

        scaleEnd: {
            default: 0.5,
            tooltip: "结束缩放"
        },

        // 音效
        coinSound: {
            default: null,
            type: cc.AudioClip,
            tooltip: "金币飞行音效（可选）"
        },

        collectSound: {
            default: null,
            type: cc.AudioClip,
            tooltip: "金币收集音效（可选）"
        },

        // 是否启用旋转
        enableRotation: {
            default: true,
            tooltip: "金币飞行时是否旋转"
        },

        // 旋转速度（度/秒）
        rotationSpeed: {
            default: 360,
            tooltip: "旋转速度"
        }
    },

    onLoad() {
        // 金币池
        this.coinPool = new cc.NodePool();
        
        // 飞行中的金币计数
        this.flyingCoins = 0;
    },

    /**
     * 飞行单个金币
     * @param {cc.Vec2} startPos - 起始位置（世界坐标）
     * @param {cc.Vec2} endPos - 结束位置（世界坐标）
     * @param {Function} callback - 完成回调
     */
    flyCoin(startPos, endPos, callback) {
        if (!this.coinPrefab) {
            cc.error("CoinFlyAnimation: coinPrefab 未设置！");
            return;
        }

        // 从对象池获取或创建金币
        let coin = this.getCoin();
        coin.parent = this.node;
        coin.position = this.node.convertToNodeSpaceAR(startPos);
        coin.scale = this.scaleStart;
        coin.opacity = 255;

        this.flyingCoins++;

        // 播放发射音效
        if (this.coinSound) {
            cc.audioEngine.playEffect(this.coinSound, false);
        }

        // 计算贝塞尔曲线控制点
        let startPosLocal = coin.position;
        let endPosLocal = this.node.convertToNodeSpaceAR(endPos);
        
        // 控制点在起点和终点中间，向上偏移
        let controlPos = cc.v2(
            (startPosLocal.x + endPosLocal.x) / 2 + this.curveOffset.x,
            (startPosLocal.y + endPosLocal.y) / 2 + this.curveOffset.y
        );

        // 创建动画序列
        let actions = [];

        // 1. 贝塞尔曲线移动
        let bezierMove = cc.bezierTo(this.flyDuration, [
            controlPos,
            controlPos,
            endPosLocal
        ]);

        // 2. 缩放动画（先变大再变小）
        let scaleAction = cc.sequence(
            cc.scaleTo(this.flyDuration * 0.3, this.scaleMiddle),
            cc.scaleTo(this.flyDuration * 0.7, this.scaleEnd)
        );

        // 3. 旋转动画（可选）
        let rotateAction = null;
        if (this.enableRotation) {
            let totalRotation = this.rotationSpeed * this.flyDuration;
            rotateAction = cc.rotateBy(this.flyDuration, totalRotation);
        }

        // 4. 淡出动画（最后阶段）
        let fadeAction = cc.sequence(
            cc.delayTime(this.flyDuration * 0.7),
            cc.fadeOut(this.flyDuration * 0.3)
        );

        // 组合所有动画
        let spawn = this.enableRotation 
            ? cc.spawn(bezierMove, scaleAction, rotateAction, fadeAction)
            : cc.spawn(bezierMove, scaleAction, fadeAction);

        // 完成回调
        let finish = cc.callFunc(() => {
            this.flyingCoins--;
            this.recycleCoin(coin);

            // 播放收集音效
            if (this.collectSound) {
                cc.audioEngine.playEffect(this.collectSound, false);
            }

            if (callback) {
                callback();
            }
        });

        // 执行动画
        coin.runAction(cc.sequence(spawn, finish));
    },

    /**
     * 批量飞行金币
     * @param {cc.Vec2} startPos - 起始位置（世界坐标）
     * @param {cc.Vec2} endPos - 结束位置（世界坐标）
     * @param {Number} count - 金币数量
     * @param {Function} allCompleteCallback - 全部完成回调
     */
    flyCoins(startPos, endPos, count, allCompleteCallback) {
        let completedCount = 0;

        for (let i = 0; i < count; i++) {
            // 延迟发射，制造连续效果
            this.scheduleOnce(() => {
                // 添加随机偏移，让金币不完全重叠
                let randomOffset = cc.v2(
                    Math.random() * 40 - 20,
                    Math.random() * 40 - 20
                );
                let randomStartPos = startPos.add(randomOffset);

                this.flyCoin(randomStartPos, endPos, () => {
                    completedCount++;
                    
                    // 所有金币都飞完了
                    if (completedCount === count && allCompleteCallback) {
                        allCompleteCallback();
                    }
                });
            }, i * this.flyInterval);
        }
    },

    /**
     * 从节点飞向节点
     * @param {cc.Node} startNode - 起始节点
     * @param {cc.Node} endNode - 结束节点
     * @param {Number} count - 金币数量
     * @param {Function} callback - 完成回调
     */
    flyFromNodeToNode(startNode, endNode, count, callback) {
        if (!startNode || !endNode) {
            cc.error("CoinFlyAnimation: startNode 或 endNode 为空！");
            return;
        }

        let startPos = startNode.convertToWorldSpaceAR(cc.v2(0, 0));
        let endPos = endNode.convertToWorldSpaceAR(cc.v2(0, 0));

        this.flyCoins(startPos, endPos, count, callback);
    },

    /**
     * 从对象池获取金币
     */
    getCoin() {
        let coin = null;
        
        if (this.coinPool.size() > 0) {
            coin = this.coinPool.get();
        } else {
            coin = cc.instantiate(this.coinPrefab);
        }

        return coin;
    },

    /**
     * 回收金币到对象池
     */
    recycleCoin(coin) {
        this.coinPool.put(coin);
    },

    /**
     * 停止所有飞行动画
     */
    stopAll() {
        this.unscheduleAllCallbacks();
        this.node.children.forEach(child => {
            child.stopAllActions();
            this.recycleCoin(child);
        });
        this.flyingCoins = 0;
    },

    /**
     * 获取当前飞行中的金币数量
     */
    getFlyingCount() {
        return this.flyingCoins;
    },

    onDestroy() {
        this.stopAll();
        this.coinPool.clear();
    }
});
