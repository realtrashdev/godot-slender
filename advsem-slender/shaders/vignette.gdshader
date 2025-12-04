shader_type canvas_item;

// Vignette customization parameters
uniform float vignette_intensity : hint_range(0.0, 1.0, 0.01) = 0.5; // How dark the edges get
uniform float vignette_radius : hint_range(0.0, 2.0, 0.05) = 0.8; // Size of bright center area
uniform float vignette_softness : hint_range(0.0, 2.0, 0.05) = 0.5; // How soft the falloff is
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Color of the vignette
uniform vec2 screen_size = vec2(1920.0, 1080.0); // Your viewport resolution
uniform float dither_strength : hint_range(0.0, 0.02, 0.001) = 0.005; // Dithering to reduce banding

// Simple noise function for dithering
float random(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Calculate aspect ratio
    float aspect = screen_size.x / screen_size.y;
    
    // Adjust UV coordinates to account for aspect ratio
    vec2 adjusted_uv = UV - 0.5;
    adjusted_uv.x *= aspect;
    
    // Calculate distance from center with corrected aspect ratio
    float dist = length(adjusted_uv);
    
    // Normalize distance
    dist = dist / (0.707 * aspect);
    
    // Apply radius and softness to create falloff
    float vignette = smoothstep(vignette_radius, vignette_radius + vignette_softness, dist);
    
    // Add dithering to break up banding
    float dither = random(FRAGCOORD.xy) * dither_strength;
    vignette += dither;
    
    // Apply intensity
    vignette *= vignette_intensity;
    
    // Clamp to valid range
    vignette = clamp(vignette, 0.0, 1.0);
    
    // Output vignette color with alpha based on distance
    COLOR = vec4(vignette_color.rgb, vignette * vignette_color.a);
}