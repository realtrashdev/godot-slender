class_name RadarScreen extends Node2D

var game_state: GameState
var player: CharacterBody3D

@onready var battery_component: Node = $BatteryComponent
@onready var audio_component: Node = $AudioComponent

@onready var base_screen: Sprite2D = $BaseScreen
@onready var battery_container: HBoxContainer = $BaseScreen/BatteryContainer
@onready var audio: AudioStreamPlayer = $AudioComponent/RadarAudio

func initialize(state: GameState, play: CharacterBody3D):
	game_state = state
	player = play
