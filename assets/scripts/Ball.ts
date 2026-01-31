
import { _decorator, Component, Node, RigidBody2D, Vec2, Vec3, Collider2D, Contact2DType, IPhysics2DContact, director } from 'cc';
import { GameEvents } from './GameData';

const { ccclass, property } = _decorator;

@ccclass('Ball')
export class Ball extends Component {
    @property
    speed: number = 15; // Physics speed
    
    @property
    minY: number = -1100; // Death threshold for 2160 height

    private rb: RigidBody2D | null = null;
    private isMoving: boolean = false;
    private startPos: Vec3 = new Vec3();

    onLoad() {
        this.startPos = this.node.position.clone();
        this.rb = this.getComponent(RigidBody2D);
    }

    start() {
        if (this.rb) {
            this.rb.gravityScale = 0;
            this.rb.linearDamping = 0;
            this.rb.angularDamping = 0;
            this.rb.fixedRotation = true;
        }

        director.on(GameEvents.GAME_START, this.launch, this);
        director.on(GameEvents.GAME_WIN, this.stop, this);
        director.on(GameEvents.GAME_OVER, this.stop, this);
    }

    onDestroy() {
        director.off(GameEvents.GAME_START, this.launch, this);
        director.off(GameEvents.GAME_WIN, this.stop, this);
        director.off(GameEvents.GAME_OVER, this.stop, this);
    }

    launch() {
        if (this.isMoving || !this.rb) return;
        
        this.isMoving = true;
        // Randomize start direction slightly
        const dirX = (Math.random() - 0.5) * 2; // -1 to 1
        const velocity = new Vec2(dirX, 1).normalize().multiplyScalar(this.speed);
        this.rb.linearVelocity = velocity;
    }

    stop() {
        this.isMoving = false;
        if (this.rb) this.rb.linearVelocity = Vec2.ZERO;
    }

    resetBall() {
        this.stop();
        this.node.setPosition(this.startPos);
        // Auto launch or wait? Let's wait for user input or timer. 
        // For this simple version, we'll auto-launch after a short delay via GameManager or just let it sit until "Start" is pressed?
        // Requirement says "Start Button".
        // But for Life loss -> Respawn, usually it's auto or click.
        // I will expose a method to be called.
    }

    update(deltaTime: number) {
        if (!this.isMoving) return;

        // Check if ball fell
        if (this.node.position.y < this.minY) {
            this.resetBall();
            director.emit(GameEvents.PLAYER_HIT);
        }

        // Maintain constant speed
        if (this.rb) {
            const currentVel = this.rb.linearVelocity;
            // Avoid normalizing zero vector
            if (currentVel.lengthSqr() > 0) {
                 const newVel = currentVel.normalize().multiplyScalar(this.speed);
                 this.rb.linearVelocity = newVel;
            }
        }
    }
}
