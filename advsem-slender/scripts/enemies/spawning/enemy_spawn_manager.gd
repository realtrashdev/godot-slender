extends Node3D

@export var enemy_pool: Array[EnemyProfile]

# dictionary with enemy names and their corresponding spawner node
@export var nav_region: NavigationRegion3D

func taking_too_long():
	for child in get_children():
		child.taking_too_long()

func add_enemy_spawners():
	for spawner in enemy_pool:
		add_child(enemy_pool[spawner].scene.instantiate())
