extends Menu

var tween: Tween

@onready var description: RichTextLabel = $DescriptionText
@onready var classic_btn: Button = $ModeButtons/ClassicButton
@onready var endless_btn: Button = $ModeButtons/EndlessButton

func _ready():
	setup_mode_buttons()
	await get_tree().create_timer(0.3).timeout
	show_current_mode_description()

func setup_mode_buttons():
	var group = ButtonGroup.new()
	classic_btn.button_group = group
	endless_btn.button_group = group
	
	classic_btn.toggled.connect(_on_classic_toggled)
	endless_btn.toggled.connect(_on_endless_toggled)
	
	match Settings.get_selected_game_mode():
		GameConfig.GameMode.CLASSIC:
			classic_btn.set_pressed_no_signal(true)
		GameConfig.GameMode.ENDLESS:
			endless_btn.set_pressed_no_signal(true)
		_:
			push_warning("Settings.gd returned unselectable game mode?")

func show_current_mode_description():
	var mode = Settings.get_selected_game_mode()
	animate_description(GameConfig.get_mode_description(mode))

func animate_description(text: String):
	description.text = text
	description.visible_characters = 0
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(description, "visible_characters", description.get_total_character_count(), 0.5)

func _on_classic_toggled(pressed: bool):
	if not pressed: return
	Settings.set_selected_game_mode(GameConfig.GameMode.CLASSIC)
	animate_description(GameConfig.get_mode_description(GameConfig.GameMode.CLASSIC))

func _on_endless_toggled(pressed: bool):
	if not pressed: return
	Settings.set_selected_game_mode(GameConfig.GameMode.ENDLESS)
	animate_description(GameConfig.get_mode_description(GameConfig.GameMode.ENDLESS))

## TODO change back to CHARACTER_SELECT once characters are implemented
func _on_start_pressed():
	go_to_menu(MenuConfig.MenuType.MAP_SELECT, MenuConfig.TransitionDirection.FORWARD, true)

func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
