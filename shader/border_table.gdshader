shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0);
uniform float outline_size = 1.0;
uniform bool outline_enabled = true;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    if (tex.a > 0.0) {
        COLOR = tex;
    } else if (outline_enabled) {
        vec2 p = TEXTURE_PIXEL_SIZE * outline_size;

        float alpha = 0.0;

        alpha = max(alpha, texture(TEXTURE, UV + vec2( p.x,  0.0)).a);
        alpha = max(alpha, texture(TEXTURE, UV + vec2(-p.x,  0.0)).a);
        alpha = max(alpha, texture(TEXTURE, UV + vec2( 0.0,  p.y)).a);
        alpha = max(alpha, texture(TEXTURE, UV + vec2( 0.0, -p.y)).a);

        alpha = max(alpha, texture(TEXTURE, UV + vec2( p.x,  p.y)).a);
        alpha = max(alpha, texture(TEXTURE, UV + vec2(-p.x,  p.y)).a);
        alpha = max(alpha, texture(TEXTURE, UV + vec2( p.x, -p.y)).a);
        alpha = max(alpha, texture(TEXTURE, UV + vec2(-p.x, -p.y)).a);

        COLOR = alpha > 0.0 ? outline_color : vec4(0.0);
    } else {
        COLOR = vec4(0.0);
    }
}