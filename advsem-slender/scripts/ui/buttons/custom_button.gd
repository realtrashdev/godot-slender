@tool
class_name CustomButton
extends Button
## Custom Button implementation that:
##
## - Uses a RichTextLabel child to support BBCode.[br]
## - Can react to the player hovering, pressing, toggling the button.

enum Pivot {
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
	TOP_LEFT,
	TOP_RIGHT,
	CENTER,
}

@export var label: RichTextLabel
@export var text_print_wait_time: float = 0.3
@export var do_size: bool = true

## Setters update values while editing in inspector.
## Should never be updating these via code. Only in the exported fields before running.
@export_group("Default", "default_")
@export var default_text: String = "Button":
	set(value):
		default_text = value
		_text = value
@export var default_font_size: int = 48:
	set(value):
		default_font_size = value
		_font_size = value
@export var default_color: Color = Color.WHITE:
	set(value):
		default_color = value
		_color = value
@export var default_size: Vector2 = Vector2(300, 100):
	set(value):
		default_size = value
		_size = value
@export var default_alignment_h: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT:
	set(value):
		default_alignment_h = value
		_align_h = value
@export var default_alignment_v: VerticalAlignment = VERTICAL_ALIGNMENT_CENTER:
	set(value):
		default_alignment_v = value
		_align_v = value
@export var default_pivot: Pivot = Pivot.TOP_LEFT:
	set(value):
		default_pivot = value
		_set_pivot(value)

@export_group("Pressing", "press_")
@export var press_color: Color = Color(0.25, 0.25, 0.25, 1.0)

@export_group("Focusing", "focus_")
@export var focus_enabled: bool = true
@export var focus_size: Vector2 = Vector2(300, 130)
@export var focus_font_size: int = 64.0
@export var focus_text_effect: String = "[wave]"
@export var focus_speed: float = 20.0

@export_group("Toggling", "toggle_")
@export var toggle_size: Vector2 = Vector2(300, 160)
@export var toggle_font_size: int = 72
@export var toggle_text_effect: String = "[wave]"

@export_group("Sounds", "sfx_")
@export var sfx_press: AudioStream = load("res://audio/menu/ui/button_press.mp3")
@export var sfx_release: AudioStream = load("res://audio/menu/ui/button_release.mp3")

# interpolated font size, gets applied to _label's theme override
var _interp_font_size: float

var _focus: bool = false

var _text: String:
	set(value):
		_text = value
		if label:
			label.text = value
var _font_size: int:
	set(value):
		_font_size = value
		if label:
			label.add_theme_font_size_override("normal_font_size", value)
var _color: Color:
	set(value):
		_color = value
		if label:
			label.add_theme_color_override("default_color", value)
var _size: Vector2:
	set(value):
		_size = value
		custom_minimum_size = value
		size = value
var _align_h: HorizontalAlignment:
	set(value):
		_align_h = value
		if label:
			label.horizontal_alignment = value
var _align_v: VerticalAlignment:
	set(value):
		_align_v = value
		if label:
			label.vertical_alignment = value


#region Default Methods
func _ready() -> void:
	_setup()
	call_deferred("delay_display")


func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		lerp_size(delta)


func _on_mouse_entered() -> void:
	if disabled:
		return
	_focus = true
	update_text_effect()


func _on_mouse_exited() -> void:
	_focus = false
	update_text_effect()
	_color = default_color


func _on_button_down() -> void:
	if disabled:
		return
	AudioTools.play_one_shot(get_tree(), sfx_press, 4, randf_range(0.8, 1.2), -10)
	_color = press_color


func _on_button_up() -> void:
	if disabled:
		return
	if _focus:
		AudioTools.play_one_shot(get_tree(), sfx_release, 4, randf_range(1.2, 1.4), -10)
		pass
	_color = default_color


func _on_toggled(toggled_on: bool) -> void:
	update_text_effect()
#endregion

#region Display
func delay_display():
	await get_tree().create_timer(text_print_wait_time).timeout
	update_text_effect()
	display_text()


func lerp_size(delta: float) -> void:
	if toggle_mode and button_pressed:
		if do_size:
			_size = lerp(_size, toggle_size, focus_speed * delta)
		_interp_font_size = lerp(_interp_font_size, float(toggle_font_size), focus_speed * delta)
	elif _focus and focus_enabled:
		if do_size:
			_size = lerp(_size, focus_size, focus_speed * delta)
		_interp_font_size = lerp(_interp_font_size, float(focus_font_size), focus_speed * delta)
	else:
		if do_size:
			_size = lerp(_size, default_size, focus_speed * delta)
		_interp_font_size = lerp(_interp_font_size, float(default_font_size), focus_speed * delta)
	
	_font_size = int(_interp_font_size)


func update_text_effect():
	if not label:
		return
	
	if button_pressed:
		_text = toggle_text_effect + default_text
	elif _focus:
		_text = focus_text_effect + default_text
	else:
		_text = default_text


func display_text():
	if label.visible_characters != label.get_total_character_count():
		create_tween().parallel().tween_property(label, "visible_characters", label.get_total_character_count(), 0.05 * label.get_total_character_count())


func instant_display_text():
	label.visible_characters = label.get_total_character_count()
#endregion


func _setup():
	label.visible_characters = 0
	_interp_font_size = default_font_size
	
	_text = default_text
	_font_size = default_font_size
	_color = default_color
	if do_size:
		_size = default_size
	_align_h = default_alignment_h
	_align_v = default_alignment_v


func _set_pivot(new: Pivot) -> void:
	pivot_offset = Vector2.ZERO
	match new:
		Pivot.BOTTOM_LEFT:
			pivot_offset_ratio = Vector2(0, 1)
		Pivot.BOTTOM_RIGHT:
			pivot_offset_ratio = Vector2(1, 1)
		Pivot.TOP_LEFT:
			pivot_offset_ratio = Vector2(0, 0)
		Pivot.TOP_RIGHT:
			pivot_offset_ratio = Vector2(1, 0)
		Pivot.CENTER:
			pivot_offset_ratio = Vector2(0.5, 0.5)
