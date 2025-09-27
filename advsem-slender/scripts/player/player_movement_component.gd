class_name PlayerMovementComponent extends Node 

const SPEED = 2.0
const SPRINT_SPEED = 3.5
const ACCELERATION = 7.0
const PATH_MODIFIER = 0.5

var player: CharacterBody3D
var restriction_component: PlayerRestrictionComponent
var audio_component: PlayerAudioComponent

@onready var ground_raycast: RayCast3D

func _ready():
	player = get_parent()
	restriction_component = player.get_node("RestrictionComponent")
	audio_component = player.get_node("AudioComponent")
	ground_raycast = player.get_node("GroundRayCast")

func handle_physics(delta: float):
	# Add gravity
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	
	# Handle movement
	var direction = get_movement_direction()
	if direction:
		player.velocity.x = move_toward(player.velocity.x, direction.x * get_movement_speed(), ACCELERATION * delta)
		player.velocity.z = move_toward(player.velocity.z, direction.z * get_movement_speed(), ACCELERATION * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, ACCELERATION * delta)
		player.velocity.z = move_toward(player.velocity.z, 0, ACCELERATION * delta)
	
	player.move_and_slide()
	audio_component.handle_movement_audio()

func get_movement_direction() -> Vector3:
	if restriction_component.check_for_restriction(PlayerRestriction.RestrictionType.MOVEMENT):
		return Vector3.ZERO
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction

func get_movement_speed() -> float:
	if is_sprinting():
		return SPRINT_SPEED + get_path_boost()
	else:
		return SPEED + get_path_boost()

func is_sprinting() -> bool:
	return Input.is_action_pressed("sprint") and player.velocity != Vector3.ZERO

func get_path_boost() -> float:
	if ground_raycast.is_colliding():
		if not ground_raycast.get_collider().is_in_group("Grass"):
			return PATH_MODIFIER
	return 0

func activate():
	set_process(true)

func deactivate():
	set_process(false)
