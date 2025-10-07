extends VBoxContainer

const START_DELAY: float = 0.4

var map_tween: Tween
var scenario_tween: Tween

@onready var map_text: RichTextLabel = $MapText
@onready var scenario_text: RichTextLabel = $ScenarioText

func _ready() -> void:
	map_text.visible_ratio = 0
	scenario_text.visible_ratio = 0
	await get_tree().create_timer(START_DELAY).timeout
	await _tween_text(map_tween, map_text, 1, 0.5).finished
	_tween_text(scenario_tween, scenario_text, 1, 0.2)

func _tween_text(tween: Tween, object: RichTextLabel, end_value: float = 1, time: float = 0.2) -> Tween:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(object, "visible_ratio", end_value, time)
	return tween

# public functions
func update_map_text(map: Map):
	map_text.visible_ratio = 0
	map_text.text = map.map_name
	_tween_text(map_tween, map_text, 1, 0.5)

func update_scenario_text(scenario: ClassicModeScenario):
	scenario_text.visible_ratio = 0
	scenario_text.text = scenario.name
	_tween_text(scenario_tween, scenario_text, 1, 0.2)
