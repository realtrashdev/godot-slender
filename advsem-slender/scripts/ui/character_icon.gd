class_name CharacterIcon extends Control

signal toggled

enum State { IDLE, FOCUS, PRESSED }

@export var profile: CharacterProfile
@export var desc_right_side: bool = true

@export_group("Sizing")
@export var default_size: Vector2 = Vector2(200, 200)
@export var focus_size: Vector2 = Vector2(225, 225)
@export var active_size: Vector2 = Vector2(250, 250)

const LEFT_OFFSET:  Vector2 = Vector2(-300.0, -100)
const RIGHT_OFFSET: Vector2 = Vector2(150, -100)

var panel_tween: Tween
var text_tween: Tween

var toggle: bool = false
var ignore_mouse: bool = false

@onready var panel_container: PanelContainer = $PanelContainer
@onready var texture: TextureRect = $PanelContainer/TextureRect
@onready var button: CustomButton = $PanelContainer/Button
@onready var description_panel: Panel = $DescriptionPanel
@onready var text_container: VBoxContainer = $DescriptionPanel/TextContainer
@onready var name_text: RichTextLabel = $DescriptionPanel/TextContainer/NameText
@onready var category_text: RichTextLabel = $DescriptionPanel/TextContainer/CategoryText
@onready var description_text: RichTextLabel = $DescriptionPanel/TextContainer/DescriptionText

func _ready() -> void:
	setup()
	description_panel.modulate = Color(0, 0, 0, 0)
	display_desc(false, 0)

func _on_hover():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED or ignore_mouse:
		return
	
	update_description_position()
	description_panel.modulate = Color.WHITE
	display_desc(true, 0.25)
	
	if toggle:
		return
	
	if panel_tween:
		panel_tween.kill()
	panel_tween = create_tween()
	
	panel_tween.tween_property(panel_container, "custom_minimum_size", focus_size, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

func _on_unhover():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED or ignore_mouse:
		return
	
	description_panel.modulate = Color(0, 0, 0, 0)
	display_desc(false, 0)
	
	if toggle:
		return
	
	if panel_tween:
		panel_tween.kill()
	panel_tween = create_tween()
	
	panel_tween.tween_property(panel_container, "custom_minimum_size", default_size, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

func _on_toggle(on: bool):
	toggled.emit(profile.name)
	toggle = on
	
	if panel_tween:
		panel_tween.kill()
	panel_tween = create_tween()
	
	match on:
		true:
			panel_tween.tween_property(panel_container, "custom_minimum_size", active_size, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		false:
			panel_tween.tween_property(panel_container, "custom_minimum_size", default_size, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

func display_desc(do_show: bool, time: float):
	if text_tween:
		text_tween.kill()
	text_tween = create_tween()
	
	name_text.visible_ratio = 1
	category_text.visible_ratio = 1
	
	for child in text_container.get_children():
		if child is RichTextLabel:
			match do_show:
				true:
					text_tween.parallel().tween_property(child, "visible_ratio", 1, time)
				false:
					text_tween.parallel().tween_property(child, "visible_ratio", 0, 0)

func setup():
	if not profile:
		queue_free()
		return
	
	if profile is VesselProfile:
		category_text.text = "[wave amp=5]"
	
	var char_name = profile.name
	
	if char_name == "default":
		char_name = SaveManager.get_player_name()
	
	texture.texture = profile.icon
	name_text.text = name_text.text + char_name.to_upper()
	category_text.text = category_text.text + profile.Type.keys()[profile.type]
	description_text.text = description_text.text + profile.description
	
	update_description_position()

func update_description_position():
	await get_tree().process_frame
	
	if desc_right_side:
		description_panel.global_position = panel_container.global_position + get_desc_offset()
	else:
		description_panel.global_position = panel_container.global_position + get_desc_offset()

func get_desc_offset():
	match desc_right_side:
		true:
			return RIGHT_OFFSET + Vector2(panel_container.custom_minimum_size.x / 2, 0)
		false:
			return LEFT_OFFSET - Vector2(panel_container.custom_minimum_size.x / 2, 0)
