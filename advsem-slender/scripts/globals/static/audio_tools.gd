class_name AudioTools


static func play_one_shot(tree: SceneTree, audio: AudioStream, bus_idx: int, pitch_scale: float = 1.0, volume_db: float = 0):
	var source = AudioStreamPlayer.new()
	source.stream = audio
	source.pitch_scale = pitch_scale
	source.volume_db = volume_db
	source.bus = AudioServer.get_bus_name(bus_idx)
	
	tree.root.add_child.call_deferred(source)
	
	source.call_deferred("play")
	await source.finished
	source.queue_free()


static func play_one_shot_3d(tree: SceneTree, audio: AudioStream, bus_idx: int, position: Vector3, max_distance: float = 20.0, pitch_scale: float = 1.0, volume_db: float = 0):
	var source = AudioStreamPlayer3D.new()
	source.stream = audio
	source.pitch_scale = pitch_scale
	source.volume_db = volume_db
	source.bus = AudioServer.get_bus_name(bus_idx)
	
	source.position = position
	source.max_distance = max_distance
	
	tree.root.add_child(source)
	
	source.play()
	await source.finished
	source.queue_free()
