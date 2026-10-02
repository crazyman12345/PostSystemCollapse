function step_hideout_traders()
{
    switch (trader_mode)
    {
        case TraderMode.SELECT: step_trader_select(); break;
        case TraderMode.BUY: step_trader_buy(); break;
        case TraderMode.SELL: step_trader_sell(); break;
    }
}