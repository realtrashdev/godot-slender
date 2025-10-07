class_name PlayerMovementComponent extends Node 

const SPEED = 2.0
const SPRINT_SPEED = 4.0
# delay before the player can move at the start
const START_SPEED_DELAY = 1
const ACCELERATION = 7.0
const PATH_MODIFIER = 1.0

var player: CharacterBody3D
var camera_component: PlayerCameraComponent
var restriction_component: PlayerRestrictionComponent
var audio_component: PlayerAudioComponent
var ground_cast: GroundCastComponent

var active: bool = false

func _ready():
	player = get_parent()
	camera_component = player.get_node("CameraComponent")
	restriction_component = player.get_node("RestrictionComponent")
	audio_component = player.get_node("AudioComponent")
	ground_cast = player.get_node("GroundCastComponent")

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
		var new_horizontal = current_horizontal.move_toward(target_velocity, ACCELERATION * delta)
		player.velocity.x = new_horizontal.x
		player.velocity.z = new_horizontal.z
	else:
		var current_horizontal = Vector3(player.velocity.x, 0, player.velocity.z)
		var new_horizontal = current_horizontal.move_toward(Vector3.ZERO, ACCELERATION * delta)
		player.velocity.x = new_horizontal.x
		player.velocity.z = new_horizontal.z
	
	player.move_and_slide()
	audio_component.handle_movement_audio()

func get_movement_direction() -> Vector3:
	if restriction_component.check_for_restriction(PlayerRestriction.RestrictionType.MOVEMENT):
		return Vector3.ZERO
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	var target_basis = Basis(Vector3.UP, camera_component.camera_rotation.y)
	var direction := (target_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir != Vector2.ZERO:
		print("Using rotation: ", camera_component.camera_rotation.y, " Direction: ", direction)
	
	return direction

func get_movement_speed() -> float:
	if is_sprinting():
		return SPRINT_SPEED + get_path_boost()
	else:
		return SPEED + get_path_boost()

func is_sprinting() -> bool:
	return Input.is_action_pressed("sprint") and player.velocity != Vector3.ZERO

func get_path_boost() -> float:
	if ground_cast.is_colliding():
		if not ground_cast.get_collider().is_in_group("Slows"):
			return PATH_MODIFIER
	return 0

func activate():
	await get_tree().create_timer(START_SPEED_DELAY).timeout
	active = true

func deactivate():
	player.velocity = Vector3.ZERO
	active = false
