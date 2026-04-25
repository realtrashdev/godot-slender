extends Menu

var manager: MenuManager
var credits_music: AudioStream = preload("uid://cjg6hknm6qj2d")


func _ready() -> void:
	manager = get_parent() as MenuManager


func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
	manager.fade_out_music_and_swap(-60, 0.5, manager.music_dict["menu"], manager.base_music_pitch)
