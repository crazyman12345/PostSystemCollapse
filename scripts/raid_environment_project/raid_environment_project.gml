function raid_environment_project(_vertex)
{
    var _height = _vertex.height;
    _vertex.draw_x = _vertex.world_x + _height * _vertex.projection_x * raid_environment.vertical_projection
        + _height * raid_environment.perspective_x;
    _vertex.draw_y = _vertex.world_y + _height * _vertex.projection_y * raid_environment.vertical_projection
        + _height * raid_environment.perspective_y;
}
