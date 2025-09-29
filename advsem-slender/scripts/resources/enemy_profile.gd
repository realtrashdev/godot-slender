class_name EnemyProfile extends Resource

enum EnemyType { LETHAL, DANGEROUS, NUISANCE }

@export_group("Basic Info")
@export var scene: PackedScene
@export var is_2d_enemy: bool = false
@export var name: String
@export var type: EnemyType
@export_multiline var description: String

@export_group("Spawning")
## How this enemy spawns. Does it use a pre placed spawn marker, does it spawn on the player, etc?
@export var spawn_behavior: SpawnBehavior
## Minimum amount of time this enemy has to wait before spawning.
@export var min_spawn_time: float
## Maximum amount of time this enemy can wait before spawning.
@export var max_spawn_time: float

@export_group("Death")
## AAAAAAHH!!
@export var jumpscare: Jumpscare
## What the game can tell the player when they die to this enemy.
@export_multiline var death_tips: Array[String]

func get_death_tip() -> String:
	if death_tips.size() > 0:
		return death_tips[randi_range(0, death_tips.size() - 1)]
	return "No tip found..."
