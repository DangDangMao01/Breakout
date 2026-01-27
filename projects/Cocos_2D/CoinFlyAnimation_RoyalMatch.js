/**
 * 金币飞行动画 - Royal Match 风格
 * 
 * 特点：
 * - 金币先向上弹起，然后飞向目标
 * - 弹性缓动效果
 * - 3D 旋转效果
 * - 批量飞行时呈扇形散开
 * - 到达目标时有缩放反馈
 */

cc.Class({
    extends: cc.Component,

    properties: {
        // 金币预制体
        coinPrefab: {
            default: null,
            type: cc.Prefab,
            tooltip: "金币预制体"
        },

        // 飞行参数
        popUpHeight: {
            default: 100,
            tooltip: "初始弹起高度"
        },

        popUpDuration: {
            default: 0.3,
            tooltip: "弹起阶段时间"
        },

        flyDuration: {
            default: 0.6,
            tooltip: "飞行阶段时间"
        },

        batchInterval: {
            default: 0.04,
            tooltip: "批量发射间隔"
        },

        // 散开参数
        spreadRadius: {
            default: 80,
            tooltip: "批量飞行时的散开半径"
        },

        // 缩放参数
        scalePopUp: {
            default: 1.3,
            tooltip: "弹起时的缩放"
        },

        scaleFly: {
            default: 1.0,
            tooltip: "飞行时的缩放"
        },

        scaleEnd: {
            default: 0.6,
            tooltip: "到达时的缩放"
        },

        // 旋转参数
        rotationSpeed: {
            default: 720,
            tooltip: "旋转速度（度/秒）"
        },

        // 音效
        popSound: {
            default: null,
            type: cc.AudioClip,
            tooltip: "弹起音效"
        },

        flySound: {
            default: null,
            type: cc.AudioClip,
            tooltip: "飞行音效"
        },

        collectSound: {
            default: null,
            type: cc.AudioClip,
            tooltip: "收集音效"
        }
    },

    onLoad() {
        this.coinPool = new cc.NodePool();
        this.flyingCoins = 0;
    },

    /**
     * Royal Match 风格的金币飞行
     * @param {cc.Vec2} startPos - 起始位置（世界坐标）
     * @param {cc.Vec2} endPos - 结束位置（世界坐标）
     * @param {Number} count - 金币数量
     * @param {Function} callback - 完成回调
     */
    flyCoins(startPos, endPos, count, callback) {
        if (!this.coinPrefab) {
            cc.error("请设置 coinPrefab！");
            return;
        }

        let completedCount = 0;

        // 计算散开的角度
        let angleStep = count > 1 ? 180 / (count - 1) : 0;
        let startAngle = -90;

        for (let i = 0; i < count; i++) {
            this.scheduleOnce(() => {
                // 计算散开位置
                let angle = startAngle + angleStep * i;
                let radian = angle * Math.PI / 180;
                let offsetX = Math.cos(radian) * this.spreadRadius;
                let offsetY = Math.sin(radian) * this.spreadRadius;

                // 添加随机偏移
                offsetX += (Math.random() - 0.5) * 30;
                offsetY += (Math.random() - 0.5) * 30;

                let popUpPos = cc.v2(
                    startPos.x + offsetX,
                    startPos.y + offsetY
                );

                this.flySingleCoin(startPos, popUpPos, endPos, () => {
                    completedCount++;
                    if (completedCount === count && callback) {
                        callback();
                    }
                });
            }, i * this.batchInterval);
        }
    },

    /**
     * 飞行单个金币（Royal Match 风格）
     */
    flySingleCoin(startPos, popUpPos, endPos, callback) {
        let coin = this.getCoin();
        coin.parent = this.node;
        coin.position = this.node.convertToNodeSpaceAR(startPos);
        coin.scale = 0.8;
        coin.opacity = 255;
        coin.angle = 0;

        this.flyingCoins++;

        // 播放弹起音效
        if (this.popSound) {
            cc.audioEngine.playEffect(this.popSound, false);
        }

        let startPosLocal = coin.position;
        let popUpPosLocal = this.node.convertToNodeSpaceAR(popUpPos);
        let endPosLocal = this.node.convertToNodeSpaceAR(endPos);

        // 阶段1：弹起（向上+散开）
        let popUpActions = cc.spawn(
            // 移动到弹起位置
            cc.moveTo(this.popUpDuration, popUpPosLocal).easing(cc.easeBackOut()),
            // 缩放变大
            cc.scaleTo(this.popUpDuration, this.scalePopUp).easing(cc.easeBackOut()),
            // 旋转
            cc.rotateBy(this.popUpDuration, this.rotationSpeed * this.popUpDuration / 360 * 180)
        );

        // 阶段2：飞行（贝塞尔曲线飞向目标）
        let controlPoint1 = cc.v2(
            (popUpPosLocal.x + endPosLocal.x) / 2,
            Math.max(popUpPosLocal.y, endPosLocal.y) + 100
        );
        let controlPoint2 = cc.v2(
            (popUpPosLocal.x + endPosLocal.x) / 2 + 50,
            (popUpPosLocal.y + endPosLocal.y) / 2 + 50
        );

        let flyActions = cc.spawn(
            // 贝塞尔曲线移动
            cc.bezierTo(this.flyDuration, [
                controlPoint1,
                controlPoint2,
                endPosLocal
            ]).easing(cc.easeInOut(2)),
            // 缩放变小
            cc.scaleTo(this.flyDuration, this.scaleEnd).easing(cc.easeIn(2)),
            // 继续旋转
            cc.rotateBy(this.flyDuration, this.rotationSpeed * this.flyDuration / 360 * 360),
            // 最后淡出
            cc.sequence(
                cc.delayTime(this.flyDuration * 0.7),
                cc.fadeOut(this.flyDuration * 0.3)
            )
        );

        // 播放飞行音效
        let playSoundAction = cc.callFunc(() => {
            if (this.flySound) {
                cc.audioEngine.playEffect(this.flySound, false);
            }
        });

        // 完成回调
        let finishAction = cc.callFunc(() => {
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

        // 执行完整动画序列
        coin.runAction(cc.sequence(
            popUpActions,
            playSoundAction,
            flyActions,
            finishAction
        ));
    },

    /**
     * 从节点飞向节点（Royal Match 风格）
     */
    flyFromNodeToNode(startNode, endNode, count, callback) {
        if (!startNode || !endNode) {
            cc.error("startNode 或 endNode 为空！");
            return;
        }

        let startPos = startNode.convertToWorldSpaceAR(cc.v2(0, 0));
        let endPos = endNode.convertToWorldSpaceAR(cc.v2(0, 0));

        this.flyCoins(startPos, endPos, count, callback);
    },

    /**
     * 带数字提示的金币飞行
     * @param {cc.Node} startNode - 起始节点
     * @param {cc.Node} endNode - 结束节点
     * @param {Number} count - 金币数量
     * @param {cc.Prefab} numberPrefab - 数字提示预制体（可选）
     * @param {Function} callback - 完成回调
     */
    flyWithNumber(startNode, endNode, count, numberPrefab, callback) {
        // 显示数字提示（+79）
        if (numberPrefab) {
            let numberNode = cc.instantiate(numberPrefab);
            numberNode.parent = this.node;
            numberNode.position = this.node.convertToNodeSpaceAR(
                startNode.convertToWorldSpaceAR(cc.v2(0, 0))
            );

            // 数字标签
            let label = numberNode.getComponent(cc.Label);
            if (label) {
                label.string = "+" + count;
            }

            // 数字动画：向上飘+淡出
            numberNode.runAction(cc.sequence(
                cc.spawn(
                    cc.moveBy(0.8, 0, 80).easing(cc.easeOut(2)),
                    cc.sequence(
                        cc.delayTime(0.3),
                        cc.fadeOut(0.5)
                    )
                ),
                cc.removeSelf()
            ));
        }

        // 延迟一点再飞金币，让数字先显示
        this.scheduleOnce(() => {
            this.flyFromNodeToNode(startNode, endNode, count, callback);
        }, 0.2);
    },

    /**
     * 目标节点的收集反馈动画
     * @param {cc.Node} targetNode - 目标节点（金币图标）
     */
    playCollectFeedback(targetNode) {
        if (!targetNode) return;

        // 缩放反馈
        targetNode.runAction(cc.sequence(
            cc.scaleTo(0.1, 1.3),
            cc.scaleTo(0.1, 1.0)
        ));

        // 可以添加粒子效果、闪光等
    },

    getCoin() {
        let coin = null;
        if (this.coinPool.size() > 0) {
            coin = this.coinPool.get();
        } else {
            coin = cc.instantiate(this.coinPrefab);
        }
        return coin;
    },

    recycleCoin(coin) {
        this.coinPool.put(coin);
    },

    stopAll() {
        this.unscheduleAllCallbacks();
        this.node.children.forEach(child => {
            child.stopAllActions();
            this.recycleCoin(child);
        });
        this.flyingCoins = 0;
    },

    getFlyingCount() {
        return this.flyingCoins;
    },

    onDestroy() {
        this.stopAll();
        this.coinPool.clear();
    }
});
