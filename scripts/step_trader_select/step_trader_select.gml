function step_trader_select(){
var trader_keys = variable_struct_get_names(global.traders);
		menu_index = terminal_menu_input(
		    menu_index,
		    array_length(trader_keys)
		);
		if (keyboard_check_pressed(vk_enter))
		{
		    current_trader_key =
		        trader_keys[menu_index];
		    trader_mode = TraderMode.BUY;
		    trader_menu_index = 0;
		}
		if (keyboard_check_pressed(vk_escape))
		{
		    hideout_focus = HideoutFocus.SIDEBAR;
		    menu_index = 0;
		}
		
}