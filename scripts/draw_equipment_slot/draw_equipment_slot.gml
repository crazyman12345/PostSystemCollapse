function draw_equipment_slot(
    _x,
    _y,
    _width,
    _height,
    _label,
    _item_key,
    _selected
)
{
    terminal_panel(
        _x,
        _y,
        _width,
        _height,
        _label
    );

    var item_name = "NONE";

    if (_item_key != "")
    {
        var item = item_get(_item_key);

        if (!is_undefined(item))
        {
            item_name = item.name;
        }
    }

    if (_selected)
    {
        draw_text(
            _x + 40,
            _y + 35,
            "> " + item_name
        );
    }
    else
    {
        draw_text(
            _x + 40,
            _y + 35,
            "  " + item_name
        );
    }
}