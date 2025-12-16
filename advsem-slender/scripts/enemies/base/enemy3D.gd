## Base class for all 3D enemies.
##
## Controls enemy State, and updates [EnemyBehavior3D] components.
class_name Enemy3D extends Node3D

enum State {
	IDLE,       ## For enemies that only active while within proximity, etc.
	ACTIVE,     ## Basic "I am doing stuff" state. Chaser is ACTIVE while pursuing the player.
	ATTACKING,  ## Not all enemies use this. Use case example would be an enemy that needs to be flashed ONLY while it is charging at the player.
	FLEEING,    ## Could be for enemies that run before dying, or for enemies that steal something and run from the player.
	DYING,      ## Feel like this one's pretty self explanatory.
	}

var components: Array[EnemyBehavior3D]

var current_state: State = State.IDLE
var using_tick_system: bool = false

# Sets up components array and checks for tick system
func _ready() -> void:
	_get_components()
	var tick_component = get_tick_system()
	if tick_component:
		using_tick_system = true
		tick_component.tick.connect(_tick_process)

# Calls update function of child components.
func _process(delta: float) -> void:
	for component in components:
		if component.has_method("update"):
			component.update(delta)

# Calls physics update function of child components.
func _physics_process(delta: float) -> void:
	for component in components:
		if component.has_method("physics_update"):
			component.physics_update(delta)
	if not using_tick_system: _tick_process()

## Calls [method EnemyBehavior3D.tick_update] function of child components.
func _tick_process() -> void:
	for component in components:
		if component.has_method("tick_update"):
			component.tick_update()

#region State Management
func get_current_state() -> State:
	return current_state

func change_state(new_state: State):
	current_state = new_state
#endregion

func die():
	pass

func _get_components():
	for child in get_children():
		if child is Node:
			components.push_back(child)

#region Helpers
# Components
func get_component(component_type: GDScript) -> EnemyBehavior3D:
	for component in components:
		if component.get_script() == component_type:
			return component
	return null

func has_component(component_type: GDScript) -> bool:
	return get_component(component_type) != null

# General
func get_character_body_3d() -> CharacterBody3D:
	for child in get_children():
		if child is CharacterBody3D:
			return child
	return null

func get_animated_sprite_3d() -> AnimatedSprite3D:
	for child in get_children():
		if child is AnimatedSprite3D:
			return child
	return null

func get_tick_system() -> TickComponent:
	for child in get_children():
		if child is TickComponent:
			return child
	return null
#endregion
