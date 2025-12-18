class_name JumpscareManager extends CanvasLayer

@export var default_jumpscare: Jumpscare  # fallback if enemy has none for some reason

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $Position/Shake/AnimatedSprite2D
@onready var fade_out: ColorRect = $FadeOut


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
	
	sprite.sprite_frames = jumpscare.animation
	var anim_names = sprite.sprite_frames.get_animation_names()
	sprite.play(anim_names[0])
	
	audio.stream = jumpscare.sound
	audio.play()
	
	animation.play("jumpscare_" + str(Jumpscare.ShakeType.keys()[jumpscare.type]).to_lower())
	create_tween().tween_property(fade_out, "color", Color.BLACK, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)

# testing in editor
func test_jumpscare(jumpscare: Jumpscare):
	_on_player_killed(jumpscare)
