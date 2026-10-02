function raid_draw_equipment_layer(_item_key, _frame, _x, _y)
{
    if (_item_key == "")
        return;

    var _item = item_get(_item_key);

    if (!is_struct(_item))
        return;

    var _spr;

    if (raid_player_moving)
        _spr = _item.sprite_run;
    else
        _spr = _item.sprite_idle;

    if (_spr == -1)
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
        1
    );
}