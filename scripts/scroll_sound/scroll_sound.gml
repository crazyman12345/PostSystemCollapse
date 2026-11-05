function scroll_sound(){
	audio_play_sound(snd_menu,0,false);
}

function ui_hover_sound(_area_key, _hover_key)
{
    if (!variable_instance_exists(id, "ui_hover_areas")) ui_hover_areas = {};
    if (!variable_instance_exists(id, "ui_hover_frame")) ui_hover_frame = 0;

    var _previous = variable_struct_exists(ui_hover_areas, _area_key)
        ? variable_struct_get(ui_hover_areas, _area_key)
        : { key: "", frame: -2 };
    var _entered = _hover_key != ""
        && (_previous.key != _hover_key || _previous.frame < ui_hover_frame - 1);
    if (_entered) scroll_sound();
    variable_struct_set(ui_hover_areas, _area_key, { key: _hover_key, frame: ui_hover_frame });
}
