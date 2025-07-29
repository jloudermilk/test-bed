shader_type spatial;
render_mode cull_disabled,unshaded;

uniform float fill_level : hint_range(0.0, 1.0) = 0.5;
uniform vec4 liquid_color : source_color = vec4(0.2, 0.6, 1.0, 1.0);
uniform vec4 top_color : source_color = vec4(0.2, 0.6, 1.0, 1.0);
uniform vec4 emission_color : source_color = vec4(0.1, 0.3, 0.8, 1.0);
uniform float emission_strength : hint_range(0.0, 2.0) = 0.3;
uniform float fresnel_power : hint_range(1.0, 5.0) = 2.0;
uniform float fresnel_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float wave_amplitude : hint_range(0.0, 0.02) = 0.005;
uniform float wave_frequency : hint_range(0.0, 10.0) = 3.0;
uniform float wave_speed : hint_range(0.0, 2.0) = 0.5;

varying vec3 world_position;
varying vec3 local_position;
varying float liquid_surface_level;
varying vec3 gravity_direction;

void vertex() {
    local_position = VERTEX;
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    
    // Get the world "up" direction (gravity always points down in world space)
    vec3 world_up = vec3(0.0, 1.0, 0.0);
    
    // Transform world up into local space to get gravity direction relative to object
    gravity_direction = normalize((inverse(MODEL_MATRIX) * vec4(world_up, 0.0)).xyz);
    
    // Calculate liquid surface based on gravity direction and fill level
    float distance_along_gravity = dot(local_position, gravity_direction);
    
    // Small wave effect
    float wave_offset = sin(world_position.x * wave_frequency + TIME * wave_speed) * 
                       cos(world_position.z * wave_frequency * 0.7 + TIME * wave_speed * 0.8) * 
                       wave_amplitude;
    
    // The liquid surface level depends on the object's rotation
    liquid_surface_level = mix(-1.0, 1.0, fill_level) + wave_offset;
    
    // If vertex is above liquid surface, move it down to the surface level
    if (distance_along_gravity > liquid_surface_level) {
        // Calculate how much to move the vertex to reach the surface
        float surface_offset = liquid_surface_level - distance_along_gravity;
        
        // Move vertex along gravity direction to the surface level
        VERTEX += gravity_direction * surface_offset;
        
        // Set normal to point opposite to gravity (upward from liquid surface)
        NORMAL = -gravity_direction;
    }
}

void fragment() {
    // Calculate distance along gravity direction for this fragment
    float distance_along_gravity = dot(local_position, gravity_direction);
    
    // Check if this fragment is below the liquid surface
    bool is_liquid = distance_along_gravity <= liquid_surface_level;
    
    // Calculate fresnel effect
    float fresnel = dot(NORMAL, VIEW);
    fresnel = clamp(1.0 - fresnel, 0.0, 1.0);
    fresnel = pow(fresnel, fresnel_power);
    

    EMISSION = emission_color.rgb * emission_strength;
    
    if (is_liquid) {
		
		if(FRONT_FACING){
        // Apply fresnel to emission - edges glow brighter
        EMISSION *= (1.0 + fresnel * fresnel_intensity);
        
        // Optional: Add depth-based emission variation
        float depth_factor = smoothstep(0.0, 0.3, liquid_surface_level - distance_along_gravity);
        EMISSION *= mix(1.0, 0.7, depth_factor);
        
        // Apply fresnel to albedo for more realistic liquid appearance
        ALBEDO = mix(liquid_color.rgb, liquid_color.rgb * 1.3, fresnel * 0.3);
		}
		else
		{
			ALBEDO = top_color.rgb;
		}
    }else{
		discard;
	}
}