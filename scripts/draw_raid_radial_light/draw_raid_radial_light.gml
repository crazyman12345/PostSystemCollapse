function draw_raid_radial_light(_x, _y, _radius, _strength, _color = c_white, _rotation = 0, _x_scale = 1, _y_scale = 1,
    _segments = 32, _soft_falloff = false, _rgb_strength = undefined)
{
    if (_radius <= 0 || _strength <= 0) return;
    if (!raid_radial_light_is_visible(_x, _y, _radius, _x_scale, _y_scale)) return;

    var _alpha = clamp(_strength, 0, 1);
    var _draw_color = _color;
    if (!is_undefined(_rgb_strength))
    {
        var _rgb_scale = clamp(_rgb_strength, 0, 1) / max(_alpha, 0.001);
        _draw_color = merge_color(c_black, _color, clamp(_rgb_scale, 0, 1));
    }
    var _ring_radius = global.graphics_settings.light_falloff ? [0, 0.10, 0.38, 0.72, 1] : [0, 1];
    var _ring_alpha = global.graphics_settings.light_falloff
        ? (_soft_falloff ? [1, 0.96, 0.68, 0.30, 0] : [1, 0.96, 0.58, 0.15, 0])
        : [1, 1];

    // Every light uses one of a few segment counts. Cache the unit circle so
    // the same trigonometry is not repeated for every ring, light, and pass.
    static _unit_circle_cache = {};
    var _cache_key = "segments_" + string(_segments);
    var _unit_circle;
    if (variable_struct_exists(_unit_circle_cache, _cache_key)) _unit_circle = variable_struct_get(_unit_circle_cache, _cache_key);
    else
    {
        var _unit_x = array_create(_segments + 1, 0);
        var _unit_y = array_create(_segments + 1, 0);
        var _angle_step = 360 / _segments;
        for (var _cache_point = 0; _cache_point <= _segments; _cache_point++)
        {
            var _cache_angle = _cache_point * _angle_step;
            _unit_x[_cache_point] = lengthdir_x(1, _cache_angle);
            _unit_y[_cache_point] = lengthdir_y(1, _cache_angle);
        }
        _unit_circle = {x: _unit_x, y: _unit_y};
        variable_struct_set(_unit_circle_cache, _cache_key, _unit_circle);
    }

    var _rotation_x = lengthdir_x(1, _rotation);
    var _rotation_y = lengthdir_y(1, _rotation);
    var _previous_x = 0;
    var _previous_y = 0;

    // Degenerate connector vertices keep all rings in one triangle strip,
    // preserving the existing piecewise-linear gradient with one submission.
    draw_primitive_begin(pr_trianglestrip);
    for (var _ring = 0; _ring < array_length(_ring_radius) - 1; _ring++)
    {
        var _inner_radius = _radius * _ring_radius[_ring];
        var _outer_radius = _radius * _ring_radius[_ring + 1];
        var _inner_alpha = _alpha * _ring_alpha[_ring];
        var _outer_alpha = _alpha * _ring_alpha[_ring + 1];

        if (_ring > 0)
        {
            var _bridge_outer_local_x = _unit_circle.x[0] * _outer_radius * _x_scale;
            var _bridge_outer_local_y = _unit_circle.y[0] * _outer_radius * _y_scale;
            var _bridge_outer_x = _x + _bridge_outer_local_x * _rotation_x - _bridge_outer_local_y * _rotation_y;
            var _bridge_outer_y = _y + _bridge_outer_local_x * _rotation_y + _bridge_outer_local_y * _rotation_x;
            draw_vertex_colour(_previous_x, _previous_y, _draw_color, _inner_alpha);
            draw_vertex_colour(_bridge_outer_x, _bridge_outer_y, _draw_color, _outer_alpha);
        }

        for (var _point = 0; _point <= _segments; _point++)
        {
            var _unit_x = _unit_circle.x[_point];
            var _unit_y = _unit_circle.y[_point];
            var _inner_x = _unit_x * _inner_radius * _x_scale;
            var _inner_y = _unit_y * _inner_radius * _y_scale;
            var _outer_x = _unit_x * _outer_radius * _x_scale;
            var _outer_y = _unit_y * _outer_radius * _y_scale;
            var _inner_draw_x = _x + _inner_x * _rotation_x - _inner_y * _rotation_y;
            var _inner_draw_y = _y + _inner_x * _rotation_y + _inner_y * _rotation_x;
            var _outer_draw_x = _x + _outer_x * _rotation_x - _outer_y * _rotation_y;
            var _outer_draw_y = _y + _outer_x * _rotation_y + _outer_y * _rotation_x;

            draw_vertex_colour(_outer_draw_x, _outer_draw_y, _draw_color, _outer_alpha);
            draw_vertex_colour(_inner_draw_x, _inner_draw_y, _draw_color, _inner_alpha);
            _previous_x = _inner_draw_x;
            _previous_y = _inner_draw_y;
        }
    }
    draw_primitive_end();
}
