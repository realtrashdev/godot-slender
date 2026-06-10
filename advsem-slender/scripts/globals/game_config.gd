extends Node

enum GameMode { CLASSIC, ENDLESS, CUSTOM }

const MODE_CONFIG = {
	GameMode.CLASSIC: {
		"description": "Collect the amount pages specified, and then the game ends.\nEnemies are determined by the challenge you choose.",
	},
	GameMode.ENDLESS: {
		"description": "Collect an increasing amount of specified pages.\nVisit the shop to buy things, then add more threats.\nKeep going until you lose all your lives!",
	}
}

func get_mode_description(mode: GameMode) -> String:
	return MODE_CONFIG[mode]["description"]
