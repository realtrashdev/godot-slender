## Component that can keep states active for a specific amount of time.
##
## This component is used to update [enum Enemy3D.State], so be careful when using it with other components that do that!
## [br]
class_name StateTimerComponent3D extends EnemyBehavior3D

## [active state, time]
@export var state_times: Dictionary[Enemy3D.State, float] = {
	Enemy3D.State.IDLE : 1.0
}

## [active state, transition state]
@export var state_transitions: Dictionary[Enemy3D.State, Enemy3D.State] = {
	Enemy3D.State.IDLE : Enemy3D.State.ACTIVE
}

var time: float = 0.0
var current_state: Enemy3D.State
var next_state: Enemy3D.State


func _setup() -> void:
	enemy.state_changed.connect(_on_state_changed)


func _update(delta: float) -> void:
	if current_state in state_times and time > 0:
		time -= delta
		
		# On timeout and the enemy's current state matches the state we started the timer with
		if time <= 0 and enemy.get_current_state() == current_state:
			enemy.change_state(next_state)


func _on_state_changed(new_state: Enemy3D.State):
	if new_state in state_times:
		# Get current state to compare on timeout to make sure it stays the same
		current_state = new_state
		
		# Get time to wait before transitioning to new state
		time = state_times[new_state]
		
		# Get state to transition to on timeout
		if new_state in state_transitions:
			next_state = state_transitions[new_state]
