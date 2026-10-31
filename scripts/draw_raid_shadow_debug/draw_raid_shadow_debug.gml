function draw_raid_shadow_debug(_occluders)
{
    if (array_length(_occluders) <= 0 || array_length(raid_wall_lights) <= 0) return;

    var _light = raid_wall_lights[0];
    gpu_set_blendmode(bm_normal);
    draw_raid_shadowed_radial_light(_light, _occluders, 0, 0, 0.85, c_white, true);

    for (var _occluder_index = 0; _occluder_index < array_length(_occluders); _occluder_index++)
    {
        var _occluder = _occluders[_occluder_index];
        if (_occluder.geometry.type == "sprite")
        {
            var _debug_color = variable_struct_exists(_occluder, "character_caster") ? c_fuchsia : c_aqua;
            var _silhouette = _occluder.geometry.silhouette;
            var _draws_surface = variable_struct_exists(_occluder, "draw_surface");
            if (_draws_surface)
            {
                draw_surface_ext(_occluder.draw_surface, _occluder.draw_x, _occluder.draw_y,
                    _occluder.draw_xscale, _occluder.draw_yscale, _occluder.rotation, _debug_color, 0.45);
            }
            else
            {
                draw_sprite_ext(_occluder.draw_sprite, _occluder.draw_subimage, _occluder.draw_x, _occluder.draw_y,
                    _occluder.draw_xscale, _occluder.draw_yscale, _occluder.rotation, _debug_color, 0.45);
            }

            // Yellow is the alpha crop's rectangular projection domain; the
            // tinted sprite shows the actual alpha silhouette sampled inside it.
            var _origin_x = _draws_surface ? 0 : sprite_get_xoffset(_occluder.draw_sprite);
            var _origin_y = _draws_surface ? 0 : sprite_get_yoffset(_occluder.draw_sprite);
            var _source_x = [_silhouette.crop_left, _silhouette.crop_right, _silhouette.crop_right, _silhouette.crop_left];
            var _source_y = [_silhouette.crop_top, _silhouette.crop_top, _silhouette.crop_bottom, _silhouette.crop_bottom];
            var _bounds_x = [];
            var _bounds_y = [];
            for (var _bound_index = 0; _bound_index < 4; _bound_index++)
            {
                var _local_x = (_source_x[_bound_index] - _origin_x) * _occluder.draw_xscale;
                var _local_y = (_source_y[_bound_index] - _origin_y) * _occluder.draw_yscale;
                var _bound_distance = point_distance(0, 0, _local_x, _local_y);
                var _bound_direction = point_direction(0, 0, _local_x, _local_y) + _occluder.rotation;
                array_push(_bounds_x, _occluder.draw_x + lengthdir_x(_bound_distance, _bound_direction));
                array_push(_bounds_y, _occluder.draw_y + lengthdir_y(_bound_distance, _bound_direction));
            }
            draw_set_color(c_yellow);
            for (var _bound_edge = 0; _bound_edge < 4; _bound_edge++)
            {
                var _next_bound_edge = (_bound_edge + 1) mod 4;
                draw_line(_bounds_x[_bound_edge], _bounds_y[_bound_edge], _bounds_x[_next_bound_edge], _bounds_y[_next_bound_edge]);
            }
            draw_set_color(_debug_color);
            draw_circle(_occluder.position.x, _occluder.position.y, 3, false);
            draw_line(_occluder.position.x - 5, _occluder.position.y, _occluder.position.x + 5, _occluder.position.y);
            draw_line(_occluder.position.x, _occluder.position.y - 5, _occluder.position.x, _occluder.position.y + 5);
            continue;
        }

        var _half_width = _occluder.geometry.width * 0.5;
        var _half_depth = _occluder.geometry.depth * 0.5;
        var _corner_x = [-_half_width, _half_width, _half_width, -_half_width];
        var _corner_y = [-_half_depth, -_half_depth, _half_depth, _half_depth];
        var _world_x = [];
        var _world_y = [];
        for (var _corner_index = 0; _corner_index < 4; _corner_index++)
        {
            var _corner_distance = point_distance(0, 0, _corner_x[_corner_index], _corner_y[_corner_index]);
            var _corner_direction = point_direction(0, 0, _corner_x[_corner_index], _corner_y[_corner_index]) + _occluder.rotation;
            array_push(_world_x, _occluder.position.x + lengthdir_x(_corner_distance, _corner_direction));
            array_push(_world_y, _occluder.position.y + lengthdir_y(_corner_distance, _corner_direction));
        }
        draw_set_color(c_yellow);
        for (var _edge_index = 0; _edge_index < 4; _edge_index++)
        {
            var _next_edge_index = (_edge_index + 1) mod 4;
            draw_line(_world_x[_edge_index], _world_y[_edge_index], _world_x[_next_edge_index], _world_y[_next_edge_index]);
        }
    }
    for (var _light_index = 0; _light_index < array_length(raid_light_sources); _light_index++)
    {
        var _debug_light = raid_light_sources[_light_index];
        var _shadow_height = raid_light_get_shadow_height(_debug_light);
        draw_circle(_debug_light.x, _debug_light.y, 4, false);
        draw_text(_debug_light.x + 6, _debug_light.y - 14, "Shadow height: " + string(_shadow_height));
    }

    var _player_body_caster = undefined;
    var _weapon_rig_caster = undefined;
    for (var _player_caster_index = 0; _player_caster_index < array_length(_occluders); _player_caster_index++)
    {
        var _player_debug_caster = _occluders[_player_caster_index];
        if (variable_struct_exists(_player_debug_caster, "player_shadow_body") && _player_debug_caster.player_shadow_body)
            _player_body_caster = _player_debug_caster;
        if (variable_struct_exists(_player_debug_caster, "shared_anchor_projection") && _player_debug_caster.shared_anchor_projection
        && (is_undefined(_weapon_rig_caster) || _player_debug_caster.height > _weapon_rig_caster.height))
            _weapon_rig_caster = _player_debug_caster;
    }
    if (!is_undefined(_player_body_caster))
    {
        var _feet_x = _player_body_caster.position.x;
        var _feet_y = _player_body_caster.position.y;
        var _light_height = raid_light_get_shadow_height(_light);
        var _body_height = min(_player_body_caster.height, _light_height * 0.95);
        var _body_projection_scale = _body_height / max(0.001, _light_height - _body_height);
        var _body_projection_x = (_feet_x - _light.x) * _body_projection_scale;
        var _body_projection_y = (_feet_y - _light.y) * _body_projection_scale;
        draw_set_color(c_yellow);
        draw_line(_light.x, _light.y, _feet_x, _feet_y);
        draw_text((_light.x + _feet_x) * 0.5 + 5, (_light.y + _feet_y) * 0.5, "light direction");
        draw_set_color(global.ui_text_color);
        draw_circle(_feet_x, _feet_y, 4, false);
        draw_line(_feet_x, _feet_y, _feet_x + _body_projection_x, _feet_y + _body_projection_y);
        draw_text(_feet_x + 6, _feet_y + 5, "feet / body projection");

        if (!is_undefined(_weapon_rig_caster))
        {
            var _weapon_height = min(_weapon_rig_caster.height, _light_height * 0.95);
            var _weapon_projection_scale = _weapon_height / max(0.001, _light_height - _weapon_height);
            draw_set_color(c_fuchsia);
            draw_line(_feet_x, _feet_y,
                _feet_x + (_feet_x - _light.x) * _weapon_projection_scale,
                _feet_y + (_feet_y - _light.y) * _weapon_projection_scale);
            draw_text(_feet_x + 6, _feet_y + 17, "weapon projection (75% height)");
        }
    }
    draw_set_color(c_white);
}
