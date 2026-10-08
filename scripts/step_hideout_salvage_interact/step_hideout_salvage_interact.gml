function step_hideout_salvage_interact(){
	var owned_items = workshop_get_salvageable_items();
	
	if (array_length(owned_items) > 0){
		// Handle Enter key for salvage action
		if (keyboard_check_pressed(vk_enter)){
			// Get the salvaged item and its output
			var selected_key = owned_items[inventory_index];
			var selected_item = item_get(selected_key);

			if (variable_struct_exists(selected_item, "salvage") && array_length(selected_item.salvage) > 0){
				if (workshop_salvage_item(selected_key)){
					log_add("You salvaged " + selected_item.name + ".");
				}
			} else {
				// Item cannot be salvaged or no salvage data
				log_add("This item cannot be salvaged.");
			}
		}

		// Update cursor position if items were consumed
		var new_items = workshop_get_salvageable_items();
		var item_count = array_length(new_items);

		if (item_count > 0){
			inventory_index = clamp(inventory_index, 0, item_count - 1);
			
			log_add(string(item_count));
		} else {
			inventory_index = 0;
		}
	}
}
