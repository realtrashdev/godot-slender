extends Node3D

@export var enemy_profile: EnemyProfile

var spawn_context: SpawnContext

var spawn_timer
var pages_collected: int = 0

# spawning conditions
var pages_needed = 1
var go = false

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var nav_region = get_parent().nav_region

func _ready() -> void:
	Signals.page_collected.connect(page_collected)
	set_timer()
	call_deferred("populate_spawn_context")

func _process(delta: float) -> void:
	# should be removed later on, as these spawners should be dynamically added to the scene tree.
	if pages_collected >= pages_needed or go:
		spawn_timer -= delta
	
	if spawn_timer <= 0:
		spawn_enemy()
		set_timer()
	
	if Input.is_action_just_pressed("ui_focus_next"):
		spawn_enemy()

func spawn_enemy():
	var enemy = enemy_profile.scene.instantiate()
	
	if enemy_profile.spawn_behavior:
		var pos = enemy_profile.spawn_behavior.get_spawn_position(spawn_context)
		add_child(enemy)
		enemy.global_position = pos
	else:
		add_child(enemy)

func populate_spawn_context():
	spawn_context = SpawnContext.new()
	spawn_context.player = player
	spawn_context.spawner = self
	# gross
	spawn_context.spawn_markers = $"../../SpawnMarkers"

func page_collected():
	pages_collected += 1

func set_timer():
	spawn_timer = randf_range(enemy_profile.min_spawn_time, enemy_profile.max_spawn_time)

func taking_too_long():
	go = true
