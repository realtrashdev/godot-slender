## Basic navigation component for enemies.
##
## [color=yellow]Recommended Component(s):[/color] [GravityComponent3D]
## [br]
## [br]Recommended on enemies that actively pursue a target (almost always the player).
class_name ChaseComponent3D extends EnemyBehavior3D

@export_group("General")
@export var using_nav_agent: bool = true
@export var move_speeds: Dictionary[Enemy3D.State, float]

@export_group("Distance Speed Multiplier")
@export var using_distance_speed_multiplier: bool = false
## Format: [[(int) Minimum distance, (float) Speed multiplier], [Min distance, Speed mult], ...]
## [br]Example: [50, 1.5] - 50m or greater: 1.5x speed multiplier
@export var distance_speed_multipliers: Array[Array] = [[0, 0.0], [0, 0.0], [0, 0.0]]

var nav_agent: NavigationAgent3D
var target: Node3D = null # Defaults to player for now


func _setup() -> void:
	# Get Player from parent
	target = enemy.get_player()
	if not target:
		push_warning("%s: Player not found." % name)
	
	# Get NavigationAgent3D from parent
	nav_agent = enemy.get_navigation_agent_3d()
	if not nav_agent and using_nav_agent:
		push_warning("%s: ChaseComponent marked as using NavigationAgent3D but could not find it. Deleting component!" % name)
		queue_free()


func _tick_update() -> void:
	if using_nav_agent:
		_agent_navigation()
	else:
		_basic_navigation()
	print(_get_distance_from_target())


## Navigation without the use of navmesh.
func _basic_navigation() -> void:
	if not target:
		target = enemy.get_player()
		if not target: return
	var direction = (target.global_position - enemy.global_position).normalized()
	
	_apply_velocity(direction)


## Navigation with the use of navmesh.
func _agent_navigation() -> void:
	# Update nav agent target position
	if target:
		nav_agent.target_position = target.global_position
	else:
		target = enemy.get_player()
	
	# If touching the target, don't navigate
	if nav_agent.is_navigation_finished():
		return
	
	# Apply velocity to enemy
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - enemy.global_position).normalized()
	
	_apply_velocity(direction)


func _apply_velocity(dir: Vector3):
	# Only apply horizontal movement, preserve Y velocity
	var horizontal_velocity = Vector3(dir.x, 0, dir.z).normalized() * _get_speed()
	enemy.velocity.x = horizontal_velocity.x
	enemy.velocity.z = horizontal_velocity.z


## Gets the movement speed of the enemy via a dictionary of state based speeds.
func _get_speed() -> float:
	var speed = move_speeds[enemy.get_current_state()]
	
	if using_distance_speed_multiplier and not distance_speed_multipliers.is_empty():
		speed *= _get_distance_speed_multiplier()
	
	print(speed)
	return speed


func _get_distance_speed_multiplier() -> float:
	var dist = _get_distance_from_target()
	var multiplier: float = 1.0
	
	for value in distance_speed_multipliers:
		# Goes until it finds a value that is bigger than the distance, and then stops
		if dist >= value[0]:
			multiplier = value[1]
		else:
			break # Got multiplier, can return now
	
	return multiplier


func _get_distance_from_target() -> float:
	if not target:
		return 0.0
	
	var dist: int = roundi(enemy.global_position.distance_to(target.global_position))
	var collider = enemy.get_collision_shape_3d()
	dist -= collider.shape.radius * 2
	
	return dist
