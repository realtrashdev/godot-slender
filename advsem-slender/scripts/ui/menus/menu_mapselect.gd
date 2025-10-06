extends Menu

var button_to_press: CharacterIcon

@onready var scenario_list: ScenarioList = $ScenarioList
@onready var map_list: MapList = $MapList
@onready var map_icon: VBoxContainer = $MapIcon

func _ready():
	scenario_list.scenario_selected.connect(_scenario_selected)

func _map_selected(map: Map):
	pass

func _scenario_selected(scenario: ClassicModeScenario):
	pass

func _character_icon_selected(profile: CharacterProfile):
	Settings.set_selected_character_name(profile.name.to_lower())

func _on_start_pressed():
	go_to_menu(MenuConfig.MenuType.START_GAME, MenuConfig.TransitionDirection.FORWARD, false)

func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.CHARACTER_SELECT, MenuConfig.TransitionDirection.BACKWARD, true)

func _on_menu_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
