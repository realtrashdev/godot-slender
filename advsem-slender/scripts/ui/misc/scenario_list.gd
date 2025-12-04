class_name ScenarioList extends GenericList

signal scenario_selected(scenario: ClassicModeScenario)

var current_map: Map

func _ready() -> void:
	# Set the button scene for this specific list
	button_scene = preload("res://scenes/ui/buttons/generic_checkbox.tscn")
	
	current_map = Settings.get_selected_map()
	
	# Populate with scenarios from the current map
	populate_list(
		current_map.scenarios,
		Settings.get_selected_scenario,
		func(scenario): return scenario.check_for_unlock()
	)
	
	# Forward the generic signal to specific signal
	item_selected.connect(_forward_signal)

func _forward_signal(item: Resource):
	scenario_selected.emit(item)
