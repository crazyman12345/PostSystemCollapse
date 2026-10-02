function step_leaf_harvest(){
	    if (keyboard_check_pressed(vk_enter)) {
            inventory_add("raw_morrowleaf", harvest_yield);
            drug_making.xp += harvest_xp;
            drug_state = DrugState.DRUG_LAB;
            menu_index = 0;
        }
}