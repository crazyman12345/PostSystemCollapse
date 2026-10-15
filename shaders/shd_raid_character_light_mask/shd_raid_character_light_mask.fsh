varying vec2 v_vTexcoord;

uniform float u_minimum_brightness;

void main()
{
    float sprite_alpha = texture2D(gm_BaseTexture, v_vTexcoord).a;
    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0 - sprite_alpha * clamp(u_minimum_brightness, 0.0, 1.0));
}
