extends Menu

var button_to_press: CharacterIcon

@onready var scenario_list: ScenarioList = $ScenarioList
@onready var map_list: MapList = $MapList
@onready var map_icon: VBoxContainer = $MapIcon

func _ready():
	map_list.map_selected.connect(_on_map_selected)
	scenario_list.scenario_selected.connect(_on_scenario_selected)

func _on_map_selected(map: Map):
	map_icon.update_map_text(map)

func _on_scenario_selected(scenario: ClassicModeScenario):
	map_icon.update_scenario_text(scenario)

func _character_icon_selected(profile: CharacterProfile):
	Settings.set_selected_character_name(profile.name.to_lower())

func _on_start_pressed():
	go_to_menu(MenuConfig.MenuType.START_GAME, MenuConfig.TransitionDirection.FORWARD, false)

func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.CHARACTER_SELECT, MenuConfig.TransitionDirection.BACKWARD, true)

func _on_menu_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
