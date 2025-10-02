extends Node

## Classic is akin to the first slender, so there's no extra pages, lives, etc.
enum GameMode { CLASSIC, SHORT_CLASSIC, ENDLESS, CUSTOM }

const MODE_CONFIG = {
	GameMode.CLASSIC: {
		"description": "Collect all eight pages, and then the game ends.\nThe shop is disabled and enemies are randomly selected.\n[shake](shop and random enemies not implemented)",
		"pages_required": 8,
		"extra_pages": 0,
		"default_lives": 1,
	},
	GameMode.SHORT_CLASSIC: {
		"pages_required": 4,
		"extra_pages": 0,
		"default_lives": 1,
	},
	GameMode.ENDLESS: {
		"description": "Collect an increasing amount of required pages.\nVisit the shop to add more threats and buy things.\nKeep going until you lose all your lives!\n[shake](lives and shop not implemented)",
		"pages_required": 3,
		"extra_pages": 2,
		"default_lives": 3,
	}
}

const MODE_ENEMY_POOLS = {
	GameMode.CLASSIC: [
		"res://resources/enemy_profiles/chaser_profile.tres",
		"res://resources/enemy_profiles/gum_profile.tres",
		# random selection from pool
	],
	GameMode.ENDLESS: [
		# all enemies available through shop
	]
}

func get_mode_description(mode: GameMode) -> String:
	return MODE_CONFIG[mode]["description"]

func get_default_pages_required(mode: GameMode) -> int:
	return MODE_CONFIG[mode]["pages_required"]

func get_default_extra_pages(mode: GameMode) -> int:
	return MODE_CONFIG[mode]["extra_pages"]
	
func get_default_lives(mode: GameMode) -> int:
	return MODE_CONFIG[mode]["default_lives"]

func get_enemy_profiles(mode: GameMode) -> Array[EnemyProfile]:
	var profiles: Array[EnemyProfile] = []
	for path in MODE_ENEMY_POOLS[mode]:
		profiles.append(load(path))
	return profiles
