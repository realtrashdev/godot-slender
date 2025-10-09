class_name PlayerRadar extends Node3D

signal radar_toggled(bool)

const OUT_POS: Vector3 = Vector3(0, 0, -0.5)
const AWAY_POS: Vector3 = Vector3(0, -0.25, 0.75)

var active: bool = false
var can_toggle: bool = true
var focused: bool = false

var pos_tween: Tween

var player: CharacterBody3D
var restriction_component: PlayerRestrictionComponent

@onready var audio: AudioStreamPlayer = $RadarAudio

func _ready() -> void:
	player = get_parent()
	restriction_component = player.get_node("RestrictionComponent")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_radar") and can_toggle and active:
		can_toggle = false
		toggle_radar()
		await get_tree().create_timer(0.5).timeout
		can_toggle = true

func toggle_radar():
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
	var final_rot_x: float
	match focused:
		true:
			final_pos = OUT_POS
			final_rot_x = deg_to_rad(-45)
		false:
			final_pos = AWAY_POS
			final_pos.x += randf_range(-0.5, 0.5)
			final_rot_x = 0
	
	if pos_tween:
		pos_tween.kill()
	pos_tween = create_tween()
	
	pos_tween.tween_property(self, "position", final_pos, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	pos_tween.parallel().tween_property(self, "rotation", Vector3(final_rot_x, 0, 0), 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

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

func deactivate():
	active = false
