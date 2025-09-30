extends AudioStreamPlayer

@export var sounds: Array[AudioStream]

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_released() or event.is_echo():
			return
		
		pitch_scale = randf_range(0.9, 1.1)
		sounds.shuffle()
		stream = sounds[0]
		play()
