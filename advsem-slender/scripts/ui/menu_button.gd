extends Button

var default_size: Vector2
var default_font_size: float

@export var enabled: bool = true
@export var default_text: String
@export var justification: HorizontalAlignment

@export_subgroup("Focusing", "focus_")
@export var focus_size: Vector2 = Vector2(0, 130)
@export var focus_font_size: float = 64
@export var focus_text_effect: String = "[wave]"
@export var focus_speed: float = 8

@export_subgroup("Toggling", "toggle_")
@export var toggle_size: Vector2 = Vector2(0, 160)
@export var toggle_font_size: float = 72
@export var toggle_text_effect: String = "[wave]"

@export_subgroup("Sounds", "sfx_")
@export var sfx_press: AudioStream = load("res://audio/menu/ui/button_press.mp3")
@export var sfx_release: AudioStream = load("res://audio/menu/ui/button_release.mp3")

# interpolated font size, gets applied to text_label's theme override
var interp_font_size: float

var focus: bool = false

@onready var text_label: RichTextLabel = $RichTextLabel

#region Default Methods
func _ready() -> void:
	setup()
	await get_tree().create_timer(0.5).timeout
	update_text_effect()
	display_text()

func _process(delta: float) -> void:
	if enabled:
		lerp_size(delta)

func _on_mouse_entered() -> void:
	if enabled:
		focus = true
		update_text_effect()

func _on_mouse_exited() -> void:
	focus = false
	update_text_effect()
	text_label.add_theme_color_override("default_color", Color.WHITE)

func _on_button_down() -> void:
	AudioTools.play_one_shot(get_tree(), sfx_press, randf_range(0.8, 1.2), -10)
	text_label.add_theme_color_override("default_color", Color.WEB_GRAY)

func _on_button_up() -> void:
	if focus:
		AudioTools.play_one_shot(get_tree(), sfx_release, randf_range(1.2, 1.4), -10)
	text_label.add_theme_color_override("default_color", Color.WHITE)

func _on_toggled(toggled_on: bool) -> void:
	update_text_effect()
#endregion

#region Display
func lerp_size(delta: float) -> void:
	if button_pressed:
		custom_minimum_size = lerp(custom_minimum_size, toggle_size, focus_speed * delta)
		interp_font_size = lerp(interp_font_size, toggle_font_size, focus_speed * delta)
	elif focus:
		custom_minimum_size = lerp(custom_minimum_size, focus_size, focus_speed * delta)
		interp_font_size = lerp(interp_font_size, focus_font_size, focus_speed * delta)
	else:
		custom_minimum_size = lerp(custom_minimum_size, default_size, focus_speed * delta)
		interp_font_size = lerp(interp_font_size, default_font_size, focus_speed * delta)
	
	text_label.add_theme_font_size_override("normal_font_size", int(interp_font_size))

func update_text_effect():
	if not text_label:
		return
	
	if button_pressed:
		text_label.text = toggle_text_effect + default_text
	elif focus:
		text_label.text = focus_text_effect + default_text
	else:
		text_label.text = default_text

func display_text():
	create_tween().parallel().tween_property(text_label, "visible_characters", text_label.get_total_character_count(), 0.05 * text_label.get_total_character_count())
#endregion

func setup():
	default_size = custom_minimum_size
	default_font_size = float(text_label.get_theme_default_font_size())
	text_label.text = default_text
	text_label.visible_characters = 0
	text_label.horizontal_alignment = justification
	interp_font_size = default_font_size
