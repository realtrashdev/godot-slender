@tool
class_name ResourceDatabase extends Node

static var CHARACTERS := {}
static var ENEMIES := {}
static var MAPS := {}
static var SCENARIOS := {}
static var COLORSETS := {}

static func _static_init() -> void:
	if Engine.is_editor_hint():
		# in editor it will scan and save to a manifest
		_scan_and_save_manifest()
	
	# in both editor and build it can load from the saved manifest
	# Swag
	_load_from_saved_manifest()

static func _scan_and_save_manifest() -> void:
	var manifest := {
		"characters": _scan_directory("res://resources/vessel_profiles/", "tres"),
		"enemies": _scan_directory("res://resources/enemy_profiles/", "tres"),
		"maps": _scan_directory("res://resources/maps/", "tres"),
		"scenarios": _scan_directory("res://resources/scenarios/", "tres"),
		"colorsets": _scan_directory("res://resources/color_sets/", "tres"),
	}
	
	# Save as JSON file
	var file := FileAccess.open("res://resources/resource_manifest.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(manifest, "\t"))
		file.close()

static func _scan_directory(path: String, extension: String) -> Array:
	var file_paths := []
	var dir := DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with("." + extension):
				file_paths.append(path + file_name)
			file_name = dir.get_next()
		
		dir.list_dir_end()
	
	return file_paths

static func _load_from_saved_manifest() -> void:
	var file := FileAccess.open("res://resources/resource_manifest.json", FileAccess.READ)
	if not file:
		push_error("Resource manifest not found!")
		return
	
	var json := JSON.new()
	var parse_result := json.parse(file.get_as_text())
	file.close()
	
	if parse_result != OK:
		push_error("Failed to parse resource manifest!")
		return
	
	var manifest = json.data
	CHARACTERS = _load_resources_from_paths(manifest.get("characters", []))
	ENEMIES = _load_resources_from_paths(manifest.get("enemies", []))
	MAPS = _load_resources_from_paths(manifest.get("maps", []))
	SCENARIOS = _load_resources_from_paths(manifest.get("scenarios", []))
	COLORSETS = _load_resources_from_paths(manifest.get("colorsets", []))

static func _load_resources_from_paths(paths: Array) -> Dictionary:
	var resources := {}
	for path in paths:
		var resource = load(path)
		if resource:
			# Extract just the filename without path or extension
			var file_name: String = path.get_file()  # "map_tutorial.tres"
			var id: String = file_name.get_basename()  # "map_tutorial"
			# Remove prefixes
			id = id.replace("profile_", "").replace("scenario_", "").replace("map_", "").replace("colorset_", "")
			resources[id] = resource
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
