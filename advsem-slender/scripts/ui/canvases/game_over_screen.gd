extends CanvasLayer

@export var after_anim_objects: Array[Control]

const CONTAINER_SEPARATION: int = 2000


@onready var panel_container: HBoxContainer = $HBoxContainer


func _ready() -> void:
	_setup()


func _setup() -> void:
	opening_animation()


func opening_animation():
	for item in after_anim_objects:
		item.visible = false
	
	panel_container.add_theme_constant_override("separation", CONTAINER_SEPARATION)
	var tween = create_tween().tween_property(panel_container, "theme_override_constants/separation", 0, 0.75)
	await tween.finished
	
	for item in after_anim_objects:
		item.visible = true


func restart_level():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_packed(Settings.get_selected_map().scene)


func return_to_menu():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://scenes/ui/menus/menu_base.tscn")
