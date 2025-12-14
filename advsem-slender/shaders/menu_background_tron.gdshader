shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(0.1, 0.0, 0.2, 1.0);
uniform vec4 color2 : source_color = vec4(0.8, 0.2, 0.3, 1.0);

void vertex() {
	UV.x *= 4.0;
	UV.y *= 2.25;
	
	UV.x += TIME * 0.05;
	UV.y += TIME * 0.05;
}

void fragment() {
	//back grid
	if (mod(UV.x, 0.2) < 0.175 && mod(UV.y, 0.2) < 0.175) {
		COLOR = color1;
	}
	else {
		COLOR = color2;
	}
	
	//front grid outline
	if (mod(UV.x / 2.5 + -TIME * 0.05, 0.25) < 0.04) {
		COLOR = color1;
	}
	if (mod(UV.y / 2.5 + -TIME * 0.05, 0.25) < 0.04) {
		COLOR = color1;
	}
	if (mod(UV.x / 2.5 + -TIME * 0.05, 0.25) > 0.24) {
		COLOR = color1;
	}
	if (mod(UV.y / 2.5 + -TIME * 0.05, 0.25) > 0.24) {
		COLOR = color1;
	}
	
	//front grid
	if (mod(UV.x / 2.5 + -TIME * 0.05, 0.25) < 0.03) {
		COLOR = color2;
	}
	if (mod(UV.y / 2.5 + -TIME * 0.05, 0.25) < 0.03) {
		COLOR = color2;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
