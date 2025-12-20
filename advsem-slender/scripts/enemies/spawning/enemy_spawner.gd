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
	
	_connect_signals()
	_reset_timer()
	check_enable()


func _exit_tree():
	if Signals.page_collected.is_connected(_on_page_collected):
		Signals.page_collected.disconnect(_on_page_collected)


func _process(delta: float) -> void:
	if not enabled or not enemy_scene:
		return
	
	if active_enemies.size() >= profile.max_instances:
		return
	
	spawn_timer -= delta
	if spawn_timer <= 0:
		_spawn_enemy()
		_reset_timer()


func _connect_signals():
	Signals.page_collected.connect(_on_page_collected)


func _spawn_enemy():
	var enemy = enemy_scene.instantiate()
	active_enemies.append(enemy)
	
	# Connect cleanup signal
	if enemy.has_signal("died"):
		enemy.died.connect(_on_enemy_died.bind(enemy))
	
	if enemy is Enemy3D:
		add_child(enemy)
		enemy.profile = profile
		print("Enemy3D spawned: %s" % enemy.name)
		Signals.enemy_spawned.emit(profile.type)
		return
	
	## Old Enemy3D/2D spawn methods
	match profile.enemy_type:
		profile.EnemyType.ENEMY_2D:
			spawn_old_2d_enemy(enemy)
		profile.EnemyType.ENEMY_3D:
			spawn_old_3d_enemy(enemy)
	Signals.enemy_spawned.emit(profile.type)


func spawn_3D_enemy(enemy: Enemy3D):
	if not enabled:
		return
	
	add_child(enemy)
	enemy.profile = profile
	print("Enemy spawned: %s" % enemy.name)


func spawn_old_2d_enemy(enemy: OldEnemy2D):
	if not enabled:
		return
	
	push_warning("OldEnemy2D Spawned")
	get_tree().current_scene.add_child(enemy)
	enemy.profile = profile
	enemy.activate()


func spawn_old_3d_enemy(enemy: OldEnemy3D):
	if not enabled:
		return
	
	push_warning("OldEnemy3D Spawned")
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
	
	#if get_tree():
		#for component in get_tree().get_nodes_in_group("ComponentEnemy"):
			#if component == enemy:
				#push_warning("Tried spawning %s twice. (Failed due to ComponentEnemy restriction)" % enemy.profile.name)
				#disable_spawner()
	
	print("ComponentEnemy Spawned")
	enemy.profile = profile
	enemy.attach_component(player)
	
	# Only one component enemy gets spawned, as they are just a tool for attaching components to others
	disable_spawner()


func _on_page_collected():
	check_enable()


func _on_enemy_died(enemy: Node):
	active_enemies.erase(enemy)


func _reset_timer():
	spawn_timer = randf_range(min_spawn_time, max_spawn_time)


func check_enable():
	# if the player has collected all required pages, don't enable
	if game_state.current_pages_collected == game_state.current_pages_required:
		return
	
	if game_state.current_pages_collected >= required_pages and not enabled:
		enable_spawner()
		_reset_timer()


func enable_spawner():
	print("Enabled " + profile.name + " Spawner")
	enabled = true
	
	if profile.enemy_type == profile.EnemyType.ENEMY_COMPONENT:
		spawn_component_enemy(enemy_scene.instantiate())


func disable_spawner():
	enabled = false
	_reset_timer()


func set_spawn_rate(min_time: float, max_time: float):
	min_spawn_time = min_time
	max_spawn_time = max_time


func clear_all_enemies():
	print("Clear all enemies")
	for enemy in active_enemies.duplicate():
		print("Try clearing enemies")
		if is_instance_valid(enemy):
			print("killing %s" % [enemy.name])
			enemy.queue_free()
	active_enemies.clear()
