function ring_attack_create(_x, _y, _windup_total, _max_radius, _expansion_speed, _thickness, _damage, _warning_color, _ring_color)
{
    var _attack = {
        x: _x,
        y: _y,
        state: "WINDUP",
        windup_timer: _windup_total,
        windup_total: _windup_total,
        current_radius: 0,
        max_radius: _max_radius,
        expansion_speed: _expansion_speed,
        thickness: _thickness,
        damage: _damage,
        warning_color: _warning_color,
        ring_color: _ring_color,
        damaged_player: false,
        active: true
    };

    array_push(raid_ring_hazards, _attack);
    return _attack;
}
