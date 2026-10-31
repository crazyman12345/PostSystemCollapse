function step_trader_select(){
var trader_keys = trader_get_unlocked_keys();
		var mouse_menu = terminal_menu_mouse_input(menu_index, array_length(trader_keys), 0, 370, 170, 620, 70);
		menu_index = mouse_menu.index;
		if (mouse_menu.confirm)
		{
		    current_trader_key =
		        trader_keys[menu_index];
		    trader_mode = TraderMode.BUY;
		    trader_menu_index = 0;
		    trader_stock_layout = trader_stock_grid_build(current_trader_key, 11);
		    trader_stock_scroll_row = 0;
		    trader_selected_stock_index = -1;
		    trader_hovered_stock_index = -1;
		    trader_purchase_quantity_text = "1";
		    trader_quantity_focused = false;
		    inventory_context_menu_close();
		}
		if (keyboard_check_pressed(vk_escape))
		{
		    audio_play_sound(snd_interact, 0, false);
		    hideout_focus = HideoutFocus.SIDEBAR;
		    menu_index = 0;
		}
		
}
