class_name CharacterIcon extends Control

signal selected(profile)
signal hovered(profile)
signal unhovered(profile)

@export var profile: CharacterProfile

@export_group("Sizing")
@export var default_size: Vector2 = Vector2(200, 200)
@export var focus_size: Vector2 = Vector2(225, 225)
@export var active_size: Vector2 = Vector2(250, 250)

var is_selected: bool = false
var is_disabled: bool = false

@onready var panel_container: PanelContainer = $PanelContainer
@onready var texture: TextureRect = $PanelContainer/TextureRect
@onready var button: CustomButton = $PanelContainer/Button
@onready var description_panel: DescriptionPanel = $DescriptionPanel

func _ready() -> void:
	setup_display()
	description_panel.hide_immediate()
	
	button.mouse_entered.connect(_on_hover)
	button.mouse_exited.connect(_on_unhover)
	button.pressed.connect(_on_pressed)

func setup_display() -> void:
	if not profile:
		push_error("CharacterIcon: No profile assigned")
		queue_free()
		return
	
	texture.texture = profile.icon
	description_panel.set_profile(profile)

func _on_hover() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED or is_disabled:
		return
	
	description_panel.show_description()
	hovered.emit(profile)
	
	if not is_selected:
		animate_to_size(focus_size)

func _on_unhover() -> void:
	if is_disabled:
		return
	
	description_panel.hide_description()
	unhovered.emit(profile)
	
	if not is_selected:
		animate_to_size(default_size)

func _on_pressed() -> void:
	if is_disabled:
		return
	
	set_selected(!is_selected)
	selected.emit(profile)

func set_selected(selected: bool) -> void:
	is_selected = selected
	button.set_pressed_no_signal(is_selected)
	
	if is_selected:
		animate_to_size(active_size)
	else:
		animate_to_size(default_size)

func set_disabled(disabled: bool) -> void:
	is_disabled = disabled
	button.disabled = disabled

func animate_to_size(target_size: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(panel_container, "custom_minimum_size", target_size, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
