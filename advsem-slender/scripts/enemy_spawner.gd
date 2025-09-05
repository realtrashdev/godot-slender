extends Node3D

@export var enemy_to_spawn: PackedScene

@export_category("Spawning")
@export var min_spawn_time: float
@export var max_spawn_time: float
@export var spawn_distance: float
var min_spawn_modifier: float
var max_spawn_modifier: float

var spawn_timer
var pages_collected: int = 0

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	Signals.page_collected.connect(page_collected)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		spawn_enemy()

func spawn_enemy():
	var enemy = enemy_to_spawn.instantiate()

	# pick a random angle in radians
	var angle = randf() * TAU  
	var offset = Vector3(cos(angle), 0, sin(angle)) * spawn_distance
	var spawn_pos = player.position + offset

	# make sure it's within the navmesh
	if is_position_in_nav_region_3d(spawn_pos):
		enemy.position = spawn_pos
		add_child(enemy)
	else:
		# try again later
		spawn_timer = 1


func is_position_in_nav_region_3d(position: Vector3) -> bool:
	var map_rid = get_world_3d().navigation_map
	var closest_point = NavigationServer3D.map_get_closest_point(map_rid, position)

	# check if point is "close enough" to navmesh
	return position.distance_to(closest_point) < 0.5

func page_collected():
	pages_collected += 1
