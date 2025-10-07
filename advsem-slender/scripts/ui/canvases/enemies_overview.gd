extends CanvasLayer

const CONTAINER_SCENE = preload("res://scenes/ui/enemy_overview_icon_container.tscn")
const SUBTITLE_EFFECT = "[wave]%s[/wave]"

var active_containers: Dictionary[int, Node]

@onready var scroll_container: SmoothScrollContainer = $SmoothScrollContainer
@onready var containers: HBoxContainer = $SmoothScrollContainer/Containers
@onready var subtitle: RichTextLabel = $Subtitle

func _ready() -> void:
	visible = false

func show_overview():
	scroll_container.scale.x = 0
	create_tween().tween_property(scroll_container, "scale", Vector2.ONE, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	visible = true

func populate_via_scenario(scenario: ClassicModeScenario):
	_clear()
	show_overview()
	subtitle.text = SUBTITLE_EFFECT % scenario.name
	var index: int = 0
	for i in scenario.enemies_to_add:
		if scenario.enemies_to_add[i] != null:
			var con = CONTAINER_SCENE.instantiate()
			containers.add_child(con)
			con.initialize(i, scenario.enemies_to_add[i].profiles, index)
		index += 1

func populate_via_array(profiles: Array[EnemyProfile]):
	pass

func _clear():
	if not containers.get_children().is_empty():
		for child in containers.get_children():
			child.queue_free()

func _on_close_button_pressed():
	visible = false
