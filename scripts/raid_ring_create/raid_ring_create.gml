function raid_ring_create(_x, _y, _max_radius, _expansion_speed, _thickness, _damage)
{
    var _ring = {
        x: _x,
        y: _y,
        current_radius: 0,
        max_radius: _max_radius,
        expansion_speed: _expansion_speed,
        thickness: _thickness,
        damage: _damage,
        active: true,
        damaged_player: false
    };

    array_push(raid_ring_hazards, _ring);
}
