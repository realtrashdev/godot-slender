extends CharacterBody3D


const SPEED = 2.0
const SPRINT_SPEED = 3.0
const ACCELERATION = 7.0

const MOUSE_SENSITIVITY = 0.002
const CAMERA_SMOOTHING = 10

var camera_rotation := Vector3(0, 0, 0)
var camera_fov: float

var flashlight_offset := Vector3(0, 0, 0)
var flashlight_target = null

var time_count: float
var bobbing_speed: float

@onready var head: Node3D = $Head
@onready var flashlight: Node3D = $Head/Flashlight
@onready var camera: Camera3D = $Head/Camera3D
@onready var interaction_cast: RayCast3D = $Head/Camera3D/RayCast3D


func _ready() -> void:
	camera_fov = camera.fov
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	debug_tools()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * get_movement_speed(), ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * get_movement_speed(), ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION * delta)

	move_and_slide()
	
	# camera rotation/bobbing
	rotation.y = lerp_angle(rotation.y, camera_rotation.y, CAMERA_SMOOTHING * delta)
	head.rotation.x = lerp_angle(head.rotation.x, camera_rotation.x, CAMERA_SMOOTHING * delta)
	camera_bobbing()
	camera_field_of_view()
	
	if not point_flashlight():
		get_flashlight_offset(delta)

## sets camera_rotation and flashlight_offset variables as input occurs
func _input(event):
	# get camera rotation
	if event is InputEventMouseMotion:
		camera_rotation.y += -event.relative.x * MOUSE_SENSITIVITY
		camera_rotation.x += -event.relative.y * MOUSE_SENSITIVITY
		
		camera_rotation.x = clamp(camera_rotation.x, deg_to_rad(-89), deg_to_rad(89))
		
		flashlight_offset.y = clamp(flashlight_offset.y + (-event.relative.x * 0.0005), -0.5, 0.5)
		flashlight_offset.x = clamp(flashlight_offset.x + (-event.relative.y * 0.0005), -0.5, 0.5)

#region Movement
## returns movement speed constants based on if the player is sprinting or not
func get_movement_speed() -> float:
	if check_sprinting():
		return SPRINT_SPEED
	else:
		return SPEED

## returns true if sprint key is pressed and player is moving
func check_sprinting() -> bool:
	if Input.is_action_pressed("sprint") and velocity != Vector3.ZERO:
		return true
	else:
		return false
#endregion

#region Flashlight
## offsets flashlight rotation slightly when moving camera
## juice thing to make camera movement feel more realistic/smooth
func get_flashlight_offset(delta: float) -> void:
	# flashlight offset
	flashlight_offset = lerp(flashlight_offset, Vector3.ZERO, CAMERA_SMOOTHING / 1.5 * delta)
	flashlight.rotation.y = lerp(flashlight.rotation.y, flashlight_offset.y, CAMERA_SMOOTHING * delta)
	
	# occurs when a page is collected, holds light down briefly
	if flashlight.rotation_override != 0:
		flashlight.rotation.x = lerp(flashlight.rotation.x, flashlight_offset.x + flashlight.rotation_override, 8 * delta)
		return
	
	# sprinting
	if check_sprinting():
		flashlight.rotation.x = lerp(flashlight.rotation.x, flashlight_offset.x + deg_to_rad(flashlight.SPRINT_ANGLE), 8 * delta)
	# walking
	elif velocity.length() != 0:
		flashlight.rotation.x = lerp(flashlight.rotation.x, flashlight_offset.x + deg_to_rad(-5), 8 * delta)
	# standing
	else:
		flashlight.rotation.x = lerp(flashlight.rotation.x, flashlight_offset.x, 8 * delta)

## points flashlight at designated object and overrides the offset function
func point_flashlight():
	var pos = interaction_cast.interactible_position
	if pos != Vector3.ZERO:
		# Target orientation (like look_at)
		var target_transform = flashlight.global_transform.looking_at(pos, Vector3.UP)

		# Orthonormalize bases before converting
		var current_quat: Quaternion = Quaternion(flashlight.global_transform.basis.orthonormalized())
		var target_quat: Quaternion = Quaternion(target_transform.basis.orthonormalized())

		# Smooth interpolation
		var smoothed_quat = current_quat.slerp(target_quat, CAMERA_SMOOTHING * get_physics_process_delta_time())

		# Apply back to flashlight
		flashlight.global_transform.basis = Basis(smoothed_quat)
		
		return true
	return false
#endregion

#region Camera
## applies simple sin wave bobbing effect to head node's z rotation
## only happens if player is moving fast enough
func camera_bobbing():
	var delta = get_physics_process_delta_time()
	time_count += delta
	bobbing_speed = get_movement_speed() * 2
	
	if velocity.length() > 1:
		camera.rotation.z = lerp(camera.rotation.z, (sin(time_count * bobbing_speed) * (0.01 * get_movement_speed())), 5 * delta)
	else:
		camera.rotation.z = lerp(camera.rotation.z, 0.0, 5 * delta)

func camera_field_of_view():
	if check_sprinting():
		camera.fov = lerp(camera.fov, camera_fov + 10, 3 * get_physics_process_delta_time())
	else:
		camera.fov = lerp(camera.fov, camera_fov, 3 * get_physics_process_delta_time())
#endregion

## DISABLE IN BUILDS
func debug_tools():
	if Input.is_key_pressed(KEY_1):
		Engine.max_fps = 30
	if Input.is_key_pressed(KEY_2):
		Engine.max_fps = 60
	if Input.is_key_pressed(KEY_3):
		Engine.max_fps = 120
	if Input.is_key_pressed(KEY_4):
		Engine.max_fps = 0
