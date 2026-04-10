class_name SpawnComponent3D extends EnemyBehavior3D

@export var behavior: SpawnBehavior

func _setup() -> void:
	if behavior is SpawnMarkers:
		enemy.position = behavior.get_spawn_position(enemy.player, get_tree().get_first_node_in_group("SpawnMarkers"))
	elif behavior is SpawnRing:
		enemy.position = behavior.get_spawn_position(enemy.player)
