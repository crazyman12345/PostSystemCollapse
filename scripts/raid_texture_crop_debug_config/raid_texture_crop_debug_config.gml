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


function raid_texture_crop_debug_shadow_set(_field, _value)
{
    if (_field == 0) raid_player_projected_shadow_offset_x = clamp(round(_value), -100, 100);
    else if (_field == 1) raid_player_projected_shadow_offset_y = clamp(round(_value), -100, 100);
    else raid_shadow_gun_extra_offset_scale = clamp(round(_value * 100) / 100, 0, 2);
}


function raid_texture_crop_debug_environment_set(_field, _value)
{
    switch (_field)
    {
        case 0: raid_environment.vertical_projection = clamp(round(_value * 100) / 100, 0, 2); break;
        case 1: raid_environment.perspective_strength_x = clamp(round(_value * 100) / 100, 0, 20); break;
        case 2: raid_environment.perspective_strength_y = clamp(round(_value * 100) / 100, 0, 20); break;
        case 3: raid_environment.perspective_smoothing = clamp(round(_value * 100) / 100, 0, 1); break;
    }
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


function raid_texture_crop_debug_material_set(_tab, _name, _value)
{
    if (_tab == 0)
    {
        var _materials = raid_environment.inner_face_materials;
        for (var _material_index = 0; _material_index < array_length(_materials); _material_index++)
            raid_texture_crop_debug_set(_materials[_material_index], _name, _value);
        if (variable_struct_exists(raid_environment, "door_inner_face_material")
            && !is_undefined(raid_environment.door_inner_face_material))
            raid_texture_crop_debug_set(raid_environment.door_inner_face_material, _name, _value);
        return;
    }

    raid_texture_crop_debug_set(raid_texture_crop_debug_material(_tab), _name, _value);
}


function raid_texture_crop_debug_reset(_tab)
{
    if (_tab == 3)
    {
        raid_environment.vertical_projection = 0.75;
        raid_environment.perspective_strength_x = 4;
        raid_environment.perspective_strength_y = 3;
        raid_environment.perspective_smoothing = 0.12;
        return;
    }

    if (_tab == 2)
    {
        raid_player_projected_shadow_offset_x = 0;
        raid_player_projected_shadow_offset_y = -6;
        raid_shadow_gun_extra_offset_scale = 0.6;
        return;
    }

    raid_texture_crop_debug_material_set(_tab, "crop_left", 0);
    raid_texture_crop_debug_material_set(_tab, "crop_right", 0);
    raid_texture_crop_debug_material_set(_tab, "crop_top", 0);
    raid_texture_crop_debug_material_set(_tab, "crop_bottom", 0);
    raid_texture_crop_debug_material_set(_tab, "offset_x", 0);
    raid_texture_crop_debug_material_set(_tab, "offset_y", 0);
    raid_texture_crop_debug_material_set(_tab, "uv_offset_u", 0);
    raid_texture_crop_debug_material_set(_tab, "uv_offset_v", 0);
    raid_texture_crop_debug_material_set(_tab, "scale_x", 100);
    raid_texture_crop_debug_material_set(_tab, "scale_y", 100);
}


function raid_texture_crop_debug_data()
{
    var _inner = raid_environment.inner_face_material;
    var _cap = raid_environment.cap_material;
    return {
        version: 6,
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
        },
        player_shadow: {
            offset_x: raid_player_projected_shadow_offset_x,
            offset_y: raid_player_projected_shadow_offset_y,
            gun_extra_offset_scale: raid_shadow_gun_extra_offset_scale
        },
        environment: {
            vertical_projection: raid_environment.vertical_projection,
            perspective_strength_x: raid_environment.perspective_strength_x,
            perspective_strength_y: raid_environment.perspective_strength_y,
            perspective_smoothing: raid_environment.perspective_smoothing
        }
    };
}


function raid_texture_crop_debug_apply_data(_data)
{
    if (!is_struct(_data)) return;
    if (variable_struct_exists(_data, "inner_face"))
        raid_texture_crop_debug_apply_inner_face_materials(_data.inner_face);
    if (variable_struct_exists(_data, "top_cap"))
        raid_texture_crop_debug_apply_material(raid_environment.cap_material, _data.top_cap);
    if (variable_struct_exists(_data, "player_shadow") && is_struct(_data.player_shadow))
    {
        if (variable_struct_exists(_data.player_shadow, "offset_x"))
            raid_texture_crop_debug_shadow_set(0, _data.player_shadow.offset_x);
        if (variable_struct_exists(_data.player_shadow, "offset_y"))
            raid_texture_crop_debug_shadow_set(1, _data.player_shadow.offset_y);
        if (variable_struct_exists(_data.player_shadow, "gun_extra_offset_scale"))
            raid_texture_crop_debug_shadow_set(2, _data.player_shadow.gun_extra_offset_scale);
    }
    if (variable_struct_exists(_data, "environment") && is_struct(_data.environment))
    {
        if (variable_struct_exists(_data.environment, "vertical_projection"))
            raid_texture_crop_debug_environment_set(0, _data.environment.vertical_projection);
        if (variable_struct_exists(_data.environment, "perspective_strength_x"))
            raid_texture_crop_debug_environment_set(1, _data.environment.perspective_strength_x);
        if (variable_struct_exists(_data.environment, "perspective_strength_y"))
            raid_texture_crop_debug_environment_set(2, _data.environment.perspective_strength_y);
        if (variable_struct_exists(_data.environment, "perspective_smoothing"))
            raid_texture_crop_debug_environment_set(3, _data.environment.perspective_smoothing);
    }
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


function raid_texture_crop_debug_apply_inner_face_materials(_data)
{
    if (!is_struct(_data)) return;
    var _names = ["crop_left", "crop_right", "crop_top", "crop_bottom", "offset_x", "offset_y", "uv_offset_u", "uv_offset_v", "scale_x", "scale_y"];
    for (var _index = 0; _index < array_length(_names); _index++)
    {
        var _name = _names[_index];
        if (variable_struct_exists(_data, _name))
            raid_texture_crop_debug_material_set(0, _name, variable_struct_get(_data, _name));
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
        + "  Scale Y: " + string(_cap.scale_y) + "%\n"
        + "PLAYER PROJECTED SHADOW\n"
        + "  Offset X: " + string(raid_player_projected_shadow_offset_x) + "\n"
        + "  Offset Y: " + string(raid_player_projected_shadow_offset_y) + "\n"
        + "  Gun Extra Offset Scale: " + string(raid_shadow_gun_extra_offset_scale) + "\n"
        + "RAID ENVIRONMENT\n"
        + "  Vertical Projection: " + string(raid_environment.vertical_projection) + "\n"
        + "  Perspective Strength X: " + string(raid_environment.perspective_strength_x) + "\n"
        + "  Perspective Strength Y: " + string(raid_environment.perspective_strength_y) + "\n"
        + "  Perspective Smoothing: " + string(raid_environment.perspective_smoothing) + "\n";
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
