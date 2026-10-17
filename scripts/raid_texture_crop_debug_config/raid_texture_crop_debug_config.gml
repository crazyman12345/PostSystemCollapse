function raid_texture_crop_debug_init()
{
    raid_texture_crop_debug_active = false;
    raid_texture_crop_debug_tab = 0;
    raid_texture_crop_debug_selection = 0;
    raid_texture_crop_debug_drag_row = -1;
    raid_texture_crop_debug_status = "F7 TO OPEN";
    raid_texture_crop_debug_filename = "raid_texture_crop_debug.json";
    raid_texture_crop_export_filename = "raid_texture_crop_settings.txt";
    raid_texture_crop_debug_load();
}


function raid_texture_crop_debug_material(_tab = raid_texture_crop_debug_tab)
{
    return _tab == 0 ? raid_environment.inner_face_material : raid_environment.cap_material;
}


function raid_texture_crop_debug_set(_material, _name, _value)
{
    if (_name == "scale_x" || _name == "scale_y")
        variable_struct_set(_material, _name, clamp(round(_value), 10, 200));
    else if (_name == "uv_offset_u" || _name == "uv_offset_v")
        variable_struct_set(_material, _name, clamp(round(_value), -100, 100));
    else
        variable_struct_set(_material, _name, clamp(round(_value), -45, 45));
}


function raid_texture_crop_debug_reset(_tab)
{
    var _material = raid_texture_crop_debug_material(_tab);
    _material.crop_left = 0;
    _material.crop_right = 0;
    _material.crop_top = 0;
    _material.crop_bottom = 0;
    _material.offset_x = 0;
    _material.offset_y = 0;
    _material.uv_offset_u = 0;
    _material.uv_offset_v = 0;
    _material.scale_x = 100;
    _material.scale_y = 100;
}


function raid_texture_crop_debug_data()
{
    var _inner = raid_environment.inner_face_material;
    var _cap = raid_environment.cap_material;
    return {
        version: 4,
        inner_face: {
            crop_left: _inner.crop_left,
            crop_right: _inner.crop_right,
            crop_top: _inner.crop_top,
            crop_bottom: _inner.crop_bottom,
            offset_x: _inner.offset_x,
            offset_y: _inner.offset_y,
            uv_offset_u: _inner.uv_offset_u,
            uv_offset_v: _inner.uv_offset_v,
            scale_x: _inner.scale_x,
            scale_y: _inner.scale_y
        },
        top_cap: {
            crop_left: _cap.crop_left,
            crop_right: _cap.crop_right,
            crop_top: _cap.crop_top,
            crop_bottom: _cap.crop_bottom,
            offset_x: _cap.offset_x,
            offset_y: _cap.offset_y,
            uv_offset_u: _cap.uv_offset_u,
            uv_offset_v: _cap.uv_offset_v,
            scale_x: _cap.scale_x,
            scale_y: _cap.scale_y
        }
    };
}


function raid_texture_crop_debug_apply_data(_data)
{
    if (!is_struct(_data)) return;
    if (variable_struct_exists(_data, "inner_face"))
        raid_texture_crop_debug_apply_material(raid_environment.inner_face_material, _data.inner_face);
    if (variable_struct_exists(_data, "top_cap"))
        raid_texture_crop_debug_apply_material(raid_environment.cap_material, _data.top_cap);
}


function raid_texture_crop_debug_apply_material(_material, _data)
{
    if (!is_struct(_data)) return;
    var _names = ["crop_left", "crop_right", "crop_top", "crop_bottom", "offset_x", "offset_y", "uv_offset_u", "uv_offset_v", "scale_x", "scale_y"];
    for (var _index = 0; _index < array_length(_names); _index++)
    {
        var _name = _names[_index];
        if (variable_struct_exists(_data, _name))
            raid_texture_crop_debug_set(_material, _name, variable_struct_get(_data, _name));
    }
}


function raid_texture_crop_debug_load()
{
    if (!file_exists(raid_texture_crop_debug_filename)) return false;
    var _file = file_text_open_read(raid_texture_crop_debug_filename);
    if (_file < 0) return false;
    var _json = "";
    while (!file_text_eof(_file))
    {
        _json += file_text_read_string(_file);
        file_text_readln(_file);
    }
    file_text_close(_file);

    try
    {
        raid_texture_crop_debug_apply_data(json_parse(_json));
        raid_texture_crop_debug_status = "LOADED " + raid_texture_crop_debug_filename;
        return true;
    }
    catch (_exception)
    {
        raid_texture_crop_debug_status = "INVALID DEBUG CONFIG";
        return false;
    }
}


function raid_texture_crop_debug_save()
{
    var _file = file_text_open_write(raid_texture_crop_debug_filename);
    if (_file < 0)
    {
        raid_texture_crop_debug_status = "SAVE FAILED";
        return false;
    }
    file_text_write_string(_file, json_stringify(raid_texture_crop_debug_data(), true));
    file_text_close(_file);
    raid_texture_crop_debug_status = "SAVED " + raid_texture_crop_debug_filename;
    return true;
}


function raid_texture_crop_debug_copy()
{
    var _inner = raid_environment.inner_face_material;
    var _cap = raid_environment.cap_material;
    var _text = "INNER FACE\n"
        + "  Crop Left: " + string(_inner.crop_left) + "%\n"
        + "  Crop Right: " + string(_inner.crop_right) + "%\n"
        + "  Crop Top: " + string(_inner.crop_top) + "%\n"
        + "  Crop Bottom: " + string(_inner.crop_bottom) + "%\n"
        + "  Offset X: " + string(_inner.offset_x) + "%\n"
        + "  Offset Y: " + string(_inner.offset_y) + "%\n"
        + "  UV Offset U: " + string(_inner.uv_offset_u) + "%\n"
        + "  UV Offset V: " + string(_inner.uv_offset_v) + "%\n"
        + "  Scale X: " + string(_inner.scale_x) + "%\n"
        + "  Scale Y: " + string(_inner.scale_y) + "%\n"
        + "TOP CAP\n"
        + "  Crop Left: " + string(_cap.crop_left) + "%\n"
        + "  Crop Right: " + string(_cap.crop_right) + "%\n"
        + "  Crop Top: " + string(_cap.crop_top) + "%\n"
        + "  Crop Bottom: " + string(_cap.crop_bottom) + "%\n"
        + "  Offset X: " + string(_cap.offset_x) + "%\n"
        + "  Offset Y: " + string(_cap.offset_y) + "%\n"
        + "  UV Offset U: " + string(_cap.uv_offset_u) + "%\n"
        + "  UV Offset V: " + string(_cap.uv_offset_v) + "%\n"
        + "  Scale X: " + string(_cap.scale_x) + "%\n"
        + "  Scale Y: " + string(_cap.scale_y) + "%\n";
    var _file = file_text_open_write(raid_texture_crop_export_filename);
    if (_file < 0)
    {
        raid_texture_crop_debug_status = "EXPORT FAILED";
        return false;
    }
    file_text_write_string(_file, _text);
    file_text_close(_file);
    raid_texture_crop_debug_status = "EXPORTED " + raid_texture_crop_export_filename;
    return true;
}
