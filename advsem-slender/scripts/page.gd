extends Interactible

@onready var interaction_area: Area3D = $InteractionArea
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D


func collect():
	print("page collected")
	Signals.page_collected.emit()
	audio.pitch_scale = randf_range(0.95, 1.15)
	audio.play()
	interaction_area.queue_free()
	await get_tree().create_timer(2).timeout
	queue_free()
