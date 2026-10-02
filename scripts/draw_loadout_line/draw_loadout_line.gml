function draw_loadout_line(
    _x,
    _y,
    _label,
    _item_key
)
{
    var item_name =
        "NONE";


    if (_item_key != "")
    {
        var item =
            item_get(_item_key);

        if (!is_undefined(item))
        {
            item_name =
                item.name;
        }
    }


    terminal_value(
        _x,
        _y,
        _label,
        item_name,
        160
    );
}