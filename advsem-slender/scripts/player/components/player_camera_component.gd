class_name PlayerCameraComponent extends Node

const MOUSE_SENSITIVITY: float = 0.002
const CAMERA_SMOOTHING: float = 10

var camera_sensitivity: float = 0
var camera_rotation: Vector3
var start_rotation: Vector3
var time_count: float

var flashlight_offset: Vector3 = Vector3(0, 0, 0)
var buffer: bool = false

var sens_tween: Tween

var player: CharacterBody3D
var restriction_component: PlayerRestrictionComponent
var movement_component: PlayerMovementComponent
var flashlight_component: PlayerFlashlightComponent

@onready var head: Node3D
@onready var camera: Camera3D

func _ready():
	player = get_parent()
	restriction_component = player.get_node("RestrictionComponent")
	movement_component = player.get_node("MovementComponent")
	flashlight_component = player.get_node("FlashlightComponent")
	head = player.get_node("Head")
	camera = player.get_node("Head/Camera3D")
	
	player.rotation.y = 0
	start_rotation = Vector3(0, 0, 0)
	camera_rotation = start_rotation

func handle_input(event: InputEvent):
	if event.is_action_pressed("toggle_radar"):
		check_radar_restriction()
	
	if event is InputEventMouseMotion:
		if buffer:
			buffer = false
			return
		handle_mouse_movement(event)

func handle_mouse_movement(event):
	if restriction_component.check_for_restriction(PlayerRestriction.RestrictionType.CAMERA_FULL):
		return
	
	camera_rotation.y += -event.relative.x * camera_sensitivity
	camera_rotation.x += -event.relative.y * camera_sensitivity
	camera_rotation.x = clamp(camera_rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
	if restriction_component.check_for_restriction(PlayerRestriction.RestrictionType.RADAR):
		camera_rotation.x = -deg_to_rad(45)
	
	# update flashlight offset
	if flashlight_component:
		flashlight_component.add_camera_offset(Vector3(-event.relative.y * 0.0005, -event.relative.x * 0.0005, 0))

func check_radar_restriction():
	if not restriction_component.check_for_restriction(PlayerRestriction.RestrictionType.RADAR):
		camera_rotation.x = -deg_to_rad(45)
		camera_sensitivity = MOUSE_SENSITIVITY / 2
	else:
		camera_rotation.x = deg_to_rad(0)
		buffer = true
		
		if sens_tween:
			sens_tween.kill()
		sens_tween = create_tween()
		sens_tween.tween_property(self, "camera_sensitivity", MOUSE_SENSITIVITY, 1)

func get_flashlight_offset() -> Vector3:
	return flashlight_offset

func handle_camera_physics(delta: float):
	time_count += delta
	
	# apply rotation smoothing
	player.rotation.y = lerp_angle(player.rotation.y, camera_rotation.y, CAMERA_SMOOTHING * delta)
	head.rotation.x = lerp_angle(head.rotation.x, camera_rotation.x, CAMERA_SMOOTHING * delta)
	
	# apply camera bobbing
	handle_camera_bobbing(delta)

func handle_camera_bobbing(delta: float):
	var bobbing_speed = movement_component.get_movement_speed() * 2
	
	if player.velocity.length() > 1:
		camera.rotation.z = lerp(camera.rotation.z, 
			sin(time_count * bobbing_speed) * (0.005 * movement_component.get_movement_speed()), 
			5 * delta)
	else:
		camera.rotation.z = lerp(camera.rotation.z, 0.0, 5 * delta)

func activate():
	camera_rotation = start_rotation
	
	camera_sensitivity = 0
	if sens_tween:
		sens_tween.kill()
	sens_tween = create_tween()
	sens_tween.tween_property(self, "camera_sensitivity", MOUSE_SENSITIVITY, 1)
	
	camera.fov = 150.0
	if camera.has_method("set_fov_smooth"):
		camera.set_fov_smooth(80.0, 1.0)

func deactivate():
	camera_sensitivity = 0
