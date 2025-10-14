class_name GenericCheckbox extends PanelContainer

signal checked(item: Resource)
signal hovered()
signal unhovered()

# sizing
const DEFAULT_SIZE: Vector2 = Vector2(600, 80)
const FOCUSED_SIZE: Vector2 = Vector2(600, 140)
const CHECKED_SIZE: Vector2 = Vector2(600, 140)

# text effect/prefixes
const FOCUSED_EFFECT: String = "[wave amp=25]%s[/wave]"
const CHECKED_EFFECT: String = "[pulse ease=2][wave amp=60]%s"

var button_checked: bool = false

var item: Resource
var focus: bool = true
var disabled: bool = false
var default_text: String

# tweens
var size_tween: Tween
var desc_text_tween: Tween

# audio
var sfx_press: AudioStream = load("res://audio/menu/ui/button_press.mp3")
var sfx_release: AudioStream = load("res://audio/menu/ui/button_release.mp3")

@onready var check_box: CheckBox = $CheckBox
@onready var text_label: RichTextLabel = $CheckBox/RichTextLabel
@onready var description_container: VBoxContainer = $VBoxContainer
@onready var description_label: RichTextLabel = $VBoxContainer/DescriptionLabel
@onready var overview_button: Button = $CheckBox/CustomButton

func _ready():
	_setup_ui()
	_connect_signals()

func _setup_ui():
	if not disabled:
		default_text = _get_item_name()
		text_label.text = default_text
		description_label.text = _get_item_description()
	else:
		check_box.disabled = true
		check_box.self_modulate = Color.TRANSPARENT
		default_text = "???"
		text_label.text = default_text
		description_label.text = "Locked..."
		overview_button.visible = false
	
	if item is Map:
		check_box.layout_direction = Control.LAYOUT_DIRECTION_RTL
		text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		description_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		overview_button.visible = false
	
	if item is ColorSet:
		overview_button.visible = false

func _connect_signals():
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)
	check_box.toggled.connect(_on_toggled)
	check_box.button_down.connect(_on_mouse_down)
	check_box.button_up.connect(_on_mouse_up)
	if overview_button:
		overview_button.pressed.connect(_show_overview)

func _get_item_name() -> String:
	if item is Map:
		return item.map_name
	elif item is ClassicModeScenario:
		return item.name
	elif item is ColorSet:
		return item.name
	return ""

func _get_item_description() -> String:
	if item is ClassicModeScenario or Map:
		return item.description
	return ""

func _on_hover():
	if disabled or not focus:
		return
	
	if desc_text_tween:
		desc_text_tween.kill()
	desc_text_tween = create_tween()
	desc_text_tween.tween_property(description_label, "visible_ratio", 1, 0.3)
	
	if not check_box.button_pressed:
		text_label.text = FOCUSED_EFFECT % default_text
		_tween_size(FOCUSED_SIZE)
		hovered.emit()

func _on_unhover():
	if disabled or not focus:
		return
	
	if not check_box.button_pressed:
		text_label.text = default_text
		_tween_size(DEFAULT_SIZE)
		unhovered.emit()
		
		if desc_text_tween:
			desc_text_tween.kill()
		desc_text_tween = create_tween()
		desc_text_tween.tween_property(description_label, "visible_ratio", 0, 0.3)

func _on_mouse_down():
	if not button_checked:
		AudioTools.play_one_shot(get_tree(), sfx_press, randf_range(0.8, 1.2), -10)

func _on_mouse_up():
	pass

func _on_toggled(toggled: bool):
	if disabled:
		return
	
	if toggled and not button_checked:
		text_label.text = CHECKED_EFFECT % default_text
		_tween_size(CHECKED_SIZE)
		_save_selection()
		button_checked = true
		checked.emit(item)
		
		if description_label.visible_ratio == 0:
			desc_text_tween = create_tween()
			desc_text_tween.tween_property(description_label, "visible_ratio", 1, 0.3)
	
	elif not toggled:
		text_label.text = default_text
		_tween_size(DEFAULT_SIZE)
		button_checked = false
		
		if desc_text_tween:
			desc_text_tween.kill()
		desc_text_tween = create_tween()
		desc_text_tween.tween_property(description_label, "visible_ratio", 0, 0.3)

func _save_selection():
	if item is Map:
		Settings.set_selected_map(item.resource_name)
	elif item is ClassicModeScenario:
		Settings.set_selected_scenario(item)
	elif item is ColorSet:
		Settings.set_selected_color_palette(item)

func _tween_size(new_size: Vector2, time: float = 0.2):
	if not focus:
		return
	
	if size_tween:
		size_tween.kill()
	size_tween = create_tween()
	size_tween.tween_property(self, "custom_minimum_size", new_size, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _show_overview():
	if item is ClassicModeScenario:
		EnemyOverview.populate_via_scenario(item)

# for resetting the pulse effect to keep the map and scenario pulses in line
func reset_text():
	if check_box.button_pressed:
		text_label.text = ""
		text_label.text = CHECKED_EFFECT % default_text
