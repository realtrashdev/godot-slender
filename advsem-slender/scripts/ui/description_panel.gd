class_name DescriptionPanel extends Panel

const DISPLAY_DURATION: float = 0.25
const OFFSET_FROM_ICON: float = 25.0

var tween: Tween

var parent_icon: CharacterIcon
var current_profile: CharacterProfile

@onready var text_container: VBoxContainer = $TextContainer
@onready var name_label: RichTextLabel = $TextContainer/NameLabel
@onready var category_label: RichTextLabel = $TextContainer/CategoryLabel
@onready var description_label: RichTextLabel = $TextContainer/DescriptionLabel

func _ready() -> void:
	parent_icon = get_parent() as CharacterIcon

func _input(event: InputEvent) -> void:
	# allow scrolling only when description is visible
	if modulate.a > 0:
		var scroll_delta = Input.get_axis("ui_text_scroll_up", "ui_text_scroll_down")
		description_label.get_v_scroll_bar().value += scroll_delta * 20

func set_profile(profile: CharacterProfile) -> void:
	current_profile = profile
	update_content()

func update_content() -> void:
	if not current_profile:
		return
	
	var display_name = get_display_name()
	name_label.text = "[tornado radius=3 freq=4]%s[/tornado]" % display_name.to_upper()
	
	category_label.text = get_category_effect() % get_type_string()
	
	description_label.text = current_profile.description

func get_display_name() -> String:
	if current_profile.name == "default":
		return SaveManager.get_player_name()
	return current_profile.name

func get_category_effect() -> String:
	match current_profile.type:
		CharacterProfile.Type.NUISANCE:
			return "[shake rate=6 level=4]%s[/shake]"
		CharacterProfile.Type.DANGEROUS:
			return "[shake rate=9 level=5]%s[/shake]"
		CharacterProfile.Type.LETHAL:
			return "[shake rate=12 level=6]%s[/shake]"
	return "[wave amp=5]%s[/wave]"

func get_type_string() -> String:
	return current_profile.Type.keys()[current_profile.type]

func show_description() -> void:
	update_position()
	
	modulate = Color.WHITE
	name_label.visible_ratio = 1
	category_label.visible_ratio = 1
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(description_label, "visible_ratio", 1, DISPLAY_DURATION)

func hide_description() -> void:
	description_label.get_v_scroll_bar().value = 0
	
	modulate = Color.TRANSPARENT
	name_label.visible_ratio = 0
	category_label.visible_ratio = 0
	
	if tween:
		tween.kill()
	description_label.visible_ratio = 0

func hide_immediate() -> void:
	modulate = Color.TRANSPARENT
	name_label.visible_ratio = 0
	category_label.visible_ratio = 0
	description_label.visible_ratio = 0

func update_position() -> void:
	await get_tree().process_frame
	
	if not parent_icon:
		return
	
	var viewport_rect = get_viewport().get_visible_rect()
	var icon_center = parent_icon.global_position + (parent_icon.size / 2)
	var icon_half_width = parent_icon.active_size.x / 2
	
	# calculate where tooltip would be if placed to the right
	var right_edge = icon_center.x + icon_half_width + OFFSET_FROM_ICON + size.x
	
	# if panel would go off screen, place it on left
	if right_edge > viewport_rect.size.x:
		# left
		global_position = icon_center + Vector2(-icon_half_width - size.x - OFFSET_FROM_ICON, -size.y / 2)
	else:
		# right (default)
		global_position = icon_center + Vector2(icon_half_width + OFFSET_FROM_ICON, -size.y / 2)
