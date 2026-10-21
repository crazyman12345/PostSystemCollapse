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
            var _death_feet_x = raid_player_death_x + (
                (sprite_get_bbox_left(raid_player_death_sprite) + sprite_get_bbox_right(raid_player_death_sprite)) * 0.5
                - sprite_get_xoffset(raid_player_death_sprite)
            ) * raid_player_death_facing * raid_player_death_scale;
            var _death_feet_y = raid_player_death_y + (
                sprite_get_bbox_bottom(raid_player_death_sprite) - sprite_get_yoffset(raid_player_death_sprite)
            ) * raid_player_death_scale;
            var _death_caster = raid_shadow_occluder_sprite(
                raid_player_death_sprite,
                raid_player_death_frame,
                raid_player_death_x,
                raid_player_death_y,
                raid_player_death_facing * raid_player_death_scale,
                raid_player_death_scale,
                0,
                undefined,
                _death_feet_x,
                _death_feet_y
            );
            _death_caster.character_caster = true;
            _death_caster.projection_sample_offset_x = raid_player_projected_shadow_offset_x;
            _death_caster.projection_sample_offset_y = raid_player_projected_shadow_offset_y;
            _death_caster.exclude_source_from_shadow = true;
            array_push(_active, _death_caster);
        }
    }
    else if (global.graphics_settings.character_shadows)
    {
        var _player_caster = raid_shadow_get_player_body_occluder();
        var _player_feet_x = _player_caster.position.x;
        var _player_feet_y = _player_caster.position.y;
        _player_caster.projection_sample_offset_x = raid_player_projected_shadow_offset_x;
        _player_caster.projection_sample_offset_y = raid_player_projected_shadow_offset_y;
        array_push(_active, _player_caster);
        _character_accessories = raid_shadow_get_player_accessory_occluders(
            _player_feet_x,
            _player_feet_y
        );
        for (var _player_accessory_index = 0; _player_accessory_index < array_length(_character_accessories); _player_accessory_index++)
        {
            _character_accessories[_player_accessory_index].projection_sample_offset_x = raid_player_projected_shadow_offset_x;
            _character_accessories[_player_accessory_index].projection_sample_offset_y = raid_player_projected_shadow_offset_y;
        }

        for (var _enemy_index = 0; _enemy_index < array_length(raid_enemies); _enemy_index++)
        {
            var _enemy = raid_enemies[_enemy_index];
            if (!is_struct(_enemy) || _enemy.enemy_sprite < 0 || !sprite_exists(_enemy.enemy_sprite)) continue;

            var _enemy_bbox_height = sprite_get_bbox_bottom(_enemy.enemy_sprite)
                - sprite_get_bbox_top(_enemy.enemy_sprite) + 1;
            var _enemy_draw_scale = 0.75 * (40 / max(1, _enemy_bbox_height)) * _enemy.size_multiplier;
            var _enemy_bbox = raid_enemy_get_collision_bbox(_enemy);
            var _enemy_caster = raid_shadow_occluder_sprite(
                _enemy.enemy_sprite,
                floor(_enemy.enemy_frame),
                _enemy.enemy_x,
                _enemy.enemy_y,
                _enemy.enemy_facing * _enemy_draw_scale,
                _enemy_draw_scale,
                0,
                undefined,
                (_enemy_bbox.left + _enemy_bbox.right) * 0.5,
                _enemy_bbox.bottom
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

function raid_shadow_get_player_body_occluder()
{
    var _surface_size = 128;
    var _draw_scale = 0.3125;
    var _legs = raid_player_moving ? spr_player_leglayer_run : spr_player_leglayer_idle;
    var _head = raid_player_get_head_sprite(crew[0].armor_head);
    var _body = raid_player_get_body_sprite(crew[0].armor_chest);
    var _frame = floor(raid_player_anim_frame) mod sprite_get_number(_legs);
    var _head_bounce = raid_player_moving ? 0 : dsin(raid_player_anim_frame * 30) * 0.75;

    if (!surface_exists(raid_player_shadow_surface))
        raid_player_shadow_surface = surface_create(_surface_size, _surface_size);

    surface_set_target(raid_player_shadow_surface);
    draw_clear_alpha(c_black, 0);
    draw_sprite(_legs, _frame, sprite_get_xoffset(_legs), sprite_get_yoffset(_legs));
    draw_sprite(_body, 0, sprite_get_xoffset(_body), sprite_get_yoffset(_body));
    draw_sprite(_head, 0, sprite_get_xoffset(_head), sprite_get_yoffset(_head) + (_head_bounce / _draw_scale));
    surface_reset_target();

    var _origin_x = sprite_get_xoffset(_legs);
    var _origin_y = sprite_get_yoffset(_legs);
    var _head_source_offset = _head_bounce / _draw_scale;
    var _crop_left = min(sprite_get_bbox_left(_legs), sprite_get_bbox_left(_body), sprite_get_bbox_left(_head));
    var _crop_top = min(sprite_get_bbox_top(_legs), sprite_get_bbox_top(_body), sprite_get_bbox_top(_head) + _head_source_offset);
    var _crop_right = max(sprite_get_bbox_right(_legs), sprite_get_bbox_right(_body), sprite_get_bbox_right(_head)) + 1;
    var _crop_bottom = max(sprite_get_bbox_bottom(_legs), sprite_get_bbox_bottom(_body), sprite_get_bbox_bottom(_head) + _head_source_offset) + 1;
    var _crop_width = _crop_right - _crop_left;
    var _crop_height = _crop_bottom - _crop_top;
    var _source_width = _crop_width * _draw_scale;
    var _source_height = _crop_height * _draw_scale;
    var _source_center_x = raid_player_x + (((_crop_left + _crop_right) * 0.5) - _origin_x) * raid_player_facing * _draw_scale;
    var _source_center_y = raid_player_y + (((_crop_top + _crop_bottom) * 0.5) - _origin_y) * _draw_scale;
    var _feet_x = _source_center_x;
    var _feet_y = raid_player_y + (_crop_bottom - _origin_y) * _draw_scale;
    var _silhouette = {
        sprite_index: -1,
        image_index: 0,
        crop_left: _crop_left,
        crop_top: _crop_top,
        crop_right: _crop_right,
        crop_bottom: _crop_bottom,
        crop_width: _crop_width,
        crop_height: _crop_height,
        uv_left: _crop_left / _surface_size,
        uv_top: _crop_top / _surface_size,
        uv_right: _crop_right / _surface_size,
        uv_bottom: _crop_bottom / _surface_size,
        texture: surface_get_texture(raid_player_shadow_surface)
    };

    return {
        geometry: {
            type: "sprite",
            width: _source_width,
            silhouette: _silhouette
        },
        position: {x: _feet_x, y: _feet_y},
        height: max(0.001, _source_height),
        rotation: 0,
        flip_x: raid_player_facing < 0,
        flip_y: false,
        enabled: true,
        draw_sprite: -1,
        draw_surface: raid_player_shadow_surface,
        draw_subimage: 0,
        draw_x: raid_player_x - (_origin_x * raid_player_facing * _draw_scale),
        draw_y: raid_player_y - (_origin_y * _draw_scale),
        draw_xscale: raid_player_facing * _draw_scale,
        draw_yscale: _draw_scale,
        source_position: {x: _source_center_x, y: _source_center_y},
        source_size: {width: _source_width, height: _source_height},
        character_caster: true,
        player_shadow_body: true,
        exclude_source_from_shadow: true
    };
}
