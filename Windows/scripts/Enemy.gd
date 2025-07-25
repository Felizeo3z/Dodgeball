extends Area2D

# Movement and targeting - our green menace has a purpose! 🎯
var target_position: Vector2 = Vector2.ZERO
var movement_speed: float = 100.0  # pixels per second - nice and steady
var direction: Vector2 = Vector2.ZERO
var is_paused: bool = false  # Pause during dramatic flash effects! 🎭

# Visual components for our sassy arrow 🏹
@onready var arrow: Polygon2D = $Visuals/Arrow

# Called when the node enters the scene tree - time to lock and load! 
func _ready():
	print("🟢 Enemy spawned! Ready to chase some red circles...")
	# Add to enemies group for easier management
	add_to_group("enemies")
	
	# Connect to GameManager flash signals for dramatic pauses! 🎬
	if GameManager:
		GameManager.collision_flash_started.connect(_on_collision_flash_started)
		GameManager.collision_flash_ended.connect(_on_collision_flash_ended)

# Called every frame - the relentless pursuit begins!
func _process(delta):
	if target_position != Vector2.ZERO and not is_paused:
		_move_towards_target(delta)
		_update_arrow_direction()

# Set our target and calculate direction - no turning back now! 🎭
func set_target(target_pos: Vector2):
	target_position = target_pos
	direction = (target_position - global_position).normalized()
	print("🎯 Enemy locked onto target: ", target_position)

# Move toward our target with unwavering determination!
func _move_towards_target(delta: float):
	# Move in the direction we calculated at spawn - no course corrections!
	global_position += direction * movement_speed * delta
	
	# Check if we've reached our target (within a reasonable distance)
	if global_position.distance_to(target_position) < 5.0:
		print("🎯 Enemy reached target position!")
		# Could add some behavior here for when target is reached

# Update arrow rotation to point toward our target - visual flair! ✨
func _update_arrow_direction():
	if arrow and target_position != Vector2.ZERO:
		var angle_to_target = global_position.angle_to_point(target_position)
		arrow.rotation = angle_to_target + PI/2  # Adjust for arrow shape orientation

# Get our current direction for external systems to read
func get_direction() -> Vector2:
	return direction

# Pause movement during collision flash - dramatic effect! 🎭
func _on_collision_flash_started():
	is_paused = true
	print("⏸️ Enemy paused for collision flash!")

# Resume movement when flash ends - back to the chase! 🏃‍♀️
func _on_collision_flash_ended():
	is_paused = false
	print("▶️ Enemy resumed movement!")

# Check if this enemy is still useful or should be cleaned up
func is_off_screen(screen_size: Vector2) -> bool:
	return (global_position.x < -50 or global_position.x > screen_size.x + 50 or
			global_position.y < -50 or global_position.y > screen_size.y + 50) 