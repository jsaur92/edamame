shader_type canvas_item;

// white benchmark. colors that have all of these values or higher are considered white.
uniform vec3 wb = vec3(0.439, 0.439, 0.439);
uniform vec4 my_color;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (color.r > wb.r && color.g > wb.g && color.b > wb.b) {
		color *= my_color;
	}
	COLOR = vec4(color.r, color.g, color.b, COLOR.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
