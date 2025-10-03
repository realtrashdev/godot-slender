extends Node

var game_state: GameState

# References to managers
@onready var page_manager: PageSpawnManager = $"../PageManager"
@onready var enemy_manager: EnemySpawnManager
@onready var ui_manager: UIManager = $"../UIManager"
@onready var audio_manager: AudioManager = $"../AudioManager"
@onready var player: CharacterBody3D = $"../Player"

func _ready() -> void:
	call_deferred("initialize_game")
	connect_signals()

func initialize_game():
	# create game state
	game_state = GameState.new()
	game_state.update_game_mode(SaveManager.get_selected_game_mode())
	
	# init managers
	page_manager.initialize(game_state)
	
	enemy_manager = EnemySpawnManager.new()
	enemy_manager.name = "EnemySpawnManager"
	enemy_manager.initialize(game_state, player)
	add_child(enemy_manager)
	
	enemy_manager.add_enemy_spawner(
		preload("res://resources/enemy_profiles/chaser_profile.tres"), 1)
	enemy_manager.add_enemy_spawner(
		preload("res://resources/enemy_profiles/gum_profile.tres"), 2)
	
	ui_manager.initialize(game_state)
	audio_manager.initialize(game_state)
	
	# first time start
	audio_manager.start_game_audio()
	await get_tree().create_timer(6).timeout
	start_game()

func connect_signals():
	Signals.page_collected.connect(_on_page_collected)
	Signals.player_died.connect(_on_player_died)
	Signals.game_started.connect(_on_game_started)

func start_game():
	game_state.reset_level_data()
	
	# managers
	page_manager.generate_pages()
	audio_manager.start_game_audio()
	
	player.position = get_player_spawn_position()
	player.activate()
	
	Signals.game_started.emit()

func finish_game():
	# shut down
	player.deactivate()
	page_manager.clear_locations()
	enemy_manager.disable_all_spawners()
	enemy_manager.clear_all_enemies()
	audio_manager.stop_game_audio()
	ui_manager.show_game_end()
	
	# handle next state
	await get_tree().create_timer(5).timeout
	transition_to_next_state()

func transition_to_next_state():
	match game_state.game_mode:
		GameConfig.GameMode.ENDLESS:
			game_state.current_pages_required += 1
			start_game()
		_:
			get_tree().change_scene_to_file("res://scenes/ui/menus/menu_base.tscn")

func get_player_spawn_position() -> Vector3:
	# load from level data in the future
	return Vector3(-27.0, 1.0, 124.0)

# high-level event handlers
func _on_page_collected():
	if game_state.current_pages_collected >= game_state.current_pages_required:
		finish_game()

func _on_player_died():
	finish_game()

func _on_game_started():
	ui_manager.show_objective()
