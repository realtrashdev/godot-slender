class_name ViewmodelArm extends TextureRect

@export var default_state: State

var up_position: Vector2
var down_position: Vector2

enum State {
	IDLE, # both
	READY_COLLECT, COLLECT, # left
	FLASHLIGHT, FLASHLIGHT_DOWN, # right
}
var current_state: State = State.IDLE

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	state_update(default_state)

func state_update(new_state: State):
	current_state = new_state
	var method = State.keys()[current_state]
	
	call(method.to_lower)

func idle():
	position = down_position

func collect():
	anim.play("collect_page")
	await anim.animation_finished
	state_update(State.IDLE)
