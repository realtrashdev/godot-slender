class_name UIComponent extends Control

var manager: UIManager


func _ready() -> void:
	var parent = get_parent()
	
	await parent.ready
	
	if parent is not UIManager:
		assert(parent is UIManager, "%s: Must be child of UIManager. Deleting." % name)
	
	manager = parent
	
	await manager.initialized
	_setup()


## Override in subclasses
func _setup():
	pass
