extends Control

var tween: Tween

@onready var description_panel: Panel = $HBoxContainer/DescriptionPanel
@onready var text_container: VBoxContainer = $HBoxContainer/DescriptionPanel/TextContainer

func _ready() -> void:
	description_panel.visible = false
	display_desc(false, 0)

func _on_hover():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		return
	
	description_panel.visible = true
	display_desc(true, 0.25)

func _on_unhover():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		return
	
	description_panel.visible = false
	display_desc(false, 0)

func display_desc(do_show: bool, time: float):
	if tween:
		tween.kill()
	tween = create_tween()
	
	for child in text_container.get_children():
		if child is RichTextLabel:
			match do_show:
				true:
					tween.parallel().tween_property(child, "visible_ratio", 1, time)
				false:
					tween.parallel().tween_property(child, "visible_ratio", 0, 0)
