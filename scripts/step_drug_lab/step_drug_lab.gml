function step_drug_lab(){
        var options = 3;
        menu_index = terminal_menu_input(menu_index, options);
        if (keyboard_check_pressed(vk_enter)) {
            switch (menu_index) {
                case 0: {
                    if (can_craft_basic_grow()) {
                        craft_basic_grow();
                    } 
                    break;
                }
                case 1:
                    drug_state = DrugState.MORROWLEAF_GROW;
                    grow_menu_index = 0;
                    menu_index = 0;
                    break;
                case 2:
                    show_debug_message("LAB UPGRADES");
                    break;
            }
        }
        if (keyboard_check_pressed(vk_escape)) {
            hideout_focus = HideoutFocus.SIDEBAR;
            menu_index = 0;
        }
}