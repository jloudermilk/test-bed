/* Shader for the container glass itself. Renders behind the liquid. */

shader_type spatial;

/* Cull all front facing faces. */
render_mode cull_disabled;

uniform vec4 glass_color : source_color;
uniform vec4 glint_color : source_color;

void fragment() {
	ALBEDO = glass_color.rgb;
	ALPHA = glass_color.a;
	// Add glint effect here if needed
	EMISSION = glint_color.rgb * 0.1; // Simple emission for glass glint
}