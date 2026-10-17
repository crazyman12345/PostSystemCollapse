function save_migrate_data(_data)
{
    if (!is_struct(_data)) return undefined;
    var version = variable_struct_exists(_data, "version") ? _data.version : 0;
    if (!is_real(version) || version < 0 || version > save_format_version) return undefined;

    while (version < save_format_version)
    {
        switch (version)
        {
            case 0:
                _data.version = 1;
                if (!variable_struct_exists(_data, "meta")) _data.meta = { unfinished_raid: false };
                version = 1;
                break;

            default:
                return undefined;
        }
    }

    return _data;
}
