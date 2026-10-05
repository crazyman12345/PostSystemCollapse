function step_trader_buy(){
var trader =
		    trader_get(current_trader_key);
		trader_menu_index =
		    terminal_menu_input(
		        trader_menu_index,
		        array_length(trader.stock)
		    );
		var visible_count = min(10, array_length(trader.stock));
		var scroll_offset = max(0, trader_menu_index - visible_count + 1);
		var mouse_menu = terminal_menu_mouse_input(trader_menu_index, visible_count, scroll_offset, 620, 270, 320, 50);
		trader_menu_index = mouse_menu.index;
		if (keyboard_check_pressed(vk_enter) || mouse_menu.confirm)
		{
		    trader_buy_item(
		        current_trader_key,
		        trader_menu_index
		    );
		}
		// Switch to sell tab
		if (keyboard_check_pressed(ord("D")))
		{
		    trader_mode = TraderMode.SELL;
		    trader_sell_index = 0;
			scroll_sound();
		}
		if (keyboard_check_pressed(vk_escape))
		{
		    audio_play_sound(snd_interact, 0, false);
		    trader_mode = TraderMode.SELECT;
		    menu_index = 0;
		}
}
