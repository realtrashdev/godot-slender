## Component that detects light raycast from player flashlight.
##
## Typically, this component will be used to toggle states between [enum Enemy3D.State.ACTIVE]
## [br]and either [enum Enemy3D.State.ACTIVE_REPELLING] or [enum Enemy3D.State.ATTACKING].
## [br]
## [br]It can also be used with a timer to change state after a certain period of flashlight shine.
## [br]
## [br]This component is used to update [enum Enemy3D.State], so be careful when using it with other components that do that!
class_name LightSensitiveComponent3D extends EnemyBehavior3D

@export_group("General")
@export var unlit_state: Enemy3D.State = Enemy3D.State.ACTIVE
@export var lit_state: Enemy3D.State = Enemy3D.State.ACTIVE_REPELLING

@export_group("Timing")
@export var do_shine_time: bool = false
@export var shine_time: float = 2.0
@export var shine_state_transition: Enemy3D.State
var time: float

var is_lit: bool = false


func _setup() -> void:
	if do_shine_time:
		time = shine_time


func _update(delta: float) -> void:
	if do_shine_time and is_lit:
		time -= delta
		if time <= 0:
			enemy.change_state(shine_state_transition)


## Ensures that if this component is deleted while the enemy is in the lit state, it transitions back to unlit.
func _exit_tree() -> void:
	if enemy.get_current_state() == lit_state:
		enemy.change_state(unlit_state)


## Public method called by flashlight enemy raycast.
func set_targeted(active: bool) -> void:
	if not is_active():
		return
	
	if is_lit == active:
		return
	
	is_lit = active
	
	if is_lit:
		enemy.change_state(lit_state)
	else:
		enemy.change_state(unlit_state)
