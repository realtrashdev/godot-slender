@tool
extends Node3D

@export_group("Settings")
@export var possible_tiles: Array[PackedScene]
@export var tile_size: Vector2 = Vector2(40, 40)
@export var map_size: Vector2i = Vector2i(5, 5)
@export_tool_button("Generate Tiles", "Add")
var generate_map: Callable = _generate_map
@export_tool_button("Delete Tiles", "Remove")
var delete_map: Callable = _delete_generated_tiles
var gen_pos: float = 0

var generated_tiles: Array[MapTile]


func _ready() -> void:
	_generate_map()


func _generate_map() -> void:
	_delete_generated_tiles()
	_verify_tile_list()
	
	_generate_blank_tiles()


func _generate_blank_tiles() -> void:
	var tiles: Array[PackedScene] = _get_non_page_tiles()
	var placement_target: Vector2 = Vector2(0, 0)
	for i in range(map_size.y):
		for j in range(map_size.x):
			var scene: PackedScene = tiles.pick_random()
			var tile: MapTile = scene.instantiate()
			add_child(tile)
			tile.global_position = Vector3(placement_target.x, 0, placement_target.y)
			tile.rotation_degrees.y = 90 * randi_range(0, 3)
			generated_tiles.append(tile)
			if Engine.is_editor_hint():
				tile.owner = get_tree().edited_scene_root
			placement_target.x += tile_size.x
		placement_target.x = 0
		placement_target.y += tile_size.y


func _verify_tile_list() -> void:
	print("verifying tile list")
	for i in range(possible_tiles.size() - 1, -1, -1):
		var inst = possible_tiles[i].instantiate()
		var ok = inst is MapTile
		inst.free()
		if not ok:
			print("found non MapTile, removing")
			possible_tiles.remove_at(i)
	print("tile list verified")


func _delete_generated_tiles() -> void:
	var deleted: int = 0
	for i in range(generated_tiles.size() - 1, -1, -1):
		generated_tiles[i].queue_free()
		generated_tiles.remove_at(i)
		deleted += 1
	print("deleted %s tiles" % deleted)


func _get_non_page_tiles() -> Array[PackedScene]:
	var tiles: Array[PackedScene]
	for i in possible_tiles.size():
		var inst: MapTile = possible_tiles[i].instantiate()
		if inst.get_page_location_count() == 0:
			tiles.append(possible_tiles[i])
		inst.free()
	print("found %s tiles with no pages" % tiles.size())
	return tiles
