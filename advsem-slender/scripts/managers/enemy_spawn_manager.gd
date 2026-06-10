class_name EnemySpawnManager extends Node

var player: CharacterBody3D
var spawners: Array[EnemySpawner] = []


func initialize(player_ref: CharacterBody3D):
	player = player_ref
	
	Signals.radar_charged.connect(_on_radar_charged)
	Signals.radar_died.connect(_on_radar_died)
	
	## Add disabled shade spawner for use when radar dies
	var shade: EnemySpawner = add_enemy_spawner(preload("uid://b2akbubrke2u1"), 0)
	shade.needs_manual_enable = true
	shade.disable_spawner()
	
	_setup_all_enemies()


func _setup_all_enemies():
	for page_number in GameState.get_enemy_list():
		var enemy_list = GameState.get_enemy_list()[page_number]
		
		# check if it's an EnemyProfileList
		if enemy_list and enemy_list is EnemyProfileList:
			# access profile array inside the list
			for enemy_profile in enemy_list.profiles:
				if enemy_profile and enemy_profile is EnemyProfile:
					print("Adding spawner: ", enemy_profile.name, " at page ", page_number)
					add_enemy_spawner(enemy_profile, page_number)
		elif enemy_list == null:
			# page has no enemies
			pass
		else:
			push_warning("Page ", page_number, " is not an EnemyProfileList: ", type_string(typeof(enemy_list)))


func add_enemy_spawner(enemy_profile: EnemyProfile, required: int) -> EnemySpawner:
	var spawner = EnemySpawner.new()
	spawner.initialize(enemy_profile, required, player)
	
	add_child(spawner)
	spawners.append(spawner)
	return spawner


func remove_enemy_type(enemy_name: String):
	for spawner in spawners.duplicate():
		if spawner.profile.name.to_lower() == enemy_name.to_lower():
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
		if spawner.profile.name.to_lower() == enemy_name.to_lower():
			spawner.enable_spawner()


func disable_enemy_type(enemy_name: String):
	for spawner in spawners:
		if spawner.profile.name.to_lower() == enemy_name.to_lower():
			spawner.disable_spawner()


func disable_all_spawners():
	for spawner in spawners:
		spawner.disable_spawner()


func set_enemy_spawn_rate(enemy_name: String, min_time: float, max_time: float):
	for spawner in spawners:
		if spawner.profile.name.to_lower() == enemy_name.to_lower():
			spawner.set_spawn_rate(min_time, max_time)


func get_spawner(enemy_name: String) -> EnemySpawner:
	for spawner in spawners:
		if spawner.profile.name.to_lower() == enemy_name.to_lower():
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
		if spawner.profile.name.to_lower() == enemy_name.to_lower():
			count += spawner.active_enemies.size()
	return count


func get_spawners_by_name(enemy_name: String) -> Array[EnemySpawner]:
	var result: Array[EnemySpawner] = []
	for spawner in spawners:
		if spawner.profile.name.to_lower() == enemy_name.to_lower():
			result.append(spawner)
	return result


func get_spawner_by_name_and_pages(enemy_name: String, required: int) -> EnemySpawner:
	for spawner in spawners:
		if spawner.profile.name.to_lower() == enemy_name.to_lower() and spawner.required_pages == required:
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

## Remove Shade enemy if active, and disable the spawner
func _on_radar_charged():
	var spawner: EnemySpawner = get_spawner("Shade")
	if spawner:
		spawner.clear_all_enemies()
		spawner.disable_spawner()

## Add Shade enemy to kill player after radar death
func _on_radar_died():
	var spawner: EnemySpawner = get_spawner("Shade")
	if spawner:
		spawner.enable_spawner()
