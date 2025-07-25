extends Area2D

# Game states - let's keep track of what's happening! ✨
var game_started = false
var ball_radius = 12.5  # Our lovely red ball is 25px diameter (0.5x smaller!)
var screen_size = Vector2(800, 600)  # Target resolution from design

# Visual components for our flashy effects! 💫
@onready var visual: Polygon2D = $Visual
var original_color: Color = Color.RED
var flash_color: Color = Color.WHITE

# Called when the node enters the scene tree
func _ready():
	print("🔴 Ball loaded! Collision layer: ", collision_layer)
	
	# Connect our input detection - gotta catch those clicks! 🎯
	input_event.connect(_on_input_event)
	
	# Connect collision detection - time to detect those enemy encounters! 💥
	area_entered.connect(_on_area_entered)
	
	# Connect to GameManager flash signals for visual feedback! ✨
	if GameManager:
		GameManager.collision_flash_started.connect(_on_collision_flash_started)
		GameManager.collision_flash_ended.connect(_on_collision_flash_ended)
	
	# Start in the center like a good little ball 🔴
	position = Vector2(screen_size.x / 2, screen_size.y / 2)
	
	print("✨ Ball setup complete! Ready for clicks and collisions!")

# Called every frame - this is where the magic happens!
func _process(_delta):
	if game_started:
		_follow_mouse()

# Instant mouse following with boundary constraints 🚀
func _follow_mouse():
	var mouse_pos = get_global_mouse_position()
	
	# Clamp that position! Keep our ball on screen like a well-behaved circle
	# 25px from edges means our center stays within bounds
	mouse_pos.x = clamp(mouse_pos.x, ball_radius, screen_size.x - ball_radius)
	mouse_pos.y = clamp(mouse_pos.y, ball_radius, screen_size.y - ball_radius)
	
	# Instant movement - no smoothing, no interpolation, just pure responsiveness! 
	position = mouse_pos

# Handle clicks on the ball - this starts our game! 🎮
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not game_started:
				_start_game()

# Game startup sequence - snap to mouse and begin the fun! 🎊
func _start_game():
	game_started = true
	# Snap instantly to mouse position (with boundaries)
	_follow_mouse()
	
	# Hide the cursor - now the ball IS your cursor! ✨
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Tell GameManager we're ready to rock! 🚀
	if GameManager:
		GameManager.start_game()

# Collision detection - when enemies get too close for comfort! 💥
func _on_area_entered(area):
	# Check if we've collided with an enemy
	if area.is_in_group("enemies"):
		print("💥 COLLISION! Ball hit by enemy!")
		
		# Handle collision through GameManager
		if GameManager:
			GameManager.handle_collision()
		
		# Remove the enemy that hit us - one and done! 
		area.queue_free()

# Flash the ball white on collision start! ⚪
func _on_collision_flash_started():
	if visual:
		visual.color = flash_color
		print("⚪ Ball flashing white!")

# Return ball to original red color when flash ends! 🔴
func _on_collision_flash_ended():
	if visual:
		visual.color = original_color
		print("🔴 Ball returned to red!") 