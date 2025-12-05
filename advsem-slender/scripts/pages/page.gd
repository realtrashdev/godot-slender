class_name Page extends Interactible

signal collected

@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

func collect():
	collected.emit()
	AudioTools.play_one_shot_3d(get_tree(), audio.stream, audio.global_position, audio.max_distance, audio.pitch_scale, audio.volume_db)
	queue_free()
