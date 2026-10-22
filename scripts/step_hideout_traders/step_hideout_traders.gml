function step_hideout_traders()
{
    switch (trader_mode)
    {
        case TraderMode.SELECT:
            if (hideout_page == HideoutPage.MESSAGES) step_messages_all();
            else step_trader_select();
        break;
        case TraderMode.BUY: step_trader_buy(); break;
        case TraderMode.SELL: step_trader_sell(); break;
        case TraderMode.CONVERSATION: step_trader_conversation(); break;
    }
}
