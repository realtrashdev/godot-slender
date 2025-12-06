extends Menu

func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
	SaveManager.save_game()


func _on_secret_music_button_pressed() -> void:
	Signals.change_menu_music_pitch.emit()
