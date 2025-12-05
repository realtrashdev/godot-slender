shader_type canvas_item;

uniform sampler2D texture1;
uniform sampler2D texture2;
uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 color1 = texture(texture1, UV);
    vec4 color2 = texture(texture2, UV);
    COLOR = mix(color1, color2, progress);
}