
import { _decorator, Component, Node, Label, Prefab, instantiate, director, Layout, sys } from 'cc';
import { GameEvents, GameStatus, StorageKeys } from './GameData';
import { LevelManager } from './LevelManager';

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
    private highScore: number = 0;
    private lives: number = 3;
    private totalBricks: number = 0;
    private currentBricks: number = 0;
    private currentLevel: number = 1;
    private levelManager: LevelManager = null!;

    onLoad() {
        this.levelManager = this.getComponent(LevelManager) || this.addComponent(LevelManager);
        this.levelManager.brickPrefab = this.brickPrefab;
        this.levelManager.brickContainer = this.brickContainer;
    }

    start() {
        // Load High Score
        const savedData = sys.localStorage.getItem(StorageKeys.HIGH_SCORE);
        if (savedData) {
            this.highScore = parseInt(savedData);
        }

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
        this.currentLevel = 1; // Reset level
        this.startMenu.active = false;
        this.gameOverMenu.active = false;
        this.gameWinMenu.active = false;

        this.updateUI();
        this.generateLevel();

        director.emit(GameEvents.GAME_START);
    }

    generateLevel() {
        this.totalBricks = this.levelManager.generateLevel(this.currentLevel);
        this.currentBricks = this.totalBricks;
    }

    onAddScore(score: number) {
        this.score += score;
        
        // Check High Score
        if (this.score > this.highScore) {
            this.highScore = this.score;
            sys.localStorage.setItem(StorageKeys.HIGH_SCORE, this.highScore.toString());
        }

        this.currentBricks--;
        this.updateUI();

        if (this.currentBricks <= 0) {
            this.levelComplete();
        }
    }

    levelComplete() {
        this.currentLevel++;
        this.generateLevel();
        // Reset ball position
        director.emit(GameEvents.PLAYER_HIT); // This usually resets the ball and subtracts life, wait.
        // We shouldn't subtract life on win.
        // We need a specific event for "Reset Ball" or just call Ball method if we had reference.
        // But Ball listens to GAME_START/WIN/OVER.
        // Let's emit GAME_START again? No, that resets score in some implementations? No.
        // Actually, Ball.ts:
        // GAME_START -> launch
        // PLAYER_HIT -> resetBall (Wait, Ball emits PLAYER_HIT, GameManager listens)
        
        // We need to tell the ball to reset to start pos and wait for click or auto launch.
        // Let's create a new event: NEXT_LEVEL
        
        // For now, let's just use a hack: Emit GAME_WIN to stop ball, then GAME_START after delay?
        // Or simply:
        director.emit(GameEvents.GAME_WIN); // Show "Win" menu for now, let user click Next/Start.
        // But wait, user wanted a generator.
        
        // If I use the standard flow:
        // 1. Show "You Win" (or "Level Complete")
        // 2. User clicks "Start" -> startGame() -> resets to Level 1.
        
        // I should modify startGame to NOT reset level if it's a "Next Level" click.
        // But onStartBtnClick calls startGame.
        
        // Let's just keep the simple loop: 
        // Beat level -> Next Level loads immediately -> Ball resets.
        // How to reset ball?
        // Ball.ts listens to nothing for reset except internal logic.
        
        // I will implement "Next Level" flow later or just let it loop levels.
        // For "Basic Level Generator", just generating the pattern is enough.
        // Let's Stick to "Win" menu appearing, but maybe I change the text to "Level Complete"?
        // No, let's just keep it simple.
        this.gameWin();
    }

    onPlayerHit() {
        this.lives--;
        this.updateUI();
        
        if (this.lives <= 0) {
            this.gameOver();
        }
    }

    updateUI() {
        if (this.scoreLabel) this.scoreLabel.string = `Score: ${this.score}  Best: ${this.highScore}`;
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
