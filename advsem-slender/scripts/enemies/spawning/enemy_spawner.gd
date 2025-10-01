class_name EnemySpawner extends Node

var profile: EnemyProfile
var enabled: bool = false

var enemy_scene: PackedScene
var min_spawn_time: float
var max_spawn_time: float

var spawn_timer: float = 0.0
var required_pages: int = 1
var active_enemies: Array[Node] = []

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	enemy_scene = profile.scene
	min_spawn_time = profile.min_spawn_time
	max_spawn_time = profile.max_spawn_time
	
	connect_signals()
	reset_timer()

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("ui_focus_next"):
	#	if active_enemies.size() >= profile.max_instances:
	#		return
	#	spawn_enemy()
	
	if not enabled or not enemy_scene:
		return
	
	if active_enemies.size() >= profile.max_instances:
		return
	
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_enemy()
		reset_timer()

func connect_signals():
	Signals.page_collected.connect(check_enable)

func spawn_enemy() -> Node:
	if not enemy_scene:
		return null
	
	var enemy = enemy_scene.instantiate()
	active_enemies.append(enemy)
	
	# Connect cleanup signals
	if enemy.has_signal("died"):
		enemy.died.connect(on_enemy_died.bind(enemy))
	
	if profile.is_2d_enemy:
		spawn_2d_enemy(enemy)
	else:
		spawn_3d_enemy(enemy)
	
	Signals.enemy_spawned.emit(profile.type)
	update_danger_level(profile.type)
	
	return enemy

func spawn_2d_enemy(enemy: Enemy2D):
	print("Enemy2D Spawned")
	get_tree().current_scene.add_child(enemy)
	enemy.profile = profile
	enemy.activate()

func spawn_3d_enemy(enemy: Enemy3D):
	print("Enemy3D Spawned")
	add_child(enemy)
	enemy.profile = profile
	
	var ctx = SpawnContext.new()
	ctx.player = player
	ctx.spawn_markers = get_tree().get_first_node_in_group("SpawnMarkers")
	
	var pos = profile.spawn_behavior.get_spawn_position(ctx)
	
	enemy.global_position = pos

func on_enemy_died(enemy: Node):
	update_danger_level(-profile.type)
	active_enemies.erase(enemy)

func reset_timer():
	spawn_timer = randf_range(min_spawn_time, max_spawn_time)

func check_enable():
	if CurrentGameData.current_pages_collected == required_pages and not enabled:
		enable_spawner()

func enable_spawner():
	print("Enabled " + profile.name + " Spawner")
	enabled = true

func disable_spawner():
	enabled = false

func set_spawn_rate(min_time: float, max_time: float):
	min_spawn_time = min_time
	max_spawn_time = max_time

func clear_all_enemies():
	for enemy in active_enemies.duplicate():
		if is_instance_valid(enemy):
			print("killing %s" % [enemy.name])
			enemy.queue_free()
	active_enemies.clear()

func update_danger_level(value: int):
	CurrentGameData.danger_level += value
