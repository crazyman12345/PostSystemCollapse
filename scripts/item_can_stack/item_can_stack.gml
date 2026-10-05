function item_get_max_stack(_item)
{
    var definition = is_string(_item) ? item_get(_item) : item_get(_item.item_key);
    if (is_undefined(definition) || !definition.stackable) return 1;
    return variable_struct_exists(definition, "max_stack") ? max(1, definition.max_stack) : 999999;
}

function item_can_stack(_first, _second)
{
    if (is_undefined(_first) || is_undefined(_second)) return false;

    var first_definition = item_get(_first.item_key);
    var second_definition = item_get(_second.item_key);
    return !is_undefined(first_definition)
        && !is_undefined(second_definition)
        && first_definition.stackable
        && second_definition.stackable
        && _first.item_key == _second.item_key;
}
