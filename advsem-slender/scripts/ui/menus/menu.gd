class_name Menu extends Control

signal menu_changed(new_menu: MenuConfig.MenuType, direction: MenuConfig.TransitionDirection)

func go_to_menu(type: MenuConfig.MenuType, direction: MenuConfig.TransitionDirection):
	menu_changed.emit(type, direction)
