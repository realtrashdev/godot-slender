shader_type spatial;

uniform sampler2D albedo_texture : source_color;

uniform vec4 shade_0 : source_color;
uniform vec4 shade_1 : source_color;
uniform vec4 shade_2 : source_color;
uniform vec4 shade_3 : source_color;

void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);
    float luma = tex_color.r;

    vec4 result_color;
    if (luma > 0.75) {
        result_color = shade_0;
    }
    else if (luma > 0.5) {
        result_color = shade_1;
    }
    else if (luma > 0.25) {
        result_color = shade_2;
    }
    else {
        result_color = shade_3;
    }

    ALBEDO = result_color.rgb;
    ALPHA = tex_color.a;
}