extends Camera3D


func set_fov_smooth(new_fov: float, time: float):
	create_tween().tween_property(self, "fov", new_fov, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
