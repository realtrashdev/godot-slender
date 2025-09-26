extends Node3D

var game_tips: Array[String] = [
	"You are slower in the grass.",
	"Your light is attracted to important things.",
	"Some enemies require you to fight back.",
	"The path will guide your way.",
	"You can still see around yourself without your light on.",
	"Pay attention to the brightness of your light.",
	"Most of them come from the woods."
]

var rare_game_tips: Array[String] = [
	"Toby is a really awesome cat and he is cool.",
	"Swag Swag Swag Swag Swag :]",
	"Actually, never mind. You don't care anyway."
]

# Player
const PLAYER_SPAWN: Vector3 = Vector3(-27.0, 1.0, 124.0)

# Pages
const DEFAULT_PAGES_REQUIRED: int = 3
const FIRST_PAGE_TIME_LIMIT: float = 90.0

var total_pages_collected: int

var pages_collected: int

@onready var player: CharacterBody3D = $Player
@onready var page_spawn_manager: Node3D = $PageSpawnManager
@onready var enemy_spawners: Node3D = $EnemySpawners
@onready var ambience: AudioStreamPlayer = $Ambient
@onready var game_ui: CanvasLayer = $InGameUI
@onready var collection_ambience: Node3D = $CollectionAmbient

func _ready() -> void:
	Signals.page_collected.connect(page_collected)
	first_start_game()

func first_start_game():
	player.position = PLAYER_SPAWN
	ambience.volume_db = -50
	ambience.play()
	ambience.set_volume_smooth(ambience.default_volume, 2)
	await get_tree().create_timer(1).timeout
	
	$FenceClimbAudio.play()
	game_ui.display_text_smooth("[wave]Tip:\n" + get_game_tip(), 1, 0, 5)
	await get_tree().create_timer(5).timeout
	
	taking_too_long()
	player.activate()
	await get_tree().create_timer(1).timeout
	
	game_ui.display_text_smooth("[wave]Collect all 8 pages", 1, 1, 3)

func start_game():
	player.position = PLAYER_SPAWN
	pages_collected = 0
	ambience.volume_db = -50
	ambience.play()
	ambience.set_volume_smooth(ambience.default_volume, 3)
	await get_tree().create_timer(1).timeout
	
	taking_too_long()
	player.activate()

func finish_game():
	pass

func page_collected():
	pages_collected += 1
	total_pages_collected += 1

func taking_too_long():
	await get_tree().create_timer(FIRST_PAGE_TIME_LIMIT).timeout
	if pages_collected == 0:
		enemy_spawners.taking_too_long()
		game_ui.taking_too_long()
		collection_ambience.taking_too_long()

func get_game_tip():
	var rand = randi_range(1, 50)
	if rand == 50:
		return rare_game_tips[randi_range(0, rare_game_tips.size() - 1)]
	else:
		return game_tips[randi_range(0, game_tips.size() - 1)]
