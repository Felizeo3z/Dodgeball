# Issues & Bug Tracking - Dodge Ball Survival Game

## Known Issues
*No issues yet - this will be updated as development progresses*

## Resolved Issues
*Track fixed bugs here for reference*

## Potential Issues to Watch For

### Ball Movement
- Mouse cursor going off-screen behavior
- Ball position initialization timing
- Screen boundary edge cases

### Enemy System
- Enemy cleanup when off-screen
- Spawn positioning precision (exactly 150px off-screen)
- Enemy collision with screen boundaries

### Collision Detection
- High-speed collision misses
- Multiple simultaneous collisions
- Collision detection during visual effects

### Audio
- Audio generation performance impact
- Sound timing synchronization
- Multiple audio streams playing simultaneously

### Performance
- Enemy spawning rate vs frame rate
- Memory usage with long gameplay sessions
- Object pooling necessity

### Visual Effects
- Flash timing accuracy
- Color blending during effects
- Enemy pause state synchronization

## Debug Notes
*Add debugging information and temporary fixes here*

## Testing Environment
- **OS**: macOS 24.5.0
- **Shell**: Fish shell
- **Godot Version**: TBD
- **Target Resolution**: 800x600 windowed 