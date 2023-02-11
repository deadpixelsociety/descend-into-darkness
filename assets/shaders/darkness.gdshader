shader_type canvas_item;

uniform vec4 light_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 darkness_color: source_color = vec4(0.3, 0.0, 0.3, 1.0);
uniform float darkness_level: hint_range(0.0, 0.9, 0.1) = 0.8;
uniform vec2 darkness_size;
uniform vec2 darkness_position;
uniform vec2[4] party_positions;
uniform float layer1_radius;
uniform float layer1_alpha;
uniform float layer2_radius;
uniform float layer2_alpha;
uniform float layer3_radius;
uniform float layer3_alpha;
uniform float pulse_distance = 4.0;
uniform float pulse_speed = 2.0;

void fragment() {
	vec4 darkness = darkness_color;
	darkness.a = darkness_level;
	
	if(darkness.a > 0.0) {
		vec2 uv = UV - 0.5;
		vec2 darkness_pos = uv * darkness_size;
		
		for(int i = 0; i < party_positions.length(); i++) {
			vec2 pos = party_positions[i];
			
			float layer1 = layer1_alpha * darkness_level;
			float layer2 = layer2_alpha * darkness_level;
			float layer3 = layer3_alpha * darkness_level;
			float offset = pulse_distance * sin(TIME * pulse_speed);
			float l1r = layer1_radius + offset;
			float l2r = layer2_radius + offset;
			float l3r = layer3_radius + offset;

			float d = distance(pos, darkness_pos);
			if(d < l1r) {
				darkness.rgb = light_color.rgb * darkness_color.rgb;
				darkness.a = layer1;
			} else if(d < l2r && darkness.a >= layer2) {
				darkness.rgb = light_color.rgb * darkness_color.rgb;
				darkness.a = layer2;
			} else if (d < l3r && darkness.a >= layer3) {
				darkness.rgb = light_color.rgb * darkness_color.rgb;
				darkness.a = layer3;
			}
		}
	}
	
	COLOR = darkness;
}
