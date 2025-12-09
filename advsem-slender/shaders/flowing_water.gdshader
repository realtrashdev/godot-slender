shader_type spatial;

uniform sampler2DArray textures: filter_nearest, repeat_enable;
uniform float swap_interval: hint_range(0.1, 10.0) = 1.0;
uniform float triplanar_sharpness: hint_range(1.0, 20.0) = 5.0;
uniform float texture_scale: hint_range(0.1, 10.0) = 1.0;
uniform float scroll_speed: hint_range(0.0, 5.0) = 0.5;

varying vec3 world_pos;
varying vec3 world_normal;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    world_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
}

void fragment() {
    // Make scrolling more visible - scroll in XZ plane for water
    vec2 scroll_offset = vec2(TIME * scroll_speed, 0.0);
    
    vec3 scaled_pos = world_pos * texture_scale;
    
    // Calculate triplanar blend weights
    vec3 blend = abs(world_normal);
    blend = pow(blend, vec3(triplanar_sharpness));
    blend /= (blend.x + blend.y + blend.z);
    
    int tex_index = int(floor(TIME / swap_interval)) % 2;
    
    // Sample with scrolling applied to UV coordinates
    vec3 x_proj = texture(textures, vec3(scaled_pos.z + scroll_offset.x, scaled_pos.y + scroll_offset.y, float(tex_index))).rgb;
    vec3 y_proj = texture(textures, vec3(scaled_pos.x + scroll_offset.x, scaled_pos.z + scroll_offset.y, float(tex_index))).rgb;
    vec3 z_proj = texture(textures, vec3(scaled_pos.x + scroll_offset.x, scaled_pos.y + scroll_offset.y, float(tex_index))).rgb;
    
    ALBEDO = x_proj * blend.x + y_proj * blend.y + z_proj * blend.z;
}