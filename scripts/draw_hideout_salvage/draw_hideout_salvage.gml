function draw_hideout_salvage(){
	var panel_left = 320;
	var panel_top = 80;
	var panel_width = 1600;
	var panel_height = 1000;
	var padding = 25;
	var list_width = 560;
	var item_x = panel_left + padding;
	var item_start_y = panel_top + 90;
	var item_spacing = 34;
	var visible_rows = inventory_visible_rows;
	var details_left = panel_left + list_width + padding;
	var details_width = panel_width - list_width - (padding * 2);

	var owned_items = inventory_get_visible_salvageable_items();
	var item_count = array_length(owned_items);

	draw_set_color(c_lime);
	draw_set_font(fnt_terminal_small);
	terminal_panel(panel_left, panel_top, list_width, panel_height, "SALVAGE", hideout_focus == HideoutFocus.CONTENT);
	terminal_panel(details_left, panel_top, details_width, panel_height, "DETAILS");

	if (item_count == 0){
		draw_text(item_x, item_start_y, "NO SALVAGEABLE ITEMS");
	} else {
		var last_visible_item = min(inventory_scroll + visible_rows, item_count);

		for (var i = inventory_scroll; i < last_visible_item; i++){
			var item_key = owned_items[i];
			var item = item_get(item_key);
			var quantity = inventory_get_quantity(item_key);
			var row = i - inventory_scroll;
			var display_text = item.name + "    x" + string(quantity);

			terminal_menu_item(item_x, item_start_y + (row * item_spacing), display_text, inventory_index == i);
		}
	}

	if (item_count > 0){
		var selected_key = owned_items[inventory_index];
		var selected_item = item_get(selected_key);
		var details_x = details_left + padding;
		var details_y = panel_top + 50;

		draw_text(details_x, details_y, selected_item.name);
		details_y += 55;

		if (variable_struct_exists(selected_item, "description")){
			draw_text_ext(details_x, details_y, selected_item.description, 24, details_width - (padding * 2));
			details_y += 100;
		}

		draw_text(details_x, details_y, "SALVAGE RESULT");
		details_y += 40;

		if (variable_struct_exists(selected_item, "salvage") && array_length(selected_item.salvage) > 0){
			for (var j = 0; j < array_length(selected_item.salvage); j++){
				var result = selected_item.salvage[j];
				var result_item = item_get(result.item_key);
				draw_text(details_x, details_y, result_item.name + " x" + string(result.quantity));
				details_y += 34;
			}
		}

		if (salvage_active){
			var progress = clamp((current_time - (salvage_end_time - salvage_duration)) / salvage_duration, 0, 1);
			draw_text(details_x, panel_top + panel_height - 120, "SALVAGING: " + string(round(progress * 100)) + "%");
		} else if (salvage_message != ""){
			draw_text(details_x, panel_top + panel_height - 120, salvage_message);
	}
	}

	if (inventory_scroll > 0) draw_text(panel_left + list_width - 45, item_start_y, "^");

	if (inventory_scroll + visible_rows < item_count){
		draw_text(panel_left + list_width - 45, panel_top + panel_height - 120, "v");
	}

	if (item_count > 0){
		draw_text(item_x, panel_top + panel_height - 95, "ITEM " + string(inventory_index + 1) + " / " + string(item_count));
	}

	var controls = "W/S: SELECT  E: SALVAGE  ESC: BACK";
	if (salvage_active) controls = "SALVAGING...";
	draw_text(item_x, panel_top + panel_height - 55, controls);
}
