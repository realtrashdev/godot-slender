extends Button

var default_size: Vector2
var default_font_size: float

@export var focused_size: Vector2 = Vector2(0, 130)
@export var focused_font_size: float
@export var focus_speed: float = 8

var focused: bool = false

func _ready() -> void:
	default_size = custom_minimum_size

func _process(delta: float) -> void:
	match focused:
		true:
			custom_minimum_size = lerp(custom_minimum_size, focused_size, focus_speed * delta)
		false:
			custom_minimum_size = lerp(custom_minimum_size, default_size, focus_speed * delta)
		_:
			print("how")

func _on_mouse_entered() -> void:
	focused = true

func _on_mouse_exited() -> void:
	focused = false
