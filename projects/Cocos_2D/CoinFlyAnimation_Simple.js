// 金币飞行动画 - 简化版（兼容 Cocos Creator 2.x）

cc.Class({
    extends: cc.Component,

    properties: {
        // 金币预制体
        coinPrefab: {
            default: null,
            type: cc.Prefab
        },

        // 飞行时间
        flyDuration: 0.8,

        // 批量间隔
        batchInterval: 0.05
    },

    onLoad: function() {
        this.coinPool = new cc.NodePool();
    },

    /**
     * 金币飞行
     * @param {cc.Vec2} startPos - 起始位置（世界坐标）
     * @param {cc.Vec2} endPos - 结束位置（世界坐标）
     * @param {Number} count - 金币数量
     * @param {Function} callback - 完成回调
     */
    flyCoins: function(startPos, endPos, count, callback) {
        if (!this.coinPrefab) {
            cc.error("请设置 coinPrefab！");
            return;
        }

        var self = this;
        var completedCount = 0;

        for (var i = 0; i < count; i++) {
            (function(index) {
                self.scheduleOnce(function() {
                    self.flySingleCoin(startPos, endPos, function() {
                        completedCount++;
                        if (completedCount === count && callback) {
                            callback();
                        }
                    });
                }, index * self.batchInterval);
            })(i);
        }
    },

    /**
     * 飞行单个金币
     */
    flySingleCoin: function(startPos, endPos, callback) {
        var coin = this.getCoin();
        coin.parent = this.node;
        coin.position = this.node.convertToNodeSpaceAR(startPos);
        coin.scale = 0.8;
        coin.opacity = 255;

        var startPosLocal = coin.position;
        var endPosLocal = this.node.convertToNodeSpaceAR(endPos);

        // 贝塞尔曲线控制点
        var controlPoint1 = cc.v2(
            (startPosLocal.x + endPosLocal.x) / 2,
            Math.max(startPosLocal.y, endPosLocal.y) + 150
        );
        var controlPoint2 = cc.v2(
            (startPosLocal.x + endPosLocal.x) / 2 + 50,
            (startPosLocal.y + endPosLocal.y) / 2 + 50
        );

        var self = this;

        // 飞行动画
        var flyAction = cc.spawn(
            // 贝塞尔曲线移动
            cc.bezierTo(this.flyDuration, [
                controlPoint1,
                controlPoint2,
                endPosLocal
            ]),
            // 缩放
            cc.scaleTo(this.flyDuration, 0.5),
            // 旋转
            cc.rotateBy(this.flyDuration, 360),
            // 淡出
            cc.sequence(
                cc.delayTime(this.flyDuration * 0.7),
                cc.fadeOut(this.flyDuration * 0.3)
            )
        );

        // 完成回调
        var finishAction = cc.callFunc(function() {
            self.recycleCoin(coin);
            if (callback) {
                callback();
            }
        });

        // 执行动画
        coin.runAction(cc.sequence(flyAction, finishAction));
    },

    /**
     * 从节点飞向节点
     */
    flyFromNodeToNode: function(startNode, endNode, count, callback) {
        if (!startNode || !endNode) {
            cc.error("startNode 或 endNode 为空！");
            return;
        }

        var startPos = startNode.convertToWorldSpaceAR(cc.v2(0, 0));
        var endPos = endNode.convertToWorldSpaceAR(cc.v2(0, 0));

        this.flyCoins(startPos, endPos, count, callback);
    },

    getCoin: function() {
        var coin = null;
        if (this.coinPool.size() > 0) {
            coin = this.coinPool.get();
        } else {
            coin = cc.instantiate(this.coinPrefab);
        }
        return coin;
    },

    recycleCoin: function(coin) {
        this.coinPool.put(coin);
    },

    onDestroy: function() {
        this.coinPool.clear();
    }
});
