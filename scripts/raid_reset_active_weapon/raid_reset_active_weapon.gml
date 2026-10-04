function raid_reset_active_weapon()
{
    active_weapon_slot = -1;
    raid_weapon_loaded_slot = -1;
    raid_weapon_loaded_key = "";
    raid_weapon_mag = 0;
    raid_weapon_mags = [0, 0];
    raid_weapon_slot_keys = ["", ""];
    raid_weapon_slot_display = 0;
    raid_weapon_slot_display_target = 0;
    raid_reload_active = false;
    raid_reload_timer = 0;
    raid_shot_cooldown = 0;
    raid_knife_attack_timer = 0;
    raid_knife_attack_hit = false;
    raid_knife_trail = [];
    raid_burst_remaining = 0;
    raid_fire_mode_index = 0;
    raid_current_fire_mode = WeaponFireMode.SEMI;
}
