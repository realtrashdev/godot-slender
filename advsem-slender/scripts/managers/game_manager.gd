extends Node

var game_state: GameState

# References to managers
@onready var page_manager: PageSpawnManager = $"../PageManager"
@onready var enemy_manager: EnemySpawnManager
@onready var scenario_manager: ScenarioManager
@onready var ui_manager: UIManager = $"../UIManager"
@onready var audio_manager: AudioManager = $"../AudioManager"
@onready var player: CharacterBody3D = $"../Player"

func _ready() -> void:
	call_deferred("initialize_game")
	connect_signals()

func initialize_game():
	# create game state
	game_state = GameState.new()
	game_state.update_game_mode(Settings.get_selected_game_mode())
	
	# init player
	player.initialize(game_state)
	
	# init managers
	page_manager.initialize(game_state)
	
	enemy_manager = EnemySpawnManager.new()
	enemy_manager.name = "EnemySpawnManager"
	enemy_manager.initialize(game_state, player)
	add_child(enemy_manager)
	
	# check for classic mode, if so, get scenario and set up
	if game_state.game_mode == GameConfig.GameMode.CLASSIC:
		scenario_manager = ScenarioManager.new()
		scenario_manager.name = "ScenarioManager"
		add_child(scenario_manager)
		
		var scenario = load_classic_scenario()
		scenario_manager.initialize(enemy_manager, scenario)
		ui_manager.scenario = scenario
		game_state.current_pages_required = scenario.required_pages
		game_state.current_extra_pages = scenario.total_pages - scenario.required_pages
	
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

func load_classic_scenario() -> ClassicModeScenario:
	return Settings.get_selected_scenario()

func start_game():
	game_state.reset_level_data()
	
	# managers
	page_manager.generate_pages()
	audio_manager.start_game_audio()
	
	# player
	player.position = get_player_spawn_position()
	player.activate()
	
	Signals.game_started.emit()

func finish_game():
	# shut down
	print("Game Finished")
	player.deactivate()
	page_manager.clear_locations()
	enemy_manager.clear_all_enemies()
	enemy_manager.disable_all_spawners()
	audio_manager.stop_game_audio()
	ui_manager.show_game_end()
	
	if game_state.game_mode == GameConfig.GameMode.CLASSIC and game_state.current_pages_collected >= game_state.current_pages_required:
		# unlocks stuff
		Progression.complete_scenario(load_classic_scenario().resource_name)
		print(load_classic_scenario().resource_name + " completed")
	
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
