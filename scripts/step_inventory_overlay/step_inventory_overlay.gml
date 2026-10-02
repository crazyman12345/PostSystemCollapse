 function step_inventory_overlay(){
	 if overlay_mode != OverlayMode.INVENTORY{
		return;
	 }
	 
   var owned_items = inventory_get_visible_items();
    var item_count = array_length(owned_items);
    if (item_count > 0) {
        inventory_index = terminal_menu_input(inventory_index, item_count);
        // ==============================
        // SCROLL DOWN
        // ==============================
        if (inventory_index >= inventory_scroll + inventory_visible_rows) {
            inventory_scroll = inventory_index - inventory_visible_rows + 1;
        }
        // ==============================
        // SCROLL UP
        // ==============================
        if (inventory_index < inventory_scroll) {
            inventory_scroll = inventory_index;
        }
    } else {
        inventory_index = 0;
        inventory_scroll = 0;
    }
    if (keyboard_check_pressed(vk_escape)) {
        overlay_mode = OverlayMode.NONE;
    }
 }