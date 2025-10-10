extends Node

const SAVE_PATH = "user://save_data.json"
const SAVE_VERSION = "0.0"

func _ready():
	reset_all_data()
	load_game()

func save_game():
	var save_dict = {
		"settings": Settings.data,
		"progression": Progression.data,
		"version": SAVE_VERSION
	}
	
	var json_string = JSON.stringify(save_dict, "\t")
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if file:
		file.store_string(json_string)
		file.close()
		print("Game saved successfully")
	else:
		push_error("Failed to save game")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found, using defaults")
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("Failed to open save file")
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result == OK:
		var data = json.data
		
		# Load into respective managers
		if data.has("settings"):
			Settings.data = data["settings"]
		
		if data.has("progression"):
			Progression.data = data["progression"]
		
		print("Game loaded successfully")
	else:
		push_error("Failed to parse save file: " + json.get_error_message())

func reset_all_data():
	Settings.reset_to_defaults()
	Progression.reset_to_defaults()
	save_game()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("GAME CLOSING - WM_CLOSE_REQUEST received!")
		print("Stack trace:")
		print_stack()
