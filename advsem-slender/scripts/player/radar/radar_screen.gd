class_name RadarScreen extends Node2D

var game_state: GameState
var player: CharacterBody3D

@onready var battery_component: Node = $BatteryComponent
@onready var audio_component: Node = $AudioComponent

@onready var base_screen: Sprite2D = $BaseScreen
@onready var home_screen: Node2D = $HomeScreen
@onready var tracker_screen: Node2D = $TrackerScreen
@onready var help_screen: Node2D = $HelpScreen
@onready var incoming_call_screen: Node2D = $IncomingCallScreen
@onready var battery_container: HBoxContainer = $BaseScreen/BatteryContainer

func initialize(state: GameState, play: CharacterBody3D):
	game_state = state
	player = play
	
	tracker_screen.player = player
	help_screen.get_help_text()

func _connect_signals():
	Signals.game_finished.connect(_on_game_finished)
	Signals.tutorial_distance_reached.connect(_on_tutorial_distance_reached)

func _on_game_finished():
	audio_component.stop_ringtone()

func call_started():
	audio_component.play_ringtone()

func call_ended():
	audio_component.stop_ringtone()

func _on_home_button_pressed() -> void:
	home_screen.visible = true
	tracker_screen.visible = false
	help_screen.visible = false

func _on_page_button_pressed() -> void:
	home_screen.visible = false
	tracker_screen.visible = true
	help_screen.visible = false

func _on_help_button_pressed() -> void:
	home_screen.visible = false
	tracker_screen.visible = false
	help_screen.visible = true

func _on_tutorial_distance_reached() -> void:
	audio_component.play_notification()
