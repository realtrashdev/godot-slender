@abstract class_name Enemy3D extends CharacterBody3D

@warning_ignore("unused_signal")
signal died

var profile: EnemyProfile

func pathfind():
	pass

func check_player_collision() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("Player"):
			Signals.killed_player.emit(profile.jumpscare)
			collider.die()
			queue_free()
