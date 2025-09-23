extends CanvasLayer

const GAME_SCENE: String = "res://scenes/playground_scenes/playground_level.tscn"

var choice_made: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func start_game():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	zoom_effect(Vector2(5, 5))
	$PlayAudio.play()
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file(GAME_SCENE)

func quit_game():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	zoom_effect(Vector2.ZERO)
	$QuitAudio.play()
	await get_tree().create_timer(1.25).timeout
	get_tree().quit()

func zoom_effect(zoom_amount: Vector2):
	var tween = create_tween()
	tween.tween_property($Control, "scale", zoom_amount, 1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
