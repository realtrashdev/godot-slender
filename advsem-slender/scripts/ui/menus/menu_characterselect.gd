extends Menu

var starting_button_name: String = SaveManager.get_selected_character_name()
var button_to_press: Button

@onready var characters: HBoxContainer = $Characters
@onready var icon_scene = preload("uid://cwiritx4rencv")

func _ready():
	get_vessel_icons()
	setup_mode_buttons()
	await get_tree().create_timer(0.3).timeout
	add_icons()

func setup_mode_buttons():
	var group = ButtonGroup.new()
	for ch in characters.get_children():
		if ch is CharacterIcon:
			ch.ignore_mouse = true
			ch.button.button_group = group
			ch.toggled.connect(_character_icon_toggled)
			
			if ch.profile.name.to_lower() == starting_button_name:
				button_to_press = ch.button

func get_vessel_icons():
	var unlocked_ids = SaveManager.get_unlocked_characters()
	var unlocked_profiles = CharacterDatabase.get_unlocked_characters(unlocked_ids)
	
	for profile in unlocked_profiles:
		var icon = icon_scene.instantiate()
		icon.profile = profile
		characters.add_child(icon)

func add_icons():
	var tween: Tween = create_tween()
	tween.tween_property(characters, "theme_override_constants/separation", 300, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	
	button_to_press.button_pressed = true
	
	for child in characters.get_children():
		child.ignore_mouse = false

func _character_icon_toggled(char_name: String):
	SaveManager.set_selected_character_name(char_name.to_lower())

func _on_start_pressed():
	go_to_menu(MenuConfig.MenuType.START_GAME, MenuConfig.TransitionDirection.FORWARD, false)

func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MODE_SELECT, MenuConfig.TransitionDirection.BACKWARD, true)

func _on_menu_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
