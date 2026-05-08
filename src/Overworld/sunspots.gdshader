shader_type canvas_item;
uniform sampler2D noise;
uniform sampler2D extraNoise;
uniform float rave = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
	float value = 0.5 * sin(PI*TIME * 0.1) - 1.5 * cos(PI*TIME * 0.2);
	VERTEX.x += value;
	VERTEX.y -= value;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 noiseTexture = texture(noise, UV).rgb;
	
	float value = PI*TIME*0.05;
	
	vec3 overlay = texture(extraNoise, UV + 0.1 * vec2(sin(value), cos(value))).rgb;
	vec4 output = vec4(noiseTexture, 1) - vec4(overlay, 0);
	
	float translucentLeaves = texture(extraNoise, UV + 0.05 * vec2(cos(value * 0.1), sin(value * 0.1))).r * 0.2;
	COLOR = clamp(output + vec4(translucentLeaves, 0, 0, 1) + rave * vec4(0.4 * abs(sin(PI*TIME)), 0, 1.0 * abs(cos(PI*TIME)), 1), 0, 1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
