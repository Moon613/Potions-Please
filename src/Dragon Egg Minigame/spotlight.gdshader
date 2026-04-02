shader_type canvas_item;

uniform vec2 mousePos;
uniform float radius = 0.1;
uniform float feather = 0.2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = SCREEN_UV - vec2(0.5) + mousePos;
	uv.x *= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	COLOR.a = smoothstep(radius, feather, length(uv));//*float(length(uv)<feather*0.5) + smoothstep(radius, 2.0*feather, length(uv))*float(length(uv)>=feather*0.5);
	COLOR.rgb = vec3(0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
