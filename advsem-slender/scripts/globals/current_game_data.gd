extends Node

#region Game Mode
var game_mode: GameConfig.GameMode = GameConfig.GameMode.CLASSIC
#endregion

#region Pages
var total_pages_collected: int = 0
var current_pages_collected: int = 0

var current_pages_required: int = 3
var current_extra_pages: int = 2
# how many pages can be generated maximum -> set by page_manager.gd at the start of the map
var current_max_pages: int = -1
#endregion

#region Enemies
var danger_level: int = 0
#endregion

#region Lives
var default_lives: int
var lives_remaining: int
#endregion

func update_game_mode(mode: GameConfig.GameMode):
	game_mode = mode
	current_pages_required = GameConfig.get_default_pages_required(game_mode)
	current_extra_pages = GameConfig.get_default_pages_required(game_mode)
	default_lives = GameConfig.get_default_lives(game_mode)

func reset_level_data():
	current_pages_collected = 0

func clear_all_data():
	total_pages_collected = 0
	current_pages_collected = 0
	lives_remaining = GameConfig.get_default_lives(game_mode)

func get_page_gen_amount():
	var amount = current_pages_required + current_extra_pages
	# prevents trying to generate more pages than the map has locations
	if amount > current_max_pages:
		return current_max_pages
	return amount
