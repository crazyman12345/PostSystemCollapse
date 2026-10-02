function step_leaf_grow(){
 if (!grow_active) {
            // No grow currently active
            // Only one selectable option: START GROW
            grow_menu_index = 0;
            if (keyboard_check_pressed(vk_enter)) {
                start_morrowleaf_grow();
            }
        } else {
            // Grow is active
            var options = 3;
			grow_menu_index = terminal_menu_input(grow_menu_index, options);
            if (keyboard_check_pressed(vk_enter)) {
                switch (grow_menu_index) {
                    case 0:
                        morrowleaf_action("WATER");
                        break;
                    case 1:
                        morrowleaf_action("FEED");
                        break;
                    case 2:
                        morrowleaf_action("TEND");
                        break;
                }
            }
        }
        if (keyboard_check_pressed(vk_escape)) {
            hideout_focus = HideoutFocus.SIDEBAR;
			grow_menu_index=0;
            menu_index = 0;
        }
}