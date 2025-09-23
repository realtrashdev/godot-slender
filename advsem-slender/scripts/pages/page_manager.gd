extends Node3D

const DEFAULT_GENERATED_PAGES: int = 3

var pages_to_generate = null
var generated_pages: Array[int]

func _ready() -> void:
	call_deferred("generate_pages", pages_to_generate)


func generate_pages(amount):
	if amount == null:
		amount = DEFAULT_GENERATED_PAGES
	
	var locations = get_tree().get_nodes_in_group("PageLocation")
	
	if locations.size() == 0:
		push_warning("No PageLocations found on map. No pages generated.")
		return
	
	for i in amount:
		var selection = randi_range(0, locations.size() - 1)
		locations[selection].generate_page()
		locations.remove_at(selection)
