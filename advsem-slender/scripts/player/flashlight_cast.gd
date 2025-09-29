extends RayCast3D

var last_target: Enemy3D = null

## TODO needs refactor

func _process(delta):
	if is_colliding():
		var collider = get_collider()
		if collider is Enemy3D:
			# notify current target
			collider.set_targeted(true)

			# if targeting something else last frame, turn it off
			if last_target and last_target != collider:
				last_target.set_targeted(false)

			last_target = collider
		else:
			# hit something else, clear last target
			if last_target:
				last_target.set_targeted(false)
				last_target = null
	else:
		# nothing hit
		if last_target:
			last_target.set_targeted(false)
			last_target = null
