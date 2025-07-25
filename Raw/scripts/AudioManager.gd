extends Node

# Procedural audio system - making sweet retro beeps and blips! 🎵
# Generates sine waves for enemy spawns and sawtooth waves for collisions

# Audio players for our sound effects
var spawn_audio_player: AudioStreamPlayer
var collision_audio_player: AudioStreamPlayer

# Audio stream generators for procedural sound
var spawn_generator: AudioStreamGenerator
var collision_generator: AudioStreamGenerator

# Playback objects for pushing audio samples
var spawn_playback: AudioStreamGeneratorPlayback
var collision_playback: AudioStreamGeneratorPlayback

# Audio parameters - tuned for that classic arcade feel! 🕹️
var spawn_frequency: float = 50.0      # 50Hz sine wave for enemy spawns
var collision_frequency: float = 100.0  # 100Hz sawtooth for collisions
var sound_duration: float = 0.2        # 200ms duration for each sound
var sample_rate: float = 22050.0       # Audio sample rate
var phase: float = 0.0                 # Current phase for waveform generation

func _ready():
	print("🎵 AudioManager initialized! Ready to generate some retro sounds!")
	_setup_audio_generators()
	_connect_to_game_signals()

# Clean up audio resources when exiting - no leaks here! 🧹
func _exit_tree():
	# Stop any playing audio
	if spawn_audio_player and spawn_audio_player.playing:
		spawn_audio_player.stop()
	if collision_audio_player and collision_audio_player.playing:
		collision_audio_player.stop()
	
	# Clear references to prevent leaks
	spawn_generator = null
	collision_generator = null
	spawn_playback = null
	collision_playback = null
	
	print("🧹 AudioManager cleanup complete - no audio leaks!")

# Set up our audio stream generators and players
func _setup_audio_generators():
	# Set up spawn sound generator
	spawn_generator = AudioStreamGenerator.new()
	spawn_generator.buffer_length = 0.1  # 100ms buffer
	
	spawn_audio_player = AudioStreamPlayer.new()
	spawn_audio_player.stream = spawn_generator
	spawn_audio_player.bus = "Master"
	add_child(spawn_audio_player)
	
	# Set up collision sound generator
	collision_generator = AudioStreamGenerator.new()
	collision_generator.buffer_length = 0.1  # 100ms buffer
	
	collision_audio_player = AudioStreamPlayer.new()
	collision_audio_player.stream = collision_generator
	collision_audio_player.bus = "Master"
	add_child(collision_audio_player)
	
	print("🔊 Audio generators configured and ready!")

# Connect to GameManager and other game signals
func _connect_to_game_signals():
	# Connect to collision events from GameManager
	if GameManager:
		GameManager.collision_flash_started.connect(_play_collision_sound)
		print("🎯 Connected to collision signal!")
	
	# Connect to enemy spawn events - we'll need to find the EnemySpawner
	# and connect to its spawn event (we'll add this signal to EnemySpawner)
	call_deferred("_connect_to_enemy_spawner")

# Find and connect to the EnemySpawner for spawn sounds
func _connect_to_enemy_spawner():
	# Find the EnemySpawner in the scene tree
	var main_scene = get_tree().current_scene
	if main_scene and main_scene.has_method("get_enemy_spawner"):
		var enemy_spawner = main_scene.get_enemy_spawner()
		if enemy_spawner:
			# We'll need to add this signal to EnemySpawner.gd
			if enemy_spawner.has_signal("enemy_spawned"):
				enemy_spawner.enemy_spawned.connect(_on_enemy_spawned)
				print("🎯 Connected to enemy spawn events!")

# Play enemy spawn sound - 50Hz sine wave goodness! 🌊
func play_spawn_sound():
	print("🎵 Playing enemy spawn sound (50Hz sine)!")
	
	# Start playing if not already playing
	if not spawn_audio_player.playing:
		spawn_audio_player.play()
	
	# Get the playback object to push samples
	spawn_playback = spawn_audio_player.get_stream_playback()
	if spawn_playback:
		_generate_sine_wave(spawn_playback, spawn_frequency, sound_duration)

# Play collision sound - 100Hz sawtooth wave impact! ⚡
func _play_collision_sound():
	print("💥 Playing collision sound (100Hz sawtooth)!")
	
	# Start playing if not already playing
	if not collision_audio_player.playing:
		collision_audio_player.play()
	
	# Get the playback object to push samples
	collision_playback = collision_audio_player.get_stream_playback()
	if collision_playback:
		_generate_sawtooth_wave(collision_playback, collision_frequency, sound_duration)

# Generate sine wave samples and push to playback buffer
func _generate_sine_wave(playback: AudioStreamGeneratorPlayback, frequency: float, duration: float):
	var samples_to_generate = int(sample_rate * duration)
	var increment = frequency / sample_rate
	
	for i in range(samples_to_generate):
		var sample_value = sin(phase * 2.0 * PI) * 0.5  # 50% volume to prevent clipping
		var frame = Vector2(sample_value, sample_value)  # Stereo frame
		
		if playback.get_frames_available() > 0:
			playback.push_frame(frame)
		
		phase = fmod(phase + increment, 1.0)

# Generate sawtooth wave samples and push to playback buffer
func _generate_sawtooth_wave(playback: AudioStreamGeneratorPlayback, frequency: float, duration: float):
	var samples_to_generate = int(sample_rate * duration)
	var increment = frequency / sample_rate
	
	for i in range(samples_to_generate):
		# Sawtooth wave: linear ramp from -1 to 1
		var sawtooth_phase = fmod(phase, 1.0)
		var sample_value = (sawtooth_phase * 2.0 - 1.0) * 0.5  # 50% volume
		var frame = Vector2(sample_value, sample_value)  # Stereo frame
		
		if playback.get_frames_available() > 0:
			playback.push_frame(frame)
		
		phase = fmod(phase + increment, 1.0)

# Handle enemy spawn events
func _on_enemy_spawned():
	play_spawn_sound() 