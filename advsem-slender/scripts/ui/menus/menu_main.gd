extends Menu

const GAME_SCENE: String = "res://scenes/playground_scenes/playground_level.tscn"

@onready var manager: Node3D = get_parent()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu_zoom_effect(Vector2(1, 1), 0.5, Tween.TRANS_QUART, Tween.EASE_OUT)

func start_game():
	menu_selected.emit("Play", MenuDirection.FORWARD)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	menu_zoom_effect(Vector2(5, 5), 0.5, Tween.TRANS_QUART, Tween.EASE_IN)

func quit_game():
	menu_selected.emit("Quit", MenuDirection.BACKWARD)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	menu_zoom_effect(Vector2.ZERO, 0.5, Tween.TRANS_QUART, Tween.EASE_IN)
	
	create_tween().tween_property($QuitAudio, "volume_db", -25, 0.6).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	$QuitAudio.play()
