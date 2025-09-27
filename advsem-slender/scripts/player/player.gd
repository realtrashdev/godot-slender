extends CharacterBody3D

signal player_dead

@export_group("Sounds")
@export var movement_gravel: Array[AudioStream]
@export var movement_grass: Array[AudioStream]
@export var movement_tile: Array[AudioStream]

const MENU_SCENE = "res://scenes/ui/menus/menu_base.tscn"

# Base Movement
const SPEED = 2.0
const SPRINT_SPEED = 3.5
const ACCELERATION = 7.0
const PATH_MODIFIER = 0.5

# Camera
const MOUSE_SENSITIVITY = 0.002
const CAMERA_SMOOTHING = 10
const CAMERA_BOB_AMOUNT = 0.015

var camera_sensitivity: float = 0
var camera_rotation := Vector3(0, 0, 0)
var camera_fov: float

# Flashlight
var flashlight_offset := Vector3(0, 0, 0)
var flashlight_target = null

# Movement Bobbing
var time_count: float
var bobbing_speed: float

# Audio
var previous_sound_index: int
var move_sound_timer: float

@onready var head: Node3D = $Head
@onready var flashlight: Node3D = $Head/Flashlight
@onready var camera: Camera3D = $Head/Camera3D
@onready var interaction_cast: RayCast3D = $Head/Camera3D/RayCast3D
@onready var movement_audio: AudioStreamPlayer = $MovementAudio

#region Default Methods
func _ready() -> void:
	deactivate()

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://scenes/ui/menus/menu_base.tscn")
	
	move_sound_timer -= delta
	#debug_tools()

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
	move_audio()

	# camera rotation/bobbing
	rotation.y = lerp_angle(rotation.y, camera_rotation.y, CAMERA_SMOOTHING * delta)
	head.rotation.x = lerp_angle(head.rotation.x, camera_rotation.x, CAMERA_SMOOTHING * delta)
	camera_bobbing()
	#camera_field_of_view()
	
	if not point_flashlight():
		get_flashlight_offset(delta)

## sets camera_rotation and flashlight_offset variables as input occurs
func _input(event):
	# get camera rotation
	if event is InputEventMouseMotion:
		camera_rotation.y += -event.relative.x * camera_sensitivity
		camera_rotation.x += -event.relative.y * camera_sensitivity
		
		camera_rotation.x = clamp(camera_rotation.x, deg_to_rad(-89), deg_to_rad(89))
		
		flashlight_offset.y = clamp(flashlight_offset.y + (-event.relative.x * 0.0005), -0.5, 0.5)
		flashlight_offset.x = clamp(flashlight_offset.x + (-event.relative.y * 0.0005), -0.5, 0.5)
#endregion

#region Movement
## returns movement speed constants based on if the player is sprinting or not
func get_movement_speed() -> float:
	if check_sprinting():
		return SPRINT_SPEED + get_path_boost()
	else:
		return SPEED + get_path_boost()

## returns true if sprint key is pressed and player is moving
func check_sprinting() -> bool:
	if Input.is_action_pressed("sprint") and velocity != Vector3.ZERO:
		return true
	else:
		return false

func get_path_boost() -> float:
	if $GroundRayCast.is_colliding():
		if not $GroundRayCast.get_collider().is_in_group("Grass"):
			return PATH_MODIFIER
	return 0

## plays stepping sounds while moving
func move_audio():
	# if not moving fast enough or in the air, don't make sounds
	if not velocity.length() > 1 or not is_on_floor():
		return
	
	if move_sound_timer > 0:
		return
	
	# randomize footstep pitch
	var pitch = 1.0
	movement_audio.pitch_scale = randf_range(pitch - 0.1, pitch + 0.1)
	
	# get sounds depending on ground material
	var sound_array = get_ground_sounds()
	if sound_array.size() == 0:
		push_warning("No ground sounds found. Defaulting.")
		sound_array = movement_gravel
	
	# prevents repeat sounds
	var rand_max = sound_array.size() - 1
	var index = randi_range(0, rand_max)
	while index == previous_sound_index:
		index = randi_range(0, rand_max)
	previous_sound_index = index
	
	# play sound
	movement_audio.stream = sound_array[index]
	movement_audio.play()
	move_sound_timer = 1.5 / get_movement_speed()

func get_ground_sounds():
	if $GroundRayCast.is_colliding():
		var collider = $GroundRayCast.get_collider()
		if collider.is_in_group("Path"):
			print("found path")
			return movement_gravel
		elif collider.is_in_group("Grass"):
			print("found grass")
			return movement_grass
		elif collider.is_in_group("Tile"):
			print("found tile")
			return movement_tile
	print("defaulting")
	return movement_gravel
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
		flashlight.global_rotation.x = lerp(flashlight.global_rotation.x, flashlight_offset.x + flashlight.rotation_override, 8 * delta)
		return
	
	# sprinting
	if check_sprinting():
		flashlight.global_rotation.x = lerp(flashlight.global_rotation.x, flashlight_offset.x + deg_to_rad(flashlight.sprint_angle), 10 * delta)
	# walking
	elif velocity.length() != 0:
		flashlight.rotation.x = lerp(flashlight.rotation.x, flashlight_offset.x + deg_to_rad(-5) + sin(time_count * 5) * 0.015, 6 * delta)
		flashlight.rotation.y = lerp(flashlight.rotation.y, flashlight_offset.y + deg_to_rad(-5) + sin(time_count * 5) * 0.015, 6 * delta)
	# standing
	else:
		flashlight.rotation.x = lerp(flashlight.rotation.x, flashlight_offset.x + cos(time_count) * 0.01, 6 * delta)

## points flashlight at designated object and overrides the offset function
func point_flashlight():
	var pos = interaction_cast.interactible_position
	if pos != Vector3.ZERO:
		# Target orientation (like look_at)
		var target_transform = flashlight.global_transform.looking_at(pos)

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
		camera.rotation.z = lerp(camera.rotation.z, (sin(time_count * bobbing_speed) * (0.005 * get_movement_speed())), 5 * delta)
	else:
		camera.rotation.z = lerp(camera.rotation.z, 0.0, 5 * delta)

#func camera_field_of_view():
	#if check_sprinting():
		#camera.fov = lerp(camera.fov, camera_fov + 10, 3 * get_physics_process_delta_time())
	#else:
		#camera.fov = lerp(camera.fov, camera_fov, 3 * get_physics_process_delta_time())
#endregion

func die(enemy_name: String):
	player_dead.emit(enemy_name)
	set_physics_process(false)
	flashlight.visible = false
	$Head/Flashlight/OmniLight3D.visible = false
	flashlight.set_process(false)
	
	## TODO switch to use lives
	var tree := get_tree()
	await get_tree().create_timer(1).timeout
	tree.change_scene_to_file(MENU_SCENE)

func activate():
	set_physics_process(true)
	flashlight.visible = true
	flashlight.set_process(true)
	flashlight.toggle_light(true)
	
	camera_sensitivity = 0
	create_tween().tween_property(self, "camera_sensitivity", MOUSE_SENSITIVITY, 2)
	camera.fov = 150.0
	camera.set_fov_smooth(80.0, 1.0)

func deactivate():
	set_physics_process(false)
	flashlight.visible = false
	flashlight.set_process(false)
	$Head/Flashlight/OmniLight3D.visible = false

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
