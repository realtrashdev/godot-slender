class_name PlayerFlashlightComponent extends Node

signal target_brightness_reached

const LIGHT_BRIGHTNESS: float = 5.0
const DEFAULT_SPRINT_ANGLE: float = -60
const TURN_ON_ANGLE: Vector2 = Vector2(-60, -30)
const CAMERA_SMOOTHING = 10

var sprint_angle: float = -60
var rotation_override: float = 0
var sprint_angle_modifier: float = 20
var flashlight_offset := Vector3(0, 0, 0)
var time_count: float

var target_brightness: float

var player: CharacterBody3D
var restriction_component: PlayerRestrictionComponent
var movement_component: PlayerMovementComponent
var camera_component: PlayerCameraComponent

@onready var flashlight: Node3D
@onready var light: SpotLight3D
@onready var audio_source: AudioStreamPlayer
@onready var omni_light: OmniLight3D
@onready var interaction_cast: RayCast3D

func _ready() -> void:
	Signals.page_collected.connect(on_page_collected)
	Signals.enemy_spawned.connect(on_enemy_spawned)
	
	player = get_parent()
	restriction_component = player.get_node("RestrictionComponent")
	movement_component = player.get_node("MovementComponent")
	camera_component = player.get_node("CameraComponent")
	
	flashlight = player.get_node("Head/Flashlight")
	light = flashlight.get_node("SpotLight3D")
	audio_source = flashlight.get_node("FlashlightAudio")
	omni_light = flashlight.get_node("OmniLight3D")
	interaction_cast = player.get_node("Head/Camera3D/RayCast3D")
	
	target_brightness = light.light_energy
	sprint_angle = get_sprint_angle()
	call_deferred("deactivate")

func _process(delta: float) -> void:
	time_count += delta
	
	if Input.is_action_just_pressed("toggle_light"):
		toggle_light(!light.visible)

func handle_flashlight_physics(delta: float):
	if light.light_energy != target_brightness:
		flicker_light()
	
	if not point_flashlight():
		get_flashlight_offset(delta)

## Offsets flashlight rotation slightly when moving camera
## Juice effect to make camera movement feel more realistic/smooth
func get_flashlight_offset(delta: float) -> void:
	# flashlight offset smoothing
	flashlight_offset = flashlight_offset.lerp(Vector3.ZERO, CAMERA_SMOOTHING / 1.5 * delta)
	flashlight.rotation.y = lerp(flashlight.rotation.y, flashlight_offset.y, CAMERA_SMOOTHING * delta)
	
	# occurs when a page is collected, holds light down briefly
	if rotation_override != 0:
		flashlight.global_rotation.x = lerp(flashlight.global_rotation.x, flashlight_offset.x + rotation_override, 8 * delta)
		return
	
	# sprinting
	if movement_component.is_sprinting():
		flashlight.global_rotation.x = lerp(flashlight.global_rotation.x, flashlight_offset.x + deg_to_rad(sprint_angle), 10 * delta)
	# walking
	elif player.velocity.length() != 0:
		flashlight.rotation.x = lerp(flashlight.rotation.x, flashlight_offset.x + deg_to_rad(-5) + sin(time_count * 5) * 0.015, 6 * delta)
		flashlight.rotation.y = lerp(flashlight.rotation.y, flashlight_offset.y + deg_to_rad(-5) + sin(time_count * 5) * 0.015, 6 * delta)
	# standing
	else:
		flashlight.rotation.x = lerp(flashlight.rotation.x, flashlight_offset.x + cos(time_count) * 0.01, 6 * delta)

func add_camera_offset(offset: Vector3):
	flashlight_offset.x = clamp(flashlight_offset.x + offset.x, -0.5, 0.5)
	flashlight_offset.y = clamp(flashlight_offset.y + offset.y, -0.5, 0.5)

## Points flashlight at designated object and overrides the offset function
# TODO optimization
func point_flashlight() -> bool:
	var pos = interaction_cast.get("interactible_position")
	if pos and pos != Vector3.ZERO:
		var target_transform = flashlight.global_transform.looking_at(pos)

		# orthonormalize bases before converting
		var current_quat: Quaternion = Quaternion(flashlight.global_transform.basis.orthonormalized())
		var target_quat: Quaternion = Quaternion(target_transform.basis.orthonormalized())

		# smooth interpolation
		var smoothed_quat = current_quat.slerp(target_quat, CAMERA_SMOOTHING * get_physics_process_delta_time())

		# apply back to flashlight
		flashlight.global_transform.basis = Basis(smoothed_quat)
		
		return true
	return false

func on_page_collected() -> void:
	rotation_override = deg_to_rad(sprint_angle)
	await get_tree().create_timer(3).timeout
	rotation_override = 0

func toggle_light(on: bool):
	light.visible = on
	omni_light.visible = !light.visible
	flashlight.rotation.x = deg_to_rad(TURN_ON_ANGLE.x)
	flashlight.rotation.y = deg_to_rad(TURN_ON_ANGLE.y)
	$"../Head/Flashlight/RayCast3D".enabled = on
	play_audio()

func set_flicker_light(starting_energy: float):
	var energy = light.light_energy
	
	target_brightness = starting_energy
	await target_brightness_reached
	target_brightness = energy

func flicker_light():
	if light.light_energy > target_brightness:
		light.light_energy += randf_range(-0.2, 0.05)
		
		if light.light_energy <= target_brightness:
			light.light_energy = target_brightness
			target_brightness_reached.emit()
	else:
		light.light_energy += randf_range(-0.05, 0.2)
		
		if light.light_energy >= target_brightness:
			light.light_energy = target_brightness
			target_brightness_reached.emit()

func play_audio():
	audio_source.pitch_scale = randf_range(0.9, 1.1)
	audio_source.play()

func get_sprint_angle() -> float:
	return DEFAULT_SPRINT_ANGLE + sprint_angle_modifier

func activate():
	set_process(true)
	flashlight.visible = true
	flashlight.set_process(true)
	toggle_light(true)

func deactivate():
	set_process(false)
	light.visible = false
	omni_light.visible = false
	flashlight.visible = false
	flashlight.set_process(false)

func on_enemy_spawned(type: EnemyProfile.EnemyType):
	match type:
		EnemyProfile.EnemyType.LETHAL:
			set_flicker_light(light.light_energy / 3)
		EnemyProfile.EnemyType.DANGEROUS:
			set_flicker_light(light.light_energy / 1.5)
		EnemyProfile.EnemyType.NUISANCE:
			pass
