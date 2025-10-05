class_name Map extends Resource

@export_category("Basic Info")
@export var map_name: GameConfig.Map
@export_multiline var description: String
@export var scene: PackedScene
@export var scenarios: Array[ClassicModeScenario]
