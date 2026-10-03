function spend_cash(_amount)
{
    if (!inventory_has("cash", _amount))
    {
        return false;
    }

    inventory_remove("cash", _amount);
	audio_play_sound(snd_purchase,0,false);
    return true;
	
	
}