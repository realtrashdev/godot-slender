class_name EnemySpawner extends Node

@export var profile: EnemyProfile
@export var max_instances: int = 3
@export var enabled: bool = true

var enemy_scene: PackedScene
var min_spawn_time: float
var max_spawn_time: float
var spawn_timer: float = 0.0
var active_enemies: Array[Node] = []

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	enemy_scene = profile.scene
	min_spawn_time = profile.min_spawn_time
	max_spawn_time = profile.max_spawn_time
	
	_reset_timer()

func _process(delta: float) -> void:
	if not enabled or not enemy_scene:
		return
	
	if Input.is_action_just_pressed("ui_focus_next"):
		spawn_enemy()
	
	if active_enemies.size() >= max_instances:
		return
		
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_enemy()
		_reset_timer()

func spawn_enemy() -> Node:
	if not enemy_scene:
		return null
	
	var enemy = enemy_scene.instantiate()
	active_enemies.append(enemy)
	
	# Connect cleanup signals
	if enemy.has_signal("died"):
		enemy.died.connect(_on_enemy_died.bind(enemy))
	
	if profile.is_2d_enemy:
		_spawn_2d_enemy(enemy)
	else:
		_spawn_3d_enemy(enemy)
	
	return enemy

func _spawn_2d_enemy(enemy: Enemy2D):
	print("Enemy2D Spawned")
	get_tree().current_scene.add_child(enemy)
	enemy.profile = profile
	enemy.activate()

func _spawn_3d_enemy(enemy: Enemy3D):
	print("Enemy3D Spawned")
	add_child(enemy)
	enemy.profile = profile
	
	var ctx = SpawnContext.new()
	ctx.player = player
	ctx.spawn_markers = get_tree().get_first_node_in_group("SpawnMarkers")
	
	var pos = profile.spawn_behavior.get_spawn_position(ctx)
	
	enemy.global_position = pos

func _on_enemy_died(enemy: Node):
	active_enemies.erase(enemy)

func _reset_timer():
	spawn_timer = randf_range(min_spawn_time, max_spawn_time)

func enable_spawner():
	enabled = true

func disable_spawner():
	enabled = false

func set_spawn_rate(min_time: float, max_time: float):
	min_spawn_time = min_time
	max_spawn_time = max_time

func clear_all_enemies():
	for enemy in active_enemies.duplicate():
		if is_instance_valid(enemy):
			enemy.queue_free()
	active_enemies.clear()
