class_name EnemySpawnManager extends Node

var game_state: GameState
var player: CharacterBody3D
var spawners: Array[EnemySpawner] = []

func initialize(state: GameState, player_ref: CharacterBody3D):
	game_state = state
	player = player_ref

func add_enemy_spawner(enemy_profile: EnemyProfile, required: int):
	var spawner = EnemySpawner.new()
	spawner.initialize(game_state, enemy_profile, required, player)
	
	add_child(spawner)
	spawners.append(spawner)

func remove_enemy_type(enemy_name: String):
	for spawner in spawners.duplicate():
		if spawner.profile.name == enemy_name:
			spawner.clear_all_enemies()
			spawner.queue_free()
			spawners.erase(spawner)

func remove_enemy_type_page_specific(enemy_name: String, pages: int):
	var sp = get_spawner_by_name_and_pages(enemy_name, pages)
	if sp:
		sp.clear_all_enemies()
		sp.queue_free()
		spawners.erase(sp)

func enable_enemy_type(enemy_name: String):
	for spawner in spawners:
		if spawner.profile.name == enemy_name:
			spawner.enable_spawner()

func disable_enemy_type(enemy_name: String):
	for spawner in spawners:
		if spawner.profile.name == enemy_name:
			spawner.disable_spawner()

func disable_all_spawners():
	for spawner in spawners:
		spawner.disable_spawner()

func set_enemy_spawn_rate(enemy_name: String, min_time: float, max_time: float):
	for spawner in spawners:
		if spawner.profile.name == enemy_name:
			spawner.set_spawn_rate(min_time, max_time)

func get_spawner(enemy_name: String) -> EnemySpawner:
	for spawner in spawners:
		if spawner.profile.name == enemy_name:
			return spawner
	return null

func get_all_spawners_organized() -> Dictionary:
	# nested dictionary [required_pages][profile: [spawners]]
	var result: Dictionary = {}
	
	for spawner in spawners:
		var required = spawner.required_pages
		var profile = spawner.profile
		
		# if required page key doesn't exist yet, initialize
		if not result.has(required):
			result[required] = {}
		
		# if this profile doesn't exist for this set of required pages, initialize
		if not result[required].has(profile):
			result[required][profile] = []
		
		# add spawner to correct array
		result[required][profile].append(spawner)
	
	return result

# returns how many of a certain enemy is active
func get_active_enemy_count(enemy_name: String) -> int:
	var count = 0
	for spawner in spawners:
		if spawner.profile.name == enemy_name:
			count += spawner.active_enemies.size()
	return count

func get_spawners_by_name(enemy_name: String) -> Array[EnemySpawner]:
	var result: Array[EnemySpawner] = []
	for spawner in spawners:
		if spawner.profile.name == enemy_name:
			result.append(spawner)
	return result

func get_spawner_by_name_and_pages(enemy_name: String, required: int) -> EnemySpawner:
	for spawner in spawners:
		if spawner.profile.name == enemy_name and spawner.required_pages == required:
			return spawner
	return null

func get_spawners_by_required_pages(required: int) -> Array[EnemySpawner]:
	var result: Array[EnemySpawner] = []
	for spawner in spawners:
		if spawner.required_pages == required:
			result.append(spawner)
	return result

func clear_all_enemies():
	for spawner in spawners:
		spawner.clear_all_enemies()

func taking_too_long():
	for spawner in spawners:
		if spawner.required_pages == 1:
			spawner.enable_spawner()
