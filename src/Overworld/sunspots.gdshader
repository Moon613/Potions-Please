shader_type canvas_item;
uniform sampler2D noise;
uniform sampler2D extraNoise;

void vertex() {
	float value = 0.5 * sin(PI*TIME * 0.1) - 1.5 * cos(PI*TIME * 0.2);
	VERTEX.x += value;
	VERTEX.y -= value;
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 noiseTexture = texture(noise, UV).rgb;
	float value = PI*TIME*0.05;
	vec3 overlay = texture(extraNoise, UV + 0.1 * vec2(sin(value), cos(value))).rgb;
	//COLOR = clamp(noiseTexture + vec4(0.4 * abs(sin(PI*TIME)), 0, 1.0 * abs(cos(PI*TIME)), 1), 0, 1);
	COLOR = vec4(noiseTexture, 1) - vec4(overlay, 0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
