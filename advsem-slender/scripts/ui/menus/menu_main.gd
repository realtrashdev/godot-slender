extends Menu

static var already_opened: bool =  false

var manager: MenuManager

@onready var title_text: RichTextLabel = $StrongParallax/TitleText
@onready var credits_text: RichTextLabel = $StrongParallax/CreditsText
@onready var version_text: RichTextLabel = $StrongParallax/VersionText

@onready var play_button: CustomButton = $StrongParallax/VBoxContainer/PlayButton
@onready var customize_button: CustomButton = $StrongParallax/VBoxContainer/CustomizeButton
@onready var settings_button: CustomButton = $StrongParallax/VBoxContainer/SettingsButton
@onready var credits_button: CustomButton = $StrongParallax/VBoxContainer/CreditsButton
@onready var quit_button: CustomButton = $StrongParallax/VBoxContainer/QuitButton

func _ready() -> void:
	manager = get_parent() as MenuManager
	
	if not already_opened:
		await get_tree().create_timer(0.5).timeout
		TextTools.change_visible_characters(title_text, title_text.get_total_character_count(), 0.5, 0)
		await get_tree().create_timer(0.5).timeout
		TextTools.change_visible_characters(version_text, version_text.get_total_character_count(), 0.2, 0)
		already_opened = true
	else:
		TextTools.change_visible_characters(title_text, title_text.get_total_character_count(), 0, 0)
		TextTools.change_visible_characters(version_text, version_text.get_total_character_count(), 0, 0)
		play_button.wait_time = 0.3
		customize_button.wait_time = 0.15
		settings_button.wait_time = 0.2
		credits_button.wait_time = 0.25
		quit_button.wait_time = 0.3
	call_deferred("defer")

func defer():
	var secret = get_parent().get_node("Secrets")
	secret.brody_typed.connect(_on_brody_typed)

func _on_play_pressed():
	go_to_menu(MenuConfig.MenuType.MAP_SELECT, MenuConfig.TransitionDirection.FORWARD, true)

func _on_customize_pressed():
	go_to_menu(MenuConfig.MenuType.CUSTOMIZE, MenuConfig.TransitionDirection.FORWARD, true)

func _on_quit_pressed():
	go_to_menu(MenuConfig.MenuType.QUIT, MenuConfig.TransitionDirection.BACKWARD, true)

func _on_settings_button_pressed() -> void:
	go_to_menu(MenuConfig.MenuType.SETTINGS, MenuConfig.TransitionDirection.FORWARD, true)

func _on_credits_button_pressed() -> void:
	go_to_menu(MenuConfig.MenuType.CREDITS, MenuConfig.TransitionDirection.FORWARD, true)
	manager.fade_out_music_and_swap(-60, 0.5, manager.music_dict["credits"])

func _on_brody_typed() -> void:
	settings_button.visible = !settings_button.visible
