class_name GenericList extends Node

signal item_selected(item: Resource)

@export var button_scene: PackedScene
@export var show_description: bool = true
@export var populate_delay: float = 0.0
@export var per_button_delay: float = 0.0

var time: Timer
var delayed: bool = false
var selected: bool = false
var opened: bool = false
var current_item: Resource

@onready var button_container: VBoxContainer = $PanelContainer/ScrollContainer/CheckBoxContainer

## Generic list population method.
## items: Array of Resources (Maps or Scenarios)
## get_current_func: Callable that returns the currently selected item
## is_unlocked_func: Optional callable to check if an item is unlocked (returns bool)
func populate_list(items: Array, get_current_func: Callable, is_unlocked_func: Callable = Callable()):
	time = Timer.new()
	add_child(time)
	if populate_delay > 0 and not delayed:
		time.start(populate_delay)
		await time.timeout
	
	current_item = get_current_func.call()
	_clear_list()
	
	var group = ButtonGroup.new()
	
	selected = false
	
	for item in items:
		# Check if item is unlocked (if function provided)
		var is_unlocked = true
		if is_unlocked_func.is_valid():
			is_unlocked = is_unlocked_func.call(item)
		
		var checkbox: GenericCheckbox = button_scene.instantiate()
		checkbox.item = item
		checkbox.focus = show_description
		
		if not is_unlocked:
			checkbox.disabled = true
		
		button_container.add_child(checkbox)
		checkbox.check_box.button_group = group
		checkbox.checked.connect(_on_item_selected)
		
		# Check if this is the currently selected item
		if _is_current_item(item) and not opened:
			checkbox.check_box.button_pressed = true
			selected = true
		# If switching to different map, auto select first incomplete scenario
		if opened and not selected and not Progression.is_scenario_completed(item.resource_name):
			checkbox.check_box.button_pressed = true
			selected = true
		
		# Delay add
		if per_button_delay > 0:
			time.start(per_button_delay)
			await time.timeout
	
	# Failsafe for auto select
	if not selected:
		button_container.get_child(0).check_box.button_pressed = true
		print("Selection failsafe used.")
	
	opened = true

func _clear_list():
	for child in button_container.get_children():
		child.queue_free()

func _is_current_item(item: Resource) -> bool:
	if not current_item:
		return false
	return item.resource_name == current_item.resource_name

func _on_item_selected(item: Resource):
	item_selected.emit(item)

func text_effect_reset():
	for child in $PanelContainer/ScrollContainer/CheckBoxContainer.get_children():
		if child is GenericCheckbox:
			child.reset_text()
