shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 1.0;

float rand(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	float t = floor(TIME * 24.0);
	vec2 cell = floor(UV * 48.0);
	float n = rand(cell + vec2(t * 1.37, t * 0.71));
	float line = step(0.96, rand(vec2(7.0, cell.y + t))) * 0.35;
	COLOR = vec4(vec3(clamp(n * 0.8 + line, 0.0, 1.0)), strength * 0.9);
}