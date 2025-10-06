class_name MapList extends Node

signal map_selected(map: Map)

const BUTTON_SCENE = preload("res://scenes/ui/buttons/map_button.tscn")

var current_map: Map

@onready var button_container: VBoxContainer = $PanelContainer/ScrollContainer/CheckBoxContainer

func _ready() -> void:
	current_map = Settings.get_selected_map()
	_populate_list()

func _populate_list():
	var group = ButtonGroup.new()
	
	for map in Progression.get_unlocked_maps():
		var mb: MapCheckbox = BUTTON_SCENE.instantiate()
		mb.map = map
		button_container.add_child(mb)
		mb.check_box.button_group = group
		
		if map.resource_name == Settings.get_selected_map().resource_name:
			mb.check_box.button_pressed = true
