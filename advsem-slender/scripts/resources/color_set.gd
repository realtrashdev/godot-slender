extends Resource
class_name ColorSet

@export_group("Basic Info")
@export var name: String = "mono"
@export var description: String = "color palette"
@export var colors: Array[Color] = []

@export_group("Unlocking")
@export var unlock_requirements: Dictionary[String, Array] = {
	"scenarios": [],
}
@export_multiline var unlock_description: String
