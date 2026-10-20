function raid_apply_effect(_effect)
{
    switch (_effect.type)
    {
		case EffectType.HEAL:
		{
			player_health_heal_global(_effect.amount);
			break;
		}
		case EffectType.ENERGY:
		{
			player_energy = clamp(player_energy + max(0, _effect.amount), 0, health_config.survival_max);
			if (player_energy > 0) energy_zero_damage_remaining = health_config.energy_zero_damage_interval_seconds;
			save_mark_dirty();
			break;
		}
		case EffectType.HYDRATION:
		{
			player_hydration = clamp(player_hydration + max(0, _effect.amount), 0, health_config.survival_max);
			if (player_hydration > 0) hydration_zero_damage_remaining = health_config.hydration_zero_damage_interval_seconds;
			save_mark_dirty();
			break;
		}
    }
}
