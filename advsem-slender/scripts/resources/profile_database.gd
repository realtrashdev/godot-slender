class_name CharacterDatabase extends Node

const CHARACTERS = {
	"default": preload("res://resources/vessel_profiles/default_profile.tres"),
	"dragon": preload("res://resources/vessel_profiles/dragon_profile.tres"),
}

const ENEMIES = {
	"chaser": preload("res://resources/enemy_profiles/chaser_profile.tres"),
	"gum": preload("res://resources/enemy_profiles/gum_profile.tres"),
	"eyes": preload("res://resources/enemy_profiles/eyes_profile.tres"),
}

static func get_characters(id: String) -> VesselProfile:
	return CHARACTERS.get(id)

static func get_all_characters() -> Array[VesselProfile]:
	return CHARACTERS.values()

static func get_unlocked_characters(unlocked_ids: Array) -> Array[VesselProfile]:
	var result: Array[VesselProfile] = []
	for id in unlocked_ids:
		if CHARACTERS.has(id):
			result.append(CHARACTERS[id])
	return result

static func get_enemy(id: String) -> EnemyProfile:
	return ENEMIES.get(id)

static func get_all_enemies() -> Array[EnemyProfile]:
	return ENEMIES.values()

static func get_unlocked_enemies(unlocked_ids: Array) -> Array[EnemyProfile]:
	var result: Array[EnemyProfile] = []
	for id in unlocked_ids:
		if ENEMIES.has(id):
			result.append(ENEMIES[id])
	return result

# debug
static func test_preload():
	var default_char = preload("res://resources/vessel_profiles/default_profile.tres")
	print("Preloaded type: ", default_char.get_class())
	print("Has script: ", default_char.get_script() != null)
	print("Script path: ", default_char.get_script())
	print("Has icon property: ", "icon" in default_char)
	
	# Try manually loading instead
	var manual_load = load("res://resources/vessel_profiles/default_profile.tres")
	print("\nManual load type: ", manual_load.get_class())
	print("Manual has script: ", manual_load.get_script() != null)
	print("Manual has icon: ", "icon" in manual_load)
