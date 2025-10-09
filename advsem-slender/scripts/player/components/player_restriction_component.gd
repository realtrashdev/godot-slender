class_name PlayerRestrictionComponent extends Node

var restrictions: Array[PlayerRestriction] = []

func _ready() -> void:
	Signals.game_finished.connect(clear_restrictions)

func add_restriction(type: PlayerRestriction.RestrictionType, source: String):
	var restrict: PlayerRestriction = PlayerRestriction.new()
	restrict.restriction = type
	restrict.source = source
	restrictions.append(restrict)
	print("Added player restriction " + str(type) + " from source " + str(source))
	
	if check_for_restriction(PlayerRestriction.RestrictionType.CAMERA_FULL):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func remove_restrictions_from_source(source: String):
	var i = restrictions.size() - 1
	while i >= 0:
		if restrictions[i].source == source:
			print("Removed restriction: " + str(restrictions[i].restriction) + " from: " + source)
			restrictions.remove_at(i)
			return

func remove_all_restrictions_from_source(source: String):
	var i = restrictions.size() - 1
	while i >= 0:
		if restrictions[i].source == source:
			print("Removed restriction: " + str(restrictions[i].restriction) + " from: " + source)
			restrictions.remove_at(i)
			return
		i -= 1

func check_for_restriction(type: PlayerRestriction.RestrictionType) -> bool:
	for restriction in restrictions:
		if restriction.restriction == type:
			return true
	return false

func clear_restrictions():
	restrictions.clear()
	print("Cleared all restrictions")

func get_restriction_sources(restriction_type: PlayerRestriction.RestrictionType) -> Array[String]:
	var sources: Array[String] = []
	for restriction in restrictions:
		if restriction.restriction == restriction_type:
			sources.append(restriction.source)
	return sources
