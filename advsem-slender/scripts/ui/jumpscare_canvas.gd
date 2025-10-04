class_name JumpscareManager extends CanvasLayer

@export var default_jumpscare: Jumpscare  # fallback if enemy has none for some reason

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var texture: TextureRect = $TextureRect
@onready var animation: AnimationPlayer = $TextureRect/AnimationPlayer

func _ready() -> void:
	visible = false
	Signals.killed_player.connect(_on_player_killed)

func _exit_tree():
	if Signals.killed_player.is_connected(_on_player_killed):
		Signals.killed_player.disconnect(_on_player_killed)

func _on_player_killed(jumpscare: Jumpscare):
	if jumpscare:
		play_jumpscare(jumpscare)
	elif default_jumpscare:
		play_jumpscare(default_jumpscare)
	else:
		push_warning("No jumpscare available")

func play_jumpscare(jumpscare: Jumpscare):
	visible = true
	texture.texture = jumpscare.sprite
	audio.stream = jumpscare.sound
	audio.play()
	animation.play("jumpscare_" + str(Jumpscare.Type.keys()[jumpscare.type]).to_lower())

# testing in editor
func test_jumpscare(jumpscare: Jumpscare):
	_on_player_killed(jumpscare)
