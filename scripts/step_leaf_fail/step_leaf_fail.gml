function step_leaf_fail(){
   if (keyboard_check_pressed(vk_enter)) {
            drug_state = DrugState.DRUG_LAB;
            menu_index = 0;
        }
}