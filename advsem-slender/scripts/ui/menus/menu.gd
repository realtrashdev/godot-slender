class_name Menu extends Control

signal menu_changed(new_menu: MenuConfig.MenuType, direction: MenuConfig.TransitionDirection, play_sound: bool)

@export var do_mouse_offset: bool = true

func _process(delta: float) -> void:
	if do_mouse_offset: position = get_menu_offset()

func go_to_menu(type: MenuConfig.MenuType, direction: MenuConfig.TransitionDirection, play_sound: bool):
	menu_changed.emit(type, direction, play_sound)

func get_menu_offset() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_center = get_viewport().size / 2.0
	var offset_from_center = mouse_pos - screen_center
	
	# Scale the offset - adjust this multiplier to control intensity
	var parallax_strength = 10.0  # pixels of movement
	var normalized_offset = offset_from_center / screen_center  # -1 to 1 range
	
	return -normalized_offset * parallax_strength
