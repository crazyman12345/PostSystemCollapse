function step_trader_buy(){
var trader =
		    trader_get(current_trader_key);
		trader_menu_index =
		    terminal_menu_input(
		        trader_menu_index,
		        array_length(trader.stock)
		    );
		if (keyboard_check_pressed(vk_enter))
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
		}
		if (keyboard_check_pressed(vk_escape))
		{
		    trader_mode = TraderMode.SELECT;
		    menu_index = 0;
		}
}