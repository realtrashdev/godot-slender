shader_type canvas_item;

// Scanline customization parameters
uniform float line_density : hint_range(50.0, 300.0, 10.0) = 100.0; // Lines per screen height
uniform float line_opacity : hint_range(0.0, 1.0, 0.01) = 0.3; // How dark the scanlines are
uniform float line_thickness : hint_range(0.1, 0.9, 0.05) = 0.5; // Thickness of dark lines (0.5 = half screen is lines)
uniform bool enable_flicker = false; // Subtle scanline flicker
uniform float flicker_speed : hint_range(0.1, 10.0, 0.1) = 5.0;
uniform float flicker_intensity : hint_range(0.0, 0.1, 0.01) = 0.02;

void fragment() {
    // Calculate scanline position based on screen coordinates
    float scanline_position = UV.y * line_density;

    // Use fract to get sharp repeating pattern (0 to 1)
    float scanline = fract(scanline_position);

    // Create hard edge - if below thickness threshold, it's a dark line
    scanline = step(line_thickness, scanline);

    // Optional flicker effect
    float flicker_amount = 0.0;
    if (enable_flicker) {
        flicker_amount = sin(TIME * flicker_speed + scanline_position) * flicker_intensity;
    }

    // Calculate darkness (0 = dark line, 1 = bright gap)
    float darkness = mix(0.0, 1.0, scanline);
    darkness += flicker_amount;

    // Output black with varying alpha based on scanline
    COLOR = vec4(0.0, 0.0, 0.0, line_opacity / 3.0 * (1.0 - darkness));
}