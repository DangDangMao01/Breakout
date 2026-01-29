/**
 * Royal Match 风格金币飞行 - 使用示例
 */

cc.Class({
    extends: cc.Component,

    properties: {
        // 金币飞行组件
        coinFlyAnim: {
            default: null,
            type: cc.Component,
            tooltip: "CoinFlyAnimation_RoyalMatch 组件"
        },

        // 金币图标节点（顶部UI）
        coinIcon: {
            default: null,
            type: cc.Node,
            tooltip: "顶部金币图标"
        },

        // 金币数量标签
        coinLabel: {
            default: null,
            type: cc.Label,
            tooltip: "金币数量显示"
        },

        // 数字提示预制体（+79）
        numberPrefab: {
            default: null,
            type: cc.Prefab,
            tooltip: "数字提示预制体"
        }
    },

    onLoad() {
        this.currentCoins = 43031; // 初始金币数量
        this.updateCoinLabel();
    },

    /**
     * 示例1：完成关卡获得金币
     * 模拟 Royal Match 完成关卡后的金币飞行
     */
    onLevelComplete() {
        // 关卡奖励金币数量
        let rewardCoins = 79;

        // 从屏幕中心飞出
        let startPos = cc.v2(cc.winSize.width / 2, cc.winSize.height / 2);
        let endPos = this.coinIcon.convertToWorldSpaceAR(cc.v2(0, 0));

        // 显示数字提示 + 金币飞行
        this.showNumberHint(startPos, rewardCoins);

        // 延迟一点再飞金币
        this.scheduleOnce(() => {
            // 飞行金币（数量可以少于实际奖励，视觉效果）
            let visualCoins = Math.min(rewardCoins, 15);
            
            this.coinFlyAnim.flyCoins(startPos, endPos, visualCoins, () => {
                // 所有金币飞完后，增加金币数量
                this.addCoins(rewardCoins);
                
                // 播放目标节点的反馈动画
                this.coinFlyAnim.playCollectFeedback(this.coinIcon);
            });
        }, 0.3);
    },

    /**
     * 示例2：点击物品获得金币
     */
    onItemClick(itemNode) {
        let coinAmount = 50;
        
        this.coinFlyAnim.flyFromNodeToNode(
            itemNode, 
            this.coinIcon, 
            10, 
            () => {
                this.addCoins(coinAmount);
                this.coinFlyAnim.playCollectFeedback(this.coinIcon);
            }
        );
    },

    /**
     * 示例3：宝箱开启
     */
    onChestOpen(chestNode) {
        let coinAmount = 200;
        
        // 显示数字
        this.showNumberHint(
            chestNode.convertToWorldSpaceAR(cc.v2(0, 0)),
            coinAmount
        );

        // 延迟后飞金币
        this.scheduleOnce(() => {
            this.coinFlyAnim.flyFromNodeToNode(
                chestNode,
                this.coinIcon,
                20, // 视觉上飞20个金币
                () => {
                    this.addCoins(coinAmount);
                    this.coinFlyAnim.playCollectFeedback(this.coinIcon);
                }
            );
        }, 0.3);
    },

    /**
     * 示例4：连续获得金币（连击效果）
     */
    onComboReward() {
        let comboCount = 5;
        let coinsPerCombo = 30;

        for (let i = 0; i < comboCount; i++) {
            this.scheduleOnce(() => {
                let startPos = cc.v2(
                    cc.winSize.width / 2 + (Math.random() - 0.5) * 200,
                    cc.winSize.height / 2 + (Math.random() - 0.5) * 200
                );
                let endPos = this.coinIcon.convertToWorldSpaceAR(cc.v2(0, 0));

                this.coinFlyAnim.flyCoins(startPos, endPos, 5, () => {
                    this.addCoins(coinsPerCombo);
                    this.coinFlyAnim.playCollectFeedback(this.coinIcon);
                });
            }, i * 0.5);
        }
    },

    /**
     * 示例5：购买道具（金币飞出）
     */
    onBuyItem(itemNode, price) {
        if (this.currentCoins < price) {
            console.log("金币不足！");
            return;
        }

        // 反向飞行：从金币图标飞向物品
        let startPos = this.coinIcon.convertToWorldSpaceAR(cc.v2(0, 0));
        let endPos = itemNode.convertToWorldSpaceAR(cc.v2(0, 0));

        // 计算飞行的金币数量（视觉效果）
        let visualCoins = Math.min(Math.ceil(price / 10), 15);

        this.coinFlyAnim.flyCoins(startPos, endPos, visualCoins, () => {
            // 扣除金币
            this.addCoins(-price);
            
            // 购买成功
            console.log("购买成功！");
        });
    },

    /**
     * 显示数字提示（+79）
     */
    showNumberHint(worldPos, amount) {
        if (!this.numberPrefab) return;

        let numberNode = cc.instantiate(this.numberPrefab);
        numberNode.parent = this.node;
        numberNode.position = this.node.convertToNodeSpaceAR(worldPos);

        // 设置数字
        let label = numberNode.getComponent(cc.Label);
        if (label) {
            label.string = "+" + amount;
        }

        // 动画：向上飘 + 淡出
        numberNode.runAction(cc.sequence(
            cc.spawn(
                cc.moveBy(1.0, 0, 100).easing(cc.easeOut(2)),
                cc.sequence(
                    cc.delayTime(0.4),
                    cc.fadeOut(0.6)
                ),
                cc.scaleTo(0.3, 1.2).easing(cc.easeBackOut())
            ),
            cc.removeSelf()
        ));
    },

    /**
     * 增加金币数量
     */
    addCoins(amount) {
        this.currentCoins += amount;
        this.updateCoinLabel();

        // 数字变化动画
        if (this.coinLabel && amount > 0) {
            this.coinLabel.node.runAction(cc.sequence(
                cc.scaleTo(0.1, 1.2),
                cc.scaleTo(0.1, 1.0)
            ));
        }
    },

    /**
     * 更新金币显示
     */
    updateCoinLabel() {
        if (this.coinLabel) {
            // 格式化数字（43031 -> 43,031）
            this.coinLabel.string = this.formatNumber(this.currentCoins);
        }
    },

    /**
     * 格式化数字（添加千位分隔符）
     */
    formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
});
