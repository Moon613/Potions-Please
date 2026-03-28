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
vec3 XYZTosRGB(vec3 input) {
	float X = input.r / 100.0;
	float Y = input.g / 100.0;
	float Z = input.b / 100.0;
	
	float R = X *  3.2406 + Y * -1.5372 + Z * -0.4986;
	float G = X * -0.9689 + Y *  1.8758 + Z *  0.0415;
	float B = X *  0.0557 + Y * -0.2040 + Z *  1.0570;
	
	if (R > 0.0031308) {
		R = 1.055 * pow(R, 1.0 / 2.4) - 0.055;
	}
	else {
		R = 12.92 * R;
	}
	if (G > 0.0031308) {
		G = 1.055 * pow(G, 1.0 / 2.4) - 0.055;
	}
	else {
		G = 12.92 * G;
	}
	if (B > 0.0031308) {
		B = 1.055 * pow(B, 1.0 / 2.4) - 0.055;
	}
	else {
		B = 12.92 * B;
	}
	
	return vec3(R,G,B);
}


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 xyzOrig = RGBToXYZ(COLOR.rgb);
	vec3 cie = XYZToLAB(xyzOrig);
	
	//cie.r = 100.0;
	//cie.g = 128.0;
	//cie.b = -128.0;
	cie.r = 53.0;
	cie.g = 49.0;
	cie.b = mix(-128.0, 128.0, closeness);
	
	vec3 xyzNew = LABToXYZ(cie);
	COLOR.rgb = XYZTosRGB(xyzNew);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
