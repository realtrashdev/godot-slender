class_name PlayerAudioComponent extends Node

@export var movement_gravel: Array[AudioStream]
@export var movement_grass: Array[AudioStream]
@export var movement_tile: Array[AudioStream]

var previous_sound_index: int
var move_sound_timer: float

var player: CharacterBody3D
var movement_component: PlayerMovementComponent

@onready var movement_audio: AudioStreamPlayer = $MovementAudio
@onready var ground_raycast: RayCast3D

func _ready():
	player = get_parent()
	movement_component = player.get_node("MovementComponent")
	ground_raycast = player.get_node("GroundRayCast")

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
		sound_array = movement_gravel
	
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

func get_ground_sounds() -> Array[AudioStream]:
	if ground_raycast.is_colliding():
		var collider = ground_raycast.get_collider()
		if collider.is_in_group("Path"):
			return movement_gravel
		elif collider.is_in_group("Grass"):
			return movement_grass
		elif collider.is_in_group("Tile"):
			return movement_tile
	return movement_gravel
