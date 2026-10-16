function raid_shadow_get_active_occluders()
{
    var _active = [];
    var _character_accessories = [];
    if (global.graphics_settings.environment_shadows)
    {
        _active = raid_shadow_get_arena_wall_occluders();
        for (var _static_index = 0; _static_index < array_length(raid_shadow_occluders); _static_index++)
            array_push(_active, raid_shadow_occluders[_static_index]);
    }

    // Character arrays are the dynamic registration source. Their current body
    // sprite, frame, position, scale, and facing are rebuilt for every draw;
    // deleting an enemy from raid_enemies unregisters it immediately.
    if (global.graphics_settings.character_shadows && raid.state == RaidState.DEATH)
    {
        if (raid_player_death_phase <= 1 && raid_player_death_sprite >= 0 && sprite_exists(raid_player_death_sprite))
        {
            var _death_caster = raid_shadow_occluder_sprite(
                raid_player_death_sprite,
                raid_player_death_frame,
                raid_player_death_x,
                raid_player_death_y,
                raid_player_death_facing * raid_player_death_scale,
                raid_player_death_scale
            );
            _death_caster.character_caster = true;
            _death_caster.exclude_source_from_shadow = true;
            array_push(_active, _death_caster);
        }
    }
    else if (global.graphics_settings.character_shadows)
    {
        var _player_sprite = raid_player_moving ? spr_player_run : spr_player_idle;
        var _player_caster = raid_shadow_occluder_sprite(
            _player_sprite,
            floor(raid_player_anim_frame),
            raid_player_x,
            raid_player_y,
            raid_player_facing,
            1
        );
        _player_caster.character_caster = true;
        _player_caster.player_shadow_body = true;
        _player_caster.exclude_source_from_shadow = true;
        array_push(_active, _player_caster);
        _character_accessories = raid_shadow_get_player_accessory_occluders(
            _player_caster.position.x,
            _player_caster.position.y
        );

        for (var _enemy_index = 0; _enemy_index < array_length(raid_enemies); _enemy_index++)
        {
            var _enemy = raid_enemies[_enemy_index];
            if (!is_struct(_enemy) || _enemy.enemy_sprite < 0 || !sprite_exists(_enemy.enemy_sprite)) continue;

            var _enemy_bbox_height = sprite_get_bbox_bottom(_enemy.enemy_sprite)
                - sprite_get_bbox_top(_enemy.enemy_sprite) + 1;
            var _enemy_draw_scale = 0.75 * (40 / max(1, _enemy_bbox_height)) * _enemy.size_multiplier;
            var _enemy_caster = raid_shadow_occluder_sprite(
                _enemy.enemy_sprite,
                floor(_enemy.enemy_frame),
                _enemy.enemy_x,
                _enemy.enemy_y,
                _enemy.enemy_facing * _enemy_draw_scale,
                _enemy_draw_scale
            );
            _enemy_caster.character_caster = true;
            _enemy_caster.exclude_source_from_shadow = true;
            array_push(_active, _enemy_caster);

            var _enemy_accessories = raid_shadow_get_enemy_accessory_occluders(_enemy);
            for (var _accessory_index = 0; _accessory_index < array_length(_enemy_accessories); _accessory_index++)
                array_push(_character_accessories, _enemy_accessories[_accessory_index]);
        }

        // Bodies stay ahead of accessories so a crowded room never loses its
        // existing body shadows when the shader reaches its caster limit.
        for (var _character_accessory_index = 0; _character_accessory_index < array_length(_character_accessories); _character_accessory_index++)
            array_push(_active, _character_accessories[_character_accessory_index]);
    }

    // Loot structs are the registration source, so clearing or replacing the
    // active room's loot array also unregisters its casters immediately.
    if (global.graphics_settings.environment_shadows) for (var _loot_index = 0; _loot_index < array_length(raid_lootables); _loot_index++)
    {
        var _lootable = raid_lootables[_loot_index];
        if (!variable_struct_exists(_lootable, "sprite_index") || _lootable.sprite_index < 0) continue;
        if (variable_struct_exists(_lootable, "shadow_enabled") && !_lootable.shadow_enabled) continue;

        var _lootable_caster = raid_shadow_occluder_sprite(
            _lootable.sprite_index,
            variable_struct_exists(_lootable, "image_index") ? _lootable.image_index : 0,
            variable_struct_exists(_lootable, "sprite_x") ? _lootable.sprite_x : _lootable.lootable_x,
            variable_struct_exists(_lootable, "sprite_y") ? _lootable.sprite_y : _lootable.lootable_y,
            variable_struct_exists(_lootable, "image_xscale") ? _lootable.image_xscale : 1,
            variable_struct_exists(_lootable, "image_yscale") ? _lootable.image_yscale : 1,
            variable_struct_exists(_lootable, "image_angle") ? _lootable.image_angle : 0,
            variable_struct_exists(_lootable, "shadow_height") ? _lootable.shadow_height : undefined,
            variable_struct_exists(_lootable, "shadow_ground_x") ? _lootable.shadow_ground_x : undefined,
            variable_struct_exists(_lootable, "shadow_ground_y") ? _lootable.shadow_ground_y : undefined,
            variable_struct_exists(_lootable, "shadow_offset_x") ? _lootable.shadow_offset_x : 0,
            variable_struct_exists(_lootable, "shadow_offset_y") ? _lootable.shadow_offset_y : 0
        );
        _lootable_caster.exclude_source_from_shadow = true;
        array_push(_active, _lootable_caster);
    }
    return _active;
}
