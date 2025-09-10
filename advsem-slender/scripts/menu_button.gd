extends Button

var default_size: Vector2
var default_font_size: float

@export var default_button_text: String
@export var focused_size: Vector2 = Vector2(0, 130)
@export var focused_font_size: float = 64
@export var focused_text_addition: String = "[wave]"
@export var focus_speed: float = 8

var interp_font_size: float
var focused: bool = false

@onready var text_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	setup()
	#await get_tree().create_timer(2).timeout
	display_text()

func _process(delta: float) -> void:
	lerp_size(delta)

func _on_mouse_entered() -> void:
	focused = true
	text_label.text = focused_text_addition + default_button_text

func _on_mouse_exited() -> void:
	focused = false
	text_label.text = default_button_text
	text_label.add_theme_color_override("default_color", Color.WHITE)

func _on_button_down() -> void:
	text_label.add_theme_color_override("default_color", Color.WEB_GRAY)

func _on_button_up() -> void:
	text_label.add_theme_color_override("default_color", Color.WHITE)

func lerp_size(delta: float) -> void:
	match focused:
		true:
			custom_minimum_size = lerp(custom_minimum_size, focused_size, focus_speed * delta)
			interp_font_size = lerp(interp_font_size, focused_font_size, focus_speed * delta)
		false:
			custom_minimum_size = lerp(custom_minimum_size, default_size, focus_speed * delta)
			interp_font_size = lerp(interp_font_size, default_font_size, focus_speed * delta)
		_:
			print("how")
	
	text_label.add_theme_font_size_override("normal_font_size", int(interp_font_size))

func display_text():
	var tween = create_tween()
	tween.parallel().tween_property(text_label, "visible_characters", text_label.get_total_character_count(), 0.05 * text_label.get_total_character_count())

func setup():
	default_size = custom_minimum_size
	default_font_size = float(text_label.get_theme_default_font_size())
	text_label.text = default_button_text
	text_label.visible_characters = 0
	interp_font_size = default_font_size
