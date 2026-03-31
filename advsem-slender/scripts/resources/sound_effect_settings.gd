class_name SoundEffectSettings extends Resource

@export_group("General Settings")

@export var stream: AudioStream
@export var volume_db: float = 0.0
@export var pitch_scale: float = 1.0
@export var pitch_variation: float = 0.0


@export_group("Fading")

@export_subgroup("Fade In", "fade_in")
@export var fade_in_enabled: bool = false
@export var fade_in_starting_volume_db: float = -60.0
@export var fade_in_time: float = 1.0

@export_subgroup("Fade Out", "fade_out")
@export var fade_out_enabled: bool = false
@export var fade_out_ending_volume_db: float = -60.0
@export var fade_out_time: float = 1.0
@export var fade_out_delay: float = 0.0

@export_group("3D")
@export var max_distance: float = 0.0
