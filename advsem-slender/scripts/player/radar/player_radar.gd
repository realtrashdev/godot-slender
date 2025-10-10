class_name PlayerRadar extends Node3D

signal radar_toggled(bool)

const OUT_POS: Vector3 = Vector3(0, 0, -0.5)
const OUT_ROT: Vector3 = Vector3(deg_to_rad(-45), 0, 0)

const AWAY_POS: Vector3 = Vector3(0, -0.25, 1.25)
const AWAY_ROT: Vector3 = Vector3(0, 0, deg_to_rad(30))

var game_state: GameState

var active: bool = false
var can_toggle: bool = true
var focused: bool = false

var pos_tween: Tween

var player: CharacterBody3D
var restriction_component: PlayerRestrictionComponent

@onready var audio: AudioStreamPlayer = $RadarAudio
@onready var display_component: RadarDisplayComponent = $RadarDisplayComponent
@onready var input_component: RadarInputComponent = $RadarInputComponent
@onready var radar_screen: RadarScreen = $SubViewport/RadarScreen

func _ready() -> void:
	player = get_parent()
	restriction_component = player.get_node("RestrictionComponent")
	
	# Optional: Connect to input component signals
	input_component.screen_clicked.connect(_on_screen_clicked)
	
	# Start with input disabled
	input_component.set_enabled(false)
	
	radar_screen.initialize(game_state, player)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_radar") and can_toggle and active:
		can_toggle = false
		toggle_radar()
		await get_tree().create_timer(0.5).timeout
		can_toggle = true

func toggle_radar():
	# Disable input IMMEDIATELY when toggling
	input_component.set_enabled(false)
	
	match restriction_component.check_for_restriction(PlayerRestriction.RestrictionType.RADAR):
		true:
			focused = false
			restriction_component.remove_restrictions_from_source("player_radar")
			update_audio()
			update_position()
		false:
			focused = true
			restriction_component.add_restriction(PlayerRestriction.RestrictionType.RADAR, "player_radar")
			update_audio()
			update_position()
	
	radar_toggled.emit(focused)

func update_position():
	var final_pos: Vector3
	var final_rot: Vector3
	match focused:
		true:
			final_pos = OUT_POS
			final_rot = OUT_ROT
		false:
			final_pos = AWAY_POS
			final_rot = AWAY_ROT
			final_pos.x += randf_range(-0.25, 0.25)
	
	if pos_tween:
		pos_tween.kill()
	pos_tween = create_tween()
	
	pos_tween.tween_property(self, "position", final_pos, 0.25)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	pos_tween.parallel().tween_property(self, "rotation", final_rot, 0.5)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	# re enable input AFTER animation completes, but ONLY if focused
	pos_tween.finished.connect(func():
		if focused:
			input_component.set_enabled(true)
	, CONNECT_ONE_SHOT)

func update_audio():
	var bus = AudioServer.get_bus_index("PlayerRadar")
	AudioServer.set_bus_effect_enabled(bus, 0, !focused)
	
	match focused:
		true:
			audio.volume_db += 5
		false:
			audio.volume_db -= 5

func activate():
	active = true
	update_position()

func deactivate():
	active = false
	update_position()

# Content management methods
func load_screen(scene_path: String):
	display_component.load_content(scene_path)

func _on_screen_clicked(pos: Vector2):
	print("Screen clicked at: ", pos)
	# Handle screen interactions here
