function draw_crew_equipment_overlay()
{
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // ==============================
    // BACKGROUND
    // ==============================

    draw_set_color(c_black);
    draw_rectangle(0, 0, 1920, 1080, false);

    draw_set_color(c_lime);

    // Reset focused item every frame
    loadout_focused_item_key = "";

    var member = crew[raid.crew_index];

    terminal_header(
        "INVENTORY"
    );


    // ==============================
    // LEFT TOP - EQUIPMENT
    // ==============================

    draw_loadout_equipment_panel(
        member
    );


    // ==============================
    // DIFFERENT LAYOUT IN RAID
    // ==============================

    if (raid.active)
    {
        draw_character_stats_panel(
            member
        );

        draw_inraid_bag_panel();
    }
    else
    {
        draw_pre_raid_bag_panel();

        draw_hideout_inventory_panel();

        draw_start_raid_panel();
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


    // ==============================
    // NORMAL PROMPT
    // ==============================

    else
    {
        if (raid.active)
        {
            terminal_prompt(
                "A/D: PANEL    W/S: SELECT    ENTER: ACTION   X: DROP ITEM    U/ESC: CLOSE"
            );
        }
        else
        {
            terminal_prompt(
                "A/D: PANEL    W/S: SELECT    ENTER: ACTION    ESC: BACK"
            );
        }
    }
}
