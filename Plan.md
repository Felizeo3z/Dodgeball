# Dodge Ball Survival Game - Implementation Plan

## Project Overview
Building a simple survival game in Godot where a red ball avoids green enemies using mouse control.

**Target**: 800x600 windowed game, 3 lives, time-based scoring, procedural audio

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
└── working/                  # Development tracking files
```

---

## Phase 1: Project Setup & Basic Scenes
**Session Goal**: Create Godot project with basic scene hierarchy and test setup

### Deliverables:
1. New Godot project configured for 800x600 windowed
2. Main.tscn scene with basic structure
3. Ball.tscn scene with red circle (50px diameter)
4. Project settings configured
5. Test that scenes load and ball displays

### Tasks:
- [x] Create new Godot project
- [x] Configure project settings (resolution, window mode)
- [x] Create Main scene with ColorRect background (white)
- [x] Create Ball scene with Area2D + CollisionShape2D + visual
- [x] Instance Ball in Main scene at center (400, 300)
- [ ] Test project runs and displays correctly

### Success Criteria:
- Project opens without errors
- Ball displays as 50px red circle in center of 800x600 white screen
- Window is properly sized and non-resizable

---

## Phase 2: Ball Movement & Input
**Session Goal**: Implement instant mouse following with screen constraints

### Dependencies: Phase 1 complete

### Deliverables:
1. Ball.gd script with mouse following
2. Screen boundary constraints working
3. Click-to-start functionality
4. Smooth input handling

### Tasks:
- [x] Create Ball.gd script with mouse position tracking
- [x] Implement instant position updates (no interpolation)
- [x] Add screen boundary clamping (25px from edges)
- [x] Add click detection to start game
- [x] Implement ball snapping to mouse on first click

### Success Criteria:
- Ball starts in center and follows mouse instantly when clicked
- Ball cannot move outside screen boundaries
- Mouse movement feels responsive with no lag
- Game starts only after clicking on ball

---

## Phase 3A: Enemy Scene & Basic Movement
**Session Goal**: Create enemy with movement mechanics (no spawning yet)

### Dependencies: Phase 2 complete

### Deliverables:
1. Enemy.tscn scene with green circle (75px diameter)
2. Enemy.gd script with targeting and movement
3. Test enemy that moves toward a fixed point
4. Visual direction arrow on enemy

### Tasks:
- [ ] Create Enemy scene with Area2D + CollisionShape2D + visual
- [ ] Create Enemy.gd with target position and movement logic
- [ ] Implement 100px/second movement speed
- [ ] Add direction arrow visual (pointing toward target)
- [ ] Test enemy movement by manually placing in Main scene

### Success Criteria:
- Enemy displays as 75px green circle with direction arrow
- Enemy moves toward target at consistent 100px/s speed
- Direction arrow points correctly toward target
- Enemy can be instantiated and moves properly

---

## Phase 3B: Enemy Spawning System
**Session Goal**: Implement automated enemy spawning with proper positioning

### Dependencies: Phase 3A complete

### Deliverables:
1. EnemySpawner.gd script
2. Timer-based spawning every 1.5 seconds
3. Random spawn positions 150px off-screen
4. Enemy targeting ball's position at spawn time

### Tasks:
- [ ] Create EnemySpawner.gd with Timer node
- [ ] Implement spawn position calculation (150px off all edges)
- [ ] Add enemy instantiation and targeting logic
- [ ] Set up 1.5-second spawn intervals
- [ ] Test multiple enemies spawning and moving

### Success Criteria:
- Enemies spawn every 1.5 seconds during gameplay
- Spawn positions are exactly 150px outside screen boundaries
- Each enemy targets ball's position when that enemy spawned
- Multiple enemies can exist and move simultaneously

---

## Phase 4: Collision Detection & Life System
**Session Goal**: Implement collision, lives, and basic game over

### Dependencies: Phase 3B complete

### Deliverables:
1. Ball-enemy collision detection
2. Life system (3 hits = game over)
3. GameManager.gd singleton for state management
4. Basic game over state

### Tasks:
- [x] Create GameManager.gd singleton with life tracking
- [x] Implement collision detection in Ball.gd
- [x] Add life reduction and enemy destruction on hit
- [x] Create game over state and detection
- [x] Add enemy cleanup when reaching screen edges

### Success Criteria:
- Ball-enemy collisions are detected accurately
- Lives decrease from 3 to 0 with each hit
- Enemies disappear after hitting ball
- Game enters game over state after 3 hits
- Enemies despawn when reaching screen edges

---

## Phase 5: Visual Feedback & Flash Effects
**Session Goal**: Add collision feedback and visual polish

### Dependencies: Phase 4 complete

### Deliverables:
1. Ball white flash on collision
2. Background black flash for 1 second on collision
3. Enemy movement pause during flash
4. Smooth visual transitions

### Tasks:
- [ ] Add flash effect system to Ball.gd
- [ ] Implement background flash in Main.gd
- [ ] Add enemy pause functionality during flash
- [ ] Create flash timing coordination
- [ ] Test visual feedback timing

### Success Criteria:
- Ball flashes white briefly on collision
- Background flashes black for exactly 1 second
- All enemies pause movement during black flash
- Visual effects don't interfere with gameplay logic

---

## Phase 6: Scoring System & UI
**Session Goal**: Implement time-based scoring with proper display

### Dependencies: Phase 5 complete

### Deliverables:
1. UI.tscn scene with score display
2. Time-based scoring (1 point/second)
3. HHH:MM:SS format display
4. Score positioning and styling

### Tasks:
- [x] Create UI.tscn with Label node for score
- [x] Create UI.gd with time formatting logic
- [x] Implement 1-point-per-second scoring
- [x] Style score display (light grey, center position)
- [x] Connect scoring to game state

### Success Criteria:
- Score displays in HHH:MM:SS format
- Score increases by 1 every second during gameplay
- Score is positioned in center, light grey color
- Score stops counting at game over

---

## Phase 7: Game Over & Restart System
**Session Goal**: Complete the game loop with restart functionality

### Dependencies: Phase 6 complete

### Deliverables:
1. Game over screen/state
2. Click-to-restart functionality
3. Proper game state reset
4. Score persistence during game over

### Tasks:
- [x] Create game over display state
- [x] Implement click-to-restart detection
- [x] Add complete game state reset logic
- [x] Clear all enemies on restart
- [x] Reset score and lives properly

### Success Criteria:
- Game over state displays final score
- Clicking anywhere restarts the game
- All game elements reset to initial state
- Lives reset to 3, score to 000:00:00

---

## Phase 8: Audio Implementation
**Session Goal**: Add procedural sound effects

### Dependencies: Phase 7 complete

### Deliverables:
1. AudioManager.gd with procedural audio generation
2. 50Hz sine wave for enemy spawn
3. 100Hz sawtooth wave for collision
4. Proper audio timing

### Tasks:
- [ ] Create AudioManager.gd singleton
- [ ] Implement 50Hz sine wave generation for spawns
- [ ] Add 100Hz sawtooth wave for collisions
- [ ] Connect audio triggers to game events
- [ ] Test audio timing and quality

### Success Criteria:
- 50Hz sine plays when enemies spawn
- 100Hz sawtooth plays on ball-enemy collision
- Audio timing matches visual events precisely
- No audio lag or performance issues

---

## Phase 9: Final Polish & Testing
**Session Goal**: Complete testing and final adjustments

### Dependencies: Phase 8 complete

### Deliverables:
1. Complete testing checklist validation
2. Performance optimization
3. Bug fixes and edge case handling
4. Final build preparation

### Tasks:
- [ ] Run complete testing checklist from working/testing.md
- [ ] Fix any discovered bugs or issues
- [ ] Optimize performance for 60 FPS target
- [ ] Test edge cases and boundary conditions
- [ ] Prepare final build

### Success Criteria:
- All items in testing checklist pass
- Game runs at stable 60 FPS
- No critical bugs or edge case failures
- Game is ready for distribution

---

## Session Notes

### Before Each Session:
1. Review the current phase deliverables
2. Check dependencies are complete
3. Update working/notes.md with current progress
4. Test previous phase functionality

### After Each Session:
1. Mark completed tasks in this plan
2. Update working/notes.md with progress
3. Note any issues in working/issues.md
4. Test deliverables meet success criteria

### Emergency Protocols:
- If a phase proves too large, split it into sub-phases
- If dependencies fail, fix before proceeding
- If major bugs emerge, pause and document in issues.md
- Always maintain working game state between phases 