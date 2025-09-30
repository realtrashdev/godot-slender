extends Node3D

#region Tips
# 1 / this chance of getting a rare tip.
const RARE_TIP_CHANCE: int = 50

var game_tips: Array[String] = [
	"Your light is attracted to important things.",
	"Some enemies require you to fight back.",
	# trauma
	"You are slower in the grass.",
	"The path will guide your way.",
	"You can still see around yourself without your light on.",
	"Some enemies are harmless until bad timing from them gets you killed.",
	#"Pay attention to the brightness of your light.",
	#"Most of them come from the woods."
]

var rare_game_tips: Array[String] = [
	"Toby is a really awesome cat and he is cool.",
	"Swag Swag Swag Swag Swag",
	"Actually, never mind. You don't care anyway."
]
#endregion

#region Player
const PLAYER_SPAWN: Vector3 = Vector3(-27.0, 1.0, 124.0)
#endregion

#region Pages
const DEFAULT_PAGES_REQUIRED: int = 3
const FIRST_PAGE_TIME_LIMIT: float = 90.0
#endregion

#region @onready
@onready var player: CharacterBody3D = $Player
@onready var page_spawn_manager: PageSpawnManager = $PageSpawnManager
@onready var enemy_spawn_manager: EnemySpawnManager
@onready var ambience: AudioStreamPlayer = $Ambient
@onready var game_ui: CanvasLayer = $InGameUI
@onready var collection_ambience: Node = $CollectionAmbient
#endregion

func _ready() -> void:
	Signals.page_collected.connect(on_page_collected)
	
	enemy_spawn_manager = EnemySpawnManager.new()
	enemy_spawn_manager.name = "EnemySpawnerManager"
	add_child(enemy_spawn_manager)
	
	## temp, ideally should add these via:
	## function that adds based off game mode (for classic/custom mode)
	## shop when implemented
	enemy_spawn_manager.add_enemy_spawner(preload("res://resources/enemy_profiles/chaser_profile.tres"), 1)
	enemy_spawn_manager.add_enemy_spawner(preload("res://resources/enemy_profiles/gum_profile.tres"), 2)
	
	first_start_game()

func first_start_game():
	ambience.volume_db = -30
	ambience.play()
	ambience.set_volume_smooth(ambience.default_volume, 1)
	
	await get_tree().create_timer(1).timeout
	$FenceClimbAudio.play()
	game_ui.display_text("[wave]Tip:\n" + get_game_tip(), 1, 5, 0)
	
	await get_tree().create_timer(5).timeout
	start_game()

func start_game():
	if not ambience.playing:
		ambience.volume_db = -30
		ambience.play()
		ambience.set_volume_smooth(ambience.default_volume, 1)
	
	CurrentGameData.current_pages_collected = 0
	page_spawn_manager.generate_pages()
	
	player.position = PLAYER_SPAWN
	player.activate()
	
	taking_too_long()
	
	await get_tree().create_timer(1).timeout
	game_ui.display_text("[wave]Collect all " + str(CurrentGameData.current_pages_required) + " pages", 1, 3, 1)

func finish_game():
	player.deactivate()
	page_spawn_manager.clear_locations()
	enemy_spawn_manager.disable_all_spawners()
	enemy_spawn_manager.clear_all_enemies()
	ambience.stop()
	collection_ambience.on_game_finished()
	
	# For now
	CurrentGameData.current_pages_required += 1
	await get_tree().create_timer(5).timeout
	start_game()

func taking_too_long():
	var pages: int = CurrentGameData.total_pages_collected
	await get_tree().create_timer(FIRST_PAGE_TIME_LIMIT).timeout
	if CurrentGameData.total_pages_collected == pages:
		enemy_spawn_manager.taking_too_long()
		game_ui.taking_too_long()
		collection_ambience.taking_too_long()

func get_game_tip():
	var rand = randi_range(1, RARE_TIP_CHANCE)
	if rand == RARE_TIP_CHANCE:
		return rare_game_tips[randi_range(0, rare_game_tips.size() - 1)]
	else:
		return game_tips[randi_range(0, game_tips.size() - 1)]

func on_page_collected():
	print("Pages: " + str(CurrentGameData.current_pages_collected) + "/" + str(CurrentGameData.current_pages_required))
	if CurrentGameData.current_pages_collected == CurrentGameData.current_pages_required:
		finish_game()
