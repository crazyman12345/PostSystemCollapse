function draw_hideout_traders(){
switch (trader_mode){
	case TraderMode.BUY: draw_trader_buy(); break;
	case TraderMode.SELECT:
		if (hideout_page == HideoutPage.MESSAGES) draw_messages_all();
		else draw_trader_select();
	break;
	case TraderMode.SELL: draw_trader_sell(); break;
	case TraderMode.CONVERSATION: draw_trader_conversation(); break;
	}
}
