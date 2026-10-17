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
    var _source_u = _vertex.u - _material.offset_x / 100;
    var _source_v = _vertex.v - _material.offset_y / 100;
    var _local_u = lerp(_material.crop_left / 100, 1 - _material.crop_right / 100, _source_u);
    var _local_v = lerp(_material.crop_top / 100, 1 - _material.crop_bottom / 100, _source_v);
    var _uv_width = _material.uv_right - _material.uv_left;
    var _uv_height = _material.uv_bottom - _material.uv_top;
    var _uv_center_u = (_material.uv_left + _material.uv_right) * 0.5;
    var _uv_center_v = (_material.uv_top + _material.uv_bottom) * 0.5;
    var _source_uv_left = _uv_center_u - _uv_width * 0.5 / (_material.scale_x / 100);
    var _source_uv_right = _uv_center_u + _uv_width * 0.5 / (_material.scale_x / 100);
    var _source_uv_top = _uv_center_v - _uv_height * 0.5 / (_material.scale_y / 100);
    var _source_uv_bottom = _uv_center_v + _uv_height * 0.5 / (_material.scale_y / 100);
    var _uv_offset_u = _uv_width * (_material.uv_offset_u / 100);
    var _uv_offset_v = _uv_height * (_material.uv_offset_v / 100);
    var _u = lerp(_source_uv_left + _uv_offset_u, _source_uv_right + _uv_offset_u, _local_u);
    var _v = lerp(_source_uv_top + _uv_offset_v, _source_uv_bottom + _uv_offset_v, _local_v);
    draw_vertex_texture_colour(_vertex.draw_x, _vertex.draw_y, _u, _v, _color, 1);
}
