function step_raid_combat_item_select()
{
    var usable_items = raid_combat_get_usable_items();
    if (array_length(usable_items) <= 0)
    {
        raid.combat_phase =
            CombatPhase.DECISION;
        return;
    }
    raid.combat_item_index =
        terminal_menu_input(
            raid.combat_item_index,
            array_length(usable_items)
        );
    // ========================================================
    // USE ITEM
    // ========================================================

    if (keyboard_check_pressed(vk_enter))
    {
        var item_key =
            usable_items[
                raid.combat_item_index
            ];
        raid_use_combat_item(
            item_key
        );
        return;
    }
    // ========================================================
    // CANCEL
    // ========================================================

    if (keyboard_check_pressed(vk_escape))
    {
        raid.combat_phase =
            CombatPhase.DECISION;

        raid.combat_item_index =
            0;
    }
}