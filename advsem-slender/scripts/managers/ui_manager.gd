class_name UIManager extends CanvasLayer

const PG_CHARACTER_TIME: float = 0.5
const PG_DISPLAY_TIME: float = 2.5
const TL_CHARACTER_TIME: float = 1
const TL_DISPLAY_TIME: float = 4

var game_state: GameState
var tip_manager: TipManager

@onready var pages_text: RichTextLabel = $PagesText
@onready var too_long_text: RichTextLabel = $TooLongText

func initialize(state: GameState):
	game_state = state
	tip_manager = TipManager.new()
	
	# connect to signals and handle internally
	Signals.page_collected.connect(_on_page_collected)

func _on_page_collected():
	update_pages()

# public interface
func show_game_start():
	await get_tree().create_timer(1).timeout
	show_tip()
	await get_tree().create_timer(5).timeout

func show_tip():
	var tip = tip_manager.get_random_tip()
	display_text("[wave]Tip:\n" + tip, 1, 5, 0)

func show_objective():
	display_text("[wave]Collect %d pages" % game_state.current_pages_required, 1, 3, 1)

func taking_too_long():
	display_text(too_long_text.text, TL_CHARACTER_TIME, TL_DISPLAY_TIME, TL_CHARACTER_TIME, too_long_text)

func show_game_end():
	# results screen
	pass

# internal methods
func update_pages():
	display_text(get_pages_text(), PG_CHARACTER_TIME, PG_DISPLAY_TIME, PG_CHARACTER_TIME, pages_text)

func get_pages_text() -> String:
	var shake_rate = str(get_shake_rate(game_state.current_pages_collected))
	return "[shake rate=%s]Pages %s/%s" % [shake_rate, game_state.current_pages_collected, game_state.current_pages_required]

func get_shake_rate(page_amount: int) -> int:
	var rate = page_amount - 2
	if rate < 1:
		return 0
	else:
		return rate * 3

func display_text(new_text: String, open_time: float, display_time: float, close_time: float, text_object: RichTextLabel = pages_text):
	text_object.text = new_text
	TextTools.change_visible_characters_timed(text_object, text_object.get_total_character_count(), open_time, display_time, close_time)
