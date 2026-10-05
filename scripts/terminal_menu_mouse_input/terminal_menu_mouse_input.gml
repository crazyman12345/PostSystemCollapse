function terminal_menu_mouse_input(_current_index, _option_count, _first_index, _x, _y, _width, _row_height)
{
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var row = floor((_mouse_y - _y) / _row_height);
    var hovered = _mouse_x >= _x && _mouse_x <= _x + _width && row >= 0 && row < _option_count;

    if (hovered)
    {
        var hover_index = _first_index + row;
        if (_current_index != hover_index)
        {
            _current_index = hover_index;
            scroll_sound();
        }
    }

    var confirm = hovered && mouse_check_button_pressed(mb_left);
    if (confirm) audio_play_sound(snd_interact, 0, false);

    return { index: _current_index, confirm: confirm };
}
