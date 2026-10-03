function terminal_menu_input(_current_index, _option_count)
{
    if (keyboard_check_pressed(ord("W")))
    {
        _current_index--;

        if (_current_index < 0)
        {
            _current_index = _option_count - 1;
        }
		scroll_sound();
    }

    if (keyboard_check_pressed(ord("S")))
    {
        _current_index++;

        if (_current_index >= _option_count)
        {
            _current_index = 0;
        }
		scroll_sound();
    }

    return _current_index;
}