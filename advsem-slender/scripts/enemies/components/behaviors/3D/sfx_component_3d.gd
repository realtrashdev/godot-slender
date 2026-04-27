class_name SFXComponent3D extends EnemyBehavior3D

@export var state_audio: Dictionary[Enemy3D.State, SoundEffectSettings]

var state: Enemy3D.State
var _audio_player: AudioStreamPlayer3D
var tween: Tween


func _setup() -> void:
	enemy.state_changed.connect(_on_state_changed)
	_audio_player = AudioStreamPlayer3D.new()
	enemy.add_child(_audio_player)


func _on_state_changed(new_state: Enemy3D.State) -> void:
	state = new_state
	if tween:
		tween.kill()
	if new_state in state_audio:
		print("go")
		_audio_player.stop()
		_audio_change(state_audio[new_state])


func _audio_change(settings: SoundEffectSettings):
	print("playing sound")
	print("audio player: " + _audio_player.name)
	_audio_player.stream = settings.stream
	_audio_player.pitch_scale = settings.pitch_scale + randf_range(-settings.pitch_variation, settings.pitch_variation)
	_audio_player.max_distance = settings.max_distance
	
	if settings.fade_in_enabled:
		_audio_player.volume_db = settings.fade_in_starting_volume_db
		_audio_player.play()
		_reset_tween().tween_property(_audio_player, "volume_db", settings.volume_db, settings.fade_in_time)
		print("playing: fade in")
		await tween.finished
	else:
		_audio_player.volume_db = settings.volume_db
		_audio_player.play()
		print("playing: no fade in")
	
	if not _check_state(): return # State has changed, do not continue
	if not settings.fade_out_enabled: return # No manual fade out, do not continue
	
	if settings.fade_out_delay > 0:
		print("delaying fade out")
		await get_tree().create_timer(settings.fade_out_delay, false).timeout
	
	if not _check_state(): return # State has changed, do not continue
	
	print("tweening fade out")
	_reset_tween().tween_property(_audio_player, "volume_db", settings.fade_out_ending_volume_db, settings.fade_out_time)


func _reset_tween() -> Tween:
	if tween:
		tween.kill()
	tween = create_tween()
	return tween


func _check_state() -> bool:
	if enemy.current_state == state:
		return true
	return false
