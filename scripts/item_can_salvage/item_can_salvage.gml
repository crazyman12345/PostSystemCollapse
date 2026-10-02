function item_can_salvage(_item_key)
{
    var item =
        item_get(_item_key);

    if (is_undefined(item))
    {
        return false;
    }

    return variable_struct_exists(
        item,
        "salvage"
    );
}