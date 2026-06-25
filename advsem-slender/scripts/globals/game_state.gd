extends Node

var game_mode: GameConfig.GameMode
var stats: PlayerStats = PlayerStats.new()
var enemy_list: Dictionary[int, EnemyProfileList]

var total_pages_collected: int = 0
var current_pages_collected: int = 0
var current_pages_required: int = 0
var current_total_pages: int = 0
var current_max_pages: int = 0

# Endless
var difficulty: int = 0
var lives_remaining: int = 3
var money: float = 0.00
var rounds_complete: int = 0
var enemy_choices: int = 3
var required_enemy_selections: int = 1


func _ready() -> void:
	game_mode = Settings.get_selected_game_mode()
	reset_game_data()
	#print("required: %s, max: %s, total: %s" % [current_pages_required, current_max_pages, current_total_pages])


func update_game_mode(mode: GameConfig.GameMode):
	clear_all_data()
	game_mode = mode


func update_endless_difficulty():
	# increase required pages, decrease generated pages, lives, etc.
	# Balatro stake style
	pass


## Should only be called right before the game starts.
func reset_game_data():
	stats = Settings.get_selected_character().stats
	total_pages_collected = 0
	current_pages_collected = 0
	
	if game_mode == GameConfig.GameMode.CLASSIC:
		var scen: ClassicModeScenario = Settings.get_selected_scenario()
		current_pages_required = scen.required_pages
		current_total_pages = scen.total_pages
		enemy_list = scen.enemies_to_add
	elif game_mode == GameConfig.GameMode.ENDLESS:
		current_pages_required = 3
		current_total_pages = 5
		lives_remaining = stats.starting_lives
		rounds_complete = 0
		enemy_choices = 3
		required_enemy_selections = 1
		enemy_list = {}
	
	# Set by PageManager when it gets all PageLocations
	current_max_pages = -1


func reset_level_data():
	print("reset level data")
	current_pages_collected = 0


func clear_all_data():
	total_pages_collected = 0
	current_pages_collected = 0
	lives_remaining = 0
	rounds_complete = 0


func get_page_gen_amount() -> int:
	var amount = current_total_pages
	if amount > current_max_pages:
		return current_max_pages
	return amount


func get_pages_collected() -> int:
	return current_pages_collected


func get_pages_required() -> int:
	return current_pages_required


func set_pages_required(req: int):
	current_pages_required = req
	if current_pages_required > current_max_pages:
		current_pages_required = current_max_pages


func get_total_pages() -> int:
	return current_total_pages


func set_total_pages(tot: int):
	current_total_pages = tot
	if current_total_pages > current_max_pages:
		current_total_pages = current_max_pages


#region Stats
func get_walk_speed() -> float:
	# Will need to account for in-game item variation later
	return stats.walk_speed # _get_item_effect(ItemEffect.Stat.WALK_SPEED)


func get_run_speed() -> float:
	return stats.run_speed


func get_light_brightness() -> float:
	return stats.light_brightness


func get_battery_chunks() -> int:
	return stats.battery_chunks
#endregion

#region Enemy List
func get_enemy_list() -> Dictionary[int, EnemyProfileList]:
	return enemy_list


func set_enemy_list(new_list: Dictionary[int, EnemyProfileList]):
	enemy_list = new_list


func add_enemy_to_list(page_count: int, enemy: EnemyProfile):
	if not enemy_list.has(page_count):
		enemy_list[page_count] = EnemyProfileList.new()
	enemy_list[page_count].profiles.append(enemy)
	print("Enemy added to enemy_list: %s at page_count %s" % [enemy.name, page_count])
#endregion

#region Items
func add_item_to_inventory():
	# Insta apply things like stat changes, etc.
	pass
#endregion
