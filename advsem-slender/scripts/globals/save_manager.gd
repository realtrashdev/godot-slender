extends Node

const SAVE_PATH = "user://save_data.page"
const SAVE_VERSION = "0.0"

func _ready():
	load_game()

func save_game():
	var save_dict = {
		"settings": Settings.data,
		"progression": Progression.data,
		"version": SAVE_VERSION
	}
	
	SaveSystem.write(SAVE_PATH, save_dict)


func load_game():
	var data = SaveSystem.read(SAVE_PATH)
	
	if data.has("settings"):
		Settings.data = data["settings"]
	
	if data.has("progression"):
		Progression.data = data["progression"]
	
	print("Game loaded successfully")


func reset_progression():
	Progression.reset_to_defaults()
	save_game()


func reset_settings():
	Settings.reset_to_defaults()
	save_game()


func reset_all_data():
	Progression.reset_to_defaults()
	Settings.reset_to_defaults()
	save_game()


#func _notification(what: int) -> void:
	#if what == NOTIFICATION_WM_CLOSE_REQUEST:
		#print("GAME CLOSING - WM_CLOSE_REQUEST received!")
		#print("Stack trace:")
		#print_stack()
