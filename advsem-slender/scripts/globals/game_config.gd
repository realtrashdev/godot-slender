extends Node

## Classic is akin to the first slender, so there's no extra pages, lives, etc.
enum GameMode { CLASSIC, ENDLESS, CUSTOM }

const MODE_CONFIG = {
	GameMode.CLASSIC: {
		"description": "Collect all eight pages, and then the game ends.\nEnemies are determined by the scenario you choose.",
		"pages_required": 8,
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

const DEFAULT_CHARACTER = "default"
const DEFAULT_PALETTE = "mono"

func get_mode_description(mode: GameMode) -> String:
	return MODE_CONFIG[mode]["description"]

func get_default_pages_required(mode: GameMode) -> int:
	return MODE_CONFIG[mode]["pages_required"]

func get_default_extra_pages(mode: GameMode) -> int:
	return MODE_CONFIG[mode]["extra_pages"]
	
func get_default_lives(mode: GameMode) -> int:
	return MODE_CONFIG[mode]["default_lives"]
