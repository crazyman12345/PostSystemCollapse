function skill_db_get(_skill_key)
{
    if (!variable_struct_exists(
        skill_db,
        _skill_key
    ))
    {
        return undefined;
    }
    return variable_struct_get(
        skill_db,
        _skill_key
    );
}