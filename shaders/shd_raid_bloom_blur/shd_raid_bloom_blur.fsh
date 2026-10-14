varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_texel_size;
uniform vec2 u_direction;
uniform float u_radius;

void main()
{
    float radius = clamp(floor(u_radius + 0.5), 0.0, 16.0);
    float sigma = max(radius * 0.5, 0.5);
    float inverse_two_sigma_squared = 0.5 / (sigma * sigma);
    vec2 texel_offset = u_texel_size * u_direction;
    vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);
    float total_weight = 1.0;

    for (float tap = 1.0; tap <= 16.0; tap += 1.0)
    {
        if (tap <= radius)
        {
            float weight = exp(-(tap * tap) * inverse_two_sigma_squared);
            vec2 offset = texel_offset * tap;
            color += texture2D(gm_BaseTexture, v_vTexcoord + offset) * weight;
            color += texture2D(gm_BaseTexture, v_vTexcoord - offset) * weight;
            total_weight += weight * 2.0;
        }
    }

    gl_FragColor = v_vColour * (color / total_weight);
}
