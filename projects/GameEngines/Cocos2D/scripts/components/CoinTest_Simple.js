// 金币测试脚本 - 简化版

cc.Class({
    extends: cc.Component,

    properties: {
        // 金币飞行组件
        coinFlyAnim: cc.Component,
        
        // 金币图标
        coinIcon: cc.Node,
        
        // 测试按钮
        testButton: cc.Node
    },

    onLoad: function() {
        console.log("=== CoinTest 初始化 ===");
        
        // 检查组件
        if (!this.coinFlyAnim) {
            cc.error("❌ coinFlyAnim 未设置！");
        }
        if (!this.coinIcon) {
            cc.error("❌ coinIcon 未设置！");
        }
        if (!this.testButton) {
            cc.error("❌ testButton 未设置！");
        }

        // 绑定按钮点击事件
        if (this.testButton) {
            this.testButton.on('click', this.onTestClick, this);
            console.log("✅ 按钮点击事件已绑定");
        }
    },

    onTestClick: function() {
        console.log("=== 按钮被点击 ===");
        
        // 检查组件
        if (!this.coinFlyAnim) {
            cc.error("❌ coinFlyAnim 组件不存在！");
            return;
        }

        // 检查节点
        if (!this.testButton || !this.coinIcon) {
            cc.error("❌ 节点不存在！");
            return;
        }

        // 获取位置
        var startPos = this.testButton.convertToWorldSpaceAR(cc.v2(0, 0));
        var endPos = this.coinIcon.convertToWorldSpaceAR(cc.v2(0, 0));

        console.log("起始位置:", startPos);
        console.log("结束位置:", endPos);
        console.log("开始飞行 10 个金币...");

        var self = this;

        // 飞行金币
        this.coinFlyAnim.flyCoins(startPos, endPos, 10, function() {
            console.log("✅ 金币飞行完成！");
            
            // 金币图标反馈动画
            if (self.coinIcon) {
                self.coinIcon.runAction(cc.sequence(
                    cc.scaleTo(0.1, 1.2),
                    cc.scaleTo(0.1, 1.0)
                ));
            }
        });
    }
});
