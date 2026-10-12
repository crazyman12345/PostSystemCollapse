function step_raid_enemy_death_effects()
{
    for (
        var i = array_length(raid_enemy_death_effects) - 1;
        i >= 0;
        i--
    )
    {
        var e =
            raid_enemy_death_effects[i];

        e.effect_x += e.effect_velocity_x * frame_scale;
        e.effect_y += e.effect_velocity_y * frame_scale;

        var _collision_radius = point_distance(
            0,
            0,
            e.effect_source_width * e.effect_scale * 0.5,
            e.effect_source_height * e.effect_scale * 0.5
        );
        var _left_edge = raid_room_x1 + _collision_radius;
        var _right_edge = raid_room_x2 - _collision_radius;
        var _top_edge = raid_room_y1 + _collision_radius;
        var _bottom_edge = raid_room_y2 - _collision_radius;

        if (e.effect_x < _left_edge)
        {
            e.effect_x = _left_edge;
            if (e.effect_velocity_x < 0) e.effect_velocity_x = -e.effect_velocity_x;
        }
        else if (e.effect_x > _right_edge)
        {
            e.effect_x = _right_edge;
            if (e.effect_velocity_x > 0) e.effect_velocity_x = -e.effect_velocity_x;
        }

        if (e.effect_y < _top_edge)
        {
            e.effect_y = _top_edge;
            if (e.effect_velocity_y < 0) e.effect_velocity_y = -e.effect_velocity_y;
        }
        else if (e.effect_y > _bottom_edge)
        {
            e.effect_y = _bottom_edge;
            if (e.effect_velocity_y > 0) e.effect_velocity_y = -e.effect_velocity_y;
        }

        e.effect_velocity_x *= power(0.96, frame_scale);
        e.effect_velocity_y *= power(0.96, frame_scale);
        e.effect_angle += e.effect_spin * frame_scale;
        e.effect_spin *= power(0.97, frame_scale);

        if (abs(e.effect_spin) < 0.05)
            e.effect_spin = 0;

        if (e.chunk_leaves_blood && !e.chunk_final_blood_done)
        {
            var _speed = point_distance(0, 0, e.effect_velocity_x, e.effect_velocity_y);

            if (_speed > 0.1)
            {
                e.chunk_blood_trail_timer -= frame_scale;

                if (e.chunk_blood_trail_timer <= 0)
                {
                    if (random(1) < 0.6)
                    {
                        blood_stamp_splat(
                            e.effect_x + random_range(-1.5, 1.5),
                            e.effect_y + random_range(-1.5, 1.5),
                            random_range(0.3, 0.6)
                        );
                    }

                    e.chunk_blood_trail_timer = random_range(4, 8);
                }
            }
            else
            {
                e.chunk_final_blood_done = true;

                if (random(1) < 0.7)
                {
                    blood_stamp_splat(
                        e.effect_x + random_range(-1.5, 1.5),
                        e.effect_y + random_range(-1.5, 1.5),
                        random_range(0.5, 0.8)
                    );
                }
            }
        }

        raid_enemy_death_effects[i] = e;
    }
}
