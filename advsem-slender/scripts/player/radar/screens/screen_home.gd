extends Node2D

var base: RadarScreen

@onready var pages_text: RichTextLabel = $PagesText

func _ready() -> void:
	base = get_parent()
	Signals.page_collected.connect(update_pages_text)
	call_deferred("update_pages_text")

func update_pages_text():
	pages_text.text = "PAGES:\n%s / %s" % [str(base.game_state.current_pages_collected), str(base.game_state.current_pages_required)]
