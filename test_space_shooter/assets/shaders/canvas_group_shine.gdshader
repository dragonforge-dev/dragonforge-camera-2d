shader_type canvas_item;

// --- Includes --- //
//#include "res://shaders/includes/generic_functions.gdshaderinc"

//CanvasGroup Shader
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// --- Uniforms --- //
uniform vec4 shine_color: source_color = vec4(1.0, 1.0, 1.0, 0.25);

uniform float line_width: hint_range(0.0, 2.0, 0.01) = 0.1;
uniform float angle: hint_range(0.0, 6.28318530718, 0.1308996939) = 0.785398163397;

uniform float speed: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float wait_cycles: hint_range(0.0, 10.0, 0.1) = 1.0;

// --- Functions --- //
vec2 rotate_precalculated(vec2 _pos, float _sine, float _cosine) {
	return vec2(_pos.x * _cosine + _pos.y * -_sine, _pos.x * _sine + _pos.y * _cosine);
}

void fragment() {
	//vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec4 c = texture(screen_texture, SCREEN_UV);
//
	//if (c.a > 0.0001) {
		//c.rgb /= c.a;
	//}


	float sine = sin(angle);
	float cosine = cos(angle);
	float len = 1.5 - max(abs(sine), abs(cosine)) + line_width;
	float line = smoothstep(-line_width, line_width, 
			rotate_precalculated((UV - vec2(0.5)), sine, cosine).y - mod(TIME * speed, (len * 2.0) * wait_cycles) + len);
	//COLOR.rgb += shine_color.rgb * shine_color.a * vec3(line * (1.0 - line) * 4.0);
	vec3 shine = shine_color.rgb * shine_color.a * vec3(line * (1.0 - line) * 4.0);
	COLOR.rgb = clamp(c.rgb + shine, 0.0, 1.0);
	COLOR.a = c.a;
}
