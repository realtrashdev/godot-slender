extends Node2D

var player: CharacterBody3D
var tutorial: bool = false

@onready var distance_text: RichTextLabel = $DistanceText
@onready var direction_arrow: Sprite2D = $DirectionArrow

func _ready() -> void:
	if Settings.get_selected_scenario().resource_name == "tutorial":
		tutorial = true
	if tutorial:
		direction_arrow.visible = false

func _process(delta: float) -> void:
	if not visible: return
	
	var result = get_nearest_page_data()
	distance_text.text = str(result.distance) + "m"
	
	if tutorial and !direction_arrow.visible:
		if player.active and result.distance > 50:
			direction_arrow.visible = true
			Signals.tutorial_distance_reached.emit()
		else:
			distance_text.text = "0m"
	
	if result.direction != Vector3.ZERO:
		update_arrow_direction(result.direction)
		#direction_arrow.visible = true
	else:
		direction_arrow.visible = false

func get_nearest_page_data() -> Dictionary:
	var locations = get_tree().get_nodes_in_group("PageLocation")
	var min_distance: int = 999999
	var nearest_position: Vector3 = Vector3.ZERO
	
	if locations.is_empty():
		return {"distance": 999999, "direction": Vector3.ZERO}
	
	for location in locations:
		for child in location.get_children():
			if child is Page:
				var distance: int = roundi(player.global_position.distance_to(child.global_position))
				if distance < min_distance:
					min_distance = distance
					nearest_position = child.global_position
	
	var direction = Vector3.ZERO
	if nearest_position != Vector3.ZERO:
		direction = (nearest_position - player.global_position).normalized()
	
	return {"distance": min_distance, "direction": direction}

func update_arrow_direction(world_direction: Vector3) -> void:
	# Get player's forward direction (assuming -Z is forward in Godot)
	var player_forward = -player.global_transform.basis.z
	var player_right = player.global_transform.basis.x
	
	# Project the direction onto the horizontal plane (ignore Y)
	var flat_direction = Vector3(world_direction.x, 0, world_direction.z).normalized()
	var flat_forward = Vector3(player_forward.x, 0, player_forward.z).normalized()
	var flat_right = Vector3(player_right.x, 0, player_right.z).normalized()
	
	# Calculate angle relative to player's forward direction
	var dot_forward = flat_direction.dot(flat_forward)
	var dot_right = flat_direction.dot(flat_right)
	
	# Convert to angle in radians (-PI to PI)
	var angle = atan2(dot_right, dot_forward)
	
	# Convert to 4 directions (0-3, where 0 is forward)
	# Divide by PI/2 (90 degrees) to get 4 quadrants
	var direction_index = int(round(angle / (PI / 2))) % 4
	
	# Rotate arrow sprite based on direction
	# Assuming your arrow sprite points up by default
	var rotation_angle = direction_index * (PI / 2)
	direction_arrow.rotation = rotation_angle

# Helper function if you want to use discrete direction names
func get_direction_name(index: int) -> String:
	var directions = ["Forward", "Right", "Back", "Left"]
	return directions[index]
