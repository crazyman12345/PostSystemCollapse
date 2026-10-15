function raid_draw_equipment_layer(_item_key, _frame, _x, _y, _alpha = 1)
{
    if (_item_key == "")
        return;

    var _item = item_get(_item_key);

    if (!is_struct(_item))
        return;

    var _spr;

    if (raid_player_moving)
    {
        if (!variable_struct_exists(_item, "sprite_run"))
            return;

        _spr = _item.sprite_run;
    }
    else
    {
        if (!variable_struct_exists(_item, "sprite_idle"))
            return;

        _spr = _item.sprite_idle;
    }

    if (is_undefined(_spr) || _spr == -1)
        return;

    if (!sprite_exists(_spr))
        return;

    draw_sprite_ext(
        _spr,
        _frame,
        _x,
        _y,
        raid_player_facing,
        1,
        0,
        c_white,
        _alpha
    );
}
