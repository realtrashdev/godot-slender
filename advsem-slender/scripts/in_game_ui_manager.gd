extends CanvasLayer

var pages: int = 0

@onready var pages_text: RichTextLabel = $PagesText

func _ready() -> void:
	Signals.page_collected.connect(display_pages)
	
	change_visible_characters(pages_text.get_total_character_count(), 1)
	await get_tree().create_timer(3).timeout
	change_visible_characters(0, 1)

func display_pages():
	pages += 1
	var page_number: String = str(pages)
	var shake_rate: String = str(get_shake_rate(pages))
	
	pages_text.text = "[shake rate=" + shake_rate + "]Pages " + page_number + "/8"
	change_visible_characters(pages_text.get_total_character_count(), 0.5)
	await get_tree().create_timer(2.5).timeout
	change_visible_characters(0, 0.5)

func get_shake_rate(page_amount: int) -> int:
	var rate = page_amount - 3
	if rate < 1:
		return 0
	else:
		return rate * 2

func change_visible_characters(visible_chars: int, time: float):
	var tween = create_tween()
	tween.tween_property(pages_text, "visible_characters", visible_chars, time)
