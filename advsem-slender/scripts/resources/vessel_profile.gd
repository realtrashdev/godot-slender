class_name VesselProfile extends CharacterProfile

@export_group("Stats")
@export_subgroup("Movement", "move_")
@export var move_speed: float = 3.0
@export var move_sprint_speed: float = 5.0
@export_subgroup("Light", "light_")
@export var light_brightness: float = 2.0
@export_subgroup("Radar", "radar_")
@export var radar_battery_chunks: int = 4
@export_subgroup("Misc")
@export var height: float = 2.0

@export_group("Items")
@export var starting_items: Array
