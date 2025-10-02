class_name PageSpawnManager extends Node

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
	
	# shuffle and spawn pages
	locations.shuffle()
	for i in range(spawn_count):
		var page = locations[i].generate_page()
		page.collected.connect(on_page_collected)
	
	# warn if unable to spawn all requested pages
	if spawn_count < desired_count:
		push_warning("Only generated %d/%d pages (out of locations)." % [spawn_count, desired_count])
	
	print("Generated %d pages" % spawn_count)

func get_locations() -> Array:
	return get_tree().get_nodes_in_group("PageLocation")

func clear_locations() -> void:
	for location in get_locations():
		location.reset()

func on_page_collected():
	game_state.current_pages_collected += 1
	game_state.total_pages_collected += 1
	Signals.page_collected.emit()
