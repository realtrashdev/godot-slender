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
@onready var nav_region = get_parent().nav_region

func _ready() -> void:
	Signals.page_collected.connect(page_collected)
	set_timer()

func _process(delta: float) -> void:
	spawn_timer -= delta
	print(spawn_timer)
	
	if spawn_timer <= 0:
		spawn_enemy()
		set_timer()
	
	if Input.is_action_just_pressed("ui_focus_next"):
		spawn_enemy()

func spawn_enemy():
	var map_rid = nav_region.get_navigation_map()
	if map_rid == RID():
		push_warning("no navigation map available to spawn enemy")
		return

	var enemy = enemy_to_spawn.instantiate()

	var max_attempts = 10
	var found = false
	var spawn_pos = Vector3.ZERO

	for i in range(max_attempts):
		# pick random angle around player
		var angle = randf() * TAU
		var offset = Vector3(cos(angle), 0, sin(angle)) * spawn_distance
		var candidate = player.position + offset

		# snap to navmesh
		var closest_point = NavigationServer3D.map_get_closest_point(map_rid, candidate)

		# success if navmesh gives something
		if closest_point != Vector3.ZERO:
			spawn_pos = closest_point
			found = true
			break

	if found:
		enemy.position = spawn_pos
		add_child(enemy)
	else:
		# no valid spots -> try again later
		spawn_timer = 1

func page_collected():
	pages_collected += 1

func set_timer():
	spawn_timer = randf_range(min_spawn_time, max_spawn_time)
