extends Node

const ICON_SCENE = preload("uid://cwiritx4rencv")

const SLOT_TEXT: String = "Activates at %s Pages Collected"
const SLOT_TEXT_ONE: String = "Activates at %s Page Collected"
const REMAIN_TEXT: String = "%s Selections Remaining"
const REMAIN_TEXT_ONE: String = "%s Selection Remaining"

var all_enemies: Array[EnemyProfile]
var enemy_choices: Array[EnemyProfile]

var selections_remaining: int = 3
var slot: int = 1

@onready var icon_container = $StrongMouseParallax/HBoxContainer
@onready var pixel_transition: PixelTransition = $PixelTransition
@onready var slot_text: RichTextLabel = $WeakMouseParallax/SlotText
@onready var remaining_text: RichTextLabel = $WeakMouseParallax/RemainingText


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	all_enemies = ResourceDatabase.get_all_usable_enemies()
	_calc_slots_and_selections()
	_setup()


func _setup():
	slot_text.text = SLOT_TEXT % slot if slot != 1 else SLOT_TEXT_ONE % slot
	remaining_text.text = REMAIN_TEXT % selections_remaining if selections_remaining != 1 else REMAIN_TEXT_ONE % selections_remaining
	_randomize_enemy_choices()
	_get_enemy_icons()
	_setup_button_group()
	pixel_transition.transition(0.0, 1.0, 0.0)
	icon_container.scale = Vector2.ZERO
	await get_tree().create_timer(1.0).timeout
	_show_icons()


func _randomize_enemy_choices():
	var enemies: Array[EnemyProfile] = all_enemies.duplicate()
	
	# No enemies, must pick a lethal enemy
	if GameState.get_enemy_list().is_empty():
		enemies = enemies.filter(func(e): return e.type == CharacterProfile.Type.LETHAL)
	
	# Normal
	for i in range(GameState.enemy_choices):
		if enemies.is_empty():
			push_warning("Ran out of unique enemy choices!")
			continue
		var enemy: EnemyProfile = enemies.pick_random()
		enemy_choices.append(enemy)
		enemies.erase(enemy)
		print("add enemy")


func _calc_slots_and_selections():
	var rand: int = randi_range(0, 1) if GameState.rounds_complete > 0 else 0
	slot = clampi(GameState.rounds_complete + rand, 1, GameState.current_max_pages - 1)
	
	# Maximum pages required = completely randomized slots to prevent stacking at end
	# Player will have already "won" at this point so this is meant to bring chaos
	if GameState.get_pages_required() == GameState.current_max_pages:
		slot = randi_range(0, GameState.current_max_pages - 1)
	
	selections_remaining = GameState.required_enemy_selections + floori(float(GameState.rounds_complete) / 4.0)


func _get_enemy_icons():
	for profile in enemy_choices:
		var icon: CharacterIcon = ICON_SCENE.instantiate()
		icon.profile = profile
		icon_container.add_child(icon)


func _setup_button_group():
	var group = ButtonGroup.new()
	for enemy in icon_container.get_children():
		if enemy is CharacterIcon:
			enemy.button.button_group = group
			enemy.set_disabled(true)


func _show_icons():
	await create_tween().tween_property(icon_container, "scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).finished
	for child in icon_container.get_children():
		if child is CharacterIcon:
			child.set_disabled(false)


func _clear_icons():
	for child in icon_container.get_children():
		if child is CharacterIcon:
			child.queue_free()
	enemy_choices.clear()


func _on_choose_button_pressed() -> void:
	var pressed: bool = false
	for child in icon_container.get_children():
		if child is CharacterIcon:
			if child.button.button_pressed:
				pressed = true
				var enemy = child.profile
				GameState.add_enemy_to_list(slot, enemy)
				all_enemies.erase(enemy)
	if not pressed:
		return
	selections_remaining -= 1
	
	if selections_remaining == 0:
		pixel_transition.transition(1.0, 1.0, 0.0)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_packed(Settings.get_selected_map().scene)
	else:
		if GameState.get_pages_required() == GameState.current_max_pages:
			slot = randi_range(0, GameState.current_max_pages - 1)
		else:
			slot += 1
		_clear_icons()
		_setup()
	
