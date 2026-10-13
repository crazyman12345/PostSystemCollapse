function raid_gun_tuning_toggle()
{
    if (state != GameState.RAID || raid.state == RaidState.INACTIVE || raid.state == RaidState.RESULT)
    {
        debug_log_add("gun_tuning_mode is only available during an active raid.");
        return;
    }

    raid_gun_tuning_active = !raid_gun_tuning_active;

    if (raid_gun_tuning_active)
    {
        var _weapon = raid_update_active_weapon();
        if (is_struct(_weapon)) raid_gun_tuning_weapon_key = _weapon.item_key;

        if (raid_gun_tuning_weapon_key == "")
        {
            var _keys = variable_struct_get_names(global.items);
            for (var i = 0; i < array_length(_keys); i++)
            {
                var _item = variable_struct_get(global.items, _keys[i]);
                if (_item.category == ItemCategory.WEAPON)
                {
                    raid_gun_tuning_weapon_key = _keys[i];
                    break;
                }
            }
        }

        raid_gun_tuning_value_index = 0;
        debug_log_add("Gun tuning mode ON");
    }
    else
    {
        debug_log_add("Gun tuning mode OFF");
    }
}
