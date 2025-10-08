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
@export var unlocks: Dictionary[String, Array] = {}

func get_all_enemy_profiles() -> Array[EnemyProfile]:
	var array: Array[EnemyProfile] = []
	
	for i in enemies_to_add:
		var profile_cluster = enemies_to_add[i]
		if profile_cluster != null:
			array += profile_cluster.profiles
	
	return array

func scenario_beaten():
	UnlockHelper.process_unlocks(unlocks)
