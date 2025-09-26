extends CanvasLayer

var pages: int = 0

@onready var pages_text: RichTextLabel = $PagesText

func _ready() -> void:
	Signals.page_collected.connect(display_pages)

func display_text_smooth(new_text: String, start_time: float, end_time: float, duration: float):
	pages_text.visible_characters = 0
	pages_text.text = new_text
	change_visible_characters(pages_text, pages_text.get_total_character_count(), start_time)
	await get_tree().create_timer(duration).timeout
	change_visible_characters(pages_text, 0, end_time)

func display_pages():
	pages += 1
	var page_number: String = str(pages)
	var shake_rate: String = str(get_shake_rate(pages))
	
	pages_text.visible_characters = 0
	pages_text.text = "[shake rate=" + shake_rate + "]Pages " + page_number + "/8"
	change_visible_characters(pages_text, pages_text.get_total_character_count(), 0.5)
	await get_tree().create_timer(2.5).timeout
	change_visible_characters(pages_text, 0, 0.5)

func get_shake_rate(page_amount: int) -> int:
	var rate = page_amount - 2
	if rate < 1:
		return 0
	elif rate < 8:
		return rate * 3
	else:
		return 0

func change_visible_characters(text: RichTextLabel, visible_chars: int, time: float):
	create_tween().tween_property(text, "visible_characters", visible_chars, time)

func taking_too_long():
	change_visible_characters($TooLongText, $TooLongText.get_total_character_count(), 1)
	await get_tree().create_timer(2.5).timeout
	change_visible_characters($TooLongText, 0, 1)
