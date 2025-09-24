extends RayCast3D

var last_target: Enemy = null

func _process(delta):
	if is_colliding():
		var collider = get_collider()
		if collider is Enemy:
			# Notify current target
			collider.set_targeted(true)

			# If we were targeting someone else last frame, turn it off
			if last_target and last_target != collider:
				last_target.set_targeted(false)

			last_target = collider
		else:
			# Hit something else, clear last target
			if last_target:
				last_target.set_targeted(false)
				last_target = null
	else:
		# Nothing hit
		if last_target:
			last_target.set_targeted(false)
			last_target = null
