function draw_raid_enemy_death_effects()
{
    for (
        var i = 0;
        i < array_length(raid_enemy_death_effects);
        i++
    )
    {
        var e =
            raid_enemy_death_effects[i];

        var _xscale = e.effect_facing * e.effect_scale;
        var _yscale = e.effect_scale;
        var _half_width = e.effect_source_width * _xscale * 0.5;
        var _half_height = e.effect_source_height * _yscale * 0.5;
        var _angle_cos = dcos(e.effect_angle);
        var _angle_sin = dsin(e.effect_angle);
        var _draw_x = e.effect_x - (_half_width * _angle_cos) - (_half_height * _angle_sin);
        var _draw_y = e.effect_y + (_half_width * _angle_sin) - (_half_height * _angle_cos);

        draw_sprite_general(
            e.effect_sprite,
            e.effect_frame,
            e.effect_source_left,
            e.effect_source_top,
            e.effect_source_width,
            e.effect_source_height,
            _draw_x,
            _draw_y,
            _xscale,
            _yscale,
            e.effect_angle,
            e.effect_color,
            e.effect_color,
            e.effect_color,
            e.effect_color,
            e.effect_alpha
        );
    }
}
