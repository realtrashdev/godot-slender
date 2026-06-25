extends Node

# Tutorial
@export var tutorial: bool = false

const ENDLESS_TRANSITION_SCENE: PackedScene = preload("uid://bvi40xtwfxw5k")
const CLASSIC_TRANSITION_SCENE: PackedScene = preload("uid://c3f6y28ur3tma")

var game_active: bool = false
var run_timer_active: bool = false
var run_timer: float

# References to managers
@onready var page_manager: PageSpawnManager = $"../PageManager"
@onready var enemy_manager: EnemySpawnManager
@onready var ui_manager: UIManager = $"../UIManager"
@onready var audio_manager: AudioManager = $"../AudioManager"
@onready var player: CharacterBody3D = $"../Player"
@onready var pause_menu: CanvasLayer = $"../PauseMenu"


func _ready() -> void:
	GameState.reset_level_data()
	call_deferred("initialize_game")
	connect_signals()
	print("Game Mode: %s" % GameState.game_mode)


func _process(delta: float) -> void:
	if run_timer_active:
		run_timer += delta
		ui_manager.update_speedrun_timer(run_timer)
	if Input.is_action_just_pressed("pause") and game_active and not tutorial:
		get_tree().paused = true
		pause_menu.pause_game()


func initialize_game():
	# init player
	player.initialize()
	
	# init managers
	page_manager.initialize()
	
	enemy_manager = EnemySpawnManager.new()
	enemy_manager.name = "EnemySpawnManager"
	enemy_manager.initialize(player)
	add_child(enemy_manager)
	
	# check for classic mode, if so, get scenario and set up
	if GameState.game_mode == GameConfig.GameMode.CLASSIC:
		ui_manager.scenario = load_classic_scenario()
		#GameState.current_pages_required = scenario.required_pages
		#GameState.current_extra_pages = scenario.total_pages - scenario.required_pages
	
	ui_manager.initialize()
	audio_manager.initialize()
	
	# first time start
	audio_manager.start_game_audio()
	if tutorial:
		await get_tree().create_timer(3).timeout
		start_game()
		return
	await get_tree().create_timer(6).timeout
	start_game()


func connect_signals():
	Signals.page_collected.connect(_on_page_collected)
	Signals.player_died.connect(_on_player_died)
	Signals.game_started.connect(_on_game_started)


func load_classic_scenario() -> ClassicModeScenario:
	return Settings.get_selected_scenario()


func start_game():
	# managers
	page_manager.generate_pages()
	audio_manager.start_game_audio()
	
	# player
	player.position = get_player_spawn_position()
	if tutorial:
		player.position = Vector3(0, 1, 0)
	player.activate()
	
	Signals.game_started.emit()
	game_active = true
	
	# timer
	# waits 1 second due to the start period where the player in not in control
	await get_tree().create_timer(1, false).timeout
	run_timer = 0.0
	run_timer_active = true


func finish_game(won: bool = true):
	# shut down
	print("Game Finished")
	run_timer_active = false
	player.deactivate()
	page_manager.clear_locations()
	enemy_manager.clear_all_enemies()
	enemy_manager.disable_all_spawners()
	enemy_manager.remove_enemy_type("shade")
	audio_manager.stop_game_audio()
	ui_manager.show_game_end()
	
	Signals.game_finished.emit()
	game_active = false
	
	if GameState.game_mode == GameConfig.GameMode.CLASSIC and GameState.current_pages_collected >= GameState.current_pages_required:
		# unlock stuff
		Progression.complete_scenario(load_classic_scenario().resource_name)
		print(load_classic_scenario().resource_name + " completed")
	
	if won:
		# handle next state
		await get_tree().create_timer(5, false).timeout
		transition_to_next_state()


func transition_to_next_state():
	match GameState.game_mode:
		GameConfig.GameMode.ENDLESS:
			GameState.set_pages_required(GameState.current_pages_required + 1)
			GameState.set_total_pages(GameState.current_total_pages + 1)
			GameState.rounds_complete += 1
			GameState.reset_level_data()
			get_tree().change_scene_to_packed(ENDLESS_TRANSITION_SCENE)
		GameConfig.GameMode.CLASSIC:
			get_tree().change_scene_to_packed(CLASSIC_TRANSITION_SCENE)


func get_player_spawn_position() -> Vector3:
	return Settings.get_selected_map().player_start_position


func _on_page_collected():
	if tutorial:
		return
	if GameState.current_pages_collected >= GameState.current_pages_required:
		finish_game(true)


func _on_player_died():
	finish_game(false)


func _on_game_started():
	if tutorial:
		return
	ui_manager.show_objective()
