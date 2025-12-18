## Makes enemies bounce!
## [br][color=red]Required Component(s):[/color]
## [br]- [GravityComponent3D]
##
## Has adjustable:
## [br]- Minimum/Maximum bounce power
## [br]- Minimum/Maximum cooldown between bounces
## [br]
## [br]Recommended on enemies with very low gravity multiplier (0.1).
## [br]This creates a sort of space jumping effect.
class_name BounceComponent3D extends EnemyBehavior3D

@export_group("Bounce Settings", "bounce_")
@export var bounce_power_min: float = 25.0
@export var bounce_power_max: float = 30.0
@export var bounce_cooldown_min: float = 0.0
@export var bounce_cooldown_max: float = 0.0

@export_group("Audio")
@export var do_audio: bool = true
@export var audio_clips: Array[AudioStream] = [
	preload("uid://c1yaax58yyegn")
]
@export_subgroup("Pitch")
@export var min_pitch: float = 1.0
@export var max_pitch: float = 1.0
@export_subgroup("AudioStreamPlayer Settings")
@export var volume_db: float = -12
@export var max_distance: float = 20.0

var character_body: CharacterBody3D
var cooldown: float = 0.0

var audio: AudioStreamPlayer3D
var available_audio_clips: Array[AudioStream]
var last_clip: AudioStream


func _setup() -> void:
	character_body = enemy.get_character_body_3d()
	
	if do_audio and audio_clips.size() > 0:
		audio = AudioStreamPlayer3D.new()
		audio.volume_db = volume_db
		audio.max_distance = max_distance
		enemy.add_child(audio)
		available_audio_clips = audio_clips.duplicate()


func _physics_process(delta: float) -> void:
	if not character_body.is_on_floor():
		return
	
	character_body.velocity.y += randf_range(bounce_power_min, bounce_power_max)
	
	if do_audio and audio_clips.size() > 0:
		audio.stream = _get_boing_sound()
		audio.pitch_scale = randf_range(min_pitch, max_pitch)
		audio.play()


func _get_boing_sound() -> AudioStream:
	if audio_clips.size() == 1:
		return audio_clips[0]
	
	var new_clip = audio_clips.pick_random()
	
	# Keep picking until we get a different one
	while new_clip == last_clip:
		new_clip = audio_clips.pick_random()
	
	last_clip = new_clip
	return new_clip
