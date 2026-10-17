function draw_raid_hotbar(_inventory = false)
{
    raid_hotbar_validate();
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    var slot_w = 64;
    var slot_h = slot_w;
    var left = _inventory ? raid_inventory_get_hotbar_rect().left : gui_w - slot_w - 20;
    var top = _inventory ? raid_inventory_get_hotbar_rect().top : 270;
    var gap = _inventory ? 8 : 6;

    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    if (_inventory)
    {
        draw_set_color(c_lime);
        draw_text(left, top - 22, "QUICK ITEMS");
    }

    for (var i = 0; i < 6; i++)
    {
        var slot_x = left + (_inventory ? i * (slot_w + gap) : 0);
        var slot_y = top + (_inventory ? 0 : i * (slot_h + gap));
        var active = raid.hotbar_feedback_slot == i && raid.hotbar_feedback_timer > 0;
        var treatment_flash = player_health_treatment_is_active()
            && raid.treatment.item == raid.hotbar[i]
            && floor(current_time / 150) mod 2 == 0;
        draw_set_color(treatment_flash ? c_white : (active ? (raid.hotbar_feedback_success ? c_lime : c_red) : c_gray));
        draw_rectangle(slot_x, slot_y, slot_x + slot_w, slot_y + slot_h, false);
        draw_set_color(c_black);
        draw_rectangle(slot_x + 3, slot_y + 3, slot_x + slot_w - 3, slot_y + slot_h - 3, true);
        draw_set_color(c_black);
        draw_set_halign(fa_right);
        draw_text(slot_x + slot_w - 7, slot_y + 6, string(i + 1));
        draw_set_halign(fa_left);

        var item = raid.hotbar[i];
        if (!is_undefined(item))
        {
            var definition = item_get(item.item_key);
            var sprite = variable_struct_exists(definition, "icon_sprite") ? definition.icon_sprite : -1;
            if (sprite != -1 && sprite_exists(sprite))
            {
                var size = 42;
                var scale_x = size / sprite_get_width(sprite);
                var scale_y = size / sprite_get_height(sprite);
                var sprite_x = slot_x + (slot_w * 0.5) + ((sprite_get_xoffset(sprite) - (sprite_get_width(sprite) * 0.5)) * scale_x);
                var sprite_y = slot_y + (slot_h * 0.5) + ((sprite_get_yoffset(sprite) - (sprite_get_height(sprite) * 0.5)) * scale_y);
                draw_sprite_ext(sprite, 0, sprite_x, sprite_y, scale_x, scale_y, 0, c_white, 1);
            }
            draw_set_color(c_black);
            if (variable_struct_exists(definition, "medical_capacity"))
            {
                var durability = variable_struct_exists(item, "durability") ? item.durability : definition.medical_capacity;
                if (definition.item_key == "medkit")
                {
                    draw_text(slot_x + 7, slot_y + 6, string(durability));
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_middle);
                    draw_text(slot_x + (slot_w * 0.5), slot_y + (slot_h * 0.5), "/");
                    draw_set_halign(fa_right);
                    draw_set_valign(fa_bottom);
                    draw_text(slot_x + slot_w - 7, slot_y + slot_h - 6, string(definition.medical_capacity));
                    draw_set_halign(fa_left);
                    draw_set_valign(fa_top);
                }
                else draw_text(slot_x + 7, slot_y + 25, string(durability) + "/" + string(definition.medical_capacity));
            }
            else draw_text(slot_x + 7, slot_y + 25, "x" + string(item.quantity));
        }
    }
}
