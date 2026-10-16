function raid_shadow_occluder_rectangle(_x, _y, _width, _depth, _height, _rotation = 0, _enabled = true)
{
    return {
        geometry: {
            type: "rectangle",
            width: max(0, _width),
            depth: max(0, _depth)
        },
        position: {x: _x, y: _y},
        height: max(0, _height),
        rotation: _rotation,
        enabled: _enabled
    };
}
