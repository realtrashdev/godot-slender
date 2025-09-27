extends RichTextLabel

@export_category("Settings")
@export var display_by_default: bool = true

@export_subgroup("Sine Rotation", "sr_")
@export var sr_enabled: bool = false
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
	if !display_by_default:
		visible_characters = 0

func _process(delta: float) -> void:
	time_elapsed += delta
	
	if sr_enabled:
		rotation = sin(time_elapsed * sr_speed) * deg_to_rad(sr_rotation)
	
	if b_enabled:
		position.y = default_pos.y + -abs(sin(time_elapsed * b_speed)) * b_height

func toggle_visible_characters():
	if visible_characters == 0:
		TextTools.change_visible_characters(self, get_total_character_count(), 1)
	else:
		TextTools.change_visible_characters(self, 0, 1)
