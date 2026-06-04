class_name GroundCastComponent extends RayCast3D

enum GroundType { GRASS, GRAVEL, TILE, WATER }

func get_ground_type() -> GroundType:
	if is_colliding():
		var collider = get_collider()
		if collider.is_in_group("GrassSounds"):
			return GroundType.GRASS
		elif collider.is_in_group("GravelSounds"):
			return GroundType.GRAVEL
		elif collider.is_in_group("TileSounds"):
			return GroundType.TILE
		elif collider.is_in_group("WaterSounds"):
			return GroundType.WATER
	return GroundType.GRAVEL
