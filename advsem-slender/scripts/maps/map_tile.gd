@tool
class_name MapTile extends Node3D


@export var pages: int = 0
@export_tool_button("Get Page Count", "Search")
var page_count = _get_page_count

@export_group("Modifiers")
@export_subgroup("Player Spawning")
@export var player_can_spawn: bool = false
@export var player_spawn_point: Node3D


func _get_page_count() -> void:
	var num: int = 0
	for child in get_children():
		if child is PageLocation:
			num += 1
	pages = num
