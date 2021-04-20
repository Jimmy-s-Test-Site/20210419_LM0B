shader_type canvas_item;

uniform float bloom_amount = 30.0;

void fragment() {
	float mask = 1.0 - step(0.5, length(UV - 0.5));
	COLOR = bloom_amount * texture(TEXTURE, UV) * vec4(mask);
}