extends Node3D

@export var menus: Dictionary[String, PackedScene]

const MENU_OPEN_DELAY: float = 0.5

@onready var current_menu: CanvasLayer = $MainMenuCanvas

func _ready() -> void:
	current_menu.menu_selected.connect(open_new_menu)
	current_menu.change_scale(Vector2.ZERO)

func open_new_menu(menu_name: String, direction: Menu.MenuDirection):
	var new_menu = load(menus[menu_name].resource_path)
	
	await get_tree().create_timer(MENU_OPEN_DELAY).timeout
	
	# delete current menu, add new one to scene tree
	current_menu.queue_free()
	var menu = new_menu.instantiate()
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
