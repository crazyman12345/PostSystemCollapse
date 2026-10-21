function draw_loadout_overlay()
{
    inventory_hover_begin();
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // ==============================
    // BACKGROUND
    // ==============================

    draw_set_color(c_black);
    if (raid.state != RaidState.INACTIVE && raid.state != RaidState.RESULT) draw_set_alpha(0.9);
    draw_rectangle(0, 0, 1920, 1080, false);
    draw_set_alpha(1);

    draw_set_color(c_lime);

    // Reset focused item every frame
    loadout_focused_item_key = "";

    var member = crew[raid.crew_index];

    if (raid.state != RaidState.INACTIVE && raid.state != RaidState.RESULT)
    {
        draw_inraid_bag_panel();
        inventory_hover_finish();
        inventory_hover_draw();
        inventory_context_menu_draw();
        return;
    }

    if (raid.state == RaidState.INACTIVE || raid.state == RaidState.RESULT)
    {
        var panel_left = 20;
        var panel_top = 80;
        var panel_width = 1880;
        var panel_height = 970;
        var raid_info_left = panel_left + panel_width - 25 - (stash.grid_width * 60);
        var raid_info_width = panel_left + panel_width - 25 - raid_info_left;

        draw_set_font(fnt_ascii);
        terminal_panel(panel_left, panel_top, panel_width, panel_height, "RAID LOADOUT");
        draw_stash_equipment_and_carried_storage(member, true, panel_left, panel_width);
        draw_pre_raid_info(raid_info_left, raid_info_width);
        draw_player_status_panel(85, 790, 360);
        draw_start_raid_panel();

        if (loadout_confirm_start)
        {
            draw_start_raid_confirmation();
        }
        draw_set_font(fnt_terminal);
        inventory_hover_finish();
        inventory_hover_draw();
        inventory_context_menu_draw();
        return;
    }

    terminal_header(
        "INVENTORY"
    );



    // ==============================
    // DIFFERENT LAYOUT IN RAID
    // ==============================

    if (raid.state != RaidState.INACTIVE && raid.state != RaidState.RESULT)
    {
        draw_character_stats_panel(
            member
        );

        draw_inraid_bag_panel();
    }


    // ==============================
    // ITEM INFO WINDOW
    // ==============================

    if (
        loadout_focused_item_key != ""
        && !equipment_selecting_item
        && !loadout_confirm_start
    )
    {
        draw_item_info_popup(
            loadout_focused_item_key
        );
    }


    // ==============================
    // EQUIPMENT SELECTION POPUP
    // ==============================

    if (equipment_selecting_item)
    {
        draw_equipment_item_select();
    }


    // ==============================
    // START RAID CONFIRMATION
    // ==============================

    else if (loadout_confirm_start)
    {
        draw_start_raid_confirmation();
    }


    inventory_hover_finish();
    inventory_hover_draw();
    inventory_context_menu_draw();
}

function draw_pre_raid_info(_info_left, _info_width)
{
	draw_set_font(fnt_ascii2);
    var info_top = 150;

    draw_set_color(c_lime);
    draw_text(_info_left, info_top - 25, "RAID INFO");
    draw_line(_info_left, info_top - 7, _info_left + _info_width, info_top - 7);

    if (!variable_struct_exists(raid, "selected_area"))
    {
        draw_text(_info_left, info_top + 20, "NO RAID LOCATION SELECTED");
        return;
    }

    var area = raid.selected_area;
    draw_text(_info_left, info_top + 20, "LOCATION: " + area.name);
    draw_text(_info_left, info_top + 55, "DANGER LEVEL: " + string(area.danger_level));

}
