
import { _decorator, Enum } from 'cc';

export const GameEvents = {
    GAME_START: 'game-start',
    GAME_OVER: 'game-over',
    GAME_WIN: 'game-win',
    ADD_SCORE: 'add-score',
    PLAYER_HIT: 'player-hit', // Ball fell
    UPDATE_UI: 'update-ui'
};

export const StorageKeys = {
    HIGH_SCORE: 'breakout-high-score'
};

export const PhysicsGroups = {
    DEFAULT: 1 << 0,
    BALL: 1 << 1,
    WALL: 1 << 2,
    PADDLE: 1 << 3,
    BRICK: 1 << 4,
};

export enum GameStatus {
    IDLE,
    PLAYING,
    GAME_OVER,
    WIN
}
