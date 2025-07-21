extends CanvasLayer

# UI management - keeping the score looking pretty! ✨
@onready var score_label: Label = $ScoreLabel

# Game over display element - clean and simple! 🎭
var game_over_label: Label

func _ready():
	print("🎨 UI loaded! Ready to show off that survival time!")
	
	# Connect to GameManager signals
	GameManager.score_updated.connect(_on_score_updated)
	GameManager.game_restarted.connect(_on_game_restarted)
	GameManager.game_over.connect(_on_game_over)
	
	# Style the score label - light grey and centered
	_setup_score_display()
	
	# Create our clean game over display! 🎭
	_setup_game_over_display()

# Set up the score display styling
func _setup_score_display():
	score_label.modulate = Color.LIGHT_GRAY
	score_label.add_theme_font_size_override("font_size", 64)  # Nice and big for easy reading! 👀

# Create the game over display element - simple and centered! 🎬
func _setup_game_over_display():
	# Single centered "click to restart" message - clean and clear! 🔄
	game_over_label = Label.new()
	game_over_label.text = "click to restart"
	game_over_label.modulate = Color.RED
	game_over_label.add_theme_font_size_override("font_size", 48)
	game_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_over_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Position using EXACT same settings as ScoreLabel! 
	game_over_label.anchors_preset = Control.PRESET_CENTER
	# Explicitly set anchor values to match ScoreLabel exactly
	game_over_label.anchor_left = 0.5
	game_over_label.anchor_top = 0.5  
	game_over_label.anchor_right = 0.5
	game_over_label.anchor_bottom = 0.5
	# Use exact same offsets as ScoreLabel
	game_over_label.offset_left = -150.0
	game_over_label.offset_top = -75.0
	game_over_label.offset_right = 150.0
	game_over_label.offset_bottom = 75.0
	game_over_label.visible = false  # Hidden by default
	add_child(game_over_label)

# Handle score updates from GameManager
func _on_score_updated(score: int):
	score_label.text = _format_time(score)

# Handle game over - show restart message and hide timer! 🎭
func _on_game_over():
	print("💀 UI: Game over! Showing restart message and hiding timer...")
	score_label.visible = false  # Hide the timer during game over
	game_over_label.visible = true  # Show the restart message

# Handle game restart - show timer and hide game over message
func _on_game_restarted():
	print("🔄 UI: Game restarted! Showing timer and hiding restart message...")
	score_label.text = "000:00:00"
	score_label.visible = true  # Show the timer again
	game_over_label.visible = false  # Hide the restart message

# Convert seconds to HHH:MM:SS format - fancy time display! ⏰
func _format_time(total_seconds: int) -> String:
	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60
	
	# Format with leading zeros - gotta look professional!
	return "%03d:%02d:%02d" % [hours, minutes, seconds] 