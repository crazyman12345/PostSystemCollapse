function terminal_menu_item(_xpos, _ypos, _label, _selected, _enabled = true)
{
    var prefix = "  ";

    if (_selected)
    {
        prefix = "> ";
    }

    draw_set_color(_enabled ? global.ui_interactive_color : c_gray);
    draw_text(_xpos, _ypos, prefix + _label);
}
