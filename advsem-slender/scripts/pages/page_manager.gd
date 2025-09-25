extends Node3D

const DEFAULT_GENERATED_PAGES: int = 8

var pages_to_generate = null
var generated_pages: Array[int]

func _ready() -> void:
	# deferred in case random landmark generation is implemented
	# gives the landmarks a chance to generate before attempting to create pages
	call_deferred("generate_pages", pages_to_generate)

func generate_pages(amount):
	if amount == null:
		amount = DEFAULT_GENERATED_PAGES
	
	# gets all possible page spawn locations
	var locations = get_tree().get_nodes_in_group("PageLocation")
	
	# checks if there are valid locations
	if locations.size() <= 0:
		push_warning("No PageLocations found on map. No pages generated.")
		return
	
	# begin spawning pages
	for node in amount:
		var selection = randi_range(0, locations.size() - 1)
		locations[selection].generate_page()
		locations.remove_at(selection)
		
		# out of spawn locations while still wanting to spawn more
		if locations.size() <= 0:
			push_warning("Out of PageLocations to generate.")
			return
