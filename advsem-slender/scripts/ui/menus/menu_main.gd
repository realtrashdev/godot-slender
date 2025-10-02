extends Menu

static var already_opened: bool =  false

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var options_button: Button = $VBoxContainer/OptionsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready() -> void:
	if not already_opened:
		await get_tree().create_timer(0.5).timeout
		TextTools.change_visible_characters($TitleText, $TitleText.get_total_character_count(), 0.5, 0)
		await get_tree().create_timer(0.5).timeout
		already_opened = true
	else:
		TextTools.change_visible_characters($TitleText, $TitleText.get_total_character_count(), 0, 0)
		play_button.wait_time = 0.3
		options_button.wait_time = 0.3
		quit_button.wait_time = 0.3

func _on_play_pressed():
	go_to_menu(MenuConfig.MenuType.PLAY, MenuConfig.TransitionDirection.FORWARD, true)

func _on_quit_pressed():
	go_to_menu(MenuConfig.MenuType.QUIT, MenuConfig.TransitionDirection.BACKWARD, true)
