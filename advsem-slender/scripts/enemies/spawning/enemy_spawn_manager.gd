extends Node3D

@export var starter_enemies: Array[EnemyProfile]
@export var all_enemies: Dictionary[String, EnemyProfile]

# dictionary with enemy names and their corresponding spawner node
@export var nav_region: NavigationRegion3D

func taking_too_long():
	for child in get_children():
		child.taking_too_long()
