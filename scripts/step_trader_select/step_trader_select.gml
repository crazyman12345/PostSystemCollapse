function step_trader_select(){
var trader_keys = ["iron", "mara", "bastion", "sawbones", "ghost"];
	if (global.admin_trader_enabled) array_push(trader_keys, "admin");
		menu_index = terminal_menu_input(
		    menu_index,
		    array_length(trader_keys)
		);
		var mouse_menu = terminal_menu_mouse_input(menu_index, array_length(trader_keys), 0, 370, 170, 620, 70);
		menu_index = mouse_menu.index;
		if (keyboard_check_pressed(vk_enter) || mouse_menu.confirm)
		{
		    current_trader_key =
		        trader_keys[menu_index];
		    trader_mode = TraderMode.BUY;
		    trader_menu_index = 0;
		}
		if (keyboard_check_pressed(vk_escape))
		{
		    audio_play_sound(snd_interact, 0, false);
		    hideout_focus = HideoutFocus.SIDEBAR;
		    menu_index = 0;
		}
		
}
