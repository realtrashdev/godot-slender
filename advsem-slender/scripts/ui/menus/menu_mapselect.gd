extends Menu

var button_to_press: CharacterIcon

@onready var scenario_list: ScenarioList = $ScenarioList
@onready var map_list: MapList = $MapList
@onready var map_icon: VBoxContainer = $MapIcon

func _ready():
	map_list.map_selected.connect(_on_map_selected)
	scenario_list.scenario_selected.connect(_on_scenario_selected)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("interact") and $EnemyOverviewTutorial.visible and EnemyOverview.visible:
		$EnemyOverviewTutorial.visible = false
		#HACK
		Progression.complete_tutorial()

func open_enemy_overview_tutorial():
	$EnemyOverviewTutorial.visible = true

func _on_map_selected(map: Map):
	map_icon.update_map_text(map)
	
	map_list.text_effect_reset()
	scenario_list.text_effect_reset()
	
	scenario_list.populate()
	
	if not Progression.is_tutorial_completed() and map.resource_name == "forest":
		open_enemy_overview_tutorial()

func _on_scenario_selected(scenario: ClassicModeScenario):
	map_icon.update_scenario_text(scenario)
	
	map_list.text_effect_reset()
	scenario_list.text_effect_reset()

func _on_start_pressed():
	go_to_menu(MenuConfig.MenuType.START_GAME, MenuConfig.TransitionDirection.FORWARD, false)

## TODO change back to CHARACTER_SELECT once implemented
func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)

func _on_menu_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
