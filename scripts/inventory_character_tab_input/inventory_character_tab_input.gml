function inventory_character_tab_input(_panel_left)
{
    if (!mouse_check_button_pressed(mb_left)) return false;
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _left = _panel_left + 20;
    var _top = 98;
    var _tab_width = 68;
    var _tab_height = 26;

    if (_mouse_y < _top || _mouse_y >= _top + _tab_height) return false;
    if (_mouse_x >= _left && _mouse_x < _left + _tab_width)
        inventory_character_tab = InventoryCharacterTab.EQUIPMENT;
    else if (_mouse_x >= _left + _tab_width + 6 && _mouse_x < _left + (_tab_width * 2) + 6)
        inventory_character_tab = InventoryCharacterTab.HEALTH;
    else
        return false;

    audio_play_sound(snd_menu, 0, false);
    return true;
}
