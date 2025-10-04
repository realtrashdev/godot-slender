class_name SpawnRing extends SpawnBehavior

## Gets a ring around the player and spawns at a random point along it.

@export var radius: float = 40.0

func get_spawn_position(ctx: SpawnContext) -> Vector3:
	var player = ctx.player
	
	var angle = randf_range(0, TAU)
	
	var x = radius * cos(angle)
	var z = radius * sin(angle)
	
	print("Player pos: ", player.global_position)
	print("Spawn pos: ", player.global_position + Vector3(x, 0, z))
	print("Distance from player: ", (player.global_position + Vector3(x, 0, z)).distance_to(player.global_position))
	
	return player.global_position + Vector3(x, 0, z)
