function draw_raid_character_shadow(_feet_x, _feet_y, _size_scale = 1, _opacity_scale = 1)
{
    var _shadow_sprite = spr_character_shadow;
    var _size = max(0, raid_character_shadow_size * _size_scale);
    var _opacity = clamp(raid_character_shadow_opacity * _opacity_scale, 0, 1);
    if (_size <= 0 || _opacity <= 0) return;

    gpu_set_blendmode(bm_normal);
    draw_sprite_ext(
        _shadow_sprite,
        0,
        _feet_x,
        _feet_y,
        _size / sprite_get_width(_shadow_sprite),
        (_size * 0.3) / sprite_get_height(_shadow_sprite),
        0,
        c_black,
        _opacity
    );
}
