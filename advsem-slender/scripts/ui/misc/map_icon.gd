extends VBoxContainer

const START_DELAY: float = 0.4
const MAP_EFFECT: String = "[wave]%s[/wave]"

var map_tween: Tween
var scenario_tween: Tween

@onready var map_text: RichTextLabel = $MapText
@onready var scenario_text: RichTextLabel = $ScenarioText

@onready var icon: TextureRect = $PanelContainer/TextureRect
var image_fade_material: ShaderMaterial
var fade_tween: Tween

func _ready() -> void:
	image_fade_material = icon.material
	
	map_text.visible_ratio = 0
	scenario_text.visible_ratio = 0
	await get_tree().create_timer(START_DELAY).timeout
	map_tween = create_tween()
	map_tween.tween_property(map_text, "visible_ratio", 1, 0.5)
	await map_tween.finished
	scenario_tween = create_tween()
	scenario_tween.tween_property(scenario_text, "visible_ratio", 1, 0.2)

# public functions
func update_map_text(map: Map):
	if map_tween:
		map_tween.kill()
	
	map_text.visible_ratio = 0
	map_text.text = MAP_EFFECT % map.map_name
	
	map_tween = create_tween()
	map_tween.tween_property(map_text, "visible_ratio", 1, 0.5)
	
	icon.texture = map.icon
	fade_map_image(map.icon)

func update_scenario_text(scenario: ClassicModeScenario):
	if scenario_tween:
		scenario_tween.kill()
	
	scenario_text.visible_ratio = 0
	scenario_text.text = scenario.name
	
	scenario_tween = create_tween()
	scenario_tween.tween_property(scenario_text, "visible_ratio", 1, 0.2)

## Uses a shader to fade between images instead of hard cutting
func fade_map_image(new_image: Texture2D):
	# get current texture before starting fade
	image_fade_material.set_shader_parameter("texture2", new_image)
	image_fade_material.set_shader_parameter("progress", 0.0)
	
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()
	await fade_tween.tween_property(image_fade_material, "shader_parameter/progress", 1, 0.5).set_ease(Tween.EASE_IN).finished
	
	# update texturerect texture and reset shader
	image_fade_material.set_shader_parameter("texture1", new_image)
	image_fade_material.set_shader_parameter("progress", 0.0)
