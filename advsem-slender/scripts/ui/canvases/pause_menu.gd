extends CanvasLayer

var just_paused: bool = false
var unpause_mouse_mode: Input.MouseMode


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and not just_paused:
		if EnemyOverview.visible:
			EnemyOverview._on_close_button_pressed()
			return
		elif $Settings.visible:
			$Settings.visible = false
			return
		unpause_game()
	elif just_paused:
		just_paused = false


func pause_game():
	just_paused = true
	visible = true
	
	unpause_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_game_pause_audio_effect(true)


func unpause_game():
	Input.mouse_mode = unpause_mouse_mode
	_game_pause_audio_effect(false)
	
	visible = false
	Signals.game_unpaused.emit.call_deferred()
	get_tree().paused = false


func _game_pause_audio_effect(pause: bool):
	var idx: int = AudioServer.get_bus_index("GameMusic")
	for effect in AudioServer.get_bus_effect_count(idx):
		AudioServer.set_bus_effect_enabled(idx, effect, pause)


func _on_overview_button_pressed() -> void:
	EnemyOverview.populate_via_scenario(Settings.get_selected_scenario())
	EnemyOverview.show_overview()


func _on_resume_button_pressed() -> void:
	unpause_game()


func _on_settings_button_pressed() -> void:
	$Settings.visible = true


func _on_restart_button_pressed() -> void:
	_game_pause_audio_effect(false)
	unpause_game()
	get_tree().change_scene_to_packed(Settings.get_selected_map().scene)


func _on_quit_button_pressed() -> void:
	_game_pause_audio_effect(false)
	unpause_game()
	get_tree().change_scene_to_file("res://scenes/ui/menus/menu_base.tscn")


func _on_close_settings_button_pressed() -> void:
	$Settings.visible = false
	SaveManager.save_game()
