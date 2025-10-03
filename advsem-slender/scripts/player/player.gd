extends CharacterBody3D

const MENU_SCENE = "res://scenes/ui/menus/menu_base.tscn"

var active: bool

@onready var movement_component: PlayerMovementComponent = $MovementComponent
@onready var camera_component: PlayerCameraComponent = $CameraComponent
@onready var flashlight_component: PlayerFlashlightComponent = $FlashlightComponent
@onready var audio_component: PlayerAudioComponent = $AudioComponent
@onready var restriction_component: PlayerRestrictionComponent = $RestrictionComponent

func _ready() -> void:
	deactivate()

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file(MENU_SCENE)

func _physics_process(delta: float) -> void:
	movement_component.handle_physics(delta)
	camera_component.handle_camera_physics(delta)
	flashlight_component.handle_flashlight_physics(delta)

func _input(event):
	camera_component.handle_input(event)

func die():
	Signals.player_died.emit()
	deactivate()
	var tree: SceneTree = get_tree()
	await get_tree().create_timer(1).timeout
	tree.change_scene_to_file(MENU_SCENE)

func activate():
	movement_component.activate()
	camera_component.activate()
	flashlight_component.activate()

func deactivate():
	movement_component.deactivate()
	camera_component.deactivate()
	flashlight_component.deactivate()
	restriction_component.clear_restrictions()

# Restriction convenience methods
func add_restriction(type: PlayerRestriction.RestrictionType, source: String):
	restriction_component.add_restriction(type, source)

func remove_restrictions_from_source(source: String):
	restriction_component.remove_restrictions_from_source(source)

func check_for_restriction(type: PlayerRestriction.RestrictionType) -> bool:
	return restriction_component.check_for_restriction(type)

func debug_tools():
	pass
