extends Menu

const GAME_SCENE: String = "res://scenes/levels/forest_level.tscn"

@onready var manager: Node3D = get_parent()
@onready var description_text: RichTextLabel = $Menu/DescriptionText
@onready var classic_button: Button = $Menu/HBoxContainer/ClassicButton
@onready var endless_button: Button = $Menu/HBoxContainer/EndlessButton

var tween: Tween

## TODO holy refactor

func _ready() -> void:
	var group = ButtonGroup.new()
	
	classic_button.button_group = group
	endless_button.button_group = group
	
	classic_button.toggled.connect(game_mode_classic)
	endless_button.toggled.connect(game_mode_endless)
	
	update_mode_buttons()
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	zoom_effect(Vector2(1, 1), 0.5, Tween.TRANS_QUART, Tween.EASE_OUT)
	
	await get_tree().create_timer(0.5).timeout
	
	description_text.visible = true
	update_description_text()

func start_game():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	zoom_effect(Vector2(10, 10), 0.6, Tween.TRANS_QUART, Tween.EASE_IN)
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(GAME_SCENE)

func back():
	menu_selected.emit("Main", MenuDirection.BACKWARD)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	zoom_effect(Vector2.ZERO, 0.5, Tween.TRANS_QUART, Tween.EASE_IN)

func update_description_text():
	if !description_text.visible:
		return
	
	description_text.text = GameConfig.get_mode_description()
	description_text.visible_characters = 0
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(description_text, "visible_characters", description_text.get_total_character_count(), 0.5)

func update_mode_buttons():
	match CurrentGameData.game_mode:
		GameConfig.GameMode.CLASSIC:
			classic_button.button_pressed = true
		GameConfig.GameMode.ENDLESS:
			endless_button.button_pressed = true

func game_mode_classic(a):
	if not a: return
	CurrentGameData.update_game_mode(GameConfig.GameMode.CLASSIC)
	print("updated game mode to classic")
	update_description_text()

func game_mode_endless(a):
	if not a: return
	CurrentGameData.update_game_mode(GameConfig.GameMode.ENDLESS)
	print("updated game mode to endless")
	update_description_text()
