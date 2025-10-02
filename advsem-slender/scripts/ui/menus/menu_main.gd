extends Menu

func _on_play_pressed():
	go_to_menu(MenuConfig.MenuType.PLAY, MenuConfig.TransitionDirection.FORWARD)

func _on_quit_pressed():
	go_to_menu(MenuConfig.MenuType.QUIT, MenuConfig.TransitionDirection.BACKWARD)
