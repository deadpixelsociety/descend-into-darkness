shader_type canvas_item;
render_mode blend_add;

// Darkness
uniform vec4 darkness_color: source_color = vec4(0.3, 0.0, 0.3, 1.0);
uniform float darkness_level: hint_range(0.0, 1.0, 0.1) = 0.8;
uniform vec2 darkness_size;
uniform vec2 darkness_offset;
// Lights
uniform int light_count;
uniform vec2[64] light_positions;
uniform vec4[64] light_colors;
uniform float[64] light_radii;
uniform float radius2_multi;
uniform float radius3_multi;
uniform float radius1_alpha;
uniform float radius2_alpha;
uniform float radius3_alpha;
uniform float pulse_distance = 4.0;
uniform float pulse_speed = 2.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 final_color = color;
	
	if(darkness_level > 0.0) {
		vec2 uv = UV - 0.5;
		vec2 darkness_position = darkness_offset + (uv * darkness_size);
		vec4 darkness = vec4(mix(color.rgb, darkness_color.rgb, darkness_level), 1.0);
		
		bool l1set = false;
		bool l2set = false;
		bool l3set = false;
		for(int i = 0; i < light_count; i++) {
			vec2 light_position = light_positions[i];
			vec4 light_color = light_colors[i];
			float light_radius1 = light_radii[i];
			float light_radius2 = light_radius1 * radius2_multi;
			float light_radius3 = light_radius2 * radius3_multi;
			
			//float offset = pulse_distance * sin(TIME * pulse_speed);
			float offset = 0.0;
			float lr1 = light_radius1 + offset;
			float lr2 = light_radius2 + offset;
			float lr3 = light_radius3 + offset;

			float d = distance(light_position, darkness_position);
			if(d < lr1) {
				final_color.rgb = mix(color.rgb, light_color.rgb, 0.2 * radius1_alpha);
				l1set = true;
				break;
			} else if(d < lr2 && d > lr1 && !l1set) {
				final_color.rgb = mix(color.rgb, light_color.rgb, 0.2 * radius2_alpha);
				final_color.rgb = mix(final_color.rgb, darkness.rgb, radius2_alpha);
				l2set = true;
			} else if(d < lr3 && d > lr2 && !l1set && !l2set) {
				final_color.rgb = mix(color.rgb, light_color.rgb, 0.2 * radius3_alpha);
				final_color.rgb = mix(final_color.rgb, darkness.rgb, radius3_alpha);
				l3set = true;
			} else if(!l1set && !l2set && !l3set) {
				final_color.rgb = darkness.rgb;
			}
		}
	}
	
	COLOR = final_color;
}
