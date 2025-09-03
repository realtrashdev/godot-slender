shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec4 shade_0 : source_color;
uniform vec4 shade_1 : source_color;
uniform vec4 shade_2 : source_color;
uniform vec4 shade_3 : source_color;

void fragment() {
    // Sample the already-rendered screen
    vec4 tex_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Compute luminance properly (instead of just red channel)
    float luma = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    vec4 result_color;
    if (luma > 0.7) {
        result_color = shade_0;
    }
    else if (luma > 0.4) {
        result_color = shade_1;
    }
    else if (luma > 0.2) {
        result_color = shade_2;
    }
    else {
        result_color = shade_3;
    }

    COLOR = vec4(result_color.rgb, tex_color.a);
}