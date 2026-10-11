shader_type canvas_item;

uniform bool defeated;

const vec4 defeated_subtractor = vec4(0.3333, 0.3333, 0.3333, 0.0);

void fragment() {
	if (defeated)
		COLOR -= defeated_subtractor;
}
