if (
    state == GameState.RAID
    && raid.state != RaidState.RESULT
)
{
    var _surface_width = surface_get_width(application_surface);
    var _surface_height = surface_get_height(application_surface);
    var _gui_width = display_get_gui_width();
    var _gui_height = display_get_gui_height();
    var _head_blacked_out = health_limbs[PlayerLimb.HEAD].injury == LimbInjuryState.BLACKED_OUT;

    if (!surface_exists(raid_map_surface)
    || surface_get_width(raid_map_surface) != _surface_width
    || surface_get_height(raid_map_surface) != _surface_height)
    {
        raid_map_surface = graphics_settings_release_surface(raid_map_surface);
        raid_map_surface = surface_create(_surface_width, _surface_height);
    }

    if (_head_blacked_out && (!surface_exists(raid_head_blur_surface)
    || surface_get_width(raid_head_blur_surface) != _surface_width
    || surface_get_height(raid_head_blur_surface) != _surface_height))
    {
        raid_head_blur_surface = graphics_settings_release_surface(raid_head_blur_surface);
        raid_head_blur_surface = surface_create(_surface_width, _surface_height);
    }

    if (_head_blacked_out && (!surface_exists(raid_head_blur_temporary_surface)
    || surface_get_width(raid_head_blur_temporary_surface) != _surface_width
    || surface_get_height(raid_head_blur_temporary_surface) != _surface_height))
    {
        raid_head_blur_temporary_surface = graphics_settings_release_surface(raid_head_blur_temporary_surface);
        raid_head_blur_temporary_surface = surface_create(_surface_width, _surface_height);
    }

    if (surface_exists(raid_map_surface))
    {
        surface_set_target(raid_map_surface);
        draw_clear(c_black);
        draw_surface_stretched(application_surface, 0, 0, _gui_width, _gui_height);
        surface_reset_target();

        var _draw_surface = raid_map_surface;
        if (_head_blacked_out && surface_exists(raid_head_blur_surface) && surface_exists(raid_head_blur_temporary_surface))
        {
            raid_bloom_process_surface(raid_map_surface, raid_head_blur_surface, raid_head_blur_temporary_surface,
                health_config.blacked_head_blur_radius, 1);
        }

        gpu_set_blendmode(bm_normal);
        draw_set_color(c_white);
        draw_set_alpha(1);
        shader_set(shd_raid_color_grade);
        shader_set_uniform_f(shader_get_uniform(shd_raid_color_grade, "u_saturation"), raid_color_grade_saturation);
        shader_set_uniform_f(shader_get_uniform(shd_raid_color_grade, "u_contrast"), raid_color_grade_contrast);
        shader_set_uniform_f(shader_get_uniform(shd_raid_color_grade, "u_brightness"), raid_color_grade_brightness);
        draw_surface_stretched(_draw_surface, 0, 0, _gui_width, _gui_height);
        if (_head_blacked_out && surface_exists(raid_head_blur_surface))
        {
            draw_set_alpha(clamp((1 - dcos(raid_head_blur_phase * 360)) * 0.5 * health_config.blacked_head_blur_intensity, 0, 1));
            draw_surface_stretched(raid_head_blur_surface, 0, 0, _gui_width, _gui_height);
        }
        shader_reset();
        draw_set_alpha(1);
    }
}
