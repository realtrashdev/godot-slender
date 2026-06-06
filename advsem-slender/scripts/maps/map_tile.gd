@tool
class_name MapTile extends Node3D

@export var area_size: Vector2 = Vector2(50, 50)

@export_group("Foliage Generation", "fol_")
@export var fol_possible_foliage: Array[PackedScene]
@export var fol_generate_on_ready: bool = true
@export var fol_amount_to_generate: int = 5
@export var fol_randomness: int = 2
@export_tool_button("Generate Foliage", "Add")
var generate_foliage: Callable = _generate_foliage
@export_subgroup("Advanced", "fol_")
@export var fol_ray_height: float = 100.0
@export var fol_max_slope: float = 30.0
## uses "terrain" layer by default
@export_flags_3d_physics var fol_mask: int = 256
var foliage_parent: Node3D

@export_group("Modifiers")
@export_subgroup("Player Spawning", "player_")
@export var player_can_spawn: bool = false
@export var player_spawn_point: Node3D


func _ready() -> void:
	if fol_generate_on_ready:
		call_deferred("_generate_foliage")


#region Pages
func get_page_location_count() -> int:
	var num: int = 0
	for child in get_children():
		if child is PageLocation:
			num += 1
	return num
#endregion

#region Foliage
func _generate_foliage() -> void:
	if fol_possible_foliage.size() == 0:
		print("%s: no foliage to place" % name)
		return
	
	var container: Node3D = _clear_foliage()
	var space = get_world_3d().direct_space_state
	
	var placed: int = 0
	var amount: int = randi_range(fol_amount_to_generate - fol_randomness, fol_amount_to_generate + fol_randomness)
	while placed <= amount:
		var x = randf_range(-area_size.x * 0.5, area_size.x * 0.5)
		var z = randf_range(-area_size.y * 0.5, area_size.y * 0.5)
		var from = global_position + Vector3(x, fol_ray_height, z)
		var to = from + Vector3.DOWN * (fol_ray_height * 2.0)
		
		var q = PhysicsRayQueryParameters3D.create(from, to)
		var hit = space.intersect_ray(q)
		
		# no hit
		if hit.is_empty():
			continue
		
		# terrain layer check
		if not (hit.collider.collision_layer & fol_mask):
			continue
		
		# slope angle check
		if hit.normal.angle_to(Vector3.UP) > deg_to_rad(fol_max_slope):
			continue
		
		# check for other collision layers
		#if hit["collider_id"] != mask:
		#	continue
		
		var align: Transform3D = _align_to_normal(hit.position, hit.normal)
		var foliage: Node3D = fol_possible_foliage.pick_random().instantiate()
		var n = foliage.name
		container.add_child(foliage)
		if Engine.is_editor_hint():
			foliage.owner = get_tree().edited_scene_root
			foliage.name = n
		foliage.global_transform = align
		
		placed += 1
	
	print("generated %s foliage pieces" % placed)

# math i looked up...
func _align_to_normal(pos: Vector3, normal: Vector3) -> Transform3D:
	var _basis = Basis()
	var up = normal
	var fwd = up.cross(Vector3.RIGHT).normalized()
	if fwd.length() < 0.01:
		fwd = up.cross(Vector3.FORWARD).normalized()
	_basis = Basis(fwd.cross(up), up, fwd)
	_basis = _basis.rotated(up, randf() * TAU)   # random yaw
	_basis = _basis.scaled(Vector3.ONE * randf_range(0.8, 1.2))  # size variation
	return Transform3D(basis, pos)

# returns container
func _clear_foliage() -> Node3D:
	# remove previous container if it exists
	var existing = get_node_or_null("FoliageContainer")
	if existing:
		existing.free()
	
	# create the parent container
	var container = Node3D.new()
	container.name = "FoliageContainer"
	add_child(container)
	if Engine.is_editor_hint():
		container.owner = get_tree().edited_scene_root
	return container
#endregion
