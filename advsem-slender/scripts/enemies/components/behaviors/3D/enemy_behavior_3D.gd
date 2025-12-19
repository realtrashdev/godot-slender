## Base class for all 3D enemy behaviors.
## 
## Components that extend from this class get automatic:
## [br]- [Enemy3D] parent reference after parent is ready
## [br]- State-based activation (via active_states export)
## [br]- Ready, Process, Physics Process, and Tick Process connections
## [br]
## [br]Overrides:
## [br][method _setup] for initialization.
## [br][method _update] for every-frame logic.
## [br][method _physics_update] for every-frame logic.
## [br][method _tick_update] for low-frequency AI logic.
class_name EnemyBehavior3D extends Node

## Parent of all [EnemyBehavior3D] nodes. Used to check state 
var enemy: Enemy3D
@export var active_states: Array[Enemy3D.State] = []

func _ready() -> void:
	var parent = get_parent()
	assert(parent != null, "%s: No parent node!" % name)
	
	# Wait for Enemy3D to finish setup
	await parent.ready
	enemy = parent as Enemy3D
	assert(enemy != null, "%s: Must be child of Enemy3D!" % name)
	
	if enemy == null:
		push_error("%s: Must be child of Enemy3D!" % name)
		queue_free()
		return
	
	# Call derived class' setup
	_setup()

## Checks [Enemy3D] parent's active_state and compares it with the behavior's active_states.
## If the [Enemy3D]'s active_state matches any of the behavior's, the behavior is considered active and will update.
func is_active() -> bool:
	if not enemy:
		return false
	
	if active_states.is_empty():
		return true
	
	return enemy.get_current_state() in active_states

## [color=red]Do NOT override![/color]
## Use [method _update] instead!
func update(delta: float) -> void:
	if not is_active():
		return
	_update(delta)

## [color=red]Do NOT override![/color]
## Use [method _physics_update] instead!
func physics_update(delta: float) -> void:
	if not is_active():
		return
	_physics_update(delta)

## [color=red]Do NOT override![/color]
## Use [method _tick_update] instead!
func tick_update() -> void:
	if not is_active():
		return
	_tick_update()

## Override in subclasses, acts as [method Node._ready].
func _setup() -> void:
	pass

## Override in subclasses, acts as [method Node._process].
func _update(delta: float) -> void:
	pass

## Override in subclasses, acts as [method Node._physics_process].
func _physics_update(delta: float) -> void:
	pass

## Override in subclasses, acts as [method Enemy3D._tick_process].
## If there is no tick system, this acts as [method Node._physics_process].
func _tick_update() -> void:
	pass
