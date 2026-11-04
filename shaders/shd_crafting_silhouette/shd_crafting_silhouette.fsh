varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    float sprite_alpha = texture2D(gm_BaseTexture, v_vTexcoord).a;
    gl_FragColor = vec4(v_vColour.rgb, sprite_alpha * v_vColour.a);
}
