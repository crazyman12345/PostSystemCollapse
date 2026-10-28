function draw_raid_character_light_masks(_camera_x, _camera_y)
{
    var _settings = global.graphics_settings;
    var _player_minimum = clamp(_settings.player_minimum_brightness, 0, 1);
    var _enemy_minimum = clamp(_settings.enemy_minimum_brightness, 0, 1);
    var _attack_ring_minimum = clamp(_settings.attack_ring_minimum_brightness, 0, 1);
    var _blood_minimum = clamp(_settings.blood_minimum_brightness, 0, 1);
    var _ambient_illumination = 1 - clamp(raid_lighting_ambient_alpha, 0, 1);
    if (_player_minimum <= _ambient_illumination && _enemy_minimum <= _ambient_illumination
    && _attack_ring_minimum <= _ambient_illumination && _blood_minimum <= _ambient_illumination) return;

    var _previous_world_matrix = matrix_get(matrix_world);
    matrix_set(matrix_world, matrix_build(-_camera_x, -_camera_y, 0, 0, 0, 0, 1, 1, 1));
    gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_one, bm_one);
    gpu_set_blendequation_sepalpha(bm_eq_add, bm_eq_min);
    shader_set(shd_raid_character_light_mask);
    var _minimum_uniform = shader_get_uniform(shd_raid_character_light_mask, "u_minimum_brightness");

    if (_player_minimum > _ambient_illumination)
    {
        shader_set_uniform_f(_minimum_uniform, _player_minimum);
        draw_raid_player(true, 1);
        if (raid.state != RaidState.DEATH) draw_raid_gun(true, 1);
    }

    if (raid.state != RaidState.DEATH && _enemy_minimum > _ambient_illumination)
    {
        shader_set_uniform_f(_minimum_uniform, _enemy_minimum);
        draw_raid_enemies(true, 1);
    }

    if (raid.state != RaidState.DEATH && _attack_ring_minimum > _ambient_illumination)
    {
        shader_set_uniform_f(_minimum_uniform, _attack_ring_minimum);
        draw_raid_ring_hazards();
    }

    if (_blood_minimum > _ambient_illumination)
    {
        shader_set_uniform_f(_minimum_uniform, _blood_minimum);
        blood_surface_draw();
        blood_spray_draw();
    }

    shader_reset();
    gpu_set_blendequation_sepalpha(bm_eq_add, bm_eq_add);
    matrix_set(matrix_world, _previous_world_matrix);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
