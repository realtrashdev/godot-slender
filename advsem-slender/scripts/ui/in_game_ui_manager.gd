extends CanvasLayer

# CHARACTER_TIME: how long it takes for characters show/unshow fully
# DISPLAY_TIME: how long the text displays for

# pages text
const PG_CHARACTER_TIME: float = 0.5
const PG_DISPLAY_TIME: float = 2.5

# too long text
const TL_CHARACTER_TIME: float = 1
const TL_DISPLAY_TIME: float = 4

var pages: int = 0

@onready var pages_text: RichTextLabel = $PagesText
@onready var too_long_text: RichTextLabel = $TooLongText

func _ready() -> void:
	Signals.page_collected.connect(update_pages)

func display_text(new_text: String, open_time: float, display_time: float, close_time: float, text_object: RichTextLabel = pages_text):
	text_object.text = new_text
	TextTools.change_visible_characters_timed(text_object, text_object.get_total_character_count(), open_time, display_time, close_time)

func update_pages():
	pages += 1
	display_text(get_pages_text(), PG_CHARACTER_TIME, PG_DISPLAY_TIME, PG_CHARACTER_TIME, pages_text)

func get_pages_text() -> String:
	var page_number: String = str(pages)
	var shake_rate: String = str(get_shake_rate(pages))
	return "[shake rate=" + shake_rate + "]Pages " + page_number + "/8"

func get_shake_rate(page_amount: int) -> int:
	var rate = page_amount - 2
	if rate < 1:
		return 0
	elif rate < 8:
		return rate * 3
	else:
		return 0

func taking_too_long():
	display_text(too_long_text.text, TL_CHARACTER_TIME, TL_DISPLAY_TIME, TL_CHARACTER_TIME, too_long_text)

func reset():
	pages = 0
