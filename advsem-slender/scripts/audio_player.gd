class_name CustomAudioPlayer extends AudioStreamPlayer

@export var fade_in: bool = false
@export var fade_in_time: float = 0.0
var default_volume: float = 0.0

func _ready() -> void:
	default_volume = volume_db
	
	if fade_in:
		set_volume_smooth(volume_db, fade_in_time, -50)

func set_volume(new_volume: float):
	volume_db = new_volume

func set_volume_smooth(new_volume: float, tween_duration: float, start_volume: float = new_volume, ease: Tween.EaseType = Tween.EASE_OUT, transition: Tween.TransitionType = Tween.TRANS_QUAD):
	volume_db = start_volume
	create_tween().tween_property(self, "volume_db", new_volume, tween_duration).set_ease(ease).set_trans(transition)
