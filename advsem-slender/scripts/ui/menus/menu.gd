class_name Menu extends Control

signal menu_changed(new_menu: MenuConfig.MenuType, direction: MenuConfig.TransitionDirection, play_sound: bool)

func go_to_menu(type: MenuConfig.MenuType, direction: MenuConfig.TransitionDirection, play_sound: bool):
	menu_changed.emit(type, direction, play_sound)
