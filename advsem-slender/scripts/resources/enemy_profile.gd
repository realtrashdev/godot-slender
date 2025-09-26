class_name EnemyProfile extends Resource

enum EnemyType { LETHAL, DANGEROUS, NUISANCE }
enum SpawnType { RING, BEHIND }

@export_group("Basic Info")
@export var scene: PackedScene
@export var name: String
@export var type: EnemyType

@export_group("Spawning")
@export var spawn_behavior: SpawnBehavior
@export var min_spawn_time: float
@export var max_spawn_time: float
@export var spawn_distance: float

@export_group("Interacting")
@export var jumpscare: Jumpscare
