extends Interactible

func collect():
	print("page collected")
	Signals.page_collected.emit()
	$AudioStreamPlayer3D.pitch_scale = randf_range(0.95, 1.15)
	$AudioStreamPlayer3D.play()
	$InteractionArea.queue_free()
	await get_tree().create_timer(2).timeout
	queue_free()
