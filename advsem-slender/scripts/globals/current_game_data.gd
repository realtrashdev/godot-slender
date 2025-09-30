extends Node

#region Game Mode
enum GameMode { CLASSIC, SHORT_CLASSIC, ENDLESS, CUSTOM }
var game_mode: GameMode
#endregion

#region Pages
var total_pages_collected: int = 0
var current_pages_collected: int = 0

var current_pages_required: int = 3
var current_extra_pages: int = 10
# how many pages can be generated maximum -> set by page_manager.gd at the start of the map
var current_max_pages: int = -1
#endregion

#region Lives
var default_lives: int
var lives_remaining: int
#endregion

func set_starter_defaults():
	match game_mode:
		GameMode.CLASSIC:
			current_pages_required = 8
			current_extra_pages = 1
		GameMode.SHORT_CLASSIC:
			current_pages_required = 4
			current_extra_pages = 2
		GameMode.ENDLESS:
			current_pages_required = 3
			current_extra_pages = 2

func clear_data():
	total_pages_collected = 0
	current_pages_collected = 0

func get_page_gen_amount():
	var amount = current_pages_required + current_extra_pages
	# prevents trying to generate more pages than the map has locations
	if amount > current_max_pages:
		return current_max_pages
	return amount
