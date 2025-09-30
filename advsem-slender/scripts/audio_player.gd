class_name CustomAudioPlayer extends AudioStreamPlayer

var default_volume: float = 0.0

func _ready() -> void:
	default_volume = volume_db

func set_volume(new_volume: float):
	volume_db = new_volume

func set_volume_smooth(new_volume: float, tween_duration: float, start_volume: float = new_volume):
	volume_db = start_volume
	create_tween().tween_property(self, "volume_db", new_volume, tween_duration)
