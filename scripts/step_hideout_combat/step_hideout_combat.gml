function step_hideout_combat()
{
    // ==========================================
    // ACTIVE IDLE COMBAT
    // ==========================================

    if (combat_menu_focus == CombatMenuFocus.COMBAT)
    {
        step_idle_combat();
        return;
    }

    // ==========================================
    // AREA SELECT
    // ==========================================

    if (combat_menu_focus == CombatMenuFocus.AREAS)
    {
        var count = array_length(combat_area_db);

        if (keyboard_check_pressed(ord("A")) && combat_area_index mod 2 == 1) combat_area_index--;

        if (keyboard_check_pressed(ord("D")) && combat_area_index mod 2 == 0 && combat_area_index + 1 < count)
            combat_area_index++;

        if (keyboard_check_pressed(ord("W")) && combat_area_index - 2 >= 0)
            combat_area_index -= 2;

        if (keyboard_check_pressed(ord("S")) && combat_area_index + 2 < count)
            combat_area_index += 2;

        if (keyboard_check_pressed(vk_enter))
        {
            var area = combat_area_db[combat_area_index];

            if (array_length(area.enemies) <= 0)
            {
                log_add("No enemies available in this area.");
                return;
            }

            combat_menu_focus = CombatMenuFocus.ENEMIES;
            combat_enemy_index = 0;
            return;
        }

        if (keyboard_check_pressed(vk_escape))
        {
            hideout_focus = HideoutFocus.SIDEBAR;
            return;
        }

        return;
    }

    // ==========================================
    // ENEMY SELECT
    // ==========================================

    if (combat_menu_focus == CombatMenuFocus.ENEMIES)
    {
        var area = combat_area_db[combat_area_index];
        var count = array_length(area.enemies);

        if (count <= 0)
        {
            combat_menu_focus = CombatMenuFocus.AREAS;
            return;
        }

        if (keyboard_check_pressed(ord("W")))
        {
            combat_enemy_index--;
            if (combat_enemy_index < 0) combat_enemy_index = count - 1;
        }

        if (keyboard_check_pressed(ord("S")))
        {
            combat_enemy_index++;
            if (combat_enemy_index >= count) combat_enemy_index = 0;
        }

        if (keyboard_check_pressed(vk_escape))
        {
            combat_menu_focus = CombatMenuFocus.AREAS;
            combat_enemy_index = 0;
            return;
        }

        if (keyboard_check_pressed(vk_enter))
        {
            var enemy_key = area.enemies[combat_enemy_index];
            combat_training_start(enemy_key);
            return;
        }
    }
}