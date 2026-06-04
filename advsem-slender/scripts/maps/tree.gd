extends Node3D


func _ready() -> void:
	var rand = randf_range(0.9, 1.3)
	scale = Vector3(rand, rand, rand)
	
	rand = randf_range(0, 360)
	rotation.y = rand
	
	#rand = randi_range(1, 10)
	#if rand == 10:
		#$CPUParticles3D.emitting = true
	#else:
		#$CPUParticles3D.emitting = false
