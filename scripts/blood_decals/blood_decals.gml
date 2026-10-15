function blood_surface_destroy()
{
    if (surface_exists(raid_blood_surface)) surface_free(raid_blood_surface);
    raid_blood_surface = -1;
}

function blood_surface_reset()
{
    blood_surface_destroy();

    raid_blood_surface_x = raid_room_x1;
    raid_blood_surface_y = raid_room_y1;
    raid_blood_surface_width = max(1, ceil(raid_room_x2 - raid_room_x1));
    raid_blood_surface_height = max(1, ceil(raid_room_y2 - raid_room_y1));
    if (!global.graphics_settings.blood_effects) return;
    raid_blood_surface = surface_create(raid_blood_surface_width, raid_blood_surface_height);

    if (surface_exists(raid_blood_surface))
    {
        surface_set_target(raid_blood_surface);
        draw_clear_alpha(c_black, 0);
        surface_reset_target();
    }
}

function blood_surface_ensure()
{
    if (!global.graphics_settings.blood_effects) return false;
    if (surface_exists(raid_blood_surface)) return true;

    raid_blood_surface = surface_create(raid_blood_surface_width, raid_blood_surface_height);
    if (!surface_exists(raid_blood_surface)) return false;

    surface_set_target(raid_blood_surface);
    draw_clear_alpha(c_black, 0);
    surface_reset_target();
    return true;
}

function blood_surface_draw()
{
    if (!global.graphics_settings.blood_effects) return;
    if (!blood_surface_ensure()) return;
    draw_surface(raid_blood_surface, raid_blood_surface_x, raid_blood_surface_y);
}

function blood_stamp_splat(_x, _y, _scale = 1)
{
    var _sprite = spr_blood_splat_small;
    if (_sprite == -1 || !blood_surface_ensure()) return;

    var _target_size = 10 * _scale * random_range(0.7, 1.3);
    var _sprite_scale = _target_size / max(sprite_get_width(_sprite), sprite_get_height(_sprite));
    var _subimage = irandom(sprite_get_number(_sprite) - 1);

    surface_set_target(raid_blood_surface);
    draw_sprite_ext(
        _sprite,
        _subimage,
        _x - raid_blood_surface_x + random_range(-2, 2),
        _y - raid_blood_surface_y + random_range(-2, 2),
        _sprite_scale,
        _sprite_scale,
        random(360),
        c_white,
        random_range(0.75, 0.95)
    );
    surface_reset_target();
}

function blood_stamp_pool(_x, _y, _scale = 1)
{
    var _sprite = spr_blood_pool;
    if (_sprite == -1 || !blood_surface_ensure()) return;

    var _target_size = 29 * _scale * random_range(0.7, 1.3);
    var _sprite_scale = _target_size / max(sprite_get_width(_sprite), sprite_get_height(_sprite));
    var _subimage = irandom(sprite_get_number(_sprite) - 1);

    surface_set_target(raid_blood_surface);
    draw_sprite_ext(
        _sprite,
        _subimage,
        _x - raid_blood_surface_x + random_range(-3, 3),
        _y - raid_blood_surface_y + random_range(-3, 3),
        _sprite_scale,
        _sprite_scale,
        random(360),
        c_white,
        random_range(0.78, 0.96)
    );
    surface_reset_target();
}

function blood_stamp_streak(_x, _y, _direction, _scale = 1)
{
    var _sprite = spr_blood_streak;
    if (_sprite == -1 || !blood_surface_ensure()) return;

    var _variation = _scale * random_range(0.7, 1.3);
    var _target_width = 12 * _variation;
    var _target_length = 32 * _variation;
    var _sprite_width = sprite_get_width(_sprite);
    var _sprite_height = sprite_get_height(_sprite);
    var _horizontal = _sprite_width >= _sprite_height;
    var _scale_x = (_horizontal ? _target_length : _target_width) / _sprite_width;
    var _scale_y = (_horizontal ? _target_width : _target_length) / _sprite_height;
    var _angle = _direction + random_range(-15, 15) - (_horizontal ? 0 : 90);
    var _subimage = irandom(sprite_get_number(_sprite) - 1);

    surface_set_target(raid_blood_surface);
    draw_sprite_ext(
        _sprite,
        _subimage,
        _x - raid_blood_surface_x + random_range(-3, 3),
        _y - raid_blood_surface_y + random_range(-3, 3),
        _scale_x,
        _scale_y,
        _angle,
        c_white,
        random_range(0.72, 0.92)
    );
    surface_reset_target();
}

function blood_hit_effect(_x, _y, _hit_direction, _intensity = 1)
{
    if (!global.graphics_settings.blood_effects) return;
    var _medium_hit = _intensity > 1;
    var _splat_count = _medium_hit ? irandom_range(2, 4) : irandom_range(1, 2);

    for (var i = 0; i < _splat_count; i++)
    {
        blood_stamp_splat(
            _x + lengthdir_x(random_range(0, 7), _hit_direction + random_range(-35, 35)),
            _y + lengthdir_y(random_range(0, 7), _hit_direction + random_range(-35, 35)),
            random_range(0.8, _medium_hit ? 1.2 : 1)
        );
    }

    if (_medium_hit)
    {
        blood_stamp_streak(_x, _y, _hit_direction, random_range(0.8, 1.05));
        if (random(1) < 0.35) blood_stamp_pool(_x, _y, random_range(0.55, 0.8));
    }
    else if (random(1) < 0.3)
    {
        blood_stamp_streak(_x, _y, _hit_direction, random_range(0.5, 0.7));
    }
}

function blood_death_effect(_x, _y, _hit_direction)
{
    if (!global.graphics_settings.blood_effects) return;
    var _splat_count = irandom_range(2, 4);
    var _pool_count = irandom_range(1, 2);
    var _streak_count = irandom_range(2, 3);

    for (var i = 0; i < _splat_count; i++)
    {
        blood_stamp_splat(_x + random_range(-8, 8), _y + random_range(-8, 8), random_range(0.9, 1.3));
    }

    for (var i = 0; i < _pool_count; i++)
    {
        blood_stamp_pool(_x + random_range(-5, 5), _y + random_range(-5, 5), random_range(0.85, 1.25));
    }

    for (var i = 0; i < _streak_count; i++)
    {
        blood_stamp_streak(_x, _y, _hit_direction, random_range(0.9, 1.2));
    }
}
