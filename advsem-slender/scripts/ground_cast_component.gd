class_name GroundCastComponent extends RayCast3D

enum GroundType { GRASS, PATH, TILE }

func get_ground_type() -> GroundType:
	if is_colliding():
		var collider = get_collider()
		if collider.is_in_group("GrassSounds"):
			return GroundType.GRASS
		elif collider.is_in_group("PathSounds"):
			return GroundType.PATH
		elif collider.is_in_group("TileSounds"):
			return GroundType.TILE
	return GroundType.PATH
