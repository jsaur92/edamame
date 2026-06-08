shader_type canvas_item;

uniform float speed = 5.;
uniform float range = 5.;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.y += sin(TIME*speed)*range;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
