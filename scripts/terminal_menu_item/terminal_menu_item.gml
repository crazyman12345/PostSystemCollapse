function terminal_menu_item(_xpos, _ypos, _label, _selected)
{
    var prefix = "  ";

    if (_selected)
    {
        prefix = "> ";
    }

    draw_text(_xpos, _ypos, prefix + _label);
}