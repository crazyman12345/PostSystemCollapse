function step_trader_sell(){
var sellable_items =
		    trader_get_sellable_items(
		        current_trader_key
		    );
		var item_count =
		    array_length(sellable_items);
		if (item_count > 0)
		{
		    trader_sell_index =
		        terminal_menu_input(
		            trader_sell_index,
		            item_count
		        );
		    var visible_count = min(10, item_count);
		    var scroll_offset = max(0, trader_sell_index - visible_count + 1);
		    var mouse_menu = terminal_menu_mouse_input(trader_sell_index, visible_count, scroll_offset, 620, 270, 280, 50);
		    trader_sell_index = mouse_menu.index;
		    if (keyboard_check_pressed(vk_enter) || mouse_menu.confirm)
		    {
		        var item_key =
		            sellable_items[
		                trader_sell_index
		            ];
		        trader_sell_item(
		            current_trader_key,
		            item_key
		        );
		        // Rebuild list because stash contents changed
		        sellable_items =
		            trader_get_sellable_items(
		                current_trader_key
		            );
		        item_count =
		            array_length(sellable_items);
		        if (item_count == 0)
		        {
		            trader_sell_index = 0;
		        }
		        else
		        {
		            trader_sell_index =
		                min(
		                    trader_sell_index,
		                    item_count - 1
		                );
		        }
		    }
		}
		else
		{
		    trader_sell_index = 0;
		}
		if (keyboard_check_pressed(ord("A")))
		{
		    trader_mode = TraderMode.BUY;
		    trader_menu_index = 0;
			scroll_sound();
		}
		if (keyboard_check_pressed(vk_escape))
		{
		    audio_play_sound(snd_interact, 0, false);
		    trader_mode = TraderMode.SELECT;
		    menu_index = 0;
		}
}
