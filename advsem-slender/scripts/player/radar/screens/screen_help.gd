extends Node2D

@onready var body_text: RichTextLabel = $BodyText

func get_help_text():
	match Settings.get_selected_map().resource_name:
		"abyss":
			body_text.text = "..."
		_:
			pass
