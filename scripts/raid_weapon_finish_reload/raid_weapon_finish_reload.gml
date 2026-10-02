function raid_weapon_finish_reload(_weapon)
{
    raid_reload_active = false;
    raid_reload_timer = 0;

    var _needed =
        _weapon.mag_size
        - raid_weapon_mag;

    if (_needed <= 0)
        return;

    for (var i = 0; i < _needed; i++)
    {
        var _removed =
            raid_bag_remove(
                _weapon.ammo_key,
                1
            );

        if (!_removed)
            break;

        raid_weapon_mag++;
    }
}