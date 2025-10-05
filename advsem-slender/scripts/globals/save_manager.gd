extends Node

const SAVE_PATH = "user://save_data.json"

# settings
var settings: Dictionary = {
	"selected_game_mode": GameConfig.GameMode.CLASSIC,
	"selected_scenario": "basics1",
	"selected_character": "default",
	"selected_palette": "mono",
	
	"audio_volume": 1.0,
	"mouse_sensitivity": 0.002,
}

# progression
var progression: Dictionary = {
	# player stats
	"total_pages_collected": 0,
	"total_deaths": 0,
	"enemy_encounters": {},  # enemy_name: count
	
	# unlocks
	"unlocked_modes": [GameConfig.GameMode.CLASSIC],
	"unlocked_scenarios": ["basics1"],
	"unlocked_characters": ["default"],
	"unlocked_palettes": ["mono"],
}

func _ready():
	load_game()
	reset_progression()
	reset_settings()

func save_game():
	var save_dict = {
		"settings": settings,
		"progression": progression,
		"version": "1.0"
	}
	
	var json_string = JSON.stringify(save_dict, "\t")
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if file:
		file.store_string(json_string)
		file.close()
		print("Game saved successfully")
	else:
		push_error("Failed to save game")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found, using defaults")
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("Failed to open save file")
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result == OK:
		var data = json.data
		settings = data.get("settings", settings)
		progression = data.get("progression", progression)
		print("Game loaded successfully")
	else:
		push_error("Failed to parse save file: " + json.get_error_message())

#region Settings Accessors
func get_selected_game_mode() -> GameConfig.GameMode:
	return settings.get("selected_game_mode", GameConfig.GameMode.CLASSIC)

func set_selected_game_mode(mode: GameConfig.GameMode):
	settings["selected_game_mode"] = mode
	save_game()

func get_selected_scenario() -> String:
	return settings.get("selected_scenario", "default")

func set_selected_scenario(mode: ClassicModeScenario):
	settings["selected_scenario"] = mode.name
	save_game()

func get_selected_character_name() -> String:
	return settings.get("selected_character", "default")

func set_selected_character_name(char_name: String):
	settings["selected_character"] = char_name
	save_game()

func get_selected_color_palette() -> String:
	return settings.get("selected_palette", "mono")

func set_selected_color_palette(char_name: String):
	settings["selected_palette"] = char_name
	save_game()
#endregion

#region Progression Accessors
func get_player_name() -> String:
	return progression.get("player_name", "Unnamed")

func set_player_name(player_name: String):
	progression["player_name"] = player_name
	save_game()

func get_unlocked_characters() -> Array:
	return progression.get("unlocked_characters", ["default"])

func unlock_character(char_name: String):
	if not progression["unlocked_characters"].has(char_name):
		progression["unlocked_characters"] += char_name
		save_game()

func add_pages_collected(count: int):
	progression["total_pages_collected"] += count
	save_game()

func increment_deaths():
	progression["total_deaths"] += 1
	save_game()

func record_enemy_encounter(enemy_name: String):
	if not progression["enemy_encounters"].has(enemy_name):
		progression["enemy_encounters"][enemy_name] = 0
	progression["enemy_encounters"][enemy_name] += 1
	save_game()

func unlock_mode(mode: GameConfig.GameMode):
	if not progression["unlocked_modes"].has(mode):
		progression["unlocked_modes"].append(mode)
		save_game()

func unlock_mode_by_name(mode: String):
	if mode.to_lower() == "endless":
		if not progression["unlocked_modes"].has(GameConfig.GameMode.ENDLESS):
			progression["unlocked_modes"].append(GameConfig.GameMode.ENDLESS)
			save_game()
	push_warning("Could not find mode to unlock... (unlock by name)")

func is_mode_unlocked(mode: GameConfig.GameMode) -> bool:
	return progression["unlocked_modes"].has(mode)
#endregion

#region Reset Functions
func reset_settings():
	settings = {
		"selected_game_mode": GameConfig.GameMode.CLASSIC,
		"selected_scenario": "basics1",
		"selected_character": "default",
		"selected_palette": "mono",
		
		"audio_volume": 1.0,
		"mouse_sensitivity": 0.002,
	}
	save_game()

func reset_progression():
	progression = {
		# stats
		"total_pages_collected": 0,
		"total_deaths": 0,
		"enemy_encounters": {},  # enemy_name: count
		
		# unlocks
		"unlocked_modes": [GameConfig.GameMode.CLASSIC],
		"unlocked_scenarios": ["basics1"],
		"unlocked_characters": ["default"],
		"unlocked_palettes": ["mono"],
	}
	save_game()
#endregion
