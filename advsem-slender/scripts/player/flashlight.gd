extends Node3D

const LIGHT_BRIGHTNESS: float = 5.0
const DEFAULT_SPRINT_ANGLE: float = -60
const TURN_ON_ANGLE: Vector2 = Vector2(-60, -30)

var sprint_angle: float = -60
var rotation_override: float = 0

var sprint_angle_modifier: float = 20

@onready var light: SpotLight3D = $SpotLight3D
@onready var audio_source: AudioStreamPlayer = $FlashlightAudio
@onready var omni_light: OmniLight3D = $OmniLight3D

func _ready() -> void:
	sprint_angle = get_sprint_angle()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_light"):
		toggle_light(!light.visible)

func _on_ray_cast_3d_object_collected() -> void:
	rotation_override = deg_to_rad(sprint_angle)
	await get_tree().create_timer(3).timeout
	rotation_override = 0

func toggle_light(on: bool):
	light.visible = on
	omni_light.visible = !light.visible
	rotation.x = deg_to_rad(TURN_ON_ANGLE.x)
	rotation.y = deg_to_rad(TURN_ON_ANGLE.y)
	play_audio()

func play_audio():
	audio_source.pitch_scale = randf_range(0.9, 1.1)
	audio_source.play()

func get_sprint_angle():
	return DEFAULT_SPRINT_ANGLE + sprint_angle_modifier
