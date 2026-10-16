function draw_raid_character_shadows()
{
    if (!global.graphics_settings.contact_shadows || !raid_character_shadows_enabled) return;

    // These are contact shadows only. Projected character shadows are produced
    // by the same light-occlusion renderer used for environmental casters.
    if (raid.state == RaidState.DEATH)
    {
        if (raid_player_death_phase <= 1)
        {
            var _death_sprite = raid_player_death_sprite;
            var _death_scale = raid_player_death_scale;
            var _death_feet_x = raid_player_death_x + (
                (sprite_get_bbox_left(_death_sprite) + sprite_get_bbox_right(_death_sprite)) * 0.5
                - sprite_get_xoffset(_death_sprite)
            ) * raid_player_death_facing * _death_scale;
            var _death_feet_y = raid_player_death_y + (
                sprite_get_bbox_bottom(_death_sprite) - sprite_get_yoffset(_death_sprite)
            ) * _death_scale;
            draw_raid_character_shadow(
                _death_feet_x,
                _death_feet_y,
                _death_scale,
                1.5
            );
        }
        return;
    }

    var _player_sprite = raid_player_moving ? spr_player_run : spr_player_idle;
    var _player_shadow_x = round(raid_player_x + (
        (sprite_get_bbox_left(_player_sprite) + sprite_get_bbox_right(_player_sprite)) * 0.5
        - sprite_get_xoffset(_player_sprite)
    ) * raid_player_facing);
    draw_raid_character_shadow(
        _player_shadow_x,
        round(raid_player_y) - 1,
        1,
        1.5
    );

    for (var _enemy_index = 0; _enemy_index < array_length(raid_enemies); _enemy_index++)
    {
        var _enemy = raid_enemies[_enemy_index];
        var _enemy_bbox = raid_enemy_get_collision_bbox(_enemy);
            draw_raid_character_shadow(
                (_enemy_bbox.left + _enemy_bbox.right) * 0.5,
                _enemy_bbox.bottom,
                _enemy.size_multiplier,
                1.5
            );
    }
}
