
import { _decorator, Component, Node, Prefab, instantiate, Layout, UITransform, Vec3, Color, Sprite } from 'cc';
const { ccclass, property } = _decorator;

@ccclass('LevelManager')
export class LevelManager extends Component {
    @property(Prefab)
    brickPrefab: Prefab = null!;

    @property(Node)
    brickContainer: Node = null!;

    private cols = 10;
    private brickWidth = 80;
    private brickHeight = 30;
    private spacingX = 10;
    private spacingY = 10;

    /**
     * Generates a specific level pattern
     * @param level Level index (1-based)
     * @returns Total number of bricks created
     */
    public generateLevel(level: number): number {
        this.clearLevel();
        
        // Disable Layout if it exists, as we'll do manual positioning for flexibility
        const layout = this.brickContainer.getComponent(Layout);
        if (layout) {
            layout.enabled = false;
        }

        let brickCount = 0;

        switch (level % 4) { // Cycle through 4 levels
            case 1:
                brickCount = this.createStandardGrid();
                break;
            case 2:
                brickCount = this.createCheckerboard();
                break;
            case 3:
                brickCount = this.createPyramid();
                break;
            case 0: // Level 4, 8, etc.
                brickCount = this.createRandom();
                break;
            default:
                brickCount = this.createStandardGrid();
                break;
        }

        return brickCount;
    }

    private clearLevel() {
        this.brickContainer.removeAllChildren();
    }

    private createStandardGrid(): number {
        const rows = 5;
        let count = 0;
        
        for (let row = 0; row < rows; row++) {
            for (let col = 0; col < this.cols; col++) {
                this.createBrick(row, col);
                count++;
            }
        }
        return count;
    }

    private createCheckerboard(): number {
        const rows = 6;
        let count = 0;

        for (let row = 0; row < rows; row++) {
            for (let col = 0; col < this.cols; col++) {
                // Check if (row + col) is even
                if ((row + col) % 2 === 0) {
                    this.createBrick(row, col);
                    count++;
                }
            }
        }
        return count;
    }

    private createPyramid(): number {
        const rows = 10;
        let count = 0;

        // Inverted pyramid or normal? Let's do normal (peak at top? no, bricks are at top of screen)
        // Usually breakout pyramids are inverted (wide at top, narrow at bottom) or normal.
        // Let's do a structure where row 0 has 10, row 1 has 8...
        
        for (let row = 0; row < rows; row++) {
            // Determine start and end col for this row
            // Row 0: 0-9 (10 bricks)
            // Row 1: 1-8 (8 bricks)
            // Row 2: 2-7 (6 bricks)
            const startCol = row;
            const endCol = this.cols - 1 - row;

            if (startCol > endCol) break;

            for (let col = startCol; col <= endCol; col++) {
                this.createBrick(row, col);
                count++;
            }
        }
        return count;
    }

    private createRandom(): number {
        const rows = 6;
        let count = 0;

        for (let row = 0; row < rows; row++) {
            for (let col = 0; col < this.cols; col++) {
                if (Math.random() > 0.5) {
                    this.createBrick(row, col);
                    count++;
                }
            }
        }
        return count;
    }

    private createBrick(row: number, col: number) {
        const brick = instantiate(this.brickPrefab);
        this.brickContainer.addChild(brick);

        // Calculate Position
        // Origin is usually top-left of the container? 
        // Or if container has anchor (0.5, 0.5), it's centered.
        // Let's assume container is centered horizontally.
        // Total width of content = cols * width + (cols-1) * spacing
        const totalWidth = this.cols * this.brickWidth + (this.cols - 1) * this.spacingX;
        const startX = -totalWidth / 2 + this.brickWidth / 2;
        
        // Y Position: Start from top (0) and go down?
        // Or start from 0 and go down (-y).
        const startY = 0; 

        const x = startX + col * (this.brickWidth + this.spacingX);
        const y = startY - row * (this.brickHeight + this.spacingY);

        brick.setPosition(new Vec3(x, y, 0));

        // Optional: Color based on row
        const sprite = brick.getComponent(Sprite);
        if (sprite) {
             // Simple color variation
             const colors = [
                 new Color(255, 100, 100), // Red
                 new Color(255, 165, 0),   // Orange
                 new Color(255, 255, 0),   // Yellow
                 new Color(100, 255, 100), // Green
                 new Color(100, 100, 255), // Blue
                 new Color(200, 100, 255)  // Purple
             ];
             sprite.color = colors[row % colors.length];
        }
    }
}
