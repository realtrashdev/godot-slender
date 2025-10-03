class_name PlayerAudioComponent extends Node

@export var movement_grass: Array[AudioStream]
@export var movement_path: Array[AudioStream]
@export var movement_tile: Array[AudioStream]

var previous_sound_index: int
var move_sound_timer: float

var player: CharacterBody3D
var movement_component: PlayerMovementComponent
var ground_cast: GroundCastComponent

@onready var movement_audio: AudioStreamPlayer = $MovementAudio

func _ready():
	player = get_parent()
	movement_component = player.get_node("MovementComponent")
	ground_cast = player.get_node("GroundCastComponent")

func _process(delta: float):
	move_sound_timer -= delta

func handle_movement_audio():
	if not player.velocity.length() > 1 or not player.is_on_floor():
		return
	
	if move_sound_timer > 0:
		return
	
	play_footstep_sound()

func play_footstep_sound():
	# randomize pitch
	var pitch = 1.0
	movement_audio.pitch_scale = randf_range(pitch - 0.1, pitch + 0.1)
	
	# get sounds based on ground material
	var sound_array = get_ground_sounds()
	if sound_array.size() == 0:
		push_warning("No ground sounds found. Defaulting.")
		sound_array = movement_path
	
	# prevent repeat sounds
	var rand_max = sound_array.size() - 1
	var index = randi_range(0, rand_max)
	while index == previous_sound_index and sound_array.size() > 1:
		index = randi_range(0, rand_max)
	previous_sound_index = index
	
	# play sound
	movement_audio.stream = sound_array[index]
	movement_audio.play()
	move_sound_timer = 1.5 / movement_component.get_movement_speed()

func get_ground_sounds():
	match ground_cast.get_ground_type():
		ground_cast.GroundType.GRASS:
			return movement_grass
		ground_cast.GroundType.PATH:
			return movement_path
		ground_cast.GroundType.TILE:
			return movement_tile
