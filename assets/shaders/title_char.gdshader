shader_type canvas_item;

uniform vec4 my_color;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color *= my_color;
	COLOR = vec4(color.r, color.g, color.b, COLOR.a);
}
