extends Menu

const GAME_SCENE: String = "res://scenes/playground_scenes/playground_level.tscn"

@onready var manager: Node3D = get_parent()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu_zoom_effect(Vector2(1, 1), 0.5, Tween.TRANS_QUART, Tween.EASE_OUT)

func start_game():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	menu_zoom_effect(Vector2(5, 5), 0.5, Tween.TRANS_QUART, Tween.EASE_IN)
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(GAME_SCENE)

func back():
	menu_selected.emit("Main", MenuDirection.BACKWARD)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	menu_zoom_effect(Vector2.ZERO, 0.5, Tween.TRANS_QUART, Tween.EASE_IN)

	await get_tree().create_timer(0.7).timeout
	get_tree().quit()
