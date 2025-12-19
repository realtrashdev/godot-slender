## Component that marks an enemy as using and handles their place in the tick system.
## [br]To execute component code on the tick system, override [method EnemyBehavior3D._tick_update].
##
## The tick system allows for certain components (navigation, etc.) to update less often,
## and staggers the updates automatically to improve performance.
## [br]
## [br]Highly recommended on enemies that utilize navmesh navigation.
class_name TickComponent extends Node

signal tick

@export var update_frequency: int = 6

static var global_tick: int = 0
static var active_pathfinders: Array[TickComponent] = []

func _ready():
	active_pathfinders.append(self)
	add_to_group("Pathfinder")

func _exit_tree():
	active_pathfinders.erase(self)
	
	if active_pathfinders.is_empty():
		global_tick = 0

func _physics_process(_delta: float) -> void:
	# first pathfinder increments tick
	if active_pathfinders.size() > 0 and active_pathfinders[0] == self:
		global_tick += 1
	
	var my_index = active_pathfinders.find(self)
	if my_index == -1:
		return
	
	# get staggered offset based on position in array
	var total_enemies = active_pathfinders.size()
	var my_offset = (my_index * update_frequency) / max(1, total_enemies)
	
	# check if it's this enemy's turn to pathfind
	if (global_tick - my_offset) % update_frequency == 0:
		tick.emit()
