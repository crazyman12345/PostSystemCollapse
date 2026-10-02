function draw_hideout_raid_select()
{
	
	var _x1 = 320;
    var _y1 = 80;
    var panel_width = 1600;
    var panel_height = 1000;
	var _x2 = _x1 + panel_width;
	var _y2 = _y1 + panel_height;
	
    var padding = 40;
	
    draw_set_font(fnt_terminal_small);
    draw_set_color(c_lime);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // ==========================================
    // ACTIVE COMBAT TRAINING
    // ==========================================

    if (combat_menu_focus == CombatMenuFocus.COMBAT)
    {
        draw_idle_combat(idle_combat_enemy_key);
        draw_set_font(fnt_terminal);
        return;
    }

    // ==========================================
    // AREA GRID
    // ==========================================

    var cols = 2;
    var rows = 6;

    var grid_left = 320;
    var grid_top = 80;
    var grid_width = 1600;
    var grid_height = 1000;
    var gap = 10;

    var box_width = (grid_width - gap) / 2;
    var box_height = (grid_height - (gap * 5)) / 6;

    for (var i = 0; i < array_length(combat_area_db); i++)
    {
        var area = combat_area_db[i];

        var col = i mod cols;
        var row = floor(i / cols);

        if (row >= rows) break;

        var box_left = grid_left + (col * (box_width + gap));
        var box_top = grid_top + (row * (box_height + gap));

        var selected = (i == combat_area_index);

        // ======================================
        // AREA BOX
        // ======================================

        terminal_box(box_left, box_top, box_width, box_height);

        if (selected && combat_menu_focus == CombatMenuFocus.AREAS)
            draw_rectangle(box_left + 4, box_top + 4, box_left + box_width - 4, box_top + box_height - 4, true);

        // ======================================
        // AREA IMAGE
        // ======================================

        var image_size = box_height - 30;

        terminal_box(box_left + 15, box_top + 15, image_size, image_size);

        if (area.sprite != -1)
        {
            draw_sprite_stretched(area.sprite, 0, box_left + 18, box_top + 18, image_size - 6, image_size - 6);
        }
        else
        {
            draw_set_halign(fa_center);
            draw_text(box_left + 15 + (image_size / 2), box_top + 15 + (image_size / 2) - 10, "-1");
            draw_set_halign(fa_left);
        }

        // ======================================
        // AREA NAME
        // ======================================

        var area_name = area.name;

        if (selected && combat_menu_focus == CombatMenuFocus.AREAS)
            area_name = "> " + area.name + " <";

        draw_text(box_left + image_size + 35, box_top + 35, area_name);

        // ======================================
        // DANGER LEVEL
        // ======================================

        draw_text(box_left + image_size + 35, box_top + 80, "DANGER LEVEL " + string(area.danger_level));
    }



    draw_set_font(fnt_terminal);
}