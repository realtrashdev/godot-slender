class_name EnemySpawnManager extends Node

# enemy_name, spawner
var spawners: Dictionary = {}

func add_enemy_spawner(enemy_profile: EnemyProfile, required: int):
	# Create new spawner for this enemy type
	var spawner = EnemySpawner.new()
	spawner.profile = enemy_profile
	spawner.required_pages = required
	
	# add to scene
	add_child(spawner)
	spawners[enemy_profile.name] = spawner
	
	print("Added enemy: ", enemy_profile.name)

func remove_enemy_type(enemy_name: String):
	if enemy_name in spawners:
		var spawner = spawners[enemy_name]
		spawner.clear_all_enemies()
		spawner.queue_free()
		spawners.erase(enemy_name)

func enable_enemy_type(enemy_name: String):
	if enemy_name in spawners:
		spawners[enemy_name].enable_spawner()

func disable_enemy_type(enemy_name: String):
	if enemy_name in spawners:
		spawners[enemy_name].disable_spawner()

func disable_all_spawners():
	for spawner in spawners.values():
		spawner.disable_spawner()

func set_enemy_spawn_rate(enemy_name: String, min_time: float, max_time: float):
	if enemy_name in spawners:
		spawners[enemy_name].set_spawn_rate(min_time, max_time)

func get_active_enemy_count(enemy_name: String) -> int:
	if enemy_name in spawners:
		return spawners[enemy_name].active_enemies.size()
	return 0

func clear_all_enemies():
	for spawner in spawners.values():
		spawner.clear_all_enemies()

func taking_too_long():
	for spawner in spawners.values():
		if spawner.required_pages == 1:
			spawner.enable_spawner()
