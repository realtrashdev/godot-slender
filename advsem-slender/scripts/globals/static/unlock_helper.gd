class_name UnlockHelper extends Node

static func process_unlocks(unlock_data: Dictionary) -> void:
	if unlock_data.is_empty():
		return
	
	# Process characters
	if unlock_data.has("characters"):
		for char_id in unlock_data["characters"]:
			_unlock_character(char_id)
	
	# Process scenarios
	if unlock_data.has("scenarios"):
		for scenario_id in unlock_data["scenarios"]:
			_unlock_scenario(scenario_id)
	
	# Process game modes
	if unlock_data.has("modes"):
		for mode_name in unlock_data["modes"]:
			_unlock_mode(mode_name)
	
	# Process palettes
	if unlock_data.has("palettes"):
		for palette_id in unlock_data["palettes"]:
			_unlock_palette(palette_id)
	
	SaveManager.save_game()

static func _unlock_character(char_id: String) -> void:
	if not SaveManager.progression["unlocked_characters"].has(char_id):
		SaveManager.progression["unlocked_characters"].append(char_id)
		print("Unlocked character: " + char_id)

static func _unlock_scenario(scenario_id: String) -> void:
	if not SaveManager.progression["unlocked_scenarios"].has(scenario_id):
		SaveManager.progression["unlocked_scenarios"].append(scenario_id)
		print("Unlocked scenario: " + scenario_id)

static func _unlock_mode(mode_name: String) -> void:
	var mode: GameConfig.GameMode
	match mode_name.to_lower():
		"classic":
			mode = GameConfig.GameMode.CLASSIC
		"endless":
			mode = GameConfig.GameMode.ENDLESS
		"custom":
			mode = GameConfig.GameMode.CUSTOM
		_:
			push_warning("Unknown mode: " + mode_name)
			return
	
	if not SaveManager.progression["unlocked_modes"].has(mode):
		SaveManager.progression["unlocked_modes"].append(mode)
		print("Unlocked mode: " + mode_name)

static func _unlock_palette(palette_id: String) -> void:
	if not SaveManager.progression["unlocked_palettes"].has(palette_id):
		SaveManager.progression["unlocked_palettes"].append(palette_id)
		print("Unlocked palette: " + palette_id)
