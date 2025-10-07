class_name MapCheckbox extends PanelContainer

signal checked(Map)
signal hovered()
signal unhovered()

const DEFAULT_SIZE: Vector2 = Vector2(600, 80)
const FOCUSED_SIZE: Vector2 = Vector2(600, 90)
const CHECKED_SIZE: Vector2 = Vector2(600, 120)

const FOCUSED_EFFECT: String = "[wave amp=25]%s[/wave]"
const CHECKED_EFFECT: String = "[wave amp=60]%s[/wave]"

var map: Map

var disabled: bool = false

var default_text: String
var size_tween: Tween

@onready var check_box: CheckBox = $CheckBox
@onready var text_label: RichTextLabel = $CheckBox/RichTextLabel

func _ready():
	if not disabled:
		default_text = map.map_name
		text_label.text = default_text
	else:
		check_box.disabled = true
		default_text = "???"
		text_label.text = default_text
	
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)
	check_box.toggled.connect(_on_toggled)

func _on_hover():
	if disabled:
		return
	
	if not check_box.button_pressed:
		text_label.text = FOCUSED_EFFECT % default_text
		_tween_size(FOCUSED_SIZE)
		hovered.emit()

func _on_unhover():
	if disabled:
		return
	
	if not check_box.button_pressed:
		text_label.text = default_text
		_tween_size(DEFAULT_SIZE)
		unhovered.emit()

func _on_toggled(toggled: bool):
	if disabled:
		return
	
	if toggled:
		text_label.text = CHECKED_EFFECT % default_text
		_tween_size(CHECKED_SIZE)
		Settings.set_selected_map(map.resource_name)
	else:
		text_label.text = default_text
		_tween_size(DEFAULT_SIZE)
	
	checked.emit(map)

func _tween_size(new_size: Vector2, time: float = 0.2):
	if size_tween:
		size_tween.kill()
	size_tween = create_tween()
	size_tween.tween_property(self, "custom_minimum_size", new_size, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
