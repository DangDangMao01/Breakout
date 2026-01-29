/**
 * 金币飞行动画 - 使用示例
 * 
 * 将此脚本挂载到测试场景中，演示各种金币飞行效果
 */

cc.Class({
    extends: cc.Component,

    properties: {
        // 金币飞行动画组件
        coinFlyAnim: {
            default: null,
            type: cc.Component,
            tooltip: "CoinFlyAnimation 组件"
        },

        // 起始节点（比如宝箱、怪物）
        startNode: {
            default: null,
            type: cc.Node,
            tooltip: "金币起始位置节点"
        },

        // 结束节点（比如UI金币图标）
        endNode: {
            default: null,
            type: cc.Node,
            tooltip: "金币结束位置节点"
        },

        // 金币数量标签
        coinCountLabel: {
            default: null,
            type: cc.Label,
            tooltip: "显示金币数量的标签"
        }
    },

    onLoad() {
        // 当前金币数量
        this.currentCoins = 0;
        this.updateCoinLabel();
    },

    /**
     * 示例1：基础飞行（单个金币）
     */
    example1_SingleCoin() {
        if (!this.checkComponents()) return;

        let startPos = this.startNode.convertToWorldSpaceAR(cc.v2(0, 0));
        let endPos = this.endNode.convertToWorldSpaceAR(cc.v2(0, 0));

        this.coinFlyAnim.flyCoin(startPos, endPos, () => {
            console.log("单个金币飞行完成");
            this.addCoins(1);
        });
    },

    /**
     * 示例2：批量飞行（10个金币）
     */
    example2_MultipleCoins() {
        if (!this.checkComponents()) return;

        let startPos = this.startNode.convertToWorldSpaceAR(cc.v2(0, 0));
        let endPos = this.endNode.convertToWorldSpaceAR(cc.v2(0, 0));

        this.coinFlyAnim.flyCoins(startPos, endPos, 10, () => {
            console.log("所有金币飞行完成");
            this.addCoins(10);
        });
    },

    /**
     * 示例3：从节点到节点
     */
    example3_NodeToNode() {
        if (!this.checkComponents()) return;

        this.coinFlyAnim.flyFromNodeToNode(this.startNode, this.endNode, 5, () => {
            console.log("节点到节点飞行完成");
            this.addCoins(5);
        });
    },

    /**
     * 示例4：大量金币（50个）
     */
    example4_ManyCoins() {
        if (!this.checkComponents()) return;

        let startPos = this.startNode.convertToWorldSpaceAR(cc.v2(0, 0));
        let endPos = this.endNode.convertToWorldSpaceAR(cc.v2(0, 0));

        this.coinFlyAnim.flyCoins(startPos, endPos, 50, () => {
            console.log("大量金币飞行完成");
            this.addCoins(50);
        });
    },

    /**
     * 示例5：连续飞行（模拟连续获得金币）
     */
    example5_ContinuousFly() {
        if (!this.checkComponents()) return;

        // 每隔1秒飞5个金币，持续5次
        let times = 5;
        let count = 0;

        let flyInterval = setInterval(() => {
            count++;
            
            this.coinFlyAnim.flyFromNodeToNode(this.startNode, this.endNode, 5, () => {
                this.addCoins(5);
            });

            if (count >= times) {
                clearInterval(flyInterval);
                console.log("连续飞行完成");
            }
        }, 1000);
    },

    /**
     * 示例6：随机位置飞行
     */
    example6_RandomPositions() {
        if (!this.checkComponents()) return;

        let endPos = this.endNode.convertToWorldSpaceAR(cc.v2(0, 0));

        // 从屏幕随机位置飞出10个金币
        for (let i = 0; i < 10; i++) {
            this.scheduleOnce(() => {
                let randomX = Math.random() * cc.winSize.width;
                let randomY = Math.random() * cc.winSize.height;
                let startPos = cc.v2(randomX, randomY);

                this.coinFlyAnim.flyCoin(startPos, endPos, () => {
                    this.addCoins(1);
                });
            }, i * 0.1);
        }
    },

    /**
     * 检查组件是否设置
     */
    checkComponents() {
        if (!this.coinFlyAnim) {
            cc.error("请设置 coinFlyAnim 组件！");
            return false;
        }
        if (!this.startNode || !this.endNode) {
            cc.error("请设置 startNode 和 endNode！");
            return false;
        }
        return true;
    },

    /**
     * 增加金币数量
     */
    addCoins(amount) {
        this.currentCoins += amount;
        this.updateCoinLabel();
    },

    /**
     * 更新金币数量显示
     */
    updateCoinLabel() {
        if (this.coinCountLabel) {
            this.coinCountLabel.string = this.currentCoins.toString();
        }
    },

    /**
     * 重置金币数量
     */
    resetCoins() {
        this.currentCoins = 0;
        this.updateCoinLabel();
    }
});
