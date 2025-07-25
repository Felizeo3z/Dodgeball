extends Node2D

# Scene references for our spawning system! 🎮
@onready var ball = $Ball
@onready var enemy_spawner = $EnemySpawner
@onready var background = $BackgroundLayer/Background

# Track spawning state
var spawning_started: bool = false

# Background flash colors - dramatic effect time! 🎭
var original_bg_color: Color = Color.WHITE
var flash_bg_color: Color = Color.BLACK

# Called when the scene is ready - time to set up the systems!
func _ready():
	print("🎬 Main scene loaded! Setting up game systems...")
	
	# Connect the spawner to our ball for targeting
	if enemy_spawner and ball:
		enemy_spawner.set_ball_reference(ball)
		print("✨ Enemy spawner connected to ball!")
	
	# Connect to GameManager signals for game state management
	if GameManager:
		GameManager.game_started.connect(_on_game_started)
		GameManager.game_over.connect(_on_game_over)
		GameManager.game_restarted.connect(_on_game_restarted)
		GameManager.collision_flash_started.connect(_on_collision_flash_started)
		GameManager.collision_flash_ended.connect(_on_collision_flash_ended)
		print("🔗 Connected to GameManager signals!")

# Check every frame for restart input after game over
func _process(_delta):
	# Handle restart on any mouse click after game over
	if GameManager and GameManager.get_is_game_over():
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_restart_game()

# Game started - begin the enemy spawning mayhem!
func _on_game_started():
	if not spawning_started:
		_start_enemy_spawning()

# Start the enemy spawning system!
func _start_enemy_spawning():
	spawning_started = true
	print("🚀 Game started! Beginning enemy spawns...")
	if enemy_spawner:
		enemy_spawner.start_spawning()

# Game over - stop everything and prepare for restart!
func _on_game_over():
	print("💀 Game over received in Main! Stopping spawns and cleaning up...")
	
	# Stop enemy spawning
	if enemy_spawner:
		enemy_spawner.stop_spawning()
	
	# Clean up all existing enemies
	_clear_all_enemies()
	
	print("🧹 All enemies cleared! Click anywhere to restart...")

# Game restarted - reset state and clean up
func _on_game_restarted():
	print("🔄 Game restart received! Preparing fresh state...")
	spawning_started = false
	_clear_all_enemies()
	# Reset difficulty progression to starting level
	if enemy_spawner:
		enemy_spawner.reset_difficulty()

# Restart the entire game - fresh start!
func _restart_game():
	print("🔄 Restarting game...")
	
	# Show the cursor again - we're back to click-to-start mode! 🖱️
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Clear all enemies before restarting
	_clear_all_enemies()
	
	# Reset ball position to center
	if ball:
		ball.game_started = false
		ball.position = Vector2(800/2, 600/2)
	
	# Reset spawning state
	spawning_started = false
	
	# Tell GameManager to restart
	if GameManager:
		GameManager.restart_game()

# Flash the background black when collision starts! ⚫
func _on_collision_flash_started():
	if background:
		background.color = flash_bg_color
		print("⚫ Background flashing black!")

# Return background to white when flash ends! ⚪
func _on_collision_flash_ended():
	if background:
		background.color = original_bg_color
		print("⚪ Background returned to white!")

# Clear all enemies from the scene - cleanup time! 🧹
func _clear_all_enemies():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.queue_free()
	print("🧹 Cleared ", enemies.size(), " enemies from scene")

# Get reference to enemy spawner for AudioManager connection
func get_enemy_spawner() -> Node2D:
	return enemy_spawner 