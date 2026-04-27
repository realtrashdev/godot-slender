extends Control

var quit: bool = false


func _init() -> void:
	SaveManager.reset_all_data()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.color = Color.BLACK
	await create_tween().tween_property($ColorRect, "color", Color(0.0, 0.0, 0.0, 0.0), 3.0).finished
	$ColorRect.mouse_filter = MOUSE_FILTER_IGNORE


func _on_play_button_pressed() -> void:
	_fade_out()


func _on_skip_button_pressed() -> void:
	Progression.complete_tutorial()
	_fade_out()


func _on_quit_button_pressed() -> void:
	quit = true
	_fade_out()


func _fade_out():
	$ColorRect.mouse_filter = MOUSE_FILTER_STOP
	$CustomAudioPlayer.set_volume_smooth(-60, 3.0)
	await create_tween().tween_property($ColorRect, "color", Color.BLACK, 3.0).finished
	if quit:
		get_tree().quit()
	get_tree().change_scene_to_file("res://scenes/ui/menus/menu_base.tscn")
	
