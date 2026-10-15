varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_saturation;
uniform float u_contrast;
uniform float u_brightness;

void main()
{
    vec4 source = texture2D(gm_BaseTexture, v_vTexcoord);
    float luminance = dot(source.rgb, vec3(0.2126, 0.7152, 0.0722));
    vec3 graded = mix(vec3(luminance), source.rgb, u_saturation);
    graded = (graded - vec3(0.5)) * u_contrast + vec3(0.5);
    graded *= u_brightness;
    gl_FragColor = v_vColour * vec4(clamp(graded, 0.0, 1.0), source.a);
}
