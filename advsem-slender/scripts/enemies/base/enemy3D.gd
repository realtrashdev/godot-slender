## Base class for all 3D enemies.
##
## Controls enemy State, and updates [EnemyBehavior3D] components.
class_name Enemy3D extends CharacterBody3D

enum State {
	IDLE,             ## For enemies that only get set to active when the player is within proximity, etc.
	ACTIVE,           ## Basic "I am doing stuff" state. Chaser is ACTIVE while pursuing the player.
	ACTIVE_REPELLING, ## Necessary for things like shining the light at an enemy for a duration to repel them, causing sprite shake/other effects.
	ATTACKING,        ## Not all enemies use this. Use case example would be an enemy that needs to be flashed ONLY while it is charging at the player.
	FLEEING,          ## Could be for enemies that run before dying, or for enemies that steal something and run from the player.
	DYING,            ## Feel like this one's pretty self explanatory.
	}

var components: Array[EnemyBehavior3D]
var player: CharacterBody3D

var current_state: State = State.IDLE
var using_tick_system: bool = false

# Set up components array and check for tick system
func _ready() -> void:
	_get_player()
	_get_components()
	var tick_component = get_tick_system()
	if tick_component:
		using_tick_system = true
		tick_component.tick.connect(_tick_process)

# Call update function of child components.
func _process(delta: float) -> void:
	for component in components:
		if component.has_method("update"):
			component.update(delta)

# Call physics update function of child components.
func _physics_process(delta: float) -> void:
	for component in components:
		if component.has_method("physics_update"):
			component.physics_update(delta)
	if not using_tick_system: _tick_process()
	
	var body = get_character_body_3d()
	if body:
		body.move_and_slide()

## Call [method EnemyBehavior3D.tick_update] function of child components.
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

## Gets all [EnemyBehavior3D] components and places them into the components array.
func _get_components():
	for child in get_children():
		if child is EnemyBehavior3D:
			components.push_back(child)

## Cache player reference for components to use
func _get_player():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		push_warning("%s: More than one player found in 'player' group!" % name)
		player = players[0]
	else:
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
func get_player() -> CharacterBody3D:
	return player

func get_character_body_3d() -> CharacterBody3D:
	for child in get_children():
		if child is CharacterBody3D:
			return child
	return self

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
#endregion
