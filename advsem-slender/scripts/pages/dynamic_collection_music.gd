extends Node

@export var enabled: bool = true
@export var music_updates: Dictionary[int, AudioStream]
@export var start_pause_time: float = 1.5
@export var pause_time: float = 0.0
## Save previous position of the audio and start the new audio at that position.
@export var use_previous_position: bool = true

var _game_state: GameState
var _current_stream: AudioStream
var _current_pos: float = 0.0

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer


func initialize(state: GameState):
	_game_state = state
	if Settings.get_selected_scenario().resource_name == "tutorial":
		return
	Signals.page_collected.connect(_on_page_collected)
	Signals.game_finished.connect(_on_game_finished)
	Signals.player_died.connect(_on_player_died)


func _on_page_collected():
	var pages: int = _game_state.current_pages_collected
	
	if pages in music_updates:
		_current_pos = _get_new_playback_position()
		var pause = _get_pause_time()
		
		audio.stop()
		audio.stream = music_updates[pages]
		_current_stream = audio.stream
		
		if pause > 0.0:
			await get_tree().create_timer(pause, false).timeout
		
		if pages == _game_state.current_pages_collected and enabled:
			audio.play(_current_pos)


func _on_game_finished():
	_current_pos = audio.get_playback_position()
	audio.stop()
	enabled = false


func _on_player_died():
	if audio.stream == null:
		return
	audio.stop()
	audio.pitch_scale = 0.5
	await get_tree().create_timer(1.0).timeout
	audio.stream = _current_stream
	audio.play(_current_pos)


func _get_new_playback_position() -> float:
	if use_previous_position:
		return audio.get_playback_position()
	return 0.0


func _get_pause_time() -> float:
	if not audio.playing:
		return start_pause_time
	return pause_time
