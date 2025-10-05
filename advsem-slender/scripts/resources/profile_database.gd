class_name CharacterDatabase
extends Node

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
