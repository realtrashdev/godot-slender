extends Menu

const GAME_SCENE: String = "res://scenes/playground_scenes/playground_level.tscn"

@onready var manager: Node3D = get_parent()
@onready var description_text: RichTextLabel = $Menu/DescriptionText

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	zoom_effect(Vector2(1, 1), 0.5, Tween.TRANS_QUART, Tween.EASE_OUT)

func start_game():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	zoom_effect(Vector2(10, 10), 0.6, Tween.TRANS_QUART, Tween.EASE_IN)
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(GAME_SCENE)

func back():
	menu_selected.emit("Main", MenuDirection.BACKWARD)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	zoom_effect(Vector2.ZERO, 0.5, Tween.TRANS_QUART, Tween.EASE_IN)

func update_description_text():
	pass
