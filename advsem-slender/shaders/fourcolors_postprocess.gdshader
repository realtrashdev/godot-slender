shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec4 shade_0 : source_color;
uniform vec4 shade_1 : source_color;
uniform vec4 shade_2 : source_color;
uniform vec4 shade_3 : source_color;

void fragment() {
    // Sample the rendered scene
    vec4 tex_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Compute luminance from RGB (standard luma weights)
    float luma = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    vec4 result_color;
    if (luma > 0.6) {
        result_color = shade_0;
    }
    else if (luma > 0.35) {
        result_color = shade_1;
    }
    else if (luma > 0.1) {
        result_color = shade_2;
    }
    else {
        result_color = shade_3;
    }

    // Replace the screen color
    ALBEDO = result_color.rgb;
    ALPHA  = tex_color.a;
}