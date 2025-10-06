class_name ResourceDatabase extends Node

static var CHARACTERS := {}
static var ENEMIES := {}
static var MAPS := {}
static var SCENARIOS := {}
static var COLORSETS := {}

static func _static_init() -> void:
	CHARACTERS = _load_resources_from_directory("res://resources/vessel_profiles/", "tres")
	ENEMIES = _load_resources_from_directory("res://resources/enemy_profiles/", "tres")
	MAPS = _load_resources_from_directory("res://resources/maps/", "tres")
	SCENARIOS = _load_resources_from_directory("res://resources/scenarios/", "tres")
	COLORSETS = _load_resources_from_directory("res://resources/color_sets/", "tres")

static func _load_resources_from_directory(path: String, extension: String) -> Dictionary:
	var resources := {}
	var dir := DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with("." + extension):
				# extract ID from filename (remove extension like .tscn)
				var id := file_name.get_basename()
				# remove prefixes
				id = id.replace("profile_", "").replace("scenario_", "").replace("map_", "").replace("colorset_", "")
				
				var resource_path := path + file_name
				resources[id] = load(resource_path)
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
	else:
		push_error("Failed to open directory: " + path)
	return resources

##
## CHARACTERS
##
static func get_characters(id: String) -> CharacterProfile:
	return CHARACTERS.get(id)

static func get_all_characters() -> Array[CharacterProfile]:
	var result: Array[CharacterProfile] = []
	result.assign(CHARACTERS.values())
	return result

static func get_unlocked_characters(unlocked_ids: Array) -> Array[CharacterProfile]:
	var result: Array[CharacterProfile] = []
	for id in unlocked_ids:
		if CHARACTERS.has(id):
			result.append(CHARACTERS[id])
	return result

##
## ENEMIES
##
static func get_enemy(id: String) -> CharacterProfile:
	return ENEMIES.get(id)

static func get_all_enemies() -> Array[CharacterProfile]:
	var result: Array[CharacterProfile] = []
	result.assign(ENEMIES.values())
	return result

static func get_unlocked_enemies(unlocked_ids: Array) -> Array[CharacterProfile]:
	var result: Array[CharacterProfile] = []
	for id in unlocked_ids:
		if ENEMIES.has(id):
			result.append(ENEMIES[id])
	return result

##
## MAPS
##
static func get_map(id: String) -> Map:
	return MAPS.get(id)

static func get_all_maps() -> Array[Map]:
	var result: Array[Map] = []
	result.assign(MAPS.values())
	return result

static func get_unlocked_maps(unlocked_ids: Array) -> Array[Map]:
	var result: Array[Map] = []
	for id in unlocked_ids:
		if MAPS.has(id):
			result.append(MAPS[id])
	return result

##
## SCENARIOS
##
static func get_scenario(id: String) -> ClassicModeScenario:
	print("Getting scenario: " + id)
	return SCENARIOS.get(id)

static func get_all_scenarios() -> Array[ClassicModeScenario]:
	var result: Array[ClassicModeScenario] = []
	result.assign(SCENARIOS.values())
	return result

static func get_unlocked_scenarios(unlocked_ids: Array) -> Array[ClassicModeScenario]:
	var result: Array[ClassicModeScenario] = []
	for id in unlocked_ids:
		if SCENARIOS.has(id):
			result.append(SCENARIOS[id])
	return result

##
## MAPS
##
static func get_color_set(id: String) -> ColorSet:
	return COLORSETS.get(id)

static func get_all_color_sets() -> Array[ColorSet]:
	var result: Array[ColorSet] = []
	result.assign(COLORSETS.values())
	return result

static func get_unlocked_color_sets(unlocked_ids: Array) -> Array[ColorSet]:
	var result: Array[ColorSet] = []
	for id in unlocked_ids:
		if COLORSETS.has(id):
			result.append(COLORSETS[id])
	return result
