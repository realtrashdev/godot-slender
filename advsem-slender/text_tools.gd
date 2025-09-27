class_name TextTools

## Tweens the visible characters of the text_object to a specified amount.
## Typically this is either 0, or the text_object's get_total_character_count().
static func change_visible_characters(text_object: RichTextLabel, char_display_amount: int, time: float):
	text_object.create_tween().tween_property(text_object, "visible_characters", char_display_amount, time)

## Calls change_visible_characters to show text, waits a specified amount of time, and then automatically calls it again to go back to 0.
static func change_visible_characters_timed(text_object: RichTextLabel, char_display_amount: int, show_time: float, wait_time: float, delete_time: float):
	change_visible_characters(text_object, char_display_amount, show_time)
	await text_object.get_tree().create_timer(wait_time).timeout
	change_visible_characters(text_object, 0, delete_time)
