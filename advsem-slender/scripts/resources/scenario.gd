class_name ClassicModeScenario extends Unlockable

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

func get_all_enemy_profiles() -> Array[EnemyProfile]:
	var array: Array[EnemyProfile] = []
	
	for i in enemies_to_add:
		var profile_cluster = enemies_to_add[i]
		if profile_cluster != null:
			array += profile_cluster.profiles
	
	return array

## Checks if the scenario's check box should be visible.
## Scenarios that have none of their required scenarios unlocked will be hidden.
func check_if_visible() -> bool:
	var requirements = unlock_requirements["scenarios"]
	
	if requirements.is_empty():
		return true
	
	for i in range(requirements.size()):
		var requirement = requirements[i]
		if Progression.is_scenario_unlocked(requirement.resource_name):
			return true
	
	return false
