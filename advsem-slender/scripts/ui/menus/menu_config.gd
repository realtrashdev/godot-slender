class_name MenuConfig

enum MenuType { INTRO, MAIN, SETTINGS, QUIT, MODE_SELECT, CHARACTER_SELECT, MAP_SELECT, START_GAME }
enum TransitionDirection { FORWARD, BACKWARD }

const MENU_SCENES = {
	MenuType.INTRO: "res://scenes/ui/menus/menu_intro.tscn",
	MenuType.MAIN: "res://scenes/ui/menus/menu_main.tscn",
	MenuType.MODE_SELECT: "res://scenes/ui/menus/menu_modeselect.tscn",
	MenuType.CHARACTER_SELECT: "res://scenes/ui/menus/menu_characterselect.tscn",
	MenuType.MAP_SELECT: "res://scenes/ui/menus/menu_mapselect.tscn"
}

const DEFAULT_GAME_SCENE = "res://scenes/levels/map_forest.tscn"
