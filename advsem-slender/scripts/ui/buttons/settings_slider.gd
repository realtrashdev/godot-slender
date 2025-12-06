extends HSlider

@export var setting_name: String = "Unnamed"
@export var variable_name: String = ""

@onready var name_text: RichTextLabel = $"NameText"
#@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	#var volume = audio_stream_player.volume_db
	#audio_stream_player.volume_db = -50
	
	value_changed.connect(_on_value_changed)
	name_text.text = setting_name
	
	# Load the current value on startup
	if variable_name != "":
		value = Settings.call("get_" + variable_name)
	
	await get_tree().create_timer(0.5).timeout
	#audio_stream_player.volume_db = volume

func _on_value_changed(new_value: float):
	if variable_name != "":
		Settings.call("set_" + variable_name, new_value)
	#audio_stream_player.pitch_scale = 0.8 + (value / step - min_value) / 50
	#audio_stream_player.play()

func _on_mouse_enter():
	pass

func _on_mouse_exit():
	pass
