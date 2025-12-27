class_name GameState extends RefCounted

var game_mode: GameConfig.GameMode = GameConfig.GameMode.CLASSIC
var total_pages_collected: int = 0
var current_pages_collected: int = 0
var current_pages_required: int = 3
var current_extra_pages: int = 2
var current_max_pages: int = -1
var default_lives: int = 1
var lives_remaining: int = 1

func update_game_mode(mode: GameConfig.GameMode):
	game_mode = mode
	current_pages_required = GameConfig.get_default_pages_required(game_mode)
	current_extra_pages = GameConfig.get_default_extra_pages(game_mode)
	default_lives = GameConfig.get_default_lives(game_mode)
	lives_remaining = default_lives

func reset_level_data():
	current_pages_collected = 0

func clear_all_data():
	total_pages_collected = 0
	current_pages_collected = 0
	lives_remaining = default_lives

func get_page_gen_amount() -> int:
	var amount = current_pages_required + current_extra_pages
	if amount > current_max_pages:
		return current_max_pages
	return amount

# getters
func get_pages_collected() -> int:
	return current_pages_collected

func get_pages_required() -> int:
	return current_pages_required
