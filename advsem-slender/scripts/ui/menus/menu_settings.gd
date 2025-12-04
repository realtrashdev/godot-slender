extends Menu

func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
