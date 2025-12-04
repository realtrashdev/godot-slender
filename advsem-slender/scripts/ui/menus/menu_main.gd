extends Menu

static var already_opened: bool =  false

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var customize_button: CustomButton = $VBoxContainer/CustomizeButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
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
		customize_button.wait_time = 0.15
		settings_button.wait_time = 0.2
		quit_button.wait_time = 0.3

func _on_play_pressed():
	go_to_menu(MenuConfig.MenuType.MAP_SELECT, MenuConfig.TransitionDirection.FORWARD, true)

func _on_customize_pressed():
	go_to_menu(MenuConfig.MenuType.CUSTOMIZE, MenuConfig.TransitionDirection.FORWARD, true)

func _on_quit_pressed():
	go_to_menu(MenuConfig.MenuType.QUIT, MenuConfig.TransitionDirection.BACKWARD, true)

func _on_settings_button_pressed() -> void:
	go_to_menu(MenuConfig.MenuType.SETTINGS, MenuConfig.TransitionDirection.FORWARD, true)
