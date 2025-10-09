extends Node3D

var focused: bool = false

var player: CharacterBody3D
var restriction_component: PlayerRestrictionComponent

@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	player = get_parent()
	restriction_component = player.get_node("RestrictionComponent")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_radar"):
		match restriction_component.check_for_restriction(PlayerRestriction.RestrictionType.RADAR):
			true:
				restriction_component.remove_restrictions_from_source("player_radar")
				update_audio_bus()
			false:
				restriction_component.add_restriction(PlayerRestriction.RestrictionType.RADAR, "player_radar")
				update_audio_bus()

func update_audio_bus():
	var bus = AudioServer.get_bus_index("PlayerRadar")
	AudioServer.set_bus_effect_enabled(bus, 0, focused)
