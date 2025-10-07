extends VBoxContainer

const START_DELAY: float = 0.4
const MAP_EFFECT: String = "[wave]%s[/wave]"

var map_tween: Tween
var scenario_tween: Tween

@onready var map_text: RichTextLabel = $MapText
@onready var scenario_text: RichTextLabel = $ScenarioText

func _ready() -> void:
	map_text.visible_ratio = 0
	scenario_text.visible_ratio = 0
	await get_tree().create_timer(START_DELAY).timeout
	map_tween = create_tween()
	map_tween.tween_property(map_text, "visible_ratio", 1, 0.5)
	await map_tween.finished
	scenario_tween = create_tween()
	scenario_tween.tween_property(scenario_text, "visible_ratio", 1, 0.2)

# public functions
func update_map_text(map: Map):
	if map_tween:
		map_tween.kill()
	
	map_text.visible_ratio = 0
	map_text.text = MAP_EFFECT % map.map_name
	
	map_tween = create_tween()
	map_tween.tween_property(map_text, "visible_ratio", 1, 0.5)

func update_scenario_text(scenario: ClassicModeScenario):
	if scenario_tween:
		scenario_tween.kill()
	
	scenario_text.visible_ratio = 0
	scenario_text.text = scenario.name
	
	scenario_tween = create_tween()
	scenario_tween.tween_property(scenario_text, "visible_ratio", 1, 0.2)
