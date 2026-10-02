function spend_cash(_amount)
{
    if (!inventory_has("cash", _amount))
    {
        return false;
    }

    inventory_remove("cash", _amount);

    return true;
}