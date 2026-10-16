function raid_light_get_shadow_height(_light)
{
    if (variable_struct_exists(_light, "shadow_height")) return max(0.001, _light.shadow_height);
    if (variable_struct_exists(_light, "height")) return max(0.001, _light.height);
    return 16;
}
