extends Node

var characters: Array[VesselProfile]

var tween: Tween

@onready var character_image: TextureRect = $MarginContainer/HBoxContainer/CharacterImage
@onready var name_desc: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/Name
@onready var speed_desc: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/StatDesc
@onready var light_desc: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/StatDesc
@onready var batt_desc: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/StatDesc


func _ready() -> void:
	characters = ResourceDatabase.get_all_characters()
	populate(Settings.get_selected_character())


func populate(profile: VesselProfile) -> void:
	if profile.icon_detailed != null:
		character_image.texture = profile.icon_detailed
	else:
		character_image.texture = profile.icon
	name_desc.text = profile.name.to_upper()
	speed_desc.text = str(profile.stats.walk_speed)
	light_desc.text = str(profile.stats.light_brightness)
	batt_desc.text = str(profile.stats.battery_chunks)
	animate()


func animate() -> void:
	character_image.modulate = Color.TRANSPARENT
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(character_image, "modulate", Color.WHITE, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
