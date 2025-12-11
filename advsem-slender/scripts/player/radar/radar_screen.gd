class_name RadarScreen extends Node2D

enum ScreenState { OFF, IDLE, ACTIVE, RINGING }

@export var all_screens: Array[Node]

var game_state: GameState
var player: CharacterBody3D

var focused: bool = false

@onready var battery_component: Node = $BatteryComponent
const BatteryComponent = preload("uid://bl7j83h5ylc5h")
@onready var audio_component: Node = $AudioComponent
const AudioComponent = preload("uid://0xwcev5ljsb1")

@onready var base_screen: Sprite2D = $BaseScreen
@onready var home_screen: Node2D = $HomeScreen
@onready var tracker_screen: Node2D = $TrackerScreen
@onready var help_screen: Node2D = $HelpScreen
@onready var incoming_call_screen: Node2D = $IncomingCallScreen
@onready var dead_battery_screen: Node2D = $DeadBatteryScreen
@onready var battery_container: HBoxContainer = $BaseScreen/BatteryContainer

func initialize(state: GameState, play: CharacterBody3D):
	game_state = state
	player = play
	
	tracker_screen.player = player
	help_screen.get_help_text()
	
	battery_component.initialize(battery_container)
	
	_connect_signals()

func _process(delta: float) -> void:
	audio_component.update(battery_component.get_battery_remaining())
	battery_component.update(delta, get_screen_state())

# Public methods
func activate():
	audio_component.activate()
	battery_component.activate()

func deactivate():
	audio_component.deactivate()
	battery_component.deactivate()

func call_started():
	audio_component.play_ringtone()

func call_ended():
	audio_component.stop_ringtone()
	if get_battery_state() != BatteryComponent.BatteryState.DEAD:
		audio_component.play_notification()

func get_battery_state() -> BatteryComponent.BatteryState:
	return battery_component.get_battery_state()

func get_screen_state() -> ScreenState:
	if battery_component.dead:
		return ScreenState.OFF
	elif incoming_call_screen.visible:
		return ScreenState.RINGING
	elif focused:
		return ScreenState.ACTIVE
	else:
		return ScreenState.IDLE

# Private methods
func _reset_screens():
	for screen in all_screens:
		screen.visible = false
	tracker_screen.visible = true

# Radar signals
func _on_home_button_pressed() -> void:
	home_screen.visible = true
	tracker_screen.visible = false
	help_screen.visible = false
	audio_component.play_notification()

func _on_page_button_pressed() -> void:
	home_screen.visible = false
	tracker_screen.visible = true
	help_screen.visible = false
	audio_component.play_notification()

func _on_help_button_pressed() -> void:
	home_screen.visible = false
	tracker_screen.visible = false
	help_screen.visible = true
	audio_component.play_notification()

# Global signals
func _connect_signals():
	Signals.game_finished.connect(_on_game_finished)
	Signals.tutorial_distance_reached.connect(_on_tutorial_distance_reached)
	
	battery_component.out_of_battery.connect(_on_out_of_battery)
	battery_component.charged.connect(_on_battery_charged)

func _on_game_finished():
	_reset_screens()

func _on_tutorial_distance_reached() -> void:
	audio_component.play_notification()

func _on_battery_charged():
	if dead_battery_screen.visible:
		dead_battery_screen.visible = false
		audio_component.play_notification()

func _on_out_of_battery():
	dead_battery_screen.visible = true
	if incoming_call_screen.visible:
		incoming_call_screen.visible = false
