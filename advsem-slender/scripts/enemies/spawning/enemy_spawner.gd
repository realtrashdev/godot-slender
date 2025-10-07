class_name EnemySpawner extends Node

var game_state: GameState
var profile: EnemyProfile
var player: CharacterBody3D
var enabled: bool = false

var enemy_scene: PackedScene
var min_spawn_time: float
var max_spawn_time: float

var spawn_timer: float = 0.0
var required_pages: int = 1
var active_enemies: Array[Node] = []

func initialize(state: GameState, enemy_profile: EnemyProfile, required: int, player_ref: CharacterBody3D):
	game_state = state
	profile = enemy_profile
	required_pages = required
	player = player_ref
	
	enemy_scene = profile.scene
	min_spawn_time = profile.min_spawn_time
	max_spawn_time = profile.max_spawn_time
	
	connect_signals()
	reset_timer()
	check_enable()

func _exit_tree():
	if Signals.page_collected.is_connected(on_page_collected):
		Signals.page_collected.disconnect(on_page_collected)

func _process(delta: float) -> void:
	if not enabled or not enemy_scene:
		return
	
	if active_enemies.size() >= profile.max_instances:
		return
	
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_enemy()
		reset_timer()

func connect_signals():
	Signals.page_collected.connect(on_page_collected)

func spawn_enemy() -> Node:
	if not enemy_scene:
		return null
	
	var enemy = enemy_scene.instantiate()
	active_enemies.append(enemy)
	
	# Connect cleanup signals
	if enemy.has_signal("died"):
		enemy.died.connect(on_enemy_died.bind(enemy))
	
	match profile.enemy_type:
		profile.EnemyType.ENEMY_2D:
			spawn_2d_enemy(enemy)
		profile.EnemyType.ENEMY_3D:
			spawn_3d_enemy(enemy)
		profile.EnemyType.ENEMY_COMPONENT:
			spawn_component_enemy(enemy)
	
	Signals.enemy_spawned.emit(profile.type)
	
	return enemy

func spawn_2d_enemy(enemy: Enemy2D):
	if not enabled:
		return
	
	print("Enemy2D Spawned")
	get_tree().current_scene.add_child(enemy)
	enemy.profile = profile
	enemy.activate()

func spawn_3d_enemy(enemy: Enemy3D):
	if not enabled:
		return
	
	print("Enemy3D Spawned")
	add_child(enemy)
	enemy.profile = profile
	
	var ctx = SpawnContext.new()
	ctx.player = player
	ctx.spawn_markers = get_tree().get_first_node_in_group("SpawnMarkers")
	
	var pos = profile.spawn_behavior.get_spawn_position(ctx)
	
	enemy.global_position = pos

func spawn_component_enemy(enemy: ComponentEnemy):
	if not enabled:
		return
	
	print("ComponentEnemy Spawned")
	add_child(enemy)
	enemy.profile = profile
	
	# Only one component enemy gets spawned, as they are just a tool for attaching components to others
	disable_spawner()

func on_page_collected():
	check_enable()

func on_enemy_died(enemy: Node):
	active_enemies.erase(enemy)

func reset_timer():
	spawn_timer = randf_range(min_spawn_time, max_spawn_time)

func check_enable():
	# if the player has collected required pages, don't enable
	if game_state.current_pages_collected == game_state.current_pages_required:
		return
	
	if game_state.current_pages_collected >= required_pages and not enabled:
		enable_spawner()
		reset_timer()

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
