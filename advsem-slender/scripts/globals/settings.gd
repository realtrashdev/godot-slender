extends Node

signal setting_changed(setting_name: String, new_value)

var data: Dictionary = {
	## Game
	"selected_game_mode": GameConfig.GameMode.CLASSIC,
	"selected_scenario": "basics1",
	"selected_character": "default",
	"selected_palette": "grayscale",
	"selected_map": "forest",
	
	## Audio
	"master_volume": 1.0,
	
	## Control
	"mouse_sensitivity": 0.002,
	
	## Display
	"window_mode": DisplayServer.WINDOW_MODE_FULLSCREEN,
	"crt_opacity": 0.1,         # 0.00 - 0.33
	"vignette_intensity": 0.7   # 0.00 - 1.00
}

#region Getters/Setters
##
## Saved Preferences
##
func get_selected_game_mode() -> GameConfig.GameMode:
	return data.get("selected_game_mode", GameConfig.GameMode.CLASSIC)

func set_selected_game_mode(mode: GameConfig.GameMode):
	data["selected_game_mode"] = mode
	setting_changed.emit("selected_game_mode", mode)
	SaveManager.save_game()

func get_selected_scenario() -> ClassicModeScenario:
	return ResourceDatabase.get_scenario(data.get("selected_scenario", "basics1"))

func set_selected_scenario(scenario: ClassicModeScenario):
	data["selected_scenario"] = scenario.resource_name
	setting_changed.emit("selected_scenario", scenario.resource_name)
	SaveManager.save_game()

func get_selected_character() -> CharacterProfile:
	return ResourceDatabase.get_characters(data.get("selected_character", "default"))

func set_selected_character_name(char_name: String):
	data["selected_character"] = char_name
	setting_changed.emit("selected_character", char_name)
	SaveManager.save_game()

func get_selected_color_palette() -> ColorSet:
	return ResourceDatabase.get_color_set(data.get("selected_palette", "grayscale"))

func set_selected_color_palette(palette: ColorSet):
	data["selected_palette"] = palette.resource_name
	setting_changed.emit("selected_palette", palette.resource_name)
	SaveManager.save_game()

func get_selected_map() -> Map:
	return ResourceDatabase.get_map(data.get("selected_map", "forest"))

func set_selected_map(map_name: String):
	data["selected_map"] = map_name
	setting_changed.emit("selected_map", map_name)
	SaveManager.save_game()

##
## Settings Menu
##
func get_master_volume() -> float:
	return data.get("master_volume", 1.0)

func set_master_volume(volume: float):
	data["master_volume"] = volume
	setting_changed.emit("master_volume", volume)
	SaveManager.save_game()

func get_mouse_sensitivity() -> float:
	return data.get("mouse_sensitivity", 0.002)

func set_mouse_sensitivity(sensitivity: float):
	data["mouse_sensitivity"] = sensitivity
	setting_changed.emit("mouse_sensitivity", sensitivity)
	SaveManager.save_game()

func get_screen_mode() -> DisplayServer.WindowMode:
	return data.get("window_mode")

func set_screen_mode(mode: DisplayServer.WindowMode):
	data["window_mode"] = mode
	setting_changed.emit("window_mode", mode)
	SaveManager.save_game()

func get_crt_opacity() -> float:
	return data.get("crt_opacity", 0.05)

func set_crt_opacity(opacity: float):
	data["crt_opacity"] = opacity
	setting_changed.emit("crt_opacity", opacity)
	SaveManager.save_game()

func get_vignette_intensity() -> float:
	return data.get("vignette_intensity", 1.0)

func set_vignette_intensity(intensity: float):
	data["vignette_intensity"] = intensity
	setting_changed.emit("vignette_intensity", intensity)
	SaveManager.save_game()
#endregion

func reset_to_defaults():
	data = {
		"selected_game_mode": GameConfig.GameMode.CLASSIC,
		"selected_scenario": "basics1",
		"selected_character": "default",
		"selected_palette": "grayscale",
		"selected_map": "forest",
		
		"master_volume": 1.0,
		
		"mouse_sensitivity": 0.002,
		
		"window_mode": DisplayServer.WINDOW_MODE_FULLSCREEN,
		"crt_opacity": 0.1,
		"vignette_intensity": 0.7,
	}
	SaveManager.save_game()

# HACK temporary for testing
func _ready() -> void:
	DisplayServer.window_set_mode(get_screen_mode())

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		match DisplayServer.window_get_mode():
			DisplayServer.WINDOW_MODE_FULLSCREEN:
				set_screen_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_mode(get_screen_mode())
			DisplayServer.WINDOW_MODE_WINDOWED:
				set_screen_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				DisplayServer.window_set_mode(get_screen_mode())
