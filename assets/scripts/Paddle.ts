
import { _decorator, Component, Node, input, Input, EventMouse, Vec3, math } from 'cc';
import { GameStatus } from './GameData';
import { GameManager } from './GameManager'; // Circular dependency risk? We'll see.
const { ccclass, property } = _decorator;

@ccclass('Paddle')
export class Paddle extends Component {
    @property
    public speed: number = 1.0;

    @property
    public xLimit: number = 490; // Adapted for 1080 width (540 - paddle_half_width)

    start() {
        input.on(Input.EventType.MOUSE_MOVE, this.onMouseMove, this);
    }

    onDestroy() {
        input.off(Input.EventType.MOUSE_MOVE, this.onMouseMove, this);
    }

    onMouseMove(event: EventMouse) {
        // Only move if game is playing? Or always?
        // Usually always allowed to move.
        
        const delta = event.getDeltaX();
        const currentPos = this.node.position;
        
        let newX = currentPos.x + (delta * this.speed);
        newX = math.clamp(newX, -this.xLimit, this.xLimit);

        this.node.setPosition(newX, currentPos.y, currentPos.z);
    }
}
