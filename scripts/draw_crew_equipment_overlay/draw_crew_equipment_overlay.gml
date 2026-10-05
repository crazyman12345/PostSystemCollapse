function draw_crew_equipment_overlay()
{
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // ==============================
    // BACKGROUND
    // ==============================

    draw_set_color(c_black);
    if (raid.active) draw_set_alpha(0.9);
    draw_rectangle(0, 0, 1920, 1080, false);
    draw_set_alpha(1);

    draw_set_color(c_lime);

    // Reset focused item every frame
    loadout_focused_item_key = "";

    var member = crew[raid.crew_index];

    if (raid.active)
    {
        draw_inraid_bag_panel();
        return;
    }

    if (!raid.active)
    {
        var panel_left = 20;
        var panel_top = 80;
        var panel_width = 1880;
        var panel_height = 970;
        var raid_info_left = panel_left + panel_width - 25 - (stash.grid_width * 60);
        var raid_info_width = panel_left + panel_width - 25 - raid_info_left;

        draw_set_font(fnt_terminal_small);
        terminal_panel(panel_left, panel_top, panel_width, panel_height, "RAID LOADOUT");
        draw_stash_equipment_and_carried_storage(member, true, panel_left, panel_width);
        draw_pre_raid_info(raid_info_left, raid_info_width);
        draw_start_raid_panel();

        if (loadout_confirm_start)
        {
            draw_start_raid_confirmation();
        }
        else
        {
            terminal_prompt("ENTER: START RAID    ESC: BACK");
        }

        draw_set_font(fnt_terminal);
        return;
    }

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
    }
}

function draw_pre_raid_info(_info_left, _info_width)
{
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
    draw_text(_info_left, info_top + 105, "KNOWN ENEMIES:");

    var enemies = "NONE";

    if (array_length(area.enemies) > 0)
    {
        enemies = "";

        for (var i = 0; i < array_length(area.enemies); i++)
        {
            if (i > 0) enemies += ", ";
            enemies += string_replace(area.enemies[i], "_", " ");
        }
    }

    draw_text_ext(_info_left, info_top + 135, enemies, 22, _info_width);
}
