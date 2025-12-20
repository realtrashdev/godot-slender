extends VBoxContainer

const ICON_SCENE = preload("res://scenes/ui/buttons/character_icon.tscn")

var page_number: int
var profiles: Array[EnemyProfile]

@onready var header: RichTextLabel = $RichTextLabel
@onready var icon_container: VBoxContainer = $SmoothScrollContainer/EnemyIconContainer

func initialize(num: int, prf: Array[EnemyProfile], index: float):
	page_number = num
	profiles = prf
	header.text = _get_header_text()
	_add_icons()

func _get_header_text():
	match page_number:
		0:
			return "Instant"
		1:
			return "1 Page"
		_:
			return "%s Pages" % page_number

func _add_icons():
	for profile in profiles:
		var icon: CharacterIcon = ICON_SCENE.instantiate()
		icon.profile = profile
		icon_container.add_child(icon)
		icon.button.disabled = true
