function raid_apply_effect(_effect)
{
    switch (_effect.type)
    {
		case EffectType.HEAL:
		{
			player_health_heal_global(_effect.amount);
			break;
		}
    }
}
