extends Camera3D


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "fov", 80, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
