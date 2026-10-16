varying vec2 v_vTexcoord;
varying vec2 v_vScreenCoord;
varying vec4 v_vColour;

uniform sampler2D u_darkness_texture;
uniform sampler2D u_colored_light_texture;
uniform float u_min_light;
uniform float u_ambient_darkness;
uniform float u_light_response;
uniform float u_colored_light_strength;
uniform float u_alpha_scale;

void main()
{
    vec4 smoke = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    float darkness = texture2D(u_darkness_texture, v_vScreenCoord).a;
    vec3 colored_light = texture2D(u_colored_light_texture, v_vScreenCoord).rgb
        + texture2D(u_darkness_texture, v_vScreenCoord).rgb;
    float illumination = clamp(1.0 - darkness, 0.0, 1.0);
    float ambient_illumination = 1.0 - clamp(u_ambient_darkness, 0.0, 1.0);
    float light_amount = clamp((illumination - ambient_illumination) / max(1.0 - ambient_illumination, 0.001), 0.0, 1.0);
    float visibility = clamp(u_min_light, 0.0, 1.0) + light_amount * max(u_light_response, 0.0);
    vec3 lit_smoke = smoke.rgb * visibility + colored_light * u_colored_light_strength;
    gl_FragColor = vec4(clamp(lit_smoke, 0.0, 1.0), clamp(smoke.a * u_alpha_scale, 0.0, 1.0));
}
