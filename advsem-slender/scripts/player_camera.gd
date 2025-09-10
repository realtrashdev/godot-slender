extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "fov", 80, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
