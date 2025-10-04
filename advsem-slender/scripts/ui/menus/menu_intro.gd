extends Menu

static var seen: bool = false

var intro_text: Array[String] = [
	"hello there.",
	"you seem to be lost.",
	"allow me to help . . . guide the way.",
	"you may have noticed that your body as\nyou know it is no longer . . . present.",
	"if you wish to venture into the unknown,\nwe must first create you a [wave]Vessel.",
]

var current_spiel: Array[String] #= intro_text
var progression: Array[Control]

var progress: bool = false

@onready var voice: RichTextLabel = $Voice

func _ready() -> void:
	progression.append($CharacterNaming)
	
	if seen:
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
	if progression.is_empty():
		seen = true
		go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.FORWARD, false)
		return
	
	progression[0].visible = true
	progression[0].modulate = Color.BLACK
	var tween = create_tween().tween_property(progression[0], "modulate", Color.WHITE, 3)
	progression.remove_at(0)
	await tween.finished
	$CharacterNaming/LineEdit.grab_focus()

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.length() > 0:
		SaveManager.set_player_name(new_text)
		$CharacterNaming/LineEdit.release_focus()
		$CharacterNaming.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		await get_tree().create_timer(3).timeout
		next_stage()
