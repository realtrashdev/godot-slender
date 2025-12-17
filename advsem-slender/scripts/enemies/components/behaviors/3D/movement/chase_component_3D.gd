## Basic navigation component for enemies.
##
## [color=yellow]Recommended Component(s):[/color] [GravityComponent3D]
## [br]
## [br]Recommended on enemies that actively pursue a target (almost always the player).
class_name ChaseComponent3D extends EnemyBehavior3D

@export var using_nav_agent: bool = true
@export var move_speeds: Dictionary[Enemy3D.State, float]

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

## Navigation without the use of navmesh.
func _basic_navigation():
	if not target:
		target = enemy.get_player()
	var direction = (target.global_position - enemy.global_position).normalized()
	enemy.velocity = direction * _get_speed()

## Navigation with the use of navmesh.
func _agent_navigation():
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
	enemy.velocity = direction * _get_speed()

## Gets the movement speed of the enemy via a dictionary of state based speeds.
func _get_speed() -> float:
	return move_speeds[enemy.get_current_state()]
