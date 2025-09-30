extends Interactible

@onready var interaction_area: Area3D = $InteractionArea
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D


func collect():
	CurrentGameData.total_pages_collected += 1
	CurrentGameData.current_pages_collected += 1
	Signals.page_collected.emit()
	AudioTools.play_one_shot_3d(get_tree(), audio.stream, audio.global_position, audio.max_distance, audio.pitch_scale, audio.volume_db)
	
	queue_free()
