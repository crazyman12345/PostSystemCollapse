function raid_radial_light_is_visible(_x, _y, _radius, _x_scale = 1, _y_scale = 1)
{
    var _extent = _radius * max(abs(_x_scale), abs(_y_scale));
    var _scissor = gpu_get_scissor();
    return _x + _extent >= _scissor.x
        && _x - _extent <= _scissor.x + _scissor.w
        && _y + _extent >= _scissor.y
        && _y - _extent <= _scissor.y + _scissor.h;
}
