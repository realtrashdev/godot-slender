class_name PageSpawnManager extends Node

@export var mandatory_locations: Array[Node3D]

var game_state: GameState

func initialize(state: GameState):
	game_state = state

func _exit_tree():
	# prevent the memory leakage
	for location in get_locations():
		for child in location.get_children():
			if child.has_signal("collected") and child.collected.is_connected(on_page_collected):
				child.collected.disconnect(on_page_collected)

func generate_pages():
	var locations = get_locations()
	
	# set max amount of pages the map can generate
	game_state.current_max_pages = locations.size()
	print("Maximum possible pages: %d" % game_state.current_max_pages)
	
	# check for valid locations
	if locations.is_empty():
		push_warning("No PageLocations found on map. No pages generated.")
		return
	
	# determine how many pages to spawn
	var desired_count = game_state.get_page_gen_amount()
	var spawn_count = mini(desired_count, locations.size())
	var pages_spawned := 0
	
	# spawn mandatory locations first
	var mandatory_spawned := 0
	for location in locations:
		if location.mandatory and pages_spawned < spawn_count:
			print("generate +1 mandatory")
			var page = location.generate_page()
			page.collected.connect(on_page_collected)
			pages_spawned += 1
			mandatory_spawned += 1
	
	# filter out mandatory locations
	var non_mandatory_locations = locations.filter(func(loc): return not loc.mandatory)
	non_mandatory_locations.shuffle()
	
	# shuffle and spawn pages
	var remaining_to_spawn = spawn_count - mandatory_spawned
	for i in range(mini(remaining_to_spawn, non_mandatory_locations.size())):
		var page = non_mandatory_locations[i].generate_page()
		page.collected.connect(on_page_collected)
		pages_spawned += 1
	
	print("Generated %d pages (%d mandatory, %d non-mandatory)" % [pages_spawned, mandatory_spawned, pages_spawned - mandatory_spawned])

func get_locations() -> Array:
	return get_tree().get_nodes_in_group("PageLocation")

func clear_locations() -> void:
	for location in get_locations():
		location.reset()

func on_page_collected():
	game_state.current_pages_collected += 1
	game_state.total_pages_collected += 1
	Signals.page_collected.emit()
