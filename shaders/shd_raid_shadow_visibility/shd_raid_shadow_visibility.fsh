varying vec2 v_vFloorPosition;
varying vec4 v_vColour;

uniform vec2 u_light_position;
uniform float u_light_height;
uniform float u_rectangle_count;
uniform vec2 u_rectangle_position[16];
uniform vec2 u_rectangle_half_size[16];
uniform float u_rectangle_height[16];
uniform float u_rectangle_rotation[16];
uniform float u_sprite_count;
uniform vec2 u_sprite_ground_position[8];
uniform vec2 u_sprite_axis[8];
uniform vec2 u_sprite_size[8];
uniform vec2 u_sprite_source_position[8];
uniform vec2 u_sprite_source_size[8];
uniform float u_sprite_exclude_source[8];
uniform vec4 u_sprite_uv[8];
uniform float u_sprite_flip[8];
uniform float u_sprite_flip_y[8];
uniform sampler2D u_sprite_texture_0;
uniform sampler2D u_sprite_texture_1;
uniform sampler2D u_sprite_texture_2;
uniform sampler2D u_sprite_texture_3;
uniform sampler2D u_sprite_texture_4;
uniform sampler2D u_sprite_texture_5;
uniform sampler2D u_sprite_texture_6;
uniform sampler2D u_sprite_texture_7;
uniform float u_debug_visibility;

vec2 rotate_into_rectangle(vec2 position, int index)
{
    float rotation_cos = cos(u_rectangle_rotation[index]);
    float rotation_sin = sin(u_rectangle_rotation[index]);
    vec2 offset = position - u_rectangle_position[index];
    return vec2(
        offset.x * rotation_cos + offset.y * rotation_sin,
        -offset.x * rotation_sin + offset.y * rotation_cos
    );
}

bool rectangle_blocks_light(int index, vec2 sample_position)
{
    vec2 floor_position = rotate_into_rectangle(sample_position, index);
    vec2 light_position = rotate_into_rectangle(u_light_position, index);
    vec2 ray = light_position - floor_position;
    float entry = 0.0;
    float exit = min(1.0, u_rectangle_height[index] / max(u_light_height, 0.001));

    if (abs(ray.x) < 0.0001)
    {
        if (abs(floor_position.x) > u_rectangle_half_size[index].x) return false;
    }
    else
    {
        float x1 = (-u_rectangle_half_size[index].x - floor_position.x) / ray.x;
        float x2 = (u_rectangle_half_size[index].x - floor_position.x) / ray.x;
        entry = max(entry, min(x1, x2));
        exit = min(exit, max(x1, x2));
    }

    if (abs(ray.y) < 0.0001)
    {
        if (abs(floor_position.y) > u_rectangle_half_size[index].y) return false;
    }
    else
    {
        float y1 = (-u_rectangle_half_size[index].y - floor_position.y) / ray.y;
        float y2 = (u_rectangle_half_size[index].y - floor_position.y) / ray.y;
        entry = max(entry, min(y1, y2));
        exit = min(exit, max(y1, y2));
    }

    return entry <= exit;
}

float sprite_silhouette_alpha(int index, vec2 uv)
{
    if (index == 0) return texture2D(u_sprite_texture_0, uv).a;
    if (index == 1) return texture2D(u_sprite_texture_1, uv).a;
    if (index == 2) return texture2D(u_sprite_texture_2, uv).a;
    if (index == 3) return texture2D(u_sprite_texture_3, uv).a;
    if (index == 4) return texture2D(u_sprite_texture_4, uv).a;
    if (index == 5) return texture2D(u_sprite_texture_5, uv).a;
    if (index == 6) return texture2D(u_sprite_texture_6, uv).a;
    if (index == 7) return texture2D(u_sprite_texture_7, uv).a;
    return 0.0;
}

bool sprite_source_is_visible(int index, vec2 sample_position)
{
    if (u_sprite_exclude_source[index] < 0.5) return false;

    vec2 axis = u_sprite_axis[index];
    vec2 normal = vec2(-axis.y, axis.x);
    vec2 source_offset = sample_position - u_sprite_source_position[index];
    float horizontal = dot(source_offset, axis) / u_sprite_source_size[index].x + 0.5;
    float vertical = dot(source_offset, normal) / u_sprite_source_size[index].y + 0.5;
    if (horizontal < 0.0 || horizontal > 1.0 || vertical < 0.0 || vertical > 1.0) return false;
    if (u_sprite_flip[index] > 0.5) horizontal = 1.0 - horizontal;
    if (u_sprite_flip_y[index] > 0.5) vertical = 1.0 - vertical;

    vec4 uv_bounds = u_sprite_uv[index];
    vec2 uv = mix(uv_bounds.xy, uv_bounds.zw, vec2(horizontal, vertical));
    return sprite_silhouette_alpha(index, uv) >= 0.1;
}

bool sprite_blocks_light(int index, vec2 sample_position)
{
    if (sprite_source_is_visible(index, sample_position)) return false;

    vec2 axis = u_sprite_axis[index];
    vec2 normal = vec2(-axis.y, axis.x);
    vec2 ray = u_light_position - sample_position;
    float denominator = dot(ray, normal);
    if (abs(denominator) < 0.0001) return false;

    float along_ray = dot(u_sprite_ground_position[index] - sample_position, normal) / denominator;
    float maximum_height_time = min(1.0, u_sprite_size[index].y / max(u_light_height, 0.001));
    if (along_ray < 0.0 || along_ray > maximum_height_time) return false;

    vec2 intersection = sample_position + ray * along_ray;
    float horizontal = dot(intersection - u_sprite_ground_position[index], axis) / u_sprite_size[index].x + 0.5;
    float vertical = 1.0 - (along_ray * u_light_height / u_sprite_size[index].y);
    if (horizontal < 0.0 || horizontal > 1.0 || vertical < 0.0 || vertical > 1.0) return false;
    if (u_sprite_flip[index] > 0.5) horizontal = 1.0 - horizontal;
    if (u_sprite_flip_y[index] > 0.5) vertical = 1.0 - vertical;

    vec4 uv_bounds = u_sprite_uv[index];
    vec2 uv = mix(uv_bounds.xy, uv_bounds.zw, vec2(horizontal, vertical));
    return sprite_silhouette_alpha(index, uv) >= 0.1;
}

float shadow_visibility(vec2 sample_position)
{
    for (int rectangle_index = 0; rectangle_index < 16; rectangle_index++)
    {
        if (float(rectangle_index) >= u_rectangle_count) break;
        if (rectangle_blocks_light(rectangle_index, sample_position)) return 0.0;
    }

    for (int sprite_index = 0; sprite_index < 8; sprite_index++)
    {
        if (float(sprite_index) >= u_sprite_count) break;
        if (sprite_blocks_light(sprite_index, sample_position)) return 0.0;
    }

    return 1.0;
}

void main()
{
    const float shadow_softness = 2.0;
    float visibility = shadow_visibility(v_vFloorPosition) * 2.0;
    visibility += shadow_visibility(v_vFloorPosition + vec2(shadow_softness, 0.0));
    visibility += shadow_visibility(v_vFloorPosition - vec2(shadow_softness, 0.0));
    visibility += shadow_visibility(v_vFloorPosition + vec2(0.0, shadow_softness));
    visibility += shadow_visibility(v_vFloorPosition - vec2(0.0, shadow_softness));
    visibility /= 6.0;
    if (u_debug_visibility > 0.5)
    {
        vec3 debug_color = mix(vec3(1.0, 0.08, 0.04), vec3(0.05, 0.8, 0.25), visibility);
        gl_FragColor = vec4(debug_color, v_vColour.a * 0.45);
    }
    else gl_FragColor = v_vColour * visibility;
}
