class_name TipManager extends RefCounted

const RARE_TIP_CHANCE: int = 50

var game_tips: Array[String] = [
	"Some enemies require you to act to get rid of them.",
	"You are slower in the grass.",
	"The path will guide your way.",
	"Pay attention to the brightness of your light.",
	"Consider checking your surroundings before taking a page.",
	"Watch the battery of your tracker carefully.",
]

var rare_game_tips: Array[String] = [
	"Toby is a really awesome cat and he is cool.",
	"Swag Swag Swag Swag Swag",
	"Actually, never mind. You don't care anyway.",
	"Try typing something out in the main menu, you might find a secret!"
]

func get_random_tip() -> String:
	if randi_range(1, RARE_TIP_CHANCE) == RARE_TIP_CHANCE:
		return rare_game_tips.pick_random()
	return game_tips.pick_random()
