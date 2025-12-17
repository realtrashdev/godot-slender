extends Node2D

var base: RadarScreen

@onready var pages_text: RichTextLabel = $PagesText

func _ready() -> void:
	base = get_parent()
	Signals.page_collected.connect(update_pages_text)
	call_deferred("update_pages_text")

func update_pages_text():
	if Settings.get_selected_scenario().resource_name == "tutorial":
		pages_text.text = "NO SIGNAL"
		return
	if base.game_state:
		pages_text.text = "PAGES:\n%s / %s" % [str(base.game_state.current_pages_collected), str(base.game_state.current_pages_required)]
	else:
		push_warning("%s: Could not find game state" % name)
