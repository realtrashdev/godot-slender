extends Menu

static var seen: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if seen:
		go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.FORWARD, false)
		return
	
	await get_tree().create_timer(1).timeout
	TextTools.change_visible_characters_timed($RichTextLabel, $RichTextLabel.get_total_character_count(), 0.5, 2, 0.5)
	await get_tree().create_timer(3).timeout
	seen = true
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.FORWARD, false)
	print("going to main")
