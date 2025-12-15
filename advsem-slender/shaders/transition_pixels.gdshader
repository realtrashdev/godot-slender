shader_type canvas_item;
uniform sampler2D noise_img: repeat_enable;
uniform float transition_amount: hint_range(0.0, 1.0);

void vertex() {
	
}

void fragment() {
    vec4 tex_color = texture(noise_img, UV);
    float luma = tex_color.r;
    
    COLOR = vec4(0, 0, 0, 1);
    float adjusted_transition = transition_amount * 1.002 - 0.001;
    COLOR.a = step(luma, adjusted_transition);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
