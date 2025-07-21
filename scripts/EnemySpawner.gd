extends Node2D

# Enemy spawning system - chaos coordinator with escalating mayhem! 🎪
# Signal emitted when an enemy is spawned - used for audio feedback! 🎵
signal enemy_spawned

var enemy_scene = preload("res://scenes/Enemy.tscn")
var spawn_timer: Timer
var cleanup_timer: Timer
var difficulty_timer: Timer
var pause_timer: Timer
var ball_reference: Node2D

# Pause system for post-hit recovery! 🛡️
var is_spawning_paused: bool = false
var pause_duration: float = 2.0  # 2 seconds of peace after taking a hit

# Game area settings for our spawning calculations
var screen_width: float = 800.0
var screen_height: float = 600.0
var spawn_distance: float = 150.0  # pixels off-screen for dramatic entrances!

# Progressive difficulty settings - the chaos escalates! ⚡
var initial_spawn_interval: float = 0.4    # starting spawn rate
var current_spawn_interval: float = 0.4    # current spawn rate
var min_spawn_interval: float = 0.1        # maximum chaos limit
var spawn_rate_increase: float = 0.05      # how much faster every 15 seconds
var difficulty_interval: float = 15.0      # seconds between difficulty increases

var cleanup_interval: float = 2.0   # seconds between cleanup checks

# Called when spawner is ready - time to set up the escalating mayhem! 🎭
func _ready():
	print("🎪 EnemySpawner initialized! Preparing for escalating chaos...")
	_setup_spawn_timer()
	_setup_cleanup_timer()
	_setup_difficulty_timer()
	_setup_pause_timer()
	_connect_to_game_events()

# Clean up timers and references when exiting - tidy spawner! 🧹
func _exit_tree():
	# Stop all timers before cleanup
	if spawn_timer:
		spawn_timer.stop()
	if cleanup_timer:
		cleanup_timer.stop()
	if difficulty_timer:
		difficulty_timer.stop()
	if pause_timer:
		pause_timer.stop()
	
	# Clear references to prevent leaks
	spawn_timer = null
	cleanup_timer = null
	difficulty_timer = null
	pause_timer = null
	ball_reference = null
	
	print("🧹 EnemySpawner cleanup complete - no spawner leaks!")

# Set up our spawn timer - starts gentle but gets WILD! 
func _setup_spawn_timer():
	spawn_timer = Timer.new()
	spawn_timer.timeout.connect(_spawn_enemy)
	spawn_timer.wait_time = current_spawn_interval
	spawn_timer.autostart = false  # We'll start this when the game begins
	add_child(spawn_timer)
	print("⏰ Spawn timer configured for ", current_spawn_interval, " second intervals")

# Set up cleanup timer to remove off-screen enemies regularly
func _setup_cleanup_timer():
	cleanup_timer = Timer.new()
	cleanup_timer.timeout.connect(cleanup_off_screen_enemies)
	cleanup_timer.wait_time = cleanup_interval
	cleanup_timer.autostart = true  # Always running to keep things tidy
	add_child(cleanup_timer)
	print("🧹 Cleanup timer configured for ", cleanup_interval, " second intervals")

# Set up difficulty progression timer - the escalation engine! 📈
func _setup_difficulty_timer():
	difficulty_timer = Timer.new()
	difficulty_timer.timeout.connect(_increase_difficulty)
	difficulty_timer.wait_time = difficulty_interval
	difficulty_timer.autostart = false  # Start with the game
	add_child(difficulty_timer)
	print("📈 Difficulty timer configured for ", difficulty_interval, " second intervals")

# Set up pause timer for post-hit recovery - mercy period! 🛡️
func _setup_pause_timer():
	pause_timer = Timer.new()
	pause_timer.timeout.connect(_resume_spawning)
	pause_timer.wait_time = pause_duration
	pause_timer.autostart = false
	pause_timer.one_shot = true  # Only trigger once per pause
	add_child(pause_timer)
	print("🛡️ Pause timer configured for ", pause_duration, " second recovery periods")

# Connect to GameManager signals for pause functionality
func _connect_to_game_events():
	if GameManager:
		GameManager.collision_flash_started.connect(_pause_spawning)
		print("🎯 Connected to collision events for spawn pausing!")

# Connect to the ball for targeting purposes - got to know where to aim!
func set_ball_reference(ball: Node2D):
	ball_reference = ball
	print("🎯 Ball reference acquired for targeting!")

# Start the spawning madness with progressive difficulty!
func start_spawning():
	if spawn_timer and difficulty_timer:
		spawn_timer.start()
		difficulty_timer.start()
		print("🚀 Enemy spawning system ACTIVATED with progressive difficulty!")

# Stop the spawning mayhem
func stop_spawning():
	if spawn_timer:
		spawn_timer.stop()
	if difficulty_timer:
		difficulty_timer.stop()
	print("🛑 Enemy spawning DEACTIVATED!")

# Increase the difficulty - make things more intense! ⚡
func _increase_difficulty():
	if current_spawn_interval > min_spawn_interval:
		current_spawn_interval -= spawn_rate_increase
		# Don't go below the minimum!
		if current_spawn_interval < min_spawn_interval:
			current_spawn_interval = min_spawn_interval
			difficulty_timer.stop()  # Max difficulty reached!
			print("🔥 MAXIMUM CHAOS ACHIEVED! Spawn rate capped at ", min_spawn_interval, " seconds!")
		
		# Update the spawn timer with new faster rate
		spawn_timer.wait_time = current_spawn_interval
		print("📈 Difficulty increased! Enemies now spawn every ", current_spawn_interval, " seconds!")
	else:
		print("🔥 Already at maximum difficulty!")

# Reset difficulty when game restarts
func reset_difficulty():
	current_spawn_interval = initial_spawn_interval
	if spawn_timer:
		spawn_timer.wait_time = current_spawn_interval
	if difficulty_timer:
		difficulty_timer.wait_time = difficulty_interval
	print("🔄 Difficulty reset to starting level: ", current_spawn_interval, " seconds")

# The main event - spawn an enemy at a random off-screen position!
func _spawn_enemy():
	# Don't spawn if game is over or not playing
	if GameManager and (GameManager.get_is_game_over() or not GameManager.get_is_playing()):
		return
	
	# Don't spawn if we're in a mercy period after taking a hit! 🛡️
	if is_spawning_paused:
		return
		
	if not ball_reference:
		print("⚠️ No ball reference - can't spawn enemy!")
		return
	
	# Calculate spawn position 150px outside screen boundaries
	var spawn_position = _get_random_spawn_position()
	
	# Get ball's current position for targeting
	var target_position = ball_reference.global_position
	
	# Create and configure the enemy
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_position
	enemy.set_target(target_position)
	
	# Add enemy to the scene (as child of Main, not spawner)
	get_parent().add_child(enemy)
	
	# Emit signal for audio feedback! 🎵
	enemy_spawned.emit()
	
	print("👹 Enemy spawned at (", spawn_position.x, ", ", spawn_position.y, ") targeting (", target_position.x, ", ", target_position.y, ")")

# Calculate random spawn position 150px off any screen edge
func _get_random_spawn_position() -> Vector2:
	var spawn_pos = Vector2()
	var side = randi() % 4  # 0=top, 1=right, 2=bottom, 3=left
	
	match side:
		0:  # Top
			spawn_pos.x = randf() * screen_width
			spawn_pos.y = -spawn_distance
		1:  # Right  
			spawn_pos.x = screen_width + spawn_distance
			spawn_pos.y = randf() * screen_height
		2:  # Bottom
			spawn_pos.x = randf() * screen_width
			spawn_pos.y = screen_height + spawn_distance
		3:  # Left
			spawn_pos.x = -spawn_distance
			spawn_pos.y = randf() * screen_height
	
	return spawn_pos

# Clean up enemies that have wandered off-screen - performance matters!
func cleanup_off_screen_enemies():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var removed_count = 0
	
	for enemy in enemies:
		var pos = enemy.global_position
		var buffer = 50  # Small buffer beyond spawn distance
		
		# Check if enemy is way off-screen (beyond spawn distance + buffer)
		if (pos.x < -spawn_distance - buffer or pos.x > screen_width + spawn_distance + buffer or
			pos.y < -spawn_distance - buffer or pos.y > screen_height + spawn_distance + buffer):
			enemy.queue_free()
			removed_count += 1
	
	if removed_count > 0:
		print("🧹 Cleaned up ", removed_count, " off-screen enemies")

# Pause enemy spawning for mercy period after taking a hit! 🛡️
func _pause_spawning():
	if not is_spawning_paused:  # Only pause if not already paused
		is_spawning_paused = true
		pause_timer.start()
		print("🛡️ Enemy spawning PAUSED for ", pause_duration, " seconds - mercy period!")

# Resume enemy spawning after mercy period ends! ⚡
func _resume_spawning():
	if is_spawning_paused:  # Only resume if currently paused
		is_spawning_paused = false
		print("⚡ Enemy spawning RESUMED - back to the chaos!") 