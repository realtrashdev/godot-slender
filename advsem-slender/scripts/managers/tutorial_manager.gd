extends Node

const BRANCH_SNAP_1 = preload("uid://doem1b4tccvqn")

@onready var game_manager: Node = $"../GameManager"
@onready var page_manager: PageSpawnManager = $"../PageManager"
@onready var audio_manager: AudioManager = $"../AudioManager"
@onready var ui_manager: UIManager = $"../UIManager"
@onready var sounds: AudioStreamPlayer = $Sounds

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	ui_manager.display_text("[wave][W][A][S][D] Move", 1, 3, 1)
	await get_tree().create_timer(10).timeout
	ui_manager.display_text("[wave][LSHIFT] Sprint", 1, 3, 1)
	await get_tree().create_timer(10).timeout
	sounds.play()
	await get_tree().create_timer(2).timeout
	ui_manager.display_text("[wave][F] Toggle Flashlight", 1, 3, 1)
