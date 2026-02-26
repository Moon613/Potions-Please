shader_type canvas_item;

uniform sampler2D overlay_open: source_color;
uniform sampler2D overlay_closed: source_color;
uniform float wetness: hint_range(0.6, 1.0) = 0.6;
uniform bool open = true;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 overlay_sample;
	if (open) {
		overlay_sample = texture(overlay_open, UV);
	}
	else {
		overlay_sample = texture(overlay_closed, UV);
	}
	vec4 screen_sample = texture(TEXTURE, UV);
	
	if (min(overlay_sample.r, min(overlay_sample.g, overlay_sample.b)) < wetness) {
		COLOR.rgb = screen_sample.rgb * overlay_sample.rgb;
	}
	COLOR.a = screen_sample.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
