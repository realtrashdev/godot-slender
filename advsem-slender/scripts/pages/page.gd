extends Interactible

@onready var interaction_area: Area3D = $InteractionArea
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D


func collect():
	Signals.page_collected.emit()
	
	# play audio
	audio.pitch_scale = randf_range(0.95, 1.15)
	audio.play()
	
	# prevent additional interaction, and then wait for sound to finish before deleting fully
	interaction_area.queue_free()
	await get_tree().create_timer(2).timeout
	queue_free()
