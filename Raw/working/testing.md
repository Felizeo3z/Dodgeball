# Testing Checklist - Dodge Ball Survival Game

## Core Mechanics
- [ ] Ball starts in center of screen
- [ ] Ball follows mouse cursor instantly
- [ ] Ball constrained to screen boundaries (800x600)
- [ ] Game starts when ball is clicked
- [ ] Ball snaps to mouse position on first click

## Enemy System
- [ ] Enemies spawn every 1.5 seconds
- [ ] Enemies spawn 150px off all screen edges
- [ ] Enemies are 75px diameter (1.5x ball size)
- [ ] Enemies move at 100px/second
- [ ] Enemies aim for ball's position when they spawned
- [ ] Enemies move in straight lines (no following)
- [ ] Enemies disappear when reaching screen edge
- [ ] Enemy direction arrows display correctly

## Collision & Lives
- [ ] Ball-enemy collision detection works accurately
- [ ] Ball flashes white on collision
- [ ] Enemy disappears on collision
- [ ] Life counter decreases on collision
- [ ] Game over occurs after 3 hits
- [ ] Background flashes black for 1 second on collision
- [ ] Enemies pause during black flash

## Scoring & UI
- [ ] Score starts at 000:00:00
- [ ] Score increases by 1 every second during gameplay
- [ ] Score displays in HHH:MM:SS format
- [ ] Score displays in light grey on white background
- [ ] Score positioned in center of screen
- [ ] Final score shown on game over

## Audio
- [ ] 50Hz sine wave plays on enemy spawn
- [ ] 100Hz sawtooth wave plays on collision
- [ ] Audio timing matches visual events
- [ ] No audio lag or stuttering

## Game Flow
- [ ] Click anywhere to restart after game over
- [ ] Game state resets properly on restart
- [ ] Score resets to 000:00:00 on restart
- [ ] Lives reset to 3 on restart
- [ ] All enemies cleared on restart

## Edge Cases
- [ ] Multiple simultaneous collisions handled correctly
- [ ] Ball movement at screen edges
- [ ] Enemy spawning near screen corners
- [ ] Rapid mouse movement doesn't break ball following
- [ ] Game over during black flash

## Performance
- [ ] Steady 60 FPS during normal gameplay
- [ ] No memory leaks from enemy spawning/destruction
- [ ] Smooth enemy movement
- [ ] Responsive input handling 