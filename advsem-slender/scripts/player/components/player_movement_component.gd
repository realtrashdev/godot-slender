class_name PlayerMovementComponent extends Node 

# delay before the player can move at the start
const START_SPEED_DELAY = 1

var speed = 3.0
var sprint_speed = 5.0
var acceleration = 12.0

var player: CharacterBody3D
var camera_component: PlayerCameraComponent
var restriction_component: PlayerRestrictionComponent
var audio_component: PlayerAudioComponent
var ground_cast: GroundCastComponent
var ground_cast_short: GroundCastComponent

var active: bool = false
var can_sprint: bool = true


func _ready():
	player = get_parent()
	camera_component = player.get_node("CameraComponent")
	restriction_component = player.get_node("RestrictionComponent")
	audio_component = player.get_node("AudioComponent")
	ground_cast = player.get_node("GroundCastComponent")
	ground_cast_short = player.get_node("GroundCastComponentShort")
	_apply_base_character_stats()


func handle_physics(delta: float):
	if not active:
		return
	
	# Add gravity
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	
	# Handle movement
	var direction = get_movement_direction()
	if direction:
		var target_velocity = direction * get_movement_speed()
		var current_horizontal = Vector3(player.velocity.x, 0, player.velocity.z)
		var new_horizontal = current_horizontal.move_toward(target_velocity, acceleration * delta)
		player.velocity.x = new_horizontal.x
		player.velocity.z = new_horizontal.z
	else:
		var current_horizontal = Vector3(player.velocity.x, 0, player.velocity.z)
		var new_horizontal = current_horizontal.move_toward(Vector3.ZERO, acceleration * delta)
		player.velocity.x = new_horizontal.x
		player.velocity.z = new_horizontal.z
	
	player.move_and_slide()
	audio_component.handle_movement_audio()


func _apply_base_character_stats() -> void:
	var profile: VesselProfile = Settings.get_selected_character()
	speed = profile.move_speed
	sprint_speed = profile.move_sprint_speed
	ground_cast_short.position.y = profile.height - 1.5


func get_movement_direction() -> Vector3:
	if restriction_component.check_for_restriction(PlayerRestriction.RestrictionType.MOVEMENT_FULL):
		return Vector3.ZERO
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var target_basis = Basis(Vector3.UP, camera_component.camera_rotation.y)
	var direction := (target_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction


func get_movement_speed() -> float:
	if is_sprinting():
		return sprint_speed - get_speed_reduction()
	else:
		return speed - get_speed_reduction()


func is_sprinting() -> bool:
	if restriction_component.check_for_restriction(PlayerRestriction.RestrictionType.RADAR):
		return false
	return Input.is_action_pressed("sprint") and player.velocity != Vector3.ZERO and can_sprint


func get_speed_reduction() -> float:
	if ground_cast_short.is_colliding():
		var col = ground_cast_short.get_collider()
		if col is SlowingObstacle:
			can_sprint = not _check_sprint_disabled(col, true)
			return abs(col.slow_amount_deep)
	if ground_cast.is_colliding():
		var col = ground_cast.get_collider()
		if col is SlowingObstacle:
			can_sprint = not _check_sprint_disabled(col, false)
			return abs(col.slow_amount)
		if ground_cast.get_collider().is_in_group("Slows"): # old generic ver
			return 1.0
	return 0


func _check_sprint_disabled(obst: SlowingObstacle, deep: bool = false) -> bool:
	if deep:
		if obst.disable_sprint_deep or obst.disable_sprint:
			return true
		else:
			return false
	else:
		if obst.disable_sprint:
			return true
		else:
			return false


func activate():
	await get_tree().create_timer(START_SPEED_DELAY, false).timeout
	active = true


func deactivate():
	player.velocity = Vector3.ZERO
	active = false
