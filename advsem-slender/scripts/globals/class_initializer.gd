extends Node

func _init():
	# forces class registration
	var _char = CharacterProfile.new()
	var _vessel = VesselProfile.new()
	var _enemy = EnemyProfile.new()
