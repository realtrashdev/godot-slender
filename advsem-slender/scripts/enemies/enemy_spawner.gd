extends Node3D

enum SPAWN_TYPE { RING }

@export var enemy_to_spawn: PackedScene

@export_category("Spawning")
@export var spawn_type: SPAWN_TYPE
@export var min_spawn_time: float
@export var max_spawn_time: float
@export var spawn_distance: float
var min_spawn_modifier: float
var max_spawn_modifier: float

var spawn_timer
var pages_collected: int = 0

var go = false

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var nav_region = get_parent().nav_region

func _ready() -> void:
	Signals.page_collected.connect(page_collected)
	set_timer()
	taking_too_long()

func _process(delta: float) -> void:
	# should be removed later on, as these spawners should be dynamically added to the scene tree.
	if pages_collected > 0 or go:
		spawn_timer -= delta
	
	if spawn_timer <= 0:
		spawn_enemy()
		set_timer()
	
	if Input.is_action_just_pressed("ui_focus_next"):
		spawn_enemy()

func spawn_enemy():
	var map_rid = nav_region.get_navigation_map()
	if map_rid == RID():
		push_warning("No navigation map available to spawn enemy!")
		return

	var enemy = enemy_to_spawn.instantiate()

	var max_attempts = 10
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
			break

	if spawn_pos != null:
		enemy.position = spawn_pos
		add_child(enemy)
	else:
		# no valid spots, try again later
		spawn_timer = 1

func page_collected():
	pages_collected += 1

func set_timer():
	spawn_timer = randf_range(min_spawn_time, max_spawn_time)

func taking_too_long():
	await get_tree().create_timer(45).timeout
	go = true
