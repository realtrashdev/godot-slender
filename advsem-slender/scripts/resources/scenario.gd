class_name ClassicModeScenario extends Resource

enum Map { FOREST }

var secret_unlock_descriptions = [
	"You're not allowed to unlock this one. Stop trying.",
	"Do [wave]50 push-ups[/wave] in real life to unlock!",
	"This one's for cool people only. Sorry!",
	"Sorry, I forgot to implement unlocking this one."
]

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

func get_unlock_description() -> String:
	var requirements = unlock_requirements["scenarios"]
	var desc = "Complete "
	var do_secret = false
	
	for i in range(requirements.size()):
		var requirement = requirements[i]
		
		if Progression.is_scenario_unlocked(requirement.resource_name):
			desc += "[wave]%s[/wave]" % requirement.name
		else:
			desc += "[wave]???[/wave]"
			do_secret = true
		
		if i < requirements.size() - 2:
			desc += ", "
		elif i < requirements.size() - 1:
			desc += " and "
	
	desc += " to unlock!"
	
	if randi_range(0, 100) == 50 and do_secret:
		desc = secret_unlock_descriptions.pick_random()
	
	return desc

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
