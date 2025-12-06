extends Menu

func _ready() -> void:
	call_deferred("defer")

func defer():
	var secret = get_parent().get_node("Secrets")
	secret.reset_typed.connect(_on_reset_typed)

func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
	SaveManager.save_game()

func _on_secret_music_button_pressed() -> void:
	Signals.change_menu_music_pitch.emit()

func _on_reset_typed():
	$ProgressResetButton.visible = true

## Resets progress other than inital setting changes and tutorial completion
func _on_progress_reset_button_pressed() -> void:
	SaveManager.reset_progression()
	Progression.complete_tutorial()
	Progression.complete_scenario("tutorial")
	Settings.set_selected_color_palette(ResourceDatabase.get_color_set("grayscale"))
	Settings.set_selected_scenario(ResourceDatabase.get_scenario("basics1"))
	Settings.set_selected_map("forest")
	ScreenColorCanvas.change_game_color(ResourceDatabase.get_color_set("grayscale"))
	
	get_tree().change_scene_to_file("res://scenes/ui/menus/menu_base.tscn")
