extends CanvasLayer

const CONTAINER_SEPARATION: int = 2000


@onready var panel_container: HBoxContainer = $HBoxContainer


func _setup() -> void:
	opening_animation()


func opening_animation():
	panel_container.add_theme_constant_override("separation", CONTAINER_SEPARATION)
	create_tween().tween_property(panel_container, "theme_override_constants/separation", 0, 0.75)
