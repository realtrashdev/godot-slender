class_name ClassicModeScenario extends Resource

enum Map { FOREST }

@export_category("Information")
@export var name: String
@export_multiline var description: String
@export var enemies_to_add: Dictionary[int, EnemyProfileList] = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null,
}

@export_category("Page Generation")
@export var required_pages: int = 8
@export var total_pages: int = 0

@export_category("Unlocking")
@export var unlock_requirements: Dictionary[String, Array] = {
	"scenarios": [],
}
@export_multiline var unlock_description = "Locked..."

func get_all_enemy_profiles() -> Array[EnemyProfile]:
	var array: Array[EnemyProfile] = []
	
	for i in enemies_to_add:
		var profile_cluster = enemies_to_add[i]
		if profile_cluster != null:
			array += profile_cluster.profiles
	
	return array

func check_for_unlock() -> bool:
	for requirement in unlock_requirements["scenarios"]:
		if requirement not in Progression.get_completed_scenarios():
			print("scenario " + resource_name + " not unlocked")
			return false
	print("scenario " + resource_name + " unlocked")
	return true
