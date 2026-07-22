class_name Unlockable extends Resource

var secret_unlock_descriptions = [
	"You're not allowed to unlock this one. Stop trying.",
	"Do [wave]50 push-ups[/wave] in real life to unlock!",
	"This one's for cool people only. Sorry!",
	"Sorry, I forgot to implement unlocking this one."
]

@export_category("Unlocking")
## "scenarios", "deaths", etc.
@export var unlock_requirements: Dictionary[String, Array] = {
	"scenarios": [],
	"play_character": [],
}
@export_multiline var unlock_description = "Locked..."


func check_for_unlock() -> bool:
	for requirement in unlock_requirements["scenarios"]:
		if requirement not in Progression.get_completed_scenarios():
			return false
	return true


func get_unlock_description() -> String:
	var scen_requirements = unlock_requirements["scenarios"]
	var desc = "Complete "
	var do_secret = false
	
	for i in range(scen_requirements.size()):
		var requirement = scen_requirements[i]
		
		if Progression.is_scenario_unlocked(requirement.resource_name):
			desc += "[wave]%s[/wave]" % requirement.name
		else:
			desc += "[wave]???[/wave]"
			do_secret = true
		
		if i < scen_requirements.size() - 2:
			desc += ", "
		elif i < scen_requirements.size() - 1:
			desc += " and "
	
	var char_requirements = unlock_requirements["play_character"]
	desc = "Play as "
	
	for i in range(char_requirements.size()):
		var requirement = char_requirements[i]
		
		if Progression.is_character_unlocked(requirement.resource_name):
			desc += "[wave]%s[/wave]" % requirement.name
		else:
			print(requirement.resource_name)
			desc += "[wave]???[/wave]"
			do_secret = true
		
		if i < char_requirements.size() - 2:
			desc += ", "
		elif i < char_requirements.size() - 1:
			desc += " or "
	
	desc += " to unlock!"
	
	if randi_range(0, 100) == 50 and do_secret:
		desc = secret_unlock_descriptions.pick_random()
	
	return desc
