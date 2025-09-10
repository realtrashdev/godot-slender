extends CanvasLayer

@export var game_scene: PackedScene

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func start_game():
	get_tree().change_scene_to_packed(game_scene)

func quit_game():
	get_tree().quit()
