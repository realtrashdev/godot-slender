class_name ScenarioList extends Node

signal scenario_selected(scenario: ClassicModeScenario)

const BUTTON_SCENE = preload("res://scenes/ui/buttons/scenario_button.tscn")

var current_map: Map

@onready var button_container: VBoxContainer = $PanelContainer/ScrollContainer/CheckBoxContainer

func _ready() -> void:
	current_map = Settings.get_selected_map()
	_add_buttons()

##
## TODO uncomment below lines once scenario unlocking is implemented
##
func _add_buttons():
	var group = ButtonGroup.new()
	
	for scenario in current_map.scenarios:
		#if scenario.resource_name in Progression.get_unlocked_scenarios():
		var cb: ScenarioCheckbox = BUTTON_SCENE.instantiate()
		cb.scenario = scenario
		button_container.add_child(cb)
		cb.check_box.button_group = group
			
		if scenario.resource_name == Settings.get_selected_scenario().resource_name:
			cb.check_box.button_pressed = true
		#else:
			#var cb: ScenarioCheckbox = BUTTON_SCENE.instantiate()
			#cb.scenario = scenario
			#cb.disabled = true
			#button_container.add_child(cb)
