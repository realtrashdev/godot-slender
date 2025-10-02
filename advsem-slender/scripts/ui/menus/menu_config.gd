class_name MenuConfig

enum MenuType { MAIN, PLAY, SETTINGS, QUIT, START_GAME }
enum TransitionDirection { FORWARD, BACKWARD }

const MENU_SCENES = {
	MenuType.MAIN: "res://scenes/ui/menus/menu_main.tscn",
	MenuType.PLAY: "res://scenes/ui/menus/menu_play.tscn",
}

const DEFAULT_GAME_SCENE = "res://scenes/levels/level_forest.tscn"
