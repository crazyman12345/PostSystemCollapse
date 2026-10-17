function raid_hotbar_is_usable(_definition)
{
    return !is_undefined(_definition)
        && variable_struct_exists(_definition, "combat_usable")
        && _definition.combat_usable
        && ((variable_struct_exists(_definition, "treatment_effect")
            && variable_struct_exists(_definition, "medical_capacity"))
        || (variable_struct_exists(_definition, "use_effects")
            && array_length(_definition.use_effects) > 0));
}
