extends Node3D


func _ready() -> void:
	var rand = randf_range(0.8, 1.3)
	scale = Vector3(rand, rand, rand)
