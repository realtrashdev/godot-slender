extends Control

signal category_changed(category_name: String)

@onready var categories_dict: Dictionary[String, Control] = {
	"game": $HBoxContainer/Settings/GameSettings,
	"display": $HBoxContainer/Settings/DisplaySettings,
	"audio": $HBoxContainer/Settings/AudioSettings,
}


func _on_game_settings_pressed() -> void:
	_set_category_visible("game")


func _on_display_settings_pressed() -> void:
	_set_category_visible("display")


func _on_audio_settings_pressed() -> void:
	_set_category_visible("audio")


func _on_other_settings_pressed() -> void:
	_set_category_visible("other")


func _set_category_visible(category_name: String):
	for val in categories_dict.values():
		val.visible = false
	
	categories_dict[category_name].visible = true
	category_changed.emit(category_name)
