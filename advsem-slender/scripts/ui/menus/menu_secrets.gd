extends Node

var recent_keys: Array[String] = []

var manager: Node3D
var tween: Tween

func _ready() -> void:
	manager = get_parent()
	check_gum()

func _input(event: InputEvent) -> void:
	if event is not InputEventKey:
		return
	
	if event.is_released() or event.is_echo():
		return
	
	print(event.as_text())
	recent_keys.append(event.as_text())
	
	if recent_keys.size() > 10:
		recent_keys.remove_at(0)
	
	check_key_array()

func check_key_array():
	if recent_keys.size() < 3:
		return
	
	var last_idx = recent_keys.size() - 1
	if last_idx >= 2:
		if recent_keys[last_idx - 2] == "G" and \
		   recent_keys[last_idx - 1] == "U" and \
		   recent_keys[last_idx] == "M":
			spawn_gum()
			return
	
	if last_idx >= 4:
		if recent_keys[last_idx - 4] == "M" and \
		   recent_keys[last_idx - 3] == "U" and \
		   recent_keys[last_idx - 2] == "S" and \
		   recent_keys[last_idx - 1] == "I" and \
		   recent_keys[last_idx] == "C":
			toggle_bgm_pitch()
			return

## 1 in 500 chance every second to spawn gum enemy on title screen
## Fun little easter egg, should decrease the odds probably
func check_gum():
	await get_tree().create_timer(1).timeout
	var num = randi_range(1, 500)
	if num == 500:
		spawn_gum()
	check_gum()

func spawn_gum():
	var scene = preload("res://scenes/enemies/gum.tscn").instantiate()
	add_child(scene)
	scene.activate()

## Changes BGM pitch to a somewhat normal sounding pitch.
## I kind of like the low pitched though, it feels dreamlike :]
func toggle_bgm_pitch():
	var bgm: AudioStreamPlayer = manager.get_node("Music")
	var new_scale: float
	
	if bgm.pitch_scale < 0.8:
		new_scale = 0.9
	else:
		new_scale = 0.4
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(bgm, "pitch_scale", 0.01, 0.5)
	await tween.finished
	tween = create_tween()
	tween.tween_property(bgm, "pitch_scale", new_scale, 0.5)
