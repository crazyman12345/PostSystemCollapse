function draw_raid_bullets()
{
    var _core_xscale = 0.25;
    var _core_yscale = 0.10;
    var _previous_blend_mode = gpu_get_blendmode_ext_sepalpha();
    var _previous_color = draw_get_color();
    var _previous_alpha = draw_get_alpha();

    gpu_set_blendmode(bm_normal);
    for (var i = 0; i < array_length(raid_bullets); i++)
    {
        var b = raid_bullets[i];
        draw_sprite_ext(spr_player_bullet, 0, b.bx, b.by, _core_xscale, _core_yscale, b.bdirection, c_white, 1);
    }

    gpu_set_blendmode_ext_sepalpha(
        _previous_blend_mode[0],
        _previous_blend_mode[1],
        _previous_blend_mode[2],
        _previous_blend_mode[3]
    );
    draw_set_color(_previous_color);
    draw_set_alpha(_previous_alpha);
}
