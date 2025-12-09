extends CheckBox

@export var display_name: String
@export var variable_name: String

@onready var text_label: RichTextLabel = $RichTextLabel
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	text_label.text = display_name
	set_pressed_no_signal(Settings.call("get_" + variable_name))

func _on_toggled(toggled_on: bool) -> void:
	Settings.call("set_" + variable_name, toggled_on)
	audio.pitch_scale = randf_range(0.95, 1.05)
	audio.play()
