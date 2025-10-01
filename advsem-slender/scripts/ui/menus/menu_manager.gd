extends Node3D

@export var menus: Dictionary[String, PackedScene]

const MENU_OPEN_DELAY: float = 0.5

var recent_keys: Array[String] = []

@onready var current_menu: CanvasLayer = $MainMenuCanvas
@onready var typing_sounds: AudioStreamPlayer = $TypingSounds

func _ready() -> void:
	create_tween().tween_property($Music, "volume_db", -7.0, 1)
	current_menu.menu_selected.connect(open_new_menu)
	current_menu.change_scale(Vector2.ZERO)
	check_gum()

func _input(event: InputEvent) -> void:
	if event is not InputEventKey:
		return
	
	if event.is_released() or event.is_echo():
		return
	
	print(event.as_text())
	recent_keys.append(event.as_text())
	
	if recent_keys.size() > 10:
		recent_keys.remove_at(0)
	
	if recent_keys.size() < 3:
		return
	
	var last_idx = recent_keys.size() - 1
	if last_idx >= 2:
		if recent_keys[last_idx - 2] == "G" and \
		   recent_keys[last_idx - 1] == "U" and \
		   recent_keys[last_idx] == "M":
			spawn_gum()

func open_new_menu(menu_name: String, direction: Menu.MenuDirection):
	if menu_name == "Quit":
		create_tween().tween_property($Music, "volume_db", -60.0, 0.6)
		await get_tree().create_timer(0.7).timeout
		get_tree().quit()
		return
	
	await get_tree().create_timer(MENU_OPEN_DELAY).timeout
	
	# delete current menu, add new one to scene tree
	current_menu.queue_free()
	var menu = menus[menu_name].instantiate()
	add_child(menu)
	
	# reconnect menu_selected signal, reassign current_menu to the one being opened
	menu.menu_selected.connect(open_new_menu)
	current_menu = menu
	
	# set starting scale based on direction menu is coming from
	match direction:
		Menu.MenuDirection.FORWARD:
			menu.change_scale(Vector2.ZERO)
		Menu.MenuDirection.BACKWARD:
			menu.change_scale(Vector2(5, 5))

## 1 in 500 chance every second to spawn gum enemy on title screen
## Fun little easter egg, should decrease the odds probably
func check_gum():
	await get_tree().create_timer(1).timeout
	var num = randi_range(1, 500)
	if num == 500:
		spawn_gum()
	check_gum()

func spawn_gum():
	var scene = preload("res://scenes/enemies/gum.tscn").instantiate()
	add_child(scene)
	scene.activate()
