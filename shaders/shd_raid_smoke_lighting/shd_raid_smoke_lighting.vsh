attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec2 v_vScreenCoord;
varying vec4 v_vColour;

void main()
{
    vec4 clip_position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
    gl_Position = clip_position;
    vec2 normalized_position = clip_position.xy / clip_position.w;
    v_vScreenCoord = vec2(normalized_position.x * 0.5 + 0.5, 0.5 - normalized_position.y * 0.5);
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}
