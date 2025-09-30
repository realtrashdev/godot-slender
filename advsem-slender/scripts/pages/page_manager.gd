class_name PageSpawnManager extends Node

func generate_pages():
	var locations = get_locations()
	
	# Set maximum amount of pages the map can generate
	CurrentGameData.current_max_pages = locations.size()
	print("Maximum possible pages: %d" % CurrentGameData.current_max_pages)
	
	# Check if there are valid locations
	if locations.is_empty():
		push_warning("No PageLocations found on map. No pages generated.")
		return
	
	# Determine how many pages to spawn
	var desired_count = CurrentGameData.get_page_gen_amount()
	var spawn_count = mini(desired_count, locations.size())
	
	# Shuffle and spawn pages
	locations.shuffle()
	for i in range(spawn_count):
		locations[i].generate_page()
	
	# Warn if we couldn't spawn all requested pages
	if spawn_count < desired_count:
		push_warning("Only generated %d/%d pages (out of locations)." % [spawn_count, desired_count])
	
	print("Generated %d pages" % spawn_count)

func get_locations() -> Array:
	return get_tree().get_nodes_in_group("PageLocation")

func clear_locations() -> void:
	for location in get_locations():
		location.reset()
