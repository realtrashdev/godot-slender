class_name ScenarioList extends GenericList

signal scenario_selected(scenario: ClassicModeScenario)

const COMPLETED_TEXT_START: String = "[tornado radius=2 freq=3]COMPLETE: "

var current_map: Map

@onready var completed_text: RichTextLabel = $CompletedText

func _ready() -> void:
	# Set the button scene for this specific list
	button_scene = preload("res://scenes/ui/buttons/generic_checkbox.tscn")
	
	# Forward the generic signal to specific signal
	item_selected.connect(_forward_signal)

func populate():
	for child in $PanelContainer/ScrollContainer/CheckBoxContainer.get_children():
		child.queue_free()
	
	current_map = Settings.get_selected_map()
	
	# Populate with scenarios from the current map
	populate_list(
		current_map.scenarios,
		Settings.get_selected_scenario,
		func(scenario): return scenario.check_if_scenario_unlocked()
	)
	
	var completed = 0
	for scenario in current_map.scenarios:
		if Progression.is_scenario_completed(scenario.resource_name):
			completed += 1
	completed_text.text = COMPLETED_TEXT_START + str(completed) + "/" + str(current_map.scenarios.size())

func _forward_signal(item: Resource):
	scenario_selected.emit(item)
