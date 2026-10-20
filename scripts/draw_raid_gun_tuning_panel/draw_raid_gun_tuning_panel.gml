function draw_raid_gun_tuning_panel()
{
    var _weapon = item_get(raid_gun_tuning_weapon_key);
    if (!is_struct(_weapon)) return;
    var _tuning = raid_gun_tuning_get(raid_gun_tuning_weapon_key, _weapon);
    var _names = ["weapon_draw_width", "weapon_offset_x", "weapon_offset_y", "hand1_offset_x", "hand1_offset_y", "hand2_offset_x", "hand2_offset_y", "muzzle_offset_x", "muzzle_offset_y", "weapon_angle_offset"];
    var _gui_x = 20;
    var _gui_y = 120;

    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_gui_x - 10, _gui_y - 10, 410, _gui_y + 255, false);
    draw_set_alpha(1);
    draw_set_color(c_yellow);
    draw_text(_gui_x, _gui_y, "GUN TUNING: " + _weapon.name);
    draw_set_color(c_white);
    for (var i = 0; i < array_length(_names); i++)
    {
        draw_set_color(i == raid_gun_tuning_value_index ? c_yellow : c_white);
        draw_text(_gui_x, _gui_y + 65 + i * 17, (i == raid_gun_tuning_value_index ? "> " : "  ") + _names[i] + ": " + string(variable_struct_get(_tuning, _names[i])));
    }
    draw_set_color(c_white);
}
