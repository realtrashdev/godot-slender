/*
Shader from Godot Shaders - the free shader library.
godotshaders.com/shader/pixelate

This shader is under CC0 license. Feel free to use, improve and 
change this shader according to your needs and consider sharing 
the modified result to godotshaders.com.
*/

shader_type canvas_item;

uniform int amount = 40;

uniform sampler2D screen_tex : hint_screen_texture, filter_nearest;
uniform vec2 screen_size = vec2(1920.0, 1080.0);

void fragment()
{
	vec2 blocks = vec2(float(amount), float(amount) * screen_size.y / screen_size.x);
	vec2 grid_uv = round(SCREEN_UV * blocks) / blocks;
	COLOR = texture(screen_tex, grid_uv);
}