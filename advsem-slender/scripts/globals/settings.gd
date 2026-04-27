extends Node

signal setting_changed(setting_name: String, new_value)

var data: Dictionary = {
	## Game
	"selected_game_mode": GameConfig.GameMode.CLASSIC,
	"selected_scenario": "tutorial",
	"selected_character": "default",
	"selected_palette": "grayscale",
	"selected_map": "abyss",
	
	## Audio
	"master_volume": 1.0,
	
	## Control
	"mouse_sensitivity": 1.0,   # 0.00 - 2.00
	
	## Display
	"fullscreen": true,
	"crt_opacity": 0.1,         # 0.00 - 0.33
	"vignette_intensity": 0.7,  # 0.00 - 1.00
	
	## Gameplay
	"run_timer": false,
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

func get_selected_scenario() -> ClassicModeScenario:
	return ResourceDatabase.get_scenario(data.get("selected_scenario", "basics1"))

func set_selected_scenario(scenario: ClassicModeScenario):
	data["selected_scenario"] = scenario.resource_name
	setting_changed.emit("selected_scenario", scenario.resource_name)

func get_selected_character() -> CharacterProfile:
	return ResourceDatabase.get_characters(data.get("selected_character", "default"))

func set_selected_character_name(char_name: String):
	data["selected_character"] = char_name
	setting_changed.emit("selected_character", char_name)

func get_selected_color_palette() -> ColorSet:
	return ResourceDatabase.get_color_set(data.get("selected_palette", "grayscale"))

func set_selected_color_palette(palette: ColorSet):
	data["selected_palette"] = palette.resource_name
	setting_changed.emit("selected_palette", palette.resource_name)

func get_selected_map() -> Map:
	return ResourceDatabase.get_map(data.get("selected_map", "forest"))

func set_selected_map(map_name: String):
	data["selected_map"] = map_name
	setting_changed.emit("selected_map", map_name)

##
## Settings
##

##
## Audio
##
func get_master_volume() -> float:
	return data.get("master_volume", 1.0)

func set_master_volume(volume: float):
	data["master_volume"] = volume
	AudioServer.set_bus_volume_linear(0, volume)
	setting_changed.emit("master_volume", volume)


##
## Display
##
func get_fullscreen() -> bool:
	return data.get("fullscreen", false)

func set_fullscreen(enabled: bool):
	data["fullscreen"] = enabled
	setting_changed.emit("fullscreen", enabled)
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func get_crt_opacity() -> float:
	return data.get("crt_opacity", 0.05)

func set_crt_opacity(opacity: float):
	data["crt_opacity"] = opacity
	setting_changed.emit("crt_opacity", opacity)

func get_vignette_intensity() -> float:
	return data.get("vignette_intensity", 1.0)

func set_vignette_intensity(intensity: float):
	data["vignette_intensity"] = intensity
	setting_changed.emit("vignette_intensity", intensity)

##
## Gameplay
##
func get_actual_mouse_sensitivity() -> float: # 0.001 - 0.003
	return (data.get("mouse_sensitivity", 1.0) + 1) / 1000

func get_mouse_sensitivity() -> float: # 0.0 - 2.0
	return data.get("mouse_sensitivity", 2.0)

func set_mouse_sensitivity(sensitivity: float):
	data["mouse_sensitivity"] = sensitivity
	setting_changed.emit("mouse_sensitivity", sensitivity)
	print("new sens: %s" % sensitivity)

func get_run_timer() -> bool:
	return data.get("run_timer", false)

func set_run_timer(enabled: bool):
	data["run_timer"] = enabled
	setting_changed.emit("run_timer", enabled)
#endregion

func reset_to_defaults():
	data = {
		"selected_game_mode": GameConfig.GameMode.CLASSIC,
		"selected_scenario": "tutorial",
		"selected_character": "default",
		"selected_palette": "grayscale",
		"selected_map": "abyss",
		
		"master_volume": 1.0,
		
		"mouse_sensitivity": 1.0,
		
		"fullscreen": true,
		"crt_opacity": 0.1,
		"vignette_intensity": 0.7,
		
		"run_timer": false,
	}
	SaveManager.save_game()

# HACK temporary for testing
func _ready() -> void:
	set_fullscreen(get_fullscreen())
	AudioServer.set_bus_volume_linear(0, data["master_volume"])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		set_fullscreen(!get_fullscreen())
