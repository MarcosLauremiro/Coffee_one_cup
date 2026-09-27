shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;
uniform float blur_size : hint_range(0.0, 20.0) = 4.0;
uniform vec2 direction = vec2(1.0, 0.0); // (1,0) horizontal, (0,1) vertical

void fragment() {
    vec2 pixel = 1.0 / vec2(textureSize(screen_texture, 0));
    vec2 offset = pixel * direction * blur_size;

    float weights[9] = float[](
        0.016, 0.05, 0.109, 0.172, 0.204, 0.172, 0.109, 0.05, 0.016
    );

    vec4 color = vec4(0.0);
    for (int i = -4; i <= 4; i++) {
        color += texture(screen_texture, SCREEN_UV + offset * float(i)) * weights[i + 4];
    }

    COLOR = color;
}