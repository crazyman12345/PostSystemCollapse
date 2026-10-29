function raid_environment_project(_vertex, _perspective_x = raid_environment.perspective_x, _perspective_y = raid_environment.perspective_y)
{
    var _height = _vertex.height;
    _vertex.draw_x = _vertex.world_x + _height * _vertex.projection_x * raid_environment.vertical_projection
        + _height * _perspective_x;
    _vertex.draw_y = _vertex.world_y + _height * _vertex.projection_y * raid_environment.vertical_projection
        + _height * _perspective_y;
}
