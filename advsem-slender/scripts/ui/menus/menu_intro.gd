extends Menu

var intro_text: Array[String] = [
	"hello there.",
	"you seem to be lost.",
	"allow me to help . . . guide the way.",
	"you may have noticed that your body as\nyou know it is no longer . . . present.",
	"if you wish to venture into the unknown,\nwe must first create you a [wave]Vessel.",
]

var current_spiel: Array[String] #= intro_text
var progression: Array[Control]
var current_screen: Control

var progress: bool = false

@onready var voice: RichTextLabel = $Voice

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	progression.append($Settings)
	
	if Progression.is_tutorial_completed() or Progression.is_scenario_completed("tutorial"):
		go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.FORWARD, false)
		return
	
	await get_tree().create_timer(1).timeout
	show_line()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and progress:
		show_line()

func show_line():
	if voice.visible_characters != voice.get_total_character_count():
		return
	
	progress = false
	
	if current_spiel.size() == 0:
		voice.visible_characters = 0
		next_stage()
		return
	
	voice.text = current_spiel[0]
	current_spiel.remove_at(0)
	
	TextTools.change_visible_characters(voice, voice.get_total_character_count(), voice.get_total_character_count() * 0.08, 0)
	await get_tree().create_timer(2).timeout
	progress = true

func next_stage():
	var tween
	
	if progression.is_empty():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		#HACK
		$Settings/ConfirmButton.enabled = false
		$CustomAudioPlayer.set_volume_smooth(-50, 5, -7, Tween.EASE_IN)
		tween = create_tween().tween_property(current_screen, "modulate", Color.BLACK, 3)
		await tween.finished
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://scenes/levels/map_abyss.tscn")
		return
	
	progression[0].visible = true
	progression[0].modulate = Color.BLACK
	tween = create_tween().tween_property(progression[0], "modulate", Color.WHITE, 3)
	current_screen = progression[0]
	progression.remove_at(0)
	
	await tween.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.length() > 0:
		Progression.set_player_name(new_text)
		$CharacterNaming/LineEdit.release_focus()
		$CharacterNaming.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		await get_tree().create_timer(3).timeout
		next_stage()
