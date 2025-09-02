extends RayCast3D

var interactible_position: Vector3

func _process(delta: float) -> void:
	if is_colliding():
		var obj = get_collider().get_parent()
		
		if obj is Interactible and obj.attract_flashlight:
			interactible_position = obj.get("global_position")
		
		# collecting
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and get_collider().get_parent().has_method("collect"):
			get_collider().get_parent().collect()
	else:
		interactible_position = Vector3.ZERO
