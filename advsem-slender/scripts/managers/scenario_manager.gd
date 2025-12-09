class_name ScenarioManager extends Node

var enemy_manager: EnemySpawnManager
var current_scenario: ClassicModeScenario

func initialize(esm: EnemySpawnManager, scenario: ClassicModeScenario):
	enemy_manager = esm
	current_scenario = scenario
	setup_all_enemies()

func setup_all_enemies():
	for page_number in current_scenario.enemies_to_add:
		var enemy_list = current_scenario.enemies_to_add[page_number]
		
		# check if it's an EnemyProfileList
		if enemy_list and enemy_list is EnemyProfileList:
			# access profile array inside the list
			for enemy_profile in enemy_list.profiles:
				if enemy_profile and enemy_profile is EnemyProfile:
					print("Adding spawner: ", enemy_profile.name, " at page ", page_number)
					enemy_manager.add_enemy_spawner(enemy_profile, page_number)
		elif enemy_list == null:
			# page has no enemies
			pass
		else:
			push_warning("Page ", page_number, " is not an EnemyProfileList: ", type_string(typeof(enemy_list)))
