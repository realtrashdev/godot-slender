extends Node

const SAVE_PATH = "user://save_data.json"

# settings
var settings: Dictionary = {
	"selected_game_mode": GameConfig.GameMode.CLASSIC,
	"audio_volume": 1.0,
	"mouse_sensitivity": 0.002,
}

# progression
var progression: Dictionary = {
	"total_pages_collected": 0,
	"total_deaths": 0,
	"best_page_streak": 0,
	"unlocked_modes": [GameConfig.GameMode.CLASSIC],
	"enemy_encounters": {},  # enemy_name: count
}

func _ready():
	load_game()

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

# settings accessors
func get_selected_game_mode() -> GameConfig.GameMode:
	return settings.get("selected_game_mode", GameConfig.GameMode.CLASSIC)

func set_selected_game_mode(mode: GameConfig.GameMode):
	settings["selected_game_mode"] = mode
	save_game()

# progression accessors
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

func is_mode_unlocked(mode: GameConfig.GameMode) -> bool:
	return progression["unlocked_modes"].has(mode)

# reset functions
func reset_progression():
	progression = {
		"total_pages_collected": 0,
		"total_deaths": 0,
		"best_page_streak": 0,
		"unlocked_modes": [GameConfig.GameMode.CLASSIC],
		"enemy_encounters": {},
	}
	save_game()

func reset_settings():
	settings = {
		"selected_game_mode": GameConfig.GameMode.CLASSIC,
		"audio_volume": 1.0,
		"mouse_sensitivity": 0.002,
	}
	save_game()
