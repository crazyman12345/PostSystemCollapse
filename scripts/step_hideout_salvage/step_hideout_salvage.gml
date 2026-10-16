function step_hideout_salvage(){
	var owned_items = workshop_get_salvageable_items();
	var item_count = array_length(owned_items);

	if (salvage_active){
		if (current_time >= salvage_end_time){
			var salvaged_item = item_get(salvage_item_key);

			if (workshop_salvage_item(salvage_item_key)){
				salvage_message = "SALVAGED: " + salvaged_item.name;
			} else {
				salvage_message = "NOT ENOUGH STASH SPACE";
			}
			salvage_active = false;

			owned_items = workshop_get_salvageable_items();
			item_count = array_length(owned_items);
		}
	} else if (item_count > 0){
		inventory_index = clamp(inventory_index, 0, item_count - 1);
		inventory_scroll = clamp(inventory_scroll, 0, max(0, item_count - inventory_visible_rows));
		inventory_index = terminal_menu_input(inventory_index, item_count);
		var mouse_menu = terminal_menu_mouse_input(inventory_index, min(inventory_visible_rows, item_count - inventory_scroll), inventory_scroll, 345, 170, 510, 34);
		inventory_index = mouse_menu.index;

		if (inventory_index >= inventory_scroll + inventory_visible_rows){
			inventory_scroll = inventory_index - inventory_visible_rows + 1;
		}
		if (inventory_index < inventory_scroll){
			inventory_scroll = inventory_index;
		}

		if (keyboard_check_pressed(ord("E")) || mouse_menu.confirm){
			var selected_key = owned_items[inventory_index];
			var selected_item = item_get(selected_key);

			if (item_can_salvage(selected_key)){
				salvage_active = true;
				salvage_item_key = selected_key;
				salvage_end_time = current_time + salvage_duration;
				salvage_message = "SALVAGING: " + selected_item.name;
			}
		}
	} else {
		inventory_index = 0;
		inventory_scroll = 0;
	}
	if (item_count > 0){
		inventory_index = clamp(inventory_index, 0, item_count - 1);
		inventory_scroll = clamp(inventory_scroll, 0, max(0, item_count - inventory_visible_rows));
	} else {
		inventory_index = 0;
		inventory_scroll = 0;
	}

	if (!salvage_active && keyboard_check_pressed(vk_escape)){
		audio_play_sound(snd_interact, 0, false);
		hideout_focus = HideoutFocus.SIDEBAR;
	}
}
