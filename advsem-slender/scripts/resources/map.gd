class_name Map extends Resource

@export_category("Basic Info")
@export var map_name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var scene: PackedScene
@export var scenarios: Array[ClassicModeScenario]
