@abstract class_name ComponentEnemy extends Node

var profile: EnemyProfile

func attach_component(target: Node):
	var enemy = profile.scene.instantiate()
	target.add_child(enemy)
