function draw_raid_emissives(_camera_x, _camera_y, _scale_x, _scale_y, _include_explosions = true, _wall_light_source_scale = 1, _projectile_source_scale = 1, _muzzle_flash_source_scale = 1, _explosion_source_scale = 1)
{
    draw_raid_wall_lights(true, _camera_x, _camera_y, _scale_x, _scale_y, _wall_light_source_scale);

    if (raid.state == RaidState.DEATH) return;

    var _projectile_lists = [raid_bullets, raid_enemy_bullets];
    if (!_include_explosions) gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_one, bm_zero, bm_one);

    if (global.graphics_settings.projectile_glow) for (var _list_index = 0; _list_index < array_length(_projectile_lists); _list_index++)
    {
        var _projectiles = _projectile_lists[_list_index];
        var _xscale = 0.30 * _scale_x * _projectile_source_scale;
        var _yscale = 0.14 * _scale_y * _projectile_source_scale;
        var _sprite = _list_index == 0 ? spr_player_bullet_glow : spr_enemy_bullet_glow;
        var _color = _list_index == 0 ? make_color_rgb(255, 190, 80) : c_white;
        var _alpha = _list_index == 0 ? 0.35 : 0.40;

        for (var _projectile_index = 0; _projectile_index < array_length(_projectiles); _projectile_index++)
        {
            var _projectile = _projectiles[_projectile_index];
            draw_sprite_ext(
                _sprite,
                0,
                (_projectile.bx - _camera_x) * _scale_x,
                (_projectile.by - _camera_y) * _scale_y,
                _xscale,
                _yscale,
                _projectile.bdirection,
                _color,
                _alpha
            );
        }
    }

    if (!_include_explosions) gpu_set_blendmode(bm_normal);

    if (is_struct(raid_muzzle_flash_light) && raid_muzzle_flash_light.lifetime > 0)
    {
        draw_sprite_ext(
            spr_muzzle_flash,
            raid_muzzle_flash_light.flash_subimage,
            (round(raid_muzzle_flash_light.x) - _camera_x) * _scale_x,
            (round(raid_muzzle_flash_light.y) - _camera_y) * _scale_y,
            raid_muzzle_flash_light.flash_xscale * _scale_x * _muzzle_flash_source_scale,
            raid_muzzle_flash_light.flash_yscale * _scale_y * _muzzle_flash_source_scale,
            raid_muzzle_flash_light.flash_direction,
            c_white,
            1
        );
    }

    for (var _enemy_flash_index = 0; _enemy_flash_index < array_length(raid_enemies); _enemy_flash_index++)
    {
        var _enemy_flash = raid_enemies[_enemy_flash_index].enemy_muzzle_flash_light;
        if (!is_struct(_enemy_flash) || _enemy_flash.lifetime <= 0) continue;

        draw_sprite_ext(
            spr_muzzle_flash,
            _enemy_flash.flash_subimage,
            (round(_enemy_flash.x) - _camera_x) * _scale_x,
            (round(_enemy_flash.y) - _camera_y) * _scale_y,
            _enemy_flash.flash_xscale * _scale_x * _muzzle_flash_source_scale,
            _enemy_flash.flash_yscale * _scale_y * _muzzle_flash_source_scale,
            _enemy_flash.flash_direction,
            c_white,
            1
        );
    }

    if (_include_explosions)
    {
        for (var _explosion_index = 0; _explosion_index < array_length(raid_ring_hazards); _explosion_index++)
        {
            var _explosion = raid_ring_hazards[_explosion_index];
            if (!_explosion.active || _explosion.state != "ACTIVE") continue;

            draw_set_color(_explosion.ring_color);
            draw_set_alpha(1);
            var _half_thickness = _explosion.thickness * 0.5;
            for (var _offset = -_half_thickness; _offset <= _half_thickness; _offset += 0.5)
            {
                draw_circle(
                    (_explosion.x - _camera_x) * _scale_x,
                    (_explosion.y - _camera_y) * _scale_y,
                    max(0, (_explosion.current_radius + _offset) * min(_scale_x, _scale_y) * _explosion_source_scale),
                    true
                );
            }
        }
    }

    draw_set_color(c_white);
    draw_set_alpha(1);
}
