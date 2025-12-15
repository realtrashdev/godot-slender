shader_type canvas_item;
uniform sampler2D noise_img: repeat_enable;
uniform vec4 color1 : source_color = vec4(0.1, 0.0, 0.2, 1.0);
uniform vec4 color2 : source_color = vec4(0.8, 0.2, 0.3, 1.0);
uniform float band_width : hint_range(0.0, 1.0) = 0.5;

void vertex() {
	//float scale_amount = 1.0 + sin(TIME * 0.3) * 0.1;
	//UV.x *= scale_amount;
	UV.x += sin(TIME * 0.1) * 0.2;
	UV.y += TIME * 0.025;
}

void fragment() {
	float time = TIME * 0.02;
	
    vec4 tex_color = texture(noise_img, UV);
    float luma = tex_color.r;
    
    float threshold = mod(time, 1.0);
    
    float dist = abs(luma - threshold);
    dist = min(dist, 1.0 - dist);
    
    if (dist <= band_width * 0.5) {
        COLOR = color1;
    }
	else {
        COLOR = color2;
    }
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
