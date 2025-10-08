class_name UnlockHelper extends Node

## process multiple unlocks from a dictionary
static func process_unlocks(unlock_data: Dictionary) -> void:
	if unlock_data.is_empty():
		return
	
	if unlock_data.has("characters"):
		for char_id in unlock_data["characters"]:
			Progression.unlock_character(char_id)
			print("Unlocking %s" % char_id)
	
	if unlock_data.has("scenarios"):
		for scenario_id in unlock_data["scenarios"]:
			Progression.unlock_scenario(scenario_id)
			print("Unlocking %s" % scenario_id)
	
	if unlock_data.has("modes"):
		for mode_name in unlock_data["modes"]:
			unlock_mode_by_name(mode_name)
			print("Unlocking %s" % mode_name)
	
	if unlock_data.has("palettes"):
		for palette_id in unlock_data["palettes"]:
			Progression.unlock_palette(palette_id)
			print("Unlocking %s" % palette_id)

## Since game mode unlocks tracks enum, this is necessary
static func unlock_mode_by_name(mode_name: String) -> void:
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
	
	Progression.unlock_mode(mode)
