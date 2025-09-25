extends Control

@export_category("Settings")

@export_subgroup("Sine Rotation", "sr_")
@export var sr_enabled: bool = true
@export var sr_rotation: float = 5.0
@export var sr_speed: float = 2.0

@export_subgroup("Bouncing", "b_")
@export var b_enabled: bool = false
@export var b_height: float = 50.0
@export var b_speed: float = 2.0

var default_pos: Vector2
var time_elapsed: float = 0

func _ready() -> void:
	default_pos = position

func _process(delta: float) -> void:
	time_elapsed += delta
	
	if sr_enabled:
		rotation = sin(time_elapsed * sr_speed) * deg_to_rad(sr_rotation)
	
	if b_enabled:
		position.y = default_pos.y + -abs(sin(time_elapsed * b_speed)) * b_height
