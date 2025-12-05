class_name Unlockable extends Resource

var secret_unlock_descriptions = [
	"You're not allowed to unlock this one. Stop trying.",
	"Do [wave]50 push-ups[/wave] in real life to unlock!",
	"This one's for cool people only. Sorry!",
	"Sorry, I forgot to implement unlocking this one."
]

@export_category("Unlocking")
## "scenarios", "deaths"
@export var unlock_requirements: Dictionary[String, Array] = {
	"scenarios": [],
}
@export_multiline var unlock_description = "Locked..."

func check_for_unlock() -> bool:
	for requirement in unlock_requirements["scenarios"]:
		if requirement not in Progression.get_completed_scenarios():
			return false
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
