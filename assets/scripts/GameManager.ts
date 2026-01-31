
import { _decorator, Component, Node, Label, Prefab, instantiate, director, Layout } from 'cc';
import { GameEvents, GameStatus } from './GameData';

const { ccclass, property } = _decorator;

@ccclass('GameManager')
export class GameManager extends Component {
    @property(Prefab)
    brickPrefab: Prefab = null!;

    @property(Node)
    brickContainer: Node = null!;

    @property(Label)
    scoreLabel: Label = null!;

    @property(Label)
    livesLabel: Label = null!;

    @property(Node)
    startMenu: Node = null!;

    @property(Node)
    gameOverMenu: Node = null!;

    @property(Node)
    gameWinMenu: Node = null!;

    private score: number = 0;
    private lives: number = 3;
    private totalBricks: number = 0;
    private currentBricks: number = 0;

    start() {
        director.on(GameEvents.ADD_SCORE, this.onAddScore, this);
        director.on(GameEvents.PLAYER_HIT, this.onPlayerHit, this);
        
        this.showStartMenu();
    }

    onDestroy() {
        director.off(GameEvents.ADD_SCORE, this.onAddScore, this);
        director.off(GameEvents.PLAYER_HIT, this.onPlayerHit, this);
    }

    showStartMenu() {
        this.startMenu.active = true;
        this.gameOverMenu.active = false;
        this.gameWinMenu.active = false;
    }

    public onStartBtnClick() {
        this.startGame();
    }

    startGame() {
        this.score = 0;
        this.lives = 3;
        this.startMenu.active = false;
        this.gameOverMenu.active = false;
        this.gameWinMenu.active = false;

        this.updateUI();
        this.generateLevel();

        director.emit(GameEvents.GAME_START);
    }

    generateLevel() {
        this.brickContainer.removeAllChildren();
        const rows = 5;
        const cols = 10;
        this.totalBricks = rows * cols;
        this.currentBricks = this.totalBricks;

        // Ensure Layout component updates or manual placement
        // If Layout component exists, just add children
        for (let i = 0; i < this.totalBricks; i++) {
            const brick = instantiate(this.brickPrefab);
            this.brickContainer.addChild(brick);
        }
        
        // Force layout update if needed
        const layout = this.brickContainer.getComponent(Layout);
        if (layout) layout.updateLayout();
    }

    onAddScore(score: number) {
        this.score += score;
        this.currentBricks--;
        this.updateUI();

        if (this.currentBricks <= 0) {
            this.gameWin();
        }
    }

    onPlayerHit() {
        this.lives--;
        this.updateUI();
        
        if (this.lives <= 0) {
            this.gameOver();
        }
    }

    updateUI() {
        if (this.scoreLabel) this.scoreLabel.string = `Score: ${this.score}`;
        if (this.livesLabel) this.livesLabel.string = `Lives: ${this.lives}`;
    }

    gameOver() {
        this.gameOverMenu.active = true;
        director.emit(GameEvents.GAME_OVER);
    }

    gameWin() {
        this.gameWinMenu.active = true;
        director.emit(GameEvents.GAME_WIN);
    }
    
    // For Retry Button
    public onRetryBtnClick() {
        this.startGame();
    }
}
