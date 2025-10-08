extends Node3D

@export var mandatory = false

const PAGE_SCENE = "uid://bi81fe12i10ix"

# Spawns a collectible page at this location. Called during page generation process.
func generate_page() -> Node:
	var page = preload(PAGE_SCENE).instantiate()
	add_child(page)
	return page

# For regenerating page locations, called if player reaches page quota without collecting this one
# Deletes all uncollected pages
func reset():
	print("Attempting page reset")
	for child in get_children():
		if child is Interactible:
			print("Reset page")
			child.queue_free()
			return
