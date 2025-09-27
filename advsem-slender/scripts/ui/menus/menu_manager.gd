extends Node3D

@export var menus: Dictionary[String, PackedScene]

const MENU_OPEN_DELAY: float = 0.5

@onready var current_menu: CanvasLayer = $MainMenuCanvas

func _ready() -> void:
	create_tween().tween_property($Music, "volume_db", -7.0, 1)
	current_menu.menu_selected.connect(open_new_menu)
	current_menu.change_scale(Vector2.ZERO)

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
	
	# connect signal, reassign current_menu to the one being opened
	menu.menu_selected.connect(open_new_menu)
	current_menu = menu
	
	# set starting scale based on direction menu is coming from
	match direction:
		Menu.MenuDirection.FORWARD:
			menu.change_scale(Vector2.ZERO)
		Menu.MenuDirection.BACKWARD:
			menu.change_scale(Vector2(5, 5))
