extends Node2D

signal call_ended

# 135 bpm
const UPDATE_TIMER: float = 0.44

const DECLINE_TIME: float = 2.0

var min_screen_position: Vector2 = Vector2(0, 57)
var max_screen_position: Vector2 = Vector2(122, 127)

var call_active: bool = false
var timer: float = 0.0
var decline_progress: float = 0.0

var button_down: bool = false

@onready var decline_button: Button = $DeclineButton
@onready var decline_progress_bar: ProgressBar = $DeclineProgress


func _process(delta: float) -> void:
	if visible:
		# make progress bar update to the beat
		if timer <= 0:
			update_progress_bar()
		else:
			timer -= delta
		
		if button_down:
			decline_progress += delta
		else:
			decline_progress -= delta * 0.33


func start_call():
	call_active = true
	await get_tree().create_timer(1.77).timeout
	if not visible:
		visible = true


func stop_call():
	call_ended.emit()
	call_active = false
	visible = false
	button_down = false
	decline_progress = 0.0
	decline_progress_bar.value = decline_progress


func update_progress_bar():
	timer = UPDATE_TIMER
	decline_progress_bar.value = decline_progress
	if decline_progress > DECLINE_TIME:
		stop_call()


func _on_decline_button_down() -> void:
	button_down = true


func _on_decline_button_up() -> void:
	button_down = false
