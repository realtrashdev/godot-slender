class_name EnemyProfile extends CharacterProfile

enum EnemyType { ENEMY_2D, ENEMY_3D, ENEMY_COMPONENT }

@export_group("Enemy Info")
@export var scene: PackedScene
@export var enemy_type: EnemyType

@export_group("Spawning")
## How this enemy spawns. Does it use a pre placed spawn marker, does it spawn on the player, etc?
@export var spawn_behavior: SpawnBehavior
## Minimum amount of time this enemy has to wait before spawning.
@export var min_spawn_time: float
## Maximum amount of time this enemy can wait before spawning.
@export var max_spawn_time: float
## Maximum amount of this enemy that can be active at once.
@export var max_instances: int = 3

@export_group("Movement")
@export var move_speed: float = 0.0

@export_group("Death")
## AAAAAAHH!!
@export var jumpscare: Jumpscare
## What the game can tell the player when they die to this enemy.
@export_multiline var death_tips: Array[String]

func get_death_tip() -> String:
	if death_tips.size() > 0:
		return death_tips[randi_range(0, death_tips.size() - 1)]
	return "No tip found..."
