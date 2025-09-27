class_name SpawnMarkers extends SpawnBehavior

## Uses pre-placed markers around the map to spawn the enemy.

@export var radius: float = 40.0
@export var min_distance: float = 20.0

func get_spawn_position(context: SpawnContext) -> Vector3:
	# get needed variables
	var player = context.player
	var spawner = context.spawner
	var spawn_markers = context.spawn_markers
	
	var candidates: Array[Marker3D] = []
	var spawn_points = spawn_markers.get_children()

	for point in spawn_points:
		var dist = point.global_position.distance_to(player.global_position)
		if dist < min_distance or dist > radius:
			continue

		var space_state = player.get_world_3d().direct_space_state
		var params = PhysicsRayQueryParameters3D.new()
		params.from = player.global_position
		params.to = point.global_position
		params.exclude = [player]

		var ray = space_state.intersect_ray(params)
		if ray:
			candidates.append(point)

	if candidates.size() > 0:
		return candidates.pick_random().global_position
	else:
		return spawner.global_position
