class_name CharacterDatabase
extends Node

const CHARACTERS = {
	"default": preload("uid://cnr7vp5lbi17t"),
	"dragon": preload("uid://ocwen38ehm68"),
}

const ENEMIES = {
	"chaser": preload("uid://5btde08a1exu"),
	"gum": preload("uid://ceka8pclkwv8e"),
	"eyes": preload("uid://bepy1x4bj1nga"),
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
