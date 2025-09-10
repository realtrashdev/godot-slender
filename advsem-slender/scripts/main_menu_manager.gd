extends CanvasLayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func start_game():
	get_tree().change_scene_to_file("res://scenes/playground_level.tscn")

func quit_game():
	get_tree().quit()
