extends Node2D

signal call_ended

# 135 bpm
const BOUNCE_TIMER: float = 0.44

var min_screen_position: Vector2 = Vector2(0, 57)
var max_screen_position: Vector2 = Vector2(122, 127)

var call_active: bool = false
var timer: float = 0

@onready var decline_button: Button = $ColorRect/DeclineButton

func _process(delta: float) -> void:
	if visible:
		if timer <= 0:
			randomize_button_position()
		else:
			timer -= delta

func start_call():
	call_active = true
	await get_tree().create_timer(1.77).timeout
	if not visible:
		visible = true
		randomize_button_position()

func stop_call():
	call_ended.emit()
	call_active = false
	visible = false

func randomize_button_position():
	decline_button.position = Vector2(randf_range(min_screen_position.x, max_screen_position.x), randf_range(min_screen_position.y, max_screen_position.y))
	timer = BOUNCE_TIMER

func _on_decline_button_pressed():
	stop_call()
