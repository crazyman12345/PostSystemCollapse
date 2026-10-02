function draw_raid_loot()
{
    terminal_panel(
        60,
        190,
        850,
        700,
        "FOUND LOOT"
    );


    terminal_panel(
        940,
        190,
        920,
        700,
        "RAID BAG"
    );


    draw_raid_loot_found_panel();

    draw_raid_loot_bag_panel();
}