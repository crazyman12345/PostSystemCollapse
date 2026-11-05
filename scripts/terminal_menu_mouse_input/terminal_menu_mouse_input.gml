function terminal_menu_mouse_input(_current_index, _option_count, _first_index, _x, _y, _width, _row_height, _select_on_hover = true)
{
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var row = floor((_mouse_y - _y) / _row_height);
    var hovered = _mouse_x >= _x && _mouse_x <= _x + _width && row >= 0 && row < _option_count;
    var _hover_index = hovered ? _first_index + row : -1;
    var _area_key = "menu:" + string(_x) + ":" + string(_y) + ":" + string(_width) + ":" + string(_row_height);
    ui_hover_sound(_area_key, hovered ? string(_hover_index) : "");

    if (hovered)
    {
        if (_select_on_hover && _current_index != _hover_index) _current_index = _hover_index;
    }

    var confirm = hovered && mouse_check_button_pressed(mb_left);
    if (confirm)
    {
        if (!_select_on_hover) _current_index = _hover_index;
        audio_play_sound(snd_interact, 0, false);
    }

    return { index: _current_index, confirm: confirm };
}
