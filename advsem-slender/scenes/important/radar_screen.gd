class_name RadarScreen extends Node2D

var game_state: GameState
var player: CharacterBody3D

func initialize(state: GameState, play: CharacterBody3D):
	game_state = state
	player = play
