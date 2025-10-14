class_name PaletteList extends GenericList

signal palette_selected(palette: Resource)

func _ready() -> void:
	# Set the button scene for this specific list
	button_scene = preload("res://scenes/ui/buttons/generic_checkbox.tscn")
	
	# Populate with palettes
	populate_list(
		Progression.get_unlocked_palettes(),
		Settings.get_selected_color_palette
	)
	
	# Forward the generic signal to specific signal
	item_selected.connect(_forward_signal)

func _forward_signal(item: Resource):
	palette_selected.emit(item)
