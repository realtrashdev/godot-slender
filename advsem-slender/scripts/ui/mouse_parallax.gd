@tool
class_name MouseParallax extends Control

@export var do_mouse_offset: bool = true
@export var parallax_strength: float = 10.0
@export var lerp_strength: float = 10.0

@export_group("Tool")
@export var do_offset_in_editor: bool = false
@export_subgroup("Presets")
@export_tool_button("Weak Offset", "Control")
var weak_button = _set_weak_offset
@export_tool_button("Strong Offset", "Control")
var strong_button = _set_strong_offset

var start_pos: Vector2


func _process(delta: float) -> void:
	if Engine.is_editor_hint() and not do_offset_in_editor:
		return
	
	start_pos = position
	if do_mouse_offset:
		position = position.lerp(_get_menu_offset(), lerp_strength * delta)
	else:
		position = start_pos


func _get_menu_offset() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_center = get_viewport().size / 2.0
	var offset_from_center = mouse_pos - screen_center
	
	var normalized_offset = offset_from_center / screen_center  # -1 to 1 range
	
	return -normalized_offset * parallax_strength


func _set_weak_offset():
	parallax_strength = 5.0


func _set_strong_offset():
	parallax_strength = 10.0
