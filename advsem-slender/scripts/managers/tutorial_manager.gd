extends Node

var can_end: bool = false

@onready var game_manager: Node = $"../GameManager"
@onready var page_manager: PageSpawnManager = $"../PageManager"
@onready var audio_manager: AudioManager = $"../AudioManager"
@onready var ui_manager: UIManager = $"../UIManager"
@onready var sounds: AudioStreamPlayer = $Sounds
@onready var tutorial_end_ambient: AudioStreamPlayer3D = $"../TutorialEndAmbient"

func _ready() -> void:
	Signals.tutorial_distance_reached.connect(_on_tutorial_distance_reached)
	
	await get_tree().create_timer(5).timeout
	ui_manager.display_text("[wave][W][A][S][D] Move", 1, 3, 1)
	await get_tree().create_timer(10).timeout
	ui_manager.display_text("[wave][LSHIFT] Sprint", 1, 3, 1)
	await get_tree().create_timer(13).timeout
	sounds.play()
	await get_tree().create_timer(2).timeout
	ui_manager.display_text("[wave][F] Toggle Flashlight", 1, 3, 1)

func _input(event: InputEvent) -> void:
	#ATTENTION REMOVE, DEBUG
	if Input.is_action_just_pressed("jump"):
		return_to_menu()

func _on_tutorial_distance_reached():
	ui_manager.display_text("[wave][RCLICK] Toggle Tracker", 1, 3, 1)
	print("Tutorial Distance Reached")
	tutorial_end_ambient.play()
	can_end = true
	$"../CSGSphere3D".visible = true
	$"../CSGSphere3D/Area3D/CollisionShape3D".disabled = false

func _on_end_sphere_hit(body):
	if can_end:
		call_deferred("return_to_menu")

func return_to_menu():
	$"../Player".deactivate()
	$"../CSGSphere3D".visible = false
	$"../CSGSphere3D/Area3D/CollisionShape3D".disabled = true
	tutorial_end_ambient.stop()
	Progression.complete_scenario("tutorial")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://scenes/ui/menus/menu_base.tscn")
