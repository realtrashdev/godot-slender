class_name ScreenEffects extends CanvasLayer

var crt: ShaderMaterial
var vignette: ShaderMaterial

func _ready() -> void:
	crt = $Scanlines.material
	vignette = $Vignette.material
	
	update_crt_opacity(Settings.get_crt_opacity())
	update_vignette_intensity(Settings.get_vignette_intensity())
	
	Settings.setting_changed.connect(_on_setting_changed)

func update_crt_opacity(new_value: float):
	crt.set_shader_parameter("line_opacity", new_value)

func update_vignette_intensity(new_value: float):
	vignette.set_shader_parameter("vignette_intensity", new_value)

func _on_setting_changed(setting_name: String, value):
	match setting_name:
		"crt_opacity":
			update_crt_opacity(value)
		"vignette_intensity":
			update_vignette_intensity(value)
