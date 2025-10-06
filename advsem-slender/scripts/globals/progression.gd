extends Node

signal item_unlocked(category: String, item_id: String)
signal stat_updated(stat_name: String, new_value)

var data: Dictionary = {
	# Player stats
	"player_name": "Unnamed",
	"total_pages_collected": 0,
	"total_deaths": 0,
	"enemy_encounters": {},  # enemy_name: count (call from enemy when it spawns)
	"enemy_deaths": {}, # enemy_name: count (call from enemy when it kills)
	
	# Unlocks
	"unlocked_modes": [GameConfig.GameMode.CLASSIC],
	"unlocked_scenarios": ["basics1"],
	"unlocked_characters": ["default"],
	"unlocked_palettes": ["mono"],
	"unlocked_maps": ["forest"],
}

#region Stats
func get_player_name() -> String:
	return data.get("player_name", "Unnamed")

func set_player_name(player_name: String):
	data["player_name"] = player_name
	stat_updated.emit("player_name", player_name)
	SaveManager.save_game()

func get_total_pages_collected() -> int:
	return data.get("total_pages_collected", 0)

func add_pages_collected(count: int):
	data["total_pages_collected"] += count
	stat_updated.emit("total_pages_collected", data["total_pages_collected"])
	SaveManager.save_game()

func get_total_deaths() -> int:
	return data.get("total_deaths", 0)

func increment_deaths():
	data["total_deaths"] += 1
	stat_updated.emit("total_deaths", data["total_deaths"])
	SaveManager.save_game()

func record_enemy_encounter(enemy_name: String):
	if not data["enemy_encounters"].has(enemy_name):
		data["enemy_encounters"][enemy_name] = 0
	data["enemy_encounters"][enemy_name] += 1
	stat_updated.emit("enemy_encounter", enemy_name)
	SaveManager.save_game()

func get_enemy_encounter_count(enemy_name: String) -> int:
	return data["enemy_encounters"].get(enemy_name, 0)
#endregion

#region Unlocks
func unlock_character(char_id: String):
	if not data["unlocked_characters"].has(char_id):
		data["unlocked_characters"].append(char_id)
		item_unlocked.emit("character", char_id)
		SaveManager.save_game()

func unlock_scenario(scenario_id: String):
	if not data["unlocked_scenarios"].has(scenario_id):
		data["unlocked_scenarios"].append(scenario_id)
		item_unlocked.emit("scenario", scenario_id)
		SaveManager.save_game()

func unlock_mode(mode: GameConfig.GameMode):
	if not data["unlocked_modes"].has(mode):
		data["unlocked_modes"].append(mode)
		item_unlocked.emit("mode", str(mode))
		SaveManager.save_game()

func unlock_palette(palette_id: String):
	if not data["unlocked_palettes"].has(palette_id):
		data["unlocked_palettes"].append(palette_id)
		item_unlocked.emit("palette", palette_id)
		SaveManager.save_game()

func unlock_map(map_id: String):
	if not data["unlocked_maps"].has(map_id):
		data["unlocked_maps"].append(map_id)
		item_unlocked.emit("map", map_id)
		SaveManager.save_game()

#
# Check if singular id is unlocked
#
func is_character_unlocked(char_id: String) -> bool:
	return data["unlocked_characters"].has(char_id)

func is_scenario_unlocked(scenario_id: String) -> bool:
	return data["unlocked_scenarios"].has(scenario_id)

func is_mode_unlocked(mode: GameConfig.GameMode) -> bool:
	return data["unlocked_modes"].has(mode)

func is_palette_unlocked(palette_id: String) -> bool:
	return data["unlocked_palettes"].has(palette_id)

func is_map_unlocked(map_id: String) -> bool:
	return data["unlocked_maps"].has(map_id)

#
# Get array of all unlocks
#
func get_unlocked_characters() -> Array[CharacterProfile]:
	return ResourceDatabase.get_unlocked_characters(data.get("unlocked_characters", ["default"]))

func get_unlocked_scenarios() -> Array[ClassicModeScenario]:
	return ResourceDatabase.get_unlocked_scenarios(data.get("unlocked_scenarios", ["basics1"]))

func get_unlocked_modes() -> Array[GameConfig.GameMode]:
	return data.get("unlocked_modes", [GameConfig.GameMode.CLASSIC])

func get_unlocked_palettes() -> Array[ColorSet]:
	return ResourceDatabase.get_unlocked_color_sets(data.get("unlocked_palettes", ["mono"]))

func get_unlocked_maps() -> Array[Map]:
	return ResourceDatabase.get_unlocked_maps(data.get("unlocked_maps", ["forest"]))
#endregion

func reset_to_defaults():
	data = {
		"player_name": "Unnamed",
		"total_pages_collected": 0,
		"total_deaths": 0,
		"enemy_encounters": {},
		
		"unlocked_modes": [GameConfig.GameMode.CLASSIC],
		"unlocked_scenarios": ["basics1"],
		"unlocked_characters": ["default"],
		"unlocked_palettes": ["mono"],
		"unlocked_maps": ["forest"]
	}
	SaveManager.save_game()
