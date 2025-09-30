extends CanvasLayer

@export var jumpscares: Dictionary[String, Jumpscare]

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var texture: TextureRect = $TextureRect
@onready var animation: AnimationPlayer = $TextureRect/AnimationPlayer

func _ready() -> void:
	Signals.killed_player.connect(jumpscare)

func jumpscare(ename: String):
	var enemy_name = ename.to_upper()
	visible = true
	
	if enemy_name == "":
		return
	
	texture.texture = jumpscares[enemy_name].sprite
	audio.stream = jumpscares[enemy_name].sound
	audio.play()
	animation.play("jumpscare")
