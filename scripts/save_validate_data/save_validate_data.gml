function save_validate_data(_data)
{
    if (!is_struct(_data)
    || !variable_struct_exists(_data, "version")
    || _data.version != save_format_version
    || !variable_struct_exists(_data, "inventory")
    || !is_struct(_data.inventory)) return false;

    if (!variable_struct_exists(_data.inventory, "stash") || !is_array(_data.inventory.stash)) return false;
    return true;
}

function save_value(_struct, _key, _default)
{
    if (!is_struct(_struct) || !variable_struct_exists(_struct, _key)) return _default;
    return variable_struct_get(_struct, _key);
}
