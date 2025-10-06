extends Menu

var button_to_press: CharacterIcon

@onready var characters: HBoxContainer = $HScrollBar/Characters
@onready var icon_scene = preload("uid://cwiritx4rencv")

func _ready():
	get_vessel_icons()
	setup_mode_buttons()
	await get_tree().create_timer(0.3).timeout
	show_icons()

func get_vessel_icons():
	var all_profiles = ResourceDatabase.get_all_characters()
	
	for profile in all_profiles:
		var icon = icon_scene.instantiate()
		icon.profile = profile
		characters.add_child(icon)

func setup_mode_buttons():
	var group = ButtonGroup.new()
	for ch in characters.get_children():
		if ch is CharacterIcon:
			ch.set_disabled(true)
			
			var unlocked_ids = Progression.get_unlocked_characters()
			if unlocked_ids.has(ch.profile):
				ch.button.button_group = group
				ch.selected.connect(_character_icon_selected)
			
			if ch.profile.name.to_lower() == Settings.get_selected_character().resource_name:
				button_to_press = ch

func show_icons():
	var tween: Tween = create_tween()
	tween.tween_property(characters, "theme_override_constants/separation", 300, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	
	for child in characters.get_children():
		if child is CharacterIcon:
			child.set_disabled(false)
	
	button_to_press.set_selected(true)

func _character_icon_selected(profile: CharacterProfile):
	Settings.set_selected_character_name(profile.name.to_lower())

func _on_start_pressed():
	go_to_menu(MenuConfig.MenuType.MAP_SELECT, MenuConfig.TransitionDirection.FORWARD, false)

func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MODE_SELECT, MenuConfig.TransitionDirection.BACKWARD, true)

func _on_menu_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
