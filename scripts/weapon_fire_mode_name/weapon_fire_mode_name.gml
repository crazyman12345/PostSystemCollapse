function weapon_fire_mode_name(_mode)
{
    switch (_mode)
    {
        case WeaponFireMode.SEMI:
            return "SEMI";

        case WeaponFireMode.BURST:
            return "BURST";

        case WeaponFireMode.AUTO:
            return "AUTO";
    }

    return "";
}