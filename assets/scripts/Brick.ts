
import { _decorator, Component, Collider2D, Contact2DType, IPhysics2DContact, director } from 'cc';
import { GameEvents } from './GameData';

const { ccclass } = _decorator;

@ccclass('Brick')
export class Brick extends Component {
    start() {
        const collider = this.getComponent(Collider2D);
        if (collider) {
            collider.on(Contact2DType.BEGIN_CONTACT, this.onBeginContact, this);
        }
    }

    onBeginContact(self: Collider2D, other: Collider2D, contact: IPhysics2DContact | null) {
        // Use scheduleOnce to avoid physics world locking issues during step
        this.scheduleOnce(() => {
            this.destroyBrick();
        });
    }

    destroyBrick() {
        if (!this.node.isValid) return;
        
        director.emit(GameEvents.ADD_SCORE, 10);
        this.node.destroy();
    }
}
