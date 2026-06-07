extends Node


var characters: Array[VesselProfile]


@onready var character_image: TextureRect = $MarginContainer/HBoxContainer/CharacterImage
@onready var name_desc: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/Name
@onready var speed_desc: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/StatDesc
@onready var light_desc: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/StatDesc
@onready var batt_desc: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/StatDesc
@onready var height_desc: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/StatDesc



func _ready() -> void:
	characters = ResourceDatabase.get_all_characters()
	_populate(Settings.get_selected_character())


func _populate(profile: VesselProfile) -> void:
	if profile.icon_detailed != null:
		character_image.texture = profile.icon_detailed
	else:
		character_image.texture = profile.icon
	name_desc.text = profile.name
	speed_desc.text = str(profile.move_speed)
	light_desc.text = str(profile.light_brightness)
	batt_desc.text = str(profile.radar_battery_chunks)
	height_desc.text = str(profile.height)
