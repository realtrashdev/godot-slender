class_name UIPagesComponent extends UIComponent

@export_group("Timing")
@export var appear_time: float = 0.5
@export var move_time: float = 1.0
@export var display_time: float = 2.0
@export var disappear_time: float = 0.5

@export_group("Positioning")
@export var start_position: Vector2
@export var finish_position: Vector2
@export var container_start_position: Vector2
@export var container_finish_position: Vector2

@export_group("Tweening")
@export var page_text_tweens: Array[Array] = [
	[Tween.EASE_IN_OUT, Tween.TRANS_EXPO],
	[Tween.EASE_IN_OUT, Tween.TRANS_EXPO],
	[Tween.EASE_IN_OUT, Tween.TRANS_EXPO],
	[Tween.EASE_OUT, Tween.TRANS_BOUNCE],
	[Tween.EASE_IN_OUT, Tween.TRANS_CIRC],
]

var game_state: GameState
var tween: Tween

@onready var pages_text: RichTextLabel = $PagesText
@onready var pages_new_number: RichTextLabel = $PageNumbersContainer/NewNumber
@onready var pages_old_number: RichTextLabel = $PageNumbersContainer/OldNumber
@onready var page_numbers_container: VBoxContainer = $PageNumbersContainer


func _setup():
	game_state = manager.get_game_state()
	Signals.page_collected.connect(_display_text)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		_display_text()


func _display_text():
	_setup_ui()
	
	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)
	
	# Make the text appear
	tween.tween_property(self, "modulate", Color.WHITE, appear_time
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", finish_position, appear_time
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	# Get randomized easing/transition for next tween
	var settings = page_text_tweens.pick_random()
	
	# Do the number change
	tween = create_tween()
	tween.tween_property(page_numbers_container, "position", container_finish_position, move_time
		).set_ease(settings[0]).set_trans(settings[1])
	await tween.finished
	
	# Wait for display time
	await get_tree().create_timer(display_time).timeout
	
	# Make the text disappear
	tween = create_tween().set_parallel(true)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, disappear_time
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", start_position, disappear_time
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func _setup_ui():
	# Text
	pages_text.text = "Pages:    /%s" % [game_state.current_pages_required]
	pages_old_number.text = str(game_state.current_pages_collected - 1)
	pages_new_number.text = str(game_state.current_pages_collected)
	
	# Parent node
	modulate = Color.TRANSPARENT
	position = start_position
	
	# Container
	page_numbers_container.position = container_start_position
