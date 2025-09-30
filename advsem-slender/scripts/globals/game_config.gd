extends Node

enum GameMode { CLASSIC, SHORT_CLASSIC, ENDLESS, CUSTOM }

const MODE_CONFIG = {
	GameMode.CLASSIC: {
		"description": "Collect all eight pages, and then the game ends.\nThe shop is disabled and enemies are randomly selected.\n[shake](shop and random enemies not implemented)",
		"pages_required": 8,
		"extra_pages": 1,
		"default_lives": 1,
	},
	GameMode.SHORT_CLASSIC: {
		"pages_required": 4,
		"extra_pages": 2,
		"default_lives": 1,
	},
	GameMode.ENDLESS: {
		"description": "Collect an increasing amount of required pages.\nVisit the shop to add more threats and buy things.\nKeep going until you lose all your lives!\n[shake](lives and shop not implemented)",
		"pages_required": 3,
		"extra_pages": 2,
		"default_lives": 3,
	}
}

func get_default_pages_required(mode: GameMode) -> int:
	return MODE_CONFIG[mode]["pages_required"]

func get_default_extra_pages(mode: GameMode) -> int:
	return MODE_CONFIG[mode]["extra_pages"]
	
func get_default_lives(mode: GameMode) -> int:
	return MODE_CONFIG[mode]["default_lives"]

func get_mode_description(mode: GameMode = CurrentGameData.game_mode) -> String:
	return MODE_CONFIG[mode]["description"]
