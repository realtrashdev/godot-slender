extends Node

const SAVE_PATH: String = "user://endless.page"

func _ready():
	load_data()

#region Saving
func save_data():
	var save_dict = {
		"enemies": _get_saved_enemy_list(GameState.enemy_list),
		"version": SaveManager.SAVE_VERSION
	}
	
	SaveSystem.write(SAVE_PATH, save_dict)

func load_data():
	var data = SaveSystem.read(SAVE_PATH)
	
	var version = data.get("version", "unknown")
	if version != SaveManager.SAVE_VERSION:
		print("Endless save version mismatch (file: %s, current: %s)" % [version, SaveManager.SAVE_VERSION])
	
	GameState.set_enemy_list(_get_loaded_enemy_list(data))
	
	print("Endless save loaded successfully")

func reset_all_data():
	GameState.enemy_list = {}
	save_data()
#endregion

#region Serialize/Deserialize
func _get_saved_enemy_list(list: Dictionary) -> Dictionary:
	var enemy_list_str: Dictionary = {}
	for i in GameState.get_enemy_list():
		enemy_list_str[i] = GameState.get_enemy_list()[i].profiles.map(
			func(p: EnemyProfile): return p.resource_name
		)
	return enemy_list_str


func _get_loaded_enemy_list(data: Dictionary) -> Dictionary[int, EnemyProfileList]:
	var result: Dictionary[int, EnemyProfileList] = {}
	for i in data.get("enemies", {}):
		var list = EnemyProfileList.new()
		for id in data["enemies"][i]:
			var profile = ResourceDatabase.get_enemy(id)
			if profile:
				list.profiles.append()
			else:
				push_warning("Unknown enemy id in endless save: %s" % id)
		result[int(i)] = list
	return result
