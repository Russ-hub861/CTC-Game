shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 4.0) = 0.0;

void fragment() {
	vec4 col = texture(TEXTURE, UV);

	if (outline_width <= 0.0 || col.a > 0.1) {
		COLOR = col;
	} else {
		vec2 px = TEXTURE_PIXEL_SIZE * outline_width;
		float neighbor = 0.0;
		neighbor = max(neighbor, texture(TEXTURE, UV + vec2(px.x, 0.0)).a);
		neighbor = max(neighbor, texture(TEXTURE, UV + vec2(-px.x, 0.0)).a);
		neighbor = max(neighbor, texture(TEXTURE, UV + vec2(0.0, px.y)).a);
		neighbor = max(neighbor, texture(TEXTURE, UV + vec2(0.0, -px.y)).a);

		COLOR = neighbor > 0.1 ? outline_color : col;
	}
}