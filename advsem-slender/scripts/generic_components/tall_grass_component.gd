extends Node

enum SlowLevel { NORMAL, SLOWED, HINDERED, ROOTED }

var slowing_text_dict: Dictionary = {
	SlowLevel.NORMAL:   "Your legs are free again.",
	SlowLevel.SLOWED:   "Grass blades have begun wrapping around your legs.",
	SlowLevel.HINDERED: "[shake rate=10 level=3]The blades are tightening. Your legs are beginning to lose circulation.[/shake]",
	SlowLevel.ROOTED:   "[shake]The blades are tearing into the flesh of your legs.[/shake]",
}

var slowing_multiplier_dict: Dictionary = {
	SlowLevel.NORMAL:   1.0,
	SlowLevel.SLOWED:   0.8,
	SlowLevel.HINDERED: 0.5,
	SlowLevel.ROOTED:   0.2,
}

var slow_level: SlowLevel = SlowLevel.NORMAL

var in_grass: bool = false
var time_in_grass: float = 0.0

@onready var player = get_parent()
@onready var ui_manager: UIManager = get_tree().get_node("UIManager")

func _physics_process(delta: float) -> void:
	pass

func _check_slow_level():
	if slow_level == SlowLevel.NORMAL and time_in_grass >= 5:
		_update_slow_level(SlowLevel.SLOWED)
	elif slow_level == SlowLevel.SLOWED and time_in_grass >= 12:
		_update_slow_level(SlowLevel.HINDERED)
	elif slow_level == SlowLevel.HINDERED and time_in_grass >= 25:
		_update_slow_level(SlowLevel.ROOTED)

func _update_slow_level(level):
	match level:
		SlowLevel.NORMAL:
			time_in_grass = 0.0
		SlowLevel.SLOWED:
			pass
		SlowLevel.HINDERED:
			pass
		SlowLevel.ROOTED:
			pass
	
	ui_manager.display_text(slowing_text_dict[level], 0.5, 3, 0.5, ui_manager.get_text_from_level(UIManager.TextLevel.BOTTOM))
