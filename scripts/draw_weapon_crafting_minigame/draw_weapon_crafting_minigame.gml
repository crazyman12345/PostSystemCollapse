function draw_weapon_crafting_minigame()
{
    var _game = crafting_minigame_state;
    var _layout = weapon_crafting_layout();
    var _shake_x = _game.shake > 0.2 ? random_range(-_game.shake, _game.shake) : 0;
    var _shake_y = _game.shake > 0.2 ? random_range(-_game.shake, _game.shake) : 0;
    var _center_x = _layout.center_x + _shake_x;
    var _center_y = _layout.center_y + _shake_y;
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _fabric = _game.outline.process == "fabric";
    var _armor_process = _game.outline.process == "armor";

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(10, 8, 7));
    draw_rectangle(_layout.left, _layout.top, _layout.right, _layout.bottom, false);
    var _bench_sprite = _game.skill_key == "armorcrafting" ? spr_armor_bench_still : spr_weapon_bench_still;
    draw_sprite_ext(_bench_sprite, 0,
        _layout.bench_left, _layout.bench_top,
        _layout.bench_scale, _layout.bench_scale, 0, c_white, 1);

    if (_game.phase == 1)
    {
        draw_crafting_cut_metal_plate(_game, _layout);
    }
    else
    {
        draw_set_color(_fabric ? make_color_rgb(78, 91, 86) : make_color_rgb(92, 99, 101));
        for (var _chunk_index = 0; _chunk_index < array_length(_game.plate_chunks); _chunk_index++)
        {
            var _chunk = _game.plate_chunks[_chunk_index];
            draw_set_alpha(clamp(_chunk.life / 24, 0, 1));
            draw_crafting_plate_chunk(_chunk);
        }
        draw_set_alpha(1);
    }

    var _vertices = _game.outline.vertices;
    if (_game.phase == 1)
    {
        draw_set_color(make_color_rgb(210, 180, 95));
        for (var _i = 0; _i < array_length(_vertices) - 1; _i++)
            draw_line(_center_x + _vertices[_i].x, _center_y + _vertices[_i].y,
                _center_x + _vertices[_i + 1].x, _center_y + _vertices[_i + 1].y);

        var _checkpoint_count = array_length(_game.outline.checkpoints);
        var _completion = _checkpoint_count > 0 ? _game.checkpoint_completed / _checkpoint_count : 0;
        draw_set_font(fnt_terminal_small);
        draw_set_color(c_white);
        var _phase_one_name = _fabric ? "PATTERN CUTTING" : (_armor_process ? "PANEL CUTTING" : "TORCH CUTTING");
        draw_text(_layout.left + 28, _layout.top + 82, _phase_one_name);
        draw_text(_layout.left + 28, _layout.top + 116, "OUTLINE " + string(round(_completion * 100)) + "%");

        if (_fabric)
        {
            var _scissors_scale = (360 / sprite_get_width(spr_cutting_torch)) * 0.7;
            var _scissors_active = mouse_check_button(mb_left);
            var _scissors_sprite = _scissors_active ? spr_scissors_animation : spr_scissors;
            var _scissors_frame = _scissors_active ? floor(_game.scissors_animation_frame) : 0;
            var _scissors_tip_x = _scissors_active ? 78 : 34;
            var _scissors_tip_y = _scissors_active ? 407 : 394;
            draw_sprite_ext(_scissors_sprite, _scissors_frame,
                _mouse_x - _scissors_tip_x * _scissors_scale,
                _mouse_y - _scissors_tip_y * _scissors_scale,
                _scissors_scale, _scissors_scale, 0, c_white, 1);
        }
        else
        {
            var _torch_scale = 360 / sprite_get_width(spr_cutting_torch);
            var _flame_length = 64;
            var _flame_direction = 225;
            var _nozzle_x = _mouse_x - lengthdir_x(_flame_length, _flame_direction);
            var _nozzle_y = _mouse_y - lengthdir_y(_flame_length, _flame_direction);
            draw_sprite_ext(spr_cutting_torch, 0,
                _nozzle_x - 20 * _torch_scale, _nozzle_y - 140 * _torch_scale,
                _torch_scale, _torch_scale, 0, c_white, 1);
            draw_set_color(c_black);
            draw_circle(_mouse_x, _mouse_y, 6, false);
            draw_set_color(c_red);
            draw_circle(_mouse_x, _mouse_y, 4, false);
        }
    }
    else
    {
        var _hammering_complete = _game.hammer_hit_count >= array_length(_game.hammer_hits);
        if (_hammering_complete)
        {
            draw_crafting_result_shadow(_game.outline, _center_x, _center_y);
            draw_crafting_result_shape(_game.outline, _center_x, _center_y, c_white, 1);
        }
        else
        {
            draw_crafting_rough_cut(_game, _layout, _center_x, _center_y);
            draw_crafting_metal_cutout(_game.outline, _layout, _center_x, _center_y);

            var _reveal_width = 210;
            var _reveal_height = 250;
            if (_game.outline.shape == "vest" || _game.outline.shape == "bag")
            {
                _reveal_width = 240;
                _reveal_height = 280;
            }
            else if (_game.outline.shape == "helmet")
            {
                _reveal_width = 220;
                _reveal_height = 230;
            }
            else if (_game.outline.process == "metal")
            {
                _reveal_width *= max(0.45, _game.outline.display_scale);
                _reveal_height *= max(0.45, _game.outline.display_scale);
            }

            for (var _reveal_index = 0; _reveal_index < array_length(_game.outline.hammer_markers); _reveal_index++)
            {
                if (!_game.hammer_hits[_reveal_index]) continue;
                var _reveal_marker = _game.outline.hammer_markers[_reveal_index];
                draw_crafting_result_shape(_game.outline, _center_x, _center_y, c_white, 1, {
                    left: _center_x + _reveal_marker.x - _reveal_width * 0.5,
                    top: _center_y + _reveal_marker.y - _reveal_height * 0.5,
                    width: _reveal_width,
                    height: _reveal_height
                });
            }
        }

        if (_game.phase == 2 && _game.transition_timer <= 0)
        {
            for (var _marker_index = 0; _marker_index < array_length(_game.outline.hammer_markers); _marker_index++)
            {
                if (_game.hammer_hits[_marker_index]) continue;
                var _marker = _game.outline.hammer_markers[_marker_index];
                var _marker_x = _center_x + _marker.x;
                var _marker_y = _center_y + _marker.y;
                draw_set_color(c_red);
                draw_line_width(_marker_x - 12, _marker_y - 12, _marker_x + 12, _marker_y + 12, 4);
                draw_line_width(_marker_x + 12, _marker_y - 12, _marker_x - 12, _marker_y + 12, 4);
            }
        }

        draw_set_font(fnt_terminal_small);
        draw_set_color(c_white);
        var _phase_two_name = _fabric ? "STITCHING" : (_armor_process ? "FASTENING" : "HAMMER FINISHING");
        draw_text(_layout.left + 28, _layout.top + 82,
            _game.phase == 3 ? "CRAFT COMPLETE" : _phase_two_name);
        if (_game.phase != 3)
            draw_text(_layout.left + 28, _layout.top + 116,
                "REFINED " + string(_game.hammer_hit_count) + " / "
                + string(array_length(_game.hammer_hits)));

        if (_game.phase == 2 && !_fabric)
        {
            var _hammer_scale = 360 / sprite_get_width(spr_sledgehammer);
            if (_game.hammer_animation_active)
            {
                draw_sprite_ext(spr_sledgehammer_animation, floor(_game.hammer_animation_frame),
                    _game.hammer_impact_x - 300 * _hammer_scale,
                    _game.hammer_impact_y - 834 * _hammer_scale,
                    _hammer_scale, _hammer_scale, 0, c_white, 1);
            }
            else
            {
                draw_sprite_ext(spr_sledgehammer, 0,
                    _mouse_x - 119 * _hammer_scale, _mouse_y - 733 * _hammer_scale,
                    _hammer_scale, _hammer_scale, 0, c_white, 1);
            }
        }
    }

    var _torch_active = _game.phase == 1 && _game.outline.process == "metal"
        && mouse_check_button(mb_left);
    var _cutting_metal = _torch_active && _game.cut_active
        && weapon_crafting_distance_to_outline(_mouse_x - _layout.center_x,
            _mouse_y - _layout.center_y, _game.outline.vertices) <= _game.outline.tolerance;
    draw_crafting_lighting(_game, _layout, _mouse_x, _mouse_y, _torch_active, _cutting_metal);

    for (var _spark_index = 0; _spark_index < array_length(_game.sparks); _spark_index++)
    {
        var _spark = _game.sparks[_spark_index];
        draw_set_alpha(clamp(_spark.life / 10, 0, 1));
        draw_set_color(_spark_index mod 2 == 0 ? c_yellow : make_color_rgb(255, 90, 20));
        draw_line(_spark.x, _spark.y, _spark.x - _spark.dx * 2, _spark.y - _spark.dy * 2);
    }
    draw_set_alpha(1);

    if (_game.impact_timer > 0)
    {
        draw_set_alpha(_game.impact_timer / 20);
        draw_set_color(c_white);
        draw_rectangle(_layout.left, _layout.top, _layout.right, _layout.bottom, false);
        draw_set_alpha(1);
    }

    if (_game.phase == 2 && _fabric)
    {
        var _spool_sprite = _game.spool_animation_active ? spr_spool_animation : spr_spool;
        var _spool_frame = _game.spool_animation_active
            ? floor(_game.spool_animation_frame) mod sprite_get_number(spr_spool_animation)
            : 0;
        var _needle_tip_x = sprite_get_bbox_left(spr_spool) + 4;
        var _needle_tip_y = sprite_get_bbox_bottom(spr_spool) - 2;
        var _spool_scale = 400 / sprite_get_width(spr_spool);
        draw_set_color(c_white);
        draw_set_alpha(1);
        draw_sprite_ext(_spool_sprite, _spool_frame,
            _mouse_x - _needle_tip_x * _spool_scale,
            _mouse_y - _needle_tip_y * _spool_scale,
            _spool_scale, _spool_scale, 0, c_white, 1);
    }

    if (_game.phase == 3)
    {
        var _rarity = is_undefined(_game.crafted_item) ? "common" : _game.crafted_item.rarity;
        var _definition = item_get(_game.recipe.output.item_key);
        var _rarity_info = _definition.category == ItemCategory.WEAPON
            ? weapon_rarity_get(_rarity)
            : armor_rarity_get(_rarity);
        draw_set_halign(fa_center);
        draw_set_color(_rarity_info.color);
        draw_set_font(fnt_terminal);
        draw_text(_layout.center_x, _layout.bottom - 150,
            "SCORE " + string(_game.final_score) + " / 100");
        draw_text(_layout.center_x, _layout.bottom - 102,
            string_upper(_rarity_info.name) + " " + string_upper(_definition.name));
        draw_set_halign(fa_left);
    }

    heading_box(1, 1, display_get_gui_width() - 2, display_get_gui_height() - 2,
        "WEAPON CRAFTING", 60);

    var _back = weapon_crafting_back_button_rect();
    var _back_hovered = point_in_rectangle(_mouse_x, _mouse_y,
        _back.left, _back.top, _back.right, _back.bottom);
    draw_set_alpha(0.9);
    draw_set_color(global.hideout_panel_color);
    draw_rectangle(_back.left, _back.top, _back.right, _back.bottom, false);
    draw_set_alpha(1);
    draw_set_color(_back_hovered ? global.hideout_interactive_color : global.hideout_border_color);
    draw_rectangle(_back.left, _back.top, _back.right, _back.bottom, true);
    var _arrow_x = (_back.left + _back.right) * 0.5;
    var _arrow_y = (_back.top + _back.bottom) * 0.5;
    draw_line_width(_arrow_x - 10, _arrow_y, _arrow_x + 11, _arrow_y, 3);
    draw_line_width(_arrow_x - 10, _arrow_y, _arrow_x - 1, _arrow_y - 9, 3);
    draw_line_width(_arrow_x - 10, _arrow_y, _arrow_x - 1, _arrow_y + 9, 3);
}

function draw_crafting_lighting(_game, _layout, _mouse_x, _mouse_y, _torch_active, _cutting_metal)
{
    var _settings = global.graphics_settings;
    var _width = max(1, ceil(display_get_gui_width()));
    var _height = max(1, ceil(display_get_gui_height()));
    var _dynamic_lighting = _settings.dynamic_lighting;
    var _use_darkness = _dynamic_lighting && _settings.ambient_darkness;
    var _use_colored_lighting = _dynamic_lighting && _settings.colored_lighting;
    var _lamp_radius = min(_layout.plate_right - _layout.plate_left, 460);
    var _lamp_x = _layout.center_x;
    var _lamp_y = _layout.center_y - 20;

    if (_use_darkness)
    {
        _game.lighting_surface = crafting_surface_ensure(_game.lighting_surface, _width, _height);
        if (surface_exists(_game.lighting_surface))
        {
            surface_set_target(_game.lighting_surface);
            draw_clear_alpha(c_black, 0.68);
            gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_zero, bm_inv_src_alpha);
            draw_raid_radial_light(_lamp_x, _lamp_y, _lamp_radius, 0.58,
                c_white, 0, 1.35, 0.48, 32, true);
            if (_torch_active)
                draw_raid_radial_light(_mouse_x, _mouse_y, 155, 0.72,
                    c_white, 0, 1.1, 0.8, 24, true);
            if (_cutting_metal)
                draw_raid_radial_light(_mouse_x, _mouse_y, 120, 0.72,
                    c_white, 0, 1.15, 0.9, 24, true);
            surface_reset_target();
            gpu_set_blendmode(bm_normal);
            draw_set_alpha(1);
            draw_set_color(c_white);
            draw_surface(_game.lighting_surface, 0, 0);
        }
    }
    else _game.lighting_surface = graphics_settings_release_surface(_game.lighting_surface);

    if (_use_colored_lighting)
    {
        gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_one, bm_zero, bm_one);
        draw_raid_radial_light(_lamp_x, _lamp_y, _lamp_radius, 0.13,
            make_color_rgb(255, 196, 118), 0, 1.35, 0.48, 32, true);
        if (_torch_active)
            draw_raid_radial_light(_mouse_x, _mouse_y, 155, 0.42,
                make_color_rgb(255, 122, 38), 0, 1.1, 0.8, 24, true);
        if (_cutting_metal)
            draw_raid_radial_light(_mouse_x, _mouse_y, 120, 0.28,
                make_color_rgb(245, 250, 255), 0, 1.15, 0.9, 24, true);
        gpu_set_blendmode(bm_normal);
    }

    if (_settings.bloom && (_torch_active || _cutting_metal))
    {
        _game.emissive_surface = crafting_surface_ensure(_game.emissive_surface, _width, _height);
        _game.bloom_blur_surface = crafting_surface_ensure(_game.bloom_blur_surface, _width, _height);
        _game.bloom_surface = crafting_surface_ensure(_game.bloom_surface, _width, _height);
        if (surface_exists(_game.emissive_surface)
        && surface_exists(_game.bloom_blur_surface)
        && surface_exists(_game.bloom_surface))
        {
            surface_set_target(_game.emissive_surface);
            draw_clear_alpha(c_black, 0);
            gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
            if (_torch_active) draw_crafting_torch_flame(_mouse_x, _mouse_y, make_color_rgb(255, 110, 28), 1);
            if (_cutting_metal)
            {
                draw_set_color(c_white);
                draw_set_alpha(1);
                draw_circle(_mouse_x, _mouse_y, 6, false);
            }
            surface_reset_target();
            raid_bloom_process_surface(_game.emissive_surface, _game.bloom_surface,
                _game.bloom_blur_surface, raid_bloom_blur_radius, raid_bloom_blur_passes);
            var _previous_texfilter = gpu_get_texfilter();
            gpu_set_texfilter(true);
            gpu_set_blendmode_ext_sepalpha(bm_one, bm_one, bm_zero, bm_one);
            draw_raid_bloom_surface(_game.bloom_surface, 0, 0, _width, _height, raid_bloom_intensity * 0.4);
            gpu_set_texfilter(_previous_texfilter);
            gpu_set_blendmode(bm_normal);
        }
    }
    else
    {
        _game.emissive_surface = graphics_settings_release_surface(_game.emissive_surface);
        _game.bloom_blur_surface = graphics_settings_release_surface(_game.bloom_blur_surface);
        _game.bloom_surface = graphics_settings_release_surface(_game.bloom_surface);
    }

    if (_torch_active) draw_crafting_torch_flame(_mouse_x, _mouse_y, c_white, 1);
    if (_cutting_metal)
    {
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_circle(_mouse_x, _mouse_y, 3, false);
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}

function draw_crafting_torch_flame(_mouse_x, _mouse_y, _color, _alpha)
{
    var _flame_length = 64;
    var _flame_direction = 225;
    var _nozzle_x = _mouse_x - lengthdir_x(_flame_length, _flame_direction);
    var _nozzle_y = _mouse_y - lengthdir_y(_flame_length, _flame_direction);
    draw_sprite_ext(spr_cutting_torch_flame, 0, _nozzle_x, _nozzle_y,
        _flame_length / (sprite_get_width(spr_cutting_torch_flame) - 1), 1,
        _flame_direction, _color, _alpha);
}

function crafting_surface_ensure(_surface, _width, _height)
{
    if (surface_exists(_surface)
    && surface_get_width(_surface) == _width
    && surface_get_height(_surface) == _height) return _surface;
    if (surface_exists(_surface)) surface_free(_surface);
    return surface_create(_width, _height);
}

function draw_crafting_cut_metal_plate(_game, _layout)
{
    var _sheet_sprite = _game.outline.process == "metal" ? spr_metal_plate : spr_cloth_sheet;
    var _width = max(1, ceil(_layout.plate_right - _layout.plate_left));
    var _height = max(1, ceil(_layout.plate_bottom - _layout.plate_top));
    if (!surface_exists(_game.plate_surface)
    || surface_get_width(_game.plate_surface) != _width
    || surface_get_height(_game.plate_surface) != _height)
    {
        if (surface_exists(_game.plate_surface)) surface_free(_game.plate_surface);
        _game.plate_surface = surface_create(_width, _height);
    }
    if (!surface_exists(_game.plate_surface)) return;

    surface_set_target(_game.plate_surface);
    draw_clear_alpha(c_black, 0);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_sprite_stretched(_sheet_sprite, 0, 0, 0, _width, _height);

    if (array_length(_game.cut_trail) > 1)
    {
        var _fabric_cut = _game.outline.process == "fabric";
        draw_set_color(_fabric_cut ? c_black : make_color_rgb(20, 13, 9));
        draw_set_alpha(_fabric_cut ? 0.24 : 0.88);
        draw_crafting_cut_surface_trail(_game.cut_trail, _layout, _fabric_cut ? 10 : 16);

        draw_set_alpha(1);
        draw_set_color(c_white);
        gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_zero, bm_inv_src_alpha);
        draw_crafting_cut_surface_trail(_game.cut_trail, _layout, 6);
        gpu_set_blendmode(bm_normal);
    }

    surface_reset_target();
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_surface_stretched(_game.plate_surface,
        _layout.plate_left, _layout.plate_top,
        _layout.plate_right - _layout.plate_left,
        _layout.plate_bottom - _layout.plate_top);
}

function draw_crafting_cut_surface_trail(_trail, _layout, _width)
{
    for (var _trail_index = 1; _trail_index < array_length(_trail); _trail_index++)
    {
        if (_trail[_trail_index].start) continue;
        var _previous = crafting_cut_trail_smooth_point(_trail, _trail_index - 1);
        var _current = crafting_cut_trail_smooth_point(_trail, _trail_index);
        var _from_x = _previous.x - _layout.plate_left;
        var _from_y = _previous.y - _layout.plate_top;
        var _to_x = _current.x - _layout.plate_left;
        var _to_y = _current.y - _layout.plate_top;
        draw_line_width(_from_x, _from_y, _to_x, _to_y, _width);
        draw_circle(_from_x, _from_y, _width * 0.5, false);
        draw_circle(_to_x, _to_y, _width * 0.5, false);
    }
}

function draw_crafting_rough_cut(_game, _layout, _center_x, _center_y)
{
    if (array_length(_game.cut_trail) <= 1) return;

    var _offset_x = _center_x - _layout.center_x;
    var _offset_y = _center_y - _layout.center_y;
    draw_set_alpha(1);
    draw_set_color(c_gray);
    var _sheet_sprite = _game.outline.process == "metal" ? spr_metal_plate : spr_cloth_sheet;
    var _texture_uvs = texture_get_uvs(sprite_get_texture(_sheet_sprite, 0));
    draw_primitive_begin_texture(pr_trianglelist, sprite_get_texture(_sheet_sprite, 0));

    var _previous_point = undefined;
    for (var _trail_index = 0; _trail_index < array_length(_game.cut_trail); _trail_index++)
    {
        var _current = _game.cut_trail[_trail_index];
        var _current_point = crafting_cut_trail_smooth_point(_game.cut_trail, _trail_index);
        _current_point.x += _offset_x;
        _current_point.y += _offset_y;
        if (_current.start || is_undefined(_previous_point)) _previous_point = _current_point;

        var _distance = point_distance(_previous_point.x, _previous_point.y,
            _current_point.x, _current_point.y);
        var _steps = max(1, ceil(_distance / 5));
        for (var _step = 0; _step <= _steps; _step++)
        {
            var _amount = _step / _steps;
            var _point_x = lerp(_previous_point.x, _current_point.x, _amount);
            var _point_y = lerp(_previous_point.y, _current_point.y, _amount);
            if (!crafting_cut_point_is_refined(_game, _center_x, _center_y, _point_x, _point_y))
            {
                for (var _curve = 0; _curve < 12; _curve++)
                {
                    var _angle_1 = (_curve / 12) * 360;
                    var _angle_2 = ((_curve + 1) / 12) * 360;
                    draw_crafting_plate_texture_vertex(_layout, _texture_uvs,
                        _point_x, _point_y, _point_x - _offset_x, _point_y - _offset_y, 1);
                    draw_crafting_plate_texture_vertex(_layout, _texture_uvs,
                        _point_x + lengthdir_x(14, _angle_1), _point_y + lengthdir_y(14, _angle_1),
                        _point_x - _offset_x + lengthdir_x(14, _angle_1),
                        _point_y - _offset_y + lengthdir_y(14, _angle_1), 1);
                    draw_crafting_plate_texture_vertex(_layout, _texture_uvs,
                        _point_x + lengthdir_x(14, _angle_2), _point_y + lengthdir_y(14, _angle_2),
                        _point_x - _offset_x + lengthdir_x(14, _angle_2),
                        _point_y - _offset_y + lengthdir_y(14, _angle_2), 1);
                }
            }
        }
        _previous_point = _current_point;
    }
    draw_primitive_end();
    draw_set_alpha(1);
}

function draw_crafting_result_shadow(_outline, _center_x, _center_y)
{
    if (!global.graphics_settings.contact_shadows) return;

    var _width = 420 * _outline.display_scale;
    var _height = 180 * _outline.display_scale;
    if (_outline.result_sprite != -1 && sprite_exists(_outline.result_sprite))
    {
        var _sprite = _outline.result_sprite;
        var _left = sprite_get_bbox_left(_sprite);
        var _top = sprite_get_bbox_top(_sprite);
        var _sprite_width = sprite_get_bbox_right(_sprite) - _left + 1;
        var _sprite_height = sprite_get_bbox_bottom(_sprite) - _top + 1;
        var _scale = min(650 / _sprite_width, 430 / _sprite_height) * _outline.display_scale;
        shader_set(shd_crafting_silhouette);
        draw_sprite_part_ext(_sprite, 0, _left, _top, _sprite_width, _sprite_height,
            _center_x - _sprite_width * _scale * 0.5 + 9,
            _center_y - _sprite_height * _scale * 0.5 + 12,
            _scale, _scale, c_black, 0.48);
        shader_reset();
        return;
    }

    draw_set_color(c_black);
    draw_sprite_ext(spr_character_shadow, 0,
        _center_x + 6, _center_y + _height * 0.18,
        (_width * 0.82) / sprite_get_width(spr_character_shadow),
        max(10, _height * 0.2) / sprite_get_height(spr_character_shadow),
        0, c_black, 0.5);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

function draw_crafting_metal_cutout(_outline, _layout, _center_x, _center_y)
{
    var _sheet_sprite = _outline.process == "metal" ? spr_metal_plate : spr_cloth_sheet;
    var _texture = sprite_get_texture(_sheet_sprite, 0);
    var _texture_uvs = texture_get_uvs(_texture);
    var _offset_x = _center_x - _layout.center_x;
    var _offset_y = _center_y - _layout.center_y;
    draw_primitive_begin_texture(pr_trianglefan, _texture);
    draw_crafting_plate_texture_vertex(_layout, _texture_uvs,
        _center_x, _center_y, _layout.center_x, _layout.center_y, 1);
    for (var _vertex_index = 0; _vertex_index < array_length(_outline.vertices); _vertex_index++)
    {
        var _vertex = _outline.vertices[_vertex_index];
        draw_crafting_plate_texture_vertex(_layout, _texture_uvs,
            _center_x + _vertex.x, _center_y + _vertex.y,
            _center_x + _vertex.x - _offset_x, _center_y + _vertex.y - _offset_y, 1);
    }
    draw_primitive_end();
}

function draw_crafting_plate_texture_vertex(_layout, _texture_uvs,
    _draw_x, _draw_y, _texture_x, _texture_y, _alpha)
{
    var _amount_x = clamp((_texture_x - _layout.plate_left)
        / (_layout.plate_right - _layout.plate_left), 0, 1);
    var _amount_y = clamp((_texture_y - _layout.plate_top)
        / (_layout.plate_bottom - _layout.plate_top), 0, 1);
    draw_vertex_texture_colour(_draw_x, _draw_y,
        lerp(_texture_uvs[0], _texture_uvs[2], _amount_x),
        lerp(_texture_uvs[1], _texture_uvs[3], _amount_y), c_white, _alpha);
}

function crafting_cut_trail_smooth_point(_trail, _index)
{
    var _stroke_start = _index;
    while (_stroke_start > 0 && !_trail[_stroke_start].start) _stroke_start--;
    var _stroke_end = _index;
    while (_stroke_end + 1 < array_length(_trail) && !_trail[_stroke_end + 1].start) _stroke_end++;

    var _first = max(_stroke_start, _index - 4);
    var _last = min(_stroke_end, _index + 4);
    var _x = 0;
    var _y = 0;
    var _count = 0;
    for (var _sample = _first; _sample <= _last; _sample++)
    {
        _x += _trail[_sample].x;
        _y += _trail[_sample].y;
        _count += 1;
    }
    return { x: _x / _count, y: _y / _count };
}

function crafting_cut_point_is_refined(_game, _center_x, _center_y, _point_x, _point_y)
{
    for (var _marker_index = 0; _marker_index < array_length(_game.outline.hammer_markers); _marker_index++)
    {
        if (!_game.hammer_hits[_marker_index]) continue;
        var _marker = _game.outline.hammer_markers[_marker_index];
        if (point_distance(_point_x, _point_y,
            _center_x + _marker.x, _center_y + _marker.y) <= _game.outline.refine_radius) return true;
    }
    return false;
}

function draw_crafting_plate_chunk(_chunk)
{
    var _half_width = _chunk.width * 0.5;
    var _half_height = _chunk.height * 0.5;
    var _distance = point_distance(0, 0, _half_width, _half_height);
    var _corner_angle = point_direction(0, 0, _half_width, _half_height);
    if (_chunk.textured)
        draw_primitive_begin_texture(pr_trianglefan, sprite_get_texture(_chunk.texture_sprite, 0));
    else draw_primitive_begin(pr_trianglefan);
    if (_chunk.textured)
        draw_vertex_texture_colour(_chunk.x, _chunk.y,
            (_chunk.u1 + _chunk.u2) * 0.5, (_chunk.v1 + _chunk.v2) * 0.5, c_white, draw_get_alpha());
    else draw_vertex(_chunk.x, _chunk.y);
    var _corner_x = _chunk.x + lengthdir_x(_distance, _corner_angle + _chunk.rotation);
    var _corner_y = _chunk.y + lengthdir_y(_distance, _corner_angle + _chunk.rotation);
    if (_chunk.textured) draw_vertex_texture_colour(_corner_x, _corner_y, _chunk.u2, _chunk.v2, c_white, draw_get_alpha());
    else draw_vertex(_corner_x, _corner_y);
    _corner_x = _chunk.x + lengthdir_x(_distance, 180 - _corner_angle + _chunk.rotation);
    _corner_y = _chunk.y + lengthdir_y(_distance, 180 - _corner_angle + _chunk.rotation);
    if (_chunk.textured) draw_vertex_texture_colour(_corner_x, _corner_y, _chunk.u1, _chunk.v2, c_white, draw_get_alpha());
    else draw_vertex(_corner_x, _corner_y);
    _corner_x = _chunk.x + lengthdir_x(_distance, 180 + _corner_angle + _chunk.rotation);
    _corner_y = _chunk.y + lengthdir_y(_distance, 180 + _corner_angle + _chunk.rotation);
    if (_chunk.textured) draw_vertex_texture_colour(_corner_x, _corner_y, _chunk.u1, _chunk.v1, c_white, draw_get_alpha());
    else draw_vertex(_corner_x, _corner_y);
    _corner_x = _chunk.x + lengthdir_x(_distance, 360 - _corner_angle + _chunk.rotation);
    _corner_y = _chunk.y + lengthdir_y(_distance, 360 - _corner_angle + _chunk.rotation);
    if (_chunk.textured) draw_vertex_texture_colour(_corner_x, _corner_y, _chunk.u2, _chunk.v1, c_white, draw_get_alpha());
    else draw_vertex(_corner_x, _corner_y);
    _corner_x = _chunk.x + lengthdir_x(_distance, _corner_angle + _chunk.rotation);
    _corner_y = _chunk.y + lengthdir_y(_distance, _corner_angle + _chunk.rotation);
    if (_chunk.textured) draw_vertex_texture_colour(_corner_x, _corner_y, _chunk.u2, _chunk.v2, c_white, draw_get_alpha());
    else draw_vertex(_corner_x, _corner_y);
    draw_primitive_end();
}

function draw_crafting_result_shape(_outline, _center_x, _center_y, _color, _alpha,
    _clip = undefined, _solid_silhouette = false)
{
    if (_alpha <= 0) return;
    var _previous_scissor = undefined;
    if (is_struct(_clip))
    {
        _previous_scissor = gpu_get_scissor();
        gpu_set_scissor(_clip.left, _clip.top, _clip.width, _clip.height);
    }

    if (_outline.result_sprite != -1 && sprite_exists(_outline.result_sprite))
    {
        var _sprite = _outline.result_sprite;
        var _left = sprite_get_bbox_left(_sprite);
        var _top = sprite_get_bbox_top(_sprite);
        var _width = sprite_get_bbox_right(_sprite) - _left + 1;
        var _height = sprite_get_bbox_bottom(_sprite) - _top + 1;
        var _scale = min(650 / _width, 430 / _height) * _outline.display_scale;
        if (_solid_silhouette) shader_set(shd_crafting_silhouette);
        draw_sprite_part_ext(_sprite, 0, _left, _top, _width, _height,
            _center_x - _width * _scale * 0.5, _center_y - _height * _scale * 0.5,
            _scale, _scale, _color, _alpha);
        if (_solid_silhouette) shader_reset();
        if (is_struct(_previous_scissor))
            gpu_set_scissor(_previous_scissor.x, _previous_scissor.y, _previous_scissor.w, _previous_scissor.h);
        return;
    }

    draw_set_alpha(_alpha);
    draw_set_color(_color);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_center_x, _center_y);
    for (var _i = 0; _i < array_length(_outline.vertices); _i++)
        draw_vertex(_center_x + _outline.vertices[_i].x, _center_y + _outline.vertices[_i].y);
    draw_primitive_end();
    draw_set_alpha(1);
    if (is_struct(_previous_scissor))
        gpu_set_scissor(_previous_scissor.x, _previous_scissor.y, _previous_scissor.w, _previous_scissor.h);
}
