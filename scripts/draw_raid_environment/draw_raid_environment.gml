function draw_raid_environment(_foreground = false)
{
    if (!raid_environment.enabled || is_undefined(raid_environment.geometry)) return;
    var _geometry = raid_environment.geometry;
    var _previous_texfilter = gpu_get_texfilter();
    gpu_set_texfilter(false);

    if (!_foreground)
    {
        raid_environment_draw_batch(_geometry.back_inner_faces, raid_environment.inner_face_material);
        raid_environment_draw_batch(_geometry.back_caps, raid_environment.cap_material);
    }
    else
    {
        raid_environment_draw_batch(_geometry.front_inner_faces, raid_environment.inner_face_material);
        raid_environment_draw_batch(_geometry.front_caps, raid_environment.cap_material);
    }

    gpu_set_texfilter(_previous_texfilter);
    draw_set_color(c_white);
    draw_set_alpha(1);
}


function raid_environment_draw_batch(_batch, _material)
{
    if (array_length(_batch) <= 0) return;
    draw_primitive_begin_texture(pr_trianglelist, _material.texture);
    for (var _quad_index = 0; _quad_index < array_length(_batch); _quad_index++)
    {
        var _quad = _batch[_quad_index];
        var _vertices = _quad.vertices;
        raid_environment_draw_vertex(_vertices[0], _material, _quad.color);
        raid_environment_draw_vertex(_vertices[1], _material, _quad.color);
        raid_environment_draw_vertex(_vertices[2], _material, _quad.color);
        raid_environment_draw_vertex(_vertices[0], _material, _quad.color);
        raid_environment_draw_vertex(_vertices[2], _material, _quad.color);
        raid_environment_draw_vertex(_vertices[3], _material, _quad.color);
    }
    draw_primitive_end();
}


function raid_environment_draw_vertex(_vertex, _material, _color)
{
    var _u = lerp(_material.uv_left, _material.uv_right, _vertex.u);
    var _v = lerp(_material.uv_top, _material.uv_bottom, _vertex.v);
    draw_vertex_texture_colour(_vertex.draw_x, _vertex.draw_y, _u, _v, _color, 1);
}
