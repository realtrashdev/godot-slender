## Base class for all 3D enemies.
##
## Controls enemy State, and updates [EnemyBehavior3D] components.
class_name Enemy3D extends CharacterBody3D

enum State {
	IDLE,             ## For enemies that only get set to active when the player is within proximity, etc.
	ACTIVE,           ## Basic "I am doing stuff" state. Chaser is [enum State.ACTIVE] while pursuing the player.
	ACTIVE_REPELLING, ## Necessary for things like shining the light at an enemy for a duration to repel them, causing sprite shake/other effects.
	ATTACKING,        ## Not all enemies use this. Use case example would be an enemy that needs to be flashed ONLY while it is charging at the player.
	FLEEING,          ## Could be for enemies that run before dying, or for enemies that steal something and run from the player.
	DYING,            ## Enemy is currently in the process of dying. Typically just used for death animations before entering [enum State.DEAD].
	DEAD,             ## Only used for calling queue_free() on the [Enemy3D]. Use [State.DYING] for animation purposes, etc.
	}

signal state_changed(State)

@export var starting_state: State = State.IDLE

@export_group("Position Nodes")
@export var flashlight_attract_position: Node3D

var components: Array[EnemyBehavior3D]
var player: CharacterBody3D
## Automatically given by EnemySpawner.
var profile: EnemyProfile

var current_state: State
var using_tick_system: bool = false

# Set up components array and check for tick system
func _ready() -> void:
	current_state = starting_state
	_get_components()
	var tick_component = get_tick_system()
	if tick_component:
		using_tick_system = true
		tick_component.tick.connect(_tick_process)
	_get_player()

# Call update function of child components.
func _process(delta: float) -> void:
	for component in components:
		if component.has_method("update"):
			component.update(delta)

# Call physics update function of child components.
func _physics_process(delta: float) -> void:
	# Reset horizontal velocity
	velocity.x = 0
	velocity.z = 0
	
	for component in components:
		if component.has_method("physics_update"):
			component.physics_update(delta)
	
	if not using_tick_system: _tick_process()
	move_and_slide()

## Call [method EnemyBehavior3D.tick_update] function of child components.
func _tick_process() -> void:
	for component in components:
		if component.has_method("tick_update"):
			component.tick_update()

#region State Management
func get_current_state() -> State:
	return current_state

func change_state(new_state: State):
	if new_state == State.DEAD: die()
	current_state = new_state
	state_changed.emit(new_state)
#endregion

func die():
	queue_free()

## Gets all [EnemyBehavior3D] components and places them into the components array.
func _get_components():
	for child in get_children():
		if child is EnemyBehavior3D:
			components.push_back(child)

## Cache player reference for components to use
func _get_player():
	player = get_tree().get_first_node_in_group("Player")
	if not player:
		push_warning("%s: No player found in 'player' group!" % name)
		player = null

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
func get_profile() -> EnemyProfile:
	assert(profile != null, "%s: Enemy has no EnemyProfile!" % name)
	return profile

func get_player() -> CharacterBody3D:
	return player

func get_character_body_3d() -> CharacterBody3D:
	return self

func get_collision_shape_3d() -> CollisionShape3D:
	for child in get_children():
		if child is CollisionShape3D:
			return child
	return null

func get_animated_sprite_3d() -> AnimatedSprite3D:
	for child in get_children():
		if child is AnimatedSprite3D:
			return child
	return null

func get_navigation_agent_3d() -> NavigationAgent3D:
	for child in get_children():
		if child is NavigationAgent3D:
			return child
	return null

func get_tick_system() -> TickComponent:
	for child in get_children():
		if child is TickComponent:
			return child
	return null

# Outside of Enemy3D Helpers
func get_flashlight_attract_position() -> Vector3:
	if flashlight_attract_position:
		return flashlight_attract_position.global_position
	return Vector3.ZERO
#endregion
