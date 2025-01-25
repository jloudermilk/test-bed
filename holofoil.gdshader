shader_type spatial;
render_mode blend_mix,depth_prepass_alpha,diffuse_burley,specular_schlick_ggx;


uniform sampler2D foil: source_color;
uniform float threshold = 0.1;
uniform float effect_alpha_mult : hint_range(0.1,1) = 1.0;
uniform float direction : hint_range(0,1) = 0.5;
uniform float specular = 1.0;
uniform float metallic : hint_range(0,1) = 0.75 ;
uniform float roughness: hint_range(0,1) = 0.75;
uniform float emission_energy: hint_range(0,1) = 0.2; 
uniform sampler2D gradient: source_color;
uniform float reflectiveShift: hint_range(0.0, 1.0);


void fragment() {
	vec2 base_uv = UV;
	vec4 foil_tex = texture(foil,UV);
	vec4 gradient_tex = texture(gradient, vec2(reflectiveShift,1.0) + vec2((0.25+(NORMAL.y*direction*2.0-NORMAL.x*(1.0-direction)*2.0)/2.0+(UV.y*direction+UV.x*(1.0-direction))/2.0), 0.0));
	ALPHA = 0.0;
	if(foil_tex.r < threshold && foil_tex.g < threshold && foil_tex.b < threshold && foil_tex.a > 0.3)
	{
		METALLIC = metallic;
		ROUGHNESS = roughness;
		SPECULAR = specular;
		ALBEDO = gradient_tex.rgb;
		ALPHA = gradient_tex.a;
		EMISSION =  ALBEDO*emission_energy;
	}
}