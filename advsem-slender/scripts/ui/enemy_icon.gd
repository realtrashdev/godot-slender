extends Control

enum State { IDLE, FOCUS, PRESSED }

@export var enemy_profile: EnemyProfile
@export var default_size: Vector2 = Vector2(200, 200)
@export var focus_size: Vector2 = Vector2(225, 225)
@export var active_size: Vector2 = Vector2(250, 250)

var panel_tween: Tween
var text_tween: Tween

var toggle: bool = false

@onready var description_panel: Panel = $HBoxContainer/DescriptionPanel
@onready var panel_container: PanelContainer = $HBoxContainer/PanelContainer
@onready var texture: TextureRect = $HBoxContainer/PanelContainer/TextureRect
@onready var text_container: VBoxContainer = $HBoxContainer/DescriptionPanel/TextContainer
@onready var name_text: RichTextLabel = $HBoxContainer/DescriptionPanel/TextContainer/NameText
@onready var category_text: RichTextLabel = $HBoxContainer/DescriptionPanel/TextContainer/CategoryText
@onready var description_text: RichTextLabel = $HBoxContainer/DescriptionPanel/TextContainer/DescriptionText

func _ready() -> void:
	setup()
	description_panel.modulate = Color(0, 0, 0, 0)
	display_desc(false, 0)

func _on_hover():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		return
	
	description_panel.modulate = Color.WHITE
	display_desc(true, 0.25)
	
	if toggle:
		return
	
	if panel_tween:
		panel_tween.kill()
	panel_tween = create_tween()
	
	panel_tween.tween_property(panel_container, "custom_minimum_size", focus_size, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func _on_unhover():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		return
	
	description_panel.modulate = Color(0, 0, 0, 0)
	display_desc(false, 0)
	
	if toggle:
		return
	
	if panel_tween:
		panel_tween.kill()
	panel_tween = create_tween()
	
	panel_tween.tween_property(panel_container, "custom_minimum_size", default_size, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func _on_toggle(on: bool):
	toggle = on
	
	if panel_tween:
		panel_tween.kill()
	panel_tween = create_tween()
	
	match on:
		true:
			panel_tween.tween_property(panel_container, "custom_minimum_size", active_size, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		false:
			panel_tween.tween_property(panel_container, "custom_minimum_size", default_size, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func display_desc(do_show: bool, time: float):
	if text_tween:
		text_tween.kill()
	text_tween = create_tween()
	
	for child in text_container.get_children():
		if child is RichTextLabel:
			match do_show:
				true:
					text_tween.parallel().tween_property(child, "visible_ratio", 1, time)
				false:
					text_tween.parallel().tween_property(child, "visible_ratio", 0, 0)

func setup():
	texture.texture = enemy_profile.icon
	name_text.text = name_text.text + enemy_profile.name
	category_text.text = category_text.text + EnemyProfile.EnemyType.keys()[enemy_profile.type]
	description_text.text = description_text.text + enemy_profile.description

func set_panel_size(state: State):
	pass
