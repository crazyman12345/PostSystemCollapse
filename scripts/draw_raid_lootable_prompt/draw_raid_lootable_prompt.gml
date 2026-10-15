function draw_raid_lootable_prompt()
{
    if (!raid.room_cleared)
        return;


    for (
        var i = 0;
        i < array_length(raid_lootables);
        i++
    )
    {
        var l =
            raid_lootables[i];


        if (
            point_distance(
                raid_player_x,
                raid_player_y,
                l.lootable_x,
                l.lootable_y
            ) <= 36
        )
        {
            var _prompt_y = l.lootable_y - 30;
            if (variable_struct_exists(l, "sprite_index") && l.sprite_index >= 0)
            {
                var _sprite_y = variable_struct_exists(l, "sprite_y") ? l.sprite_y : l.lootable_y;
                var _yscale = variable_struct_exists(l, "image_yscale") ? l.image_yscale : 1;
                var _sprite_top = _sprite_y + (sprite_get_bbox_top(l.sprite_index) - sprite_get_yoffset(l.sprite_index)) * _yscale;
                var _sprite_bottom = _sprite_y + (sprite_get_bbox_bottom(l.sprite_index) + 1 - sprite_get_yoffset(l.sprite_index)) * _yscale;
                _prompt_y = min(_sprite_top, _sprite_bottom) - 25;
            }

            draw_interact_prompt(
                l.lootable_x,
                _prompt_y
            );

            return;
        }
    }
}
