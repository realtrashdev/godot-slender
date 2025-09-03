shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec4 shade_0 : source_color;
uniform vec4 shade_1 : source_color;
uniform vec4 shade_2 : source_color;
uniform vec4 shade_3 : source_color;
uniform vec4 shade_4 : source_color;
uniform vec4 shade_5 : source_color;
uniform vec4 shade_6 : source_color;
uniform vec4 shade_7 : source_color;

void fragment() {
    // Sample the already-rendered screen
    vec4 tex_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Compute luminance properly (instead of just red channel)
    float luma = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    vec4 result_color;
    if (luma > 0.95) {
        result_color = shade_0;
    }
	else if (luma > 0.8) {
		result_color = shade_1;
	}
	else if (luma > 0.7) {
		result_color = shade_2;
	}
	else if (luma > 0.6) {
		result_color = shade_3;
	}
    else if (luma > 0.5) {
        result_color = shade_4;
    }
	else if (luma > 0.4) {
		result_color = shade_5;
	}
    else if (luma > 0.25) {
        result_color = shade_6;
    }
    else {
        result_color = shade_7;
    }

    COLOR = vec4(result_color.rgb, tex_color.a);
}