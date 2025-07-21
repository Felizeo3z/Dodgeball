extends Node

# Game state management - keeping track of all the important stuff! 🎮
signal life_lost(lives_remaining: int)
signal game_over
signal score_updated(score: int)
signal game_started
signal game_restarted
signal collision_flash_started
signal collision_flash_ended

# Game state variables
var lives: int = 3
var score: int = 0
var is_game_over: bool = false
var is_playing: bool = false
var is_flashing: bool = false

# Scoring system - 1 point per second of survival! ⏱️
var score_timer: Timer
var flash_timer: Timer

func _ready():
	print("🎯 GameManager loaded! Ready to manage some epic survival!")
	_setup_score_timer()
	_setup_flash_timer()

# Clean up timers when exiting - pristine GameManager! 🧹
func _exit_tree():
	# Stop timers before cleanup
	if score_timer:
		score_timer.stop()
	if flash_timer:
		flash_timer.stop()
	
	# Clear references
	score_timer = null
	flash_timer = null
	
	print("🧹 GameManager cleanup complete - no manager leaks!")

# Initialize our scoring timer - steady as she goes!
func _setup_score_timer():
	score_timer = Timer.new()
	score_timer.timeout.connect(_increment_score)
	score_timer.wait_time = 1.0  # 1 second intervals
	score_timer.autostart = false
	add_child(score_timer)

# Initialize flash timer for collision visual effects! ✨
func _setup_flash_timer():
	flash_timer = Timer.new()
	flash_timer.timeout.connect(_end_collision_flash)
	flash_timer.wait_time = 1.0  # 1 second flash duration
	flash_timer.autostart = false
	add_child(flash_timer)

# Start the game - reset everything and begin scoring!
func start_game():
	if is_game_over:
		restart_game()
		return
	
	# Only start timer and scoring when ball actually begins tracking! 🎯
	_start_scoring()
	game_started.emit()
	print("🚀 Game started! Ball is now tracking mouse!")

# Handle collision between ball and enemy - ouch! 💥
func handle_collision():
	if is_game_over:
		return
	
	# Start the visual flash sequence! ✨
	_start_collision_flash()
	
	lives -= 1
	print("💔 Life lost! Lives remaining: ", lives)
	life_lost.emit(lives)
	
	if lives <= 0:
		_trigger_game_over()

# Game over sequence - the end of our survival run! 😵
func _trigger_game_over():
	is_game_over = true
	is_playing = false
	score_timer.stop()
	print("💀 GAME OVER! Final score: ", score)
	game_over.emit()

# Restart the game - fresh start, clean slate! ✨
func restart_game():
	lives = 3
	score = 0
	is_game_over = false
	is_playing = false  # Not playing until ball is clicked! 
	
	# Stop timer and reset score display, but don't start timer yet! ⏸️
	score_timer.stop()
	score_updated.emit(score)
	game_restarted.emit()
	print("🔄 Game restarted! Lives: ", lives, " Score: ", score, " - Click ball to start timer!")

# Start the scoring timer - only when ball begins tracking! ⏰
func _start_scoring():
	is_playing = true
	score_timer.start()
	score_updated.emit(score)  # Update UI with initial score
	print("⏰ Score timer started! Survival time now counting!")

# Increment score every second - survival pays off! 🏆
func _increment_score():
	if is_playing and not is_game_over:
		score += 1
		score_updated.emit(score)

# Start collision flash effects - lights, camera, action! 🎬
func _start_collision_flash():
	is_flashing = true
	score_timer.set_paused(true)  # Pause scoring during flash! ⏸️
	collision_flash_started.emit()
	flash_timer.start()
	print("✨ Collision flash started! Timer paused.")

# End collision flash effects - back to normal! 
func _end_collision_flash():
	is_flashing = false
	score_timer.set_paused(false)  # Resume scoring after flash! ▶️
	collision_flash_ended.emit()
	print("✨ Collision flash ended! Timer resumed.")

# Getters for external systems to check state
func get_lives() -> int:
	return lives

func get_score() -> int:
	return score

func get_is_game_over() -> bool:
	return is_game_over

func get_is_playing() -> bool:
	return is_playing

func get_is_flashing() -> bool:
	return is_flashing 