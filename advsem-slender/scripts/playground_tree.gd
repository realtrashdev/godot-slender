extends Node3D

const MIN_SCALE = 0.9
const MAX_SCALE = 1.3

func _ready() -> void:
	var rand = randf_range(MIN_SCALE, MAX_SCALE)
	scale = Vector3(rand, rand, rand)
	
	rand = randf_range(0, 360)
	rotation.y = deg_to_rad(rand)
