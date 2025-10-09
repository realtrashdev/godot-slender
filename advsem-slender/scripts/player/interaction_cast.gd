extends RayCast3D

signal object_collected

var interactible_position: Vector3

func _process(delta: float) -> void:
	if is_colliding():
		var col = get_collider()
		
		if col is not Node:
			return
		
		var obj = col.get_parent()
		
		if obj is Interactible and obj.attract_flashlight:
			interactible_position = obj.get("global_position")
		
		# collecting
		if Input.is_action_just_pressed("interact") and obj.has_method("collect"):
			obj.collect()
			object_collected.emit()
	else:
		interactible_position = Vector3.ZERO
