shader_type canvas_item;

uniform float shake_intensity = 0.0;

void vertex() {
    float mask = 1.0 - UV.y; 
    
    VERTEX.x += sin(TIME * 20.0) * shake_intensity * mask;
}