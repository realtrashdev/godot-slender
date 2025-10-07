class_name ScenarioCheckbox extends PanelContainer

signal checked(ClassicModeScenario)
signal hovered()
signal unhovered()

# sizing
const DEFAULT_SIZE: Vector2 = Vector2(600, 80)
const FOCUSED_SIZE: Vector2 = Vector2(600, 140)
const CHECKED_SIZE: Vector2 = Vector2(600, 140)

# text effect/prefixes
const FOCUSED_EFFECT: String = "[wave amp=25]%s[/wave]"
const CHECKED_EFFECT: String = "[wave amp=60]%s[/wave]"
const DESCRIPTION_PREFIX: String = ""

var scenario: ClassicModeScenario

# defaults
var default_text: String
var disabled: bool = false

# tweens
var size_tween: Tween
var desc_text_tween: Tween

# loads
var sfx_press: AudioStream = load("res://audio/menu/ui/button_press.mp3")
var sfx_release: AudioStream = load("res://audio/menu/ui/button_release.mp3")

@onready var check_box: CheckBox = $CheckBox
@onready var text_label: RichTextLabel = $CheckBox/RichTextLabel
@onready var description_label: RichTextLabel = $VBoxContainer/DescriptionLabel
@onready var overview_button: Button = $CheckBox/CustomButton

func _ready():
	if not disabled:
		default_text = scenario.name
		text_label.text = default_text
		description_label.text = DESCRIPTION_PREFIX + scenario.description
	else:
		check_box.disabled = true
		default_text = "???"
		text_label.text = default_text
		description_label.text = DESCRIPTION_PREFIX + "Locked..."
	
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)
	check_box.button_down.connect(_on_mouse_down)
	check_box.button_up.connect(_on_mouse_up)
	check_box.toggled.connect(_on_toggled)
	overview_button.pressed.connect(_show_overview)

func _on_hover():
	if disabled:
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
	if disabled:
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
	AudioTools.play_one_shot(get_tree(), sfx_press, randf_range(0.8, 1.2), -10)

func _on_mouse_up():
	AudioTools.play_one_shot(get_tree(), sfx_release, randf_range(1.2, 1.4), -10)

func _on_toggled(toggled: bool):
	if disabled:
		return
	
	if toggled:
		text_label.text = CHECKED_EFFECT % default_text
		_tween_size(CHECKED_SIZE)
		Settings.set_selected_scenario(scenario)
		
		if description_label.visible_ratio == 0:
			desc_text_tween = create_tween()
			desc_text_tween.tween_property(description_label, "visible_ratio", 1, 0.3)
	else:
		text_label.text = default_text
		_tween_size(DEFAULT_SIZE)
		
		if desc_text_tween:
			desc_text_tween.kill()
		desc_text_tween = create_tween()
		desc_text_tween.tween_property(description_label, "visible_ratio", 0, 0.3)
	
	checked.emit(scenario)

func _tween_size(new_size: Vector2, time: float = 0.2):
	if size_tween:
		size_tween.kill()
	size_tween = create_tween()
	size_tween.tween_property(self, "custom_minimum_size", new_size, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _show_overview():
	EnemyOverview.populate_via_scenario(scenario)
