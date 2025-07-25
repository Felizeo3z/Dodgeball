# Dodge Ball Survival Game

## Core Concept
We are building a game in the Godot engine.
The game is about a ball that needs to avoid enemies that spawn in from outside the screen and move towards the ball.
The ball needs to survive for as long as possible.
The ball follows the mouse cursor.
The ball is red.
The enemies are green.

## Game Mechanics

### Survival & Scoring
- **Objective**: Survive as long as possible
- **Scoring**: Time-based survival score (seconds survived)
- **High Score**: Track and display best survival time

### Difficulty Progression
- **Enemy Spawn Rate**: Gradually increase frequency over time
- **Enemy Speed**: Slowly increase movement speed
- **Enemy Variety**: no variety the enemies will all be the same. they will spawn in and move in a straight line at where the ball is. the will not follow the ball.

### Player Controls
- **Mouse Following**: Ball follows mouse cursor
- **Responsiveness**: no lag or smoothing. the ball should move to the mouse cursor instantly.
- **Screen Boundaries**: Ball constrained to screen edges.

## Visual Design

### Art Style
- **Aesthetic**: Simple geometric shapes with clean colors
- **Background**: Solid white
- **Particle Effects**: enemies will display a small arrow that points in the direction they are moving.

### Visual Elements
- **Ball**: Red circle, that is smaller than the enemies the ball will be 25 pixels in diameter.
- **Enemies**: Green circles, that are 1.5x as large as the ball.
- **UI**: the score will be displayed on the background in a light grey colour.

### Screen Layout
- **Play Area**: bordered play area
- **UI Positioning**: the timer will be displayed in the center of the screen.
- **Visual Feedback**: the ball will flash white when it is hit by an enemy and the background will flash black for one second. during the flash the enemies will stop moving.

## Enemy Design

### Basic Behavior
- **Spawn Locations**: From outside screen edges all sides. 150 pixels off screen.
- **Movement**: Direct line toward where the ball was when the enemy spawned.
- **Collision**: when the enemy collides with the ball, the ball will flash white and the enemy will disappear.

### Enemy Varieties (Future)
- **Basic Chaser**: Moves directly toward where the ball was when the enemy spawned.


## Audio Design
- **Background Music**: none
- **Sound Effects**: enemy spawn, ball movement, collision, death.


## Technical Implementation

### Performance
- **Target Frame Rate**: 60 FPS
- **Enemy Limit**: Maximum concurrent enemies on screen
- **Object Pooling**: Reuse enemy objects for performance

### Input Handling
- **Mouse Tracking**: Smooth interpolation between mouse positions
- **Input Lag**: Minimize delay between mouse movement and ball movement

## Questions to Resolve

1. **Enemy Spawn Timing**: 
   - What's the initial spawn interval (e.g., every 2 seconds)?
   the spawn rate will be once every 1.5 seconds.
   - How quickly should the spawn rate increase over time?
    the spawn rate will not increse over time.

2. **Enemy Speed**: 
   - What's the base movement speed for enemies?
   the enemies will move at a speed of 100 pixels per second
   - How much should speed increase over time?
   the speed will not increase over time.

3. **Movement Speeds**:
   - How fast should the ball move when following the mouse?
   instantly
   - Should enemies move at consistent speed or vary?
   consistent speed.

4. **Play Area Border**:
   - What should the border look like (thickness, color)?
   no border.
   - How much padding between border and screen edge?
   no padding.

5. **Enemy Cleanup**:
   - What happens when enemies reach the play area edge without hitting the ball?
   they disappear.

6. **Sound Effects**:
   - What style/type of sounds for spawn, movement, collision, death?
   - the sound effects will be 50hz sine wave for enemies spawning and 100hz sine wave for collision. on collision the sound will be a 100hz sawtooth wave.

7. **Restart Mechanism**:
   - How does the player restart after game over?
   clicking the mouse will restart the game after a game over.

8. **Score Display**:
   - the score should count upwards one point every second.
   - Format: the score will be displayed as HHH:MM:SS. (hours, minutes, seconds)

   9. starting position: the ball will start on the center of the screen and the game will start when the ball is clicked upon which the ball will snap to the mouse cursor position.

## Implementation Priority
1. **MVP**: Basic ball, mouse following, simple enemy spawning, collision detection
2. **Core Loop**: Scoring, game over after 3 collisions, restart functionality  
3. **Polish**: Visual effects, audio.
4. **Enhancement**: none

## File Structure

```
testgame/
├── project.godot              # Godot project file
├── scenes/
│   ├── Main.tscn             # Main game scene
│   ├── Ball.tscn             # Player ball scene
│   ├── Enemy.tscn            # Enemy scene
│   └── UI.tscn               # UI overlay scene
├── scripts/
│   ├── Main.gd               # Main game controller
│   ├── Ball.gd               # Ball movement and collision
│   ├── Enemy.gd              # Enemy movement and behavior
│   ├── EnemySpawner.gd       # Enemy spawning logic
│   ├── GameManager.gd        # Game state, scoring, lives
│   ├── UI.gd                 # Score display and UI updates
│   └── AudioManager.gd       # Sound generation and playback
├── assets/
│   └── sounds/               # Generated sound files (if needed)
└── working/
    ├── notes.md              # Development notes and progress
    ├── testing.md            # Testing checklist
    └── issues.md             # Known issues and fixes
```

## Implementation Plan

### Phase 1: Project Setup & Core Framework
1. Create new Godot project (800x600 windowed)
2. Set up basic scene structure (Main, Ball, Enemy, UI)
3. Configure project settings (resolution, input map)
4. Create basic GameManager singleton for state management

### Phase 2: Ball Implementation
1. Create Ball scene with collision detection
2. Implement instant mouse following
3. Add screen boundary constraints
4. Test ball movement and positioning

### Phase 3: Enemy System
1. Create Enemy scene with movement logic
2. Implement EnemySpawner with 1.5s intervals
3. Add enemy targeting (aim where ball was on spawn)
4. Test enemy spawning and movement patterns

### Phase 4: Collision & Game States
1. Implement ball-enemy collision detection
2. Add life system (3 hits = game over)
3. Create game state management (playing, game over)
4. Add visual feedback (white flash, black background flash)

### Phase 5: Scoring & UI
1. Implement time-based scoring (1 point/second)
2. Create score display (HHH:MM:SS format)
3. Add game over screen and restart functionality
4. Test complete game loop

### Phase 6: Audio Implementation
1. Create AudioManager for procedural sound generation
2. Implement 50Hz sine wave for enemy spawn
3. Add 100Hz sawtooth wave for collision
4. Test audio timing and playback

### Phase 7: Polish & Visual Effects
1. Add enemy direction arrows
2. Implement pause during black flash
3. Fine-tune timing and visual feedback
4. Comprehensive testing and bug fixes

### Phase 8: Final Testing & Cleanup
1. Performance testing and optimization
2. Edge case testing (boundary conditions)
3. Code cleanup and documentation
4. Final build and deployment preparation