extends HSlider

@export var setting_name: String = "Unnamed"
@export var variable_name: String = ""

@onready var name_text: RichTextLabel = $"NameText"

func _ready():
	value_changed.connect(_on_value_changed)
	name_text.text = setting_name
	
	# Load the current value on startup
	if variable_name != "":
		value = Settings.call("get_" + variable_name)
	
	await get_tree().create_timer(0.5).timeout

func _on_value_changed(new_value: float):
	if variable_name != "":
		Settings.call("set_" + variable_name, new_value)

func _on_mouse_enter():
	pass

func _on_mouse_exit():
	pass
