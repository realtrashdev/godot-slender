extends RayCast3D

var last_target: Node = null
var enemy_position: Vector3 = Vector3.ZERO

func _process(_delta):
	if not enabled:
		if last_target or enemy_position != Vector3.ZERO:
			_clear_last_target()
		return
	
	var collider = get_collider() if is_colliding() else null
	var current_target = _find_targetable(collider)
	
	if current_target != last_target:
		_clear_last_target()
		if current_target:
			_set_new_target(current_target)
	
	_update_attraction_position(collider)

func _find_targetable(collider: Node) -> Node:
	if not collider:
		return null
	
	# Check for component-based enemy
	if collider.has_method("get_component"):
		var light_component = collider.get_component(LightSensitiveComponent3D)
		if light_component:
			return light_component
	
	# Check for old enemy system
	if collider.has_method("set_targeted"):
		return collider
	
	return null

func _set_new_target(target: Node) -> void:
	target.set_targeted(true)
	last_target = target

func _clear_last_target() -> void:
	if last_target:
		last_target.set_targeted(false)
	last_target = null
	enemy_position = Vector3.ZERO

func _update_attraction_position(collider: Node) -> void:
	if collider and collider.has_method("get_flashlight_attract_position"):
		enemy_position = collider.get_flashlight_attract_position()
	else:
		enemy_position = Vector3.ZERO
