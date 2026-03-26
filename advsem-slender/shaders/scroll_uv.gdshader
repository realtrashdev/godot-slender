shader_type canvas_item;
uniform float scroll_x;
uniform float scroll_y;
uniform bool sin_x;
uniform float sin_mult_x;
uniform float time_mult_x;

void vertex() {
	if (sin_x)
	{
		UV.x += sin(scroll_x * (TIME * time_mult_x)) * sin_mult_x;
	}
	else
	{
		UV.x += scroll_x * TIME;
	}
	UV.y += scroll_y * TIME;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
