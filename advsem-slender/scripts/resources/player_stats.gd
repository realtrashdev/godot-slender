class_name PlayerStats extends Resource

@export_group("Movement", "")
@export var walk_speed: float = 3.0
@export var run_speed: float = 5.0

@export_group("Light", "light_")
@export var light_brightness: float = 2.0

@export_group("Radar", "")
@export var battery_chunks: int = 4

@export_group("Lives", "")
@export var starting_lives: int = 3
