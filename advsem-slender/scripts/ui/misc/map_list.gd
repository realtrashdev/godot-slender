class_name MapList extends GenericList

signal map_selected(map: Map)

func _ready() -> void:
	# Set the button scene for this specific list
	button_scene = preload("res://scenes/ui/buttons/generic_checkbox.tscn")
	
	# Populate with maps
	populate_list(
		Progression.get_unlocked_maps(),
		Settings.get_selected_map,
		func(map): return Progression.is_map_unlocked(map.resource_name)
	)
	
	# Forward the generic signal to specific signal
	item_selected.connect(_forward_signal)

func _forward_signal(item: Resource):
	map_selected.emit(item)
