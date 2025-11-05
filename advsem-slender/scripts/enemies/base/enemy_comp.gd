@abstract class_name ComponentEnemy extends Node

var profile: EnemyProfile

func attach_component(target: Node):
	var enemy = profile.scene.instantiate()
	enemy.profile = profile
	target.add_child(enemy)
