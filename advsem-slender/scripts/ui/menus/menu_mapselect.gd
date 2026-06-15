extends Menu

var button_to_press: CharacterIcon

@onready var scenario_list: ScenarioList = $StrongMouseParallax/ScenarioList
@onready var map_list: MapList = $StrongMouseParallax/MapList
@onready var map_icon: VBoxContainer = $StrongMouseParallax/MapIcon
@onready var overview_tutorial = $StrongMouseParallax/EnemyOverviewTutorial

func _ready():
	map_list.map_selected.connect(_on_map_selected)
	scenario_list.scenario_selected.connect(_on_scenario_selected)
	
	if Settings.get_selected_game_mode() == GameConfig.GameMode.ENDLESS:
		scenario_list.visible = false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		_on_back_pressed()
	
	if Input.is_action_just_released("interact") and overview_tutorial.visible and EnemyOverview.visible:
		overview_tutorial.visible = false
		#HACK
		Progression.complete_tutorial()


func open_enemy_overview_tutorial():
	overview_tutorial.visible = true


func _on_map_selected(map: Map):
	map_icon.update_map_text(map)
	
	map_list.text_effect_reset()
	scenario_list.text_effect_reset()
	
	scenario_list.populate()
	
	if not Progression.is_tutorial_completed() and map.resource_name == "forest" and Settings.get_selected_game_mode() == GameConfig.GameMode.CLASSIC:
		open_enemy_overview_tutorial()


func _on_scenario_selected(scenario: ClassicModeScenario):
	map_icon.update_scenario_text(scenario)
	
	map_list.text_effect_reset()
	scenario_list.text_effect_reset()


func _on_start_pressed():
	go_to_menu(MenuConfig.MenuType.START_GAME, MenuConfig.TransitionDirection.FORWARD, false)
	SaveManager.save_game()


func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.CHARACTER_SELECT, MenuConfig.TransitionDirection.BACKWARD, true)
	SaveManager.save_game()


func _on_menu_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
	SaveManager.save_game()
