shader_type canvas_item;
render_mode blend_mix;

uniform vec4 light_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 darkness_color: source_color = vec4(0.3, 0.0, 0.3, 1.0);
uniform float darkness_level: hint_range(0.0, 1.0, 0.1) = 0.8;
uniform vec2 darkness_size;
uniform vec2 darkness_offset;
uniform int light_count;
uniform vec2[64] light_positions;
uniform float layer1_radius;
uniform float layer1_alpha;
uniform float layer2_radius;
uniform float layer2_alpha;
uniform float layer3_radius;
uniform float layer3_alpha;
uniform float pulse_distance = 4.0;
uniform float pulse_speed = 2.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 final_color = color;
	
	if(darkness_level > 0.0) {
		vec2 uv = UV - 0.5;
		vec2 darkness_pos = darkness_offset + (uv * darkness_size);
		
		bool l1set = false;
		bool l2set = false;
		bool l3set = false;
		for(int i = 0; i < light_count; i++) {
			vec2 pos = light_positions[i];
			
			float offset = pulse_distance * sin(TIME * pulse_speed);
			float l1r = layer1_radius + offset;
			float l2r = layer2_radius + offset;
			float l3r = layer3_radius + offset;

			float d = distance(pos, darkness_pos);
			if(d < l1r) {
				final_color.rgb = mix(color.rgb, light_color.rgb, 0.2 * layer1_alpha);
				l1set = true;
			} else if(d < l2r && d > l1r && !l1set) {
				final_color.rgb = mix(color.rgb, light_color.rgb, 0.2 * layer2_alpha);
				final_color.rgb = mix(final_color.rgb, darkness_color.rgb, 0.5 * darkness_level);
				l2set = true;
			} else if(d < l3r && d > l2r && !l1set && !l2set) {
				final_color.rgb = mix(color.rgb, light_color.rgb, 0.2 * layer3_alpha);
				final_color.rgb = mix(final_color.rgb, darkness_color.rgb, 0.8 * darkness_level);
				l3set = true;
			} else if(!l1set && !l2set && !l3set) {
				final_color.rgb = mix(color.rgb, darkness_color.rgb, darkness_level);
			}
		}
	}
	
	COLOR = final_color;
}
