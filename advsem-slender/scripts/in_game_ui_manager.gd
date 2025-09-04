extends CanvasLayer

var pages: int = 0

@onready var pages_text: RichTextLabel = $PagesText

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	Signals.page_collected.connect(display_pages)
	pages_text.text = ""

func display_pages():
	pages += 1
	var page_number: String = str(pages)
	var shake_rate: String = str(get_shake_rate(pages))
	
	pages_text.text = "[shake rate=" + shake_rate + "]Pages " + page_number + "/8"
	await get_tree().create_timer(3).timeout
	pages_text.text = ""

func get_shake_rate(pages: int) -> int:
	var rate = pages - 3
	if rate < 1:
		return 0
	else:
		return rate * 2
