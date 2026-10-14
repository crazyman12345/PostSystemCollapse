function raid_enemy_fire_bullet(_x, _y, _dir, _speed, _damage, _light_enabled = true, _light_color = make_color_rgb(255, 95, 40), _light_radius = 20, _light_intensity = 0.12)
{
    array_push(
        raid_enemy_bullets,
        {
            bx: _x,
            by: _y,
            bdirection: _dir,
            bspeed: _speed * 1.15,
            bdamage: _damage,
            light_enabled: _light_enabled,
            light_color: _light_color,
            light_radius: _light_radius,
            light_intensity: _light_intensity
        }
    );
}
