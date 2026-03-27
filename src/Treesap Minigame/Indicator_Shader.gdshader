shader_type canvas_item;

uniform float closeness: hint_range(0.0, 1.0) = 0.0;

//https://stackoverflow.com/questions/15408522/rgb-to-xyz-and-lab-colours-conversion
vec3 RGBToXYZ(vec3 input) {
	vec3 ret;
	if (input.r > 0.04045) {
		ret.r = pow(((input.r + 0.055) / 1.055), 2.4);
	}
	else {
		ret.r = input.r / 12.92;
	}
	if (input.g > 0.04045) {
		ret.g = pow(((input.g + 0.055) / 1.055), 2.4);
	}
	else {
		ret.g = input.g / 12.92;
	}
	if (input.b > 0.04045) {
		ret.b = pow(((input.b + 0.055) / 1.055), 2.4);
	}
	else {
		ret.b = input.b / 12.92;
	}
	ret = ret*100.0;
	float X = ret.r * 0.4124 + ret.g * 0.3576 + ret.b * 0.1805;
	float Y = ret.r * 0.2126 + ret.g * 0.7152 + ret.b * 0.0722;
	float Z = ret.r * 0.0193 + ret.g * 0.1192 + ret.b * 0.9505;
	return vec3(X,Y,Z);
}
vec3 XYZToLAB(vec3 input) {
	float refX = 95.047;
	float refY = 100.0;
	float refZ = 108.883;
	
	float X = input.r / refX;
	float Y  = input.g / refY;
	float Z = input.b / refZ;
	
    if (X > 0.008856) {
		X = pow(X, 1.0/3.0);
	}
    else {
		X = (7.787 * X) + (16.0/116.0);
	}
    if (Y > 0.008856) {
		Y = pow(Y, 1.0/3.0);
	}
    else {
		Y = (7.787 * Y) + (16.0/116.0);
	}
    if (Z > 0.008856) {
		Z = pow(Z, 1.0/3.0);
	}
    else {
		Z = (7.787 * Z) + (16.0/116.0);
	}
	
	float L = (116.0 * Y) - 16.0;
	float a = 500.0 * (X - Y);
	float b = 200.0 * (Y - Z);
	return vec3(L,a,b);
}

//http://www.brucelindbloom.com/index.html?Eqn_Lab_to_XYZ.html
vec3 LABToXYZ(vec3 input) {
	vec3 ret;
	float Fy = (input.r+16.0)/116.0;
	float Fx = input.g/500.0 + Fy;
	float Fz = Fy - input.b/200.0;
	if (pow(Fx,3) > 0.008856) {
		ret.r = pow(Fx, 3) * 95.047;
	}
	else {
		ret.r = (116.0*Fx - 16.0)/903.3 * 95.047;
	}
	if (input.r > 903.3*0.008856) {
		ret.g = pow((input.r+16.0)/116.0,3) * 100.0;
	}
	else {
		ret.g = input.r/903.3 * 100.0;
	}
	if (pow(Fz,3) > 0.008856) {
		ret.b = pow(Fz, 3) * 108.883;
	}
	else {
		ret.b = (116.0*Fz - 16.0)/903.3 * 108.883;
	}
	return ret;
}
//https://www.oceanopticsbook.info/view/photometry-and-visibility/from-xyz-to-rgb
vec3 XYZTosRGB(vec3 input) {
	mat3 matrix = mat3(
		vec3(3.2404542, -0.969266, 0.0556434),
		vec3(-1.5371385, 1.8760108, -0.2040259),
		vec3(-0.4985314, 0.041556, 1.0572252)
		);
	return matrix * input;
}


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 xyzOrig = RGBToXYZ(COLOR.rgb);
	vec3 cie = XYZToLAB(xyzOrig);
	
	cie.r = 100.0;
	cie.g = 128.0;
	cie.b = 128.0;
	//cie.r = 53.0;
	//cie.g = 49.0;
	//cie.b = mix(-128.0, 128.0, closeness);
	
	vec3 xyzNew = LABToXYZ(cie);
	COLOR.rgb = XYZTosRGB(xyzNew);
	
	
	//COLOR.rgb = mix(vec3(22.0/255.0,65.0/255.0,255.0/255.0), vec3(255.0/255.0,0.0/255.0,12.0/255.0), closeness);
	//COLOR.r *= closeness;
	//COLOR.g *= clamp(1.0-closeness, 0.25, 1.0);
	//COLOR.b *= 1.0-closeness;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
