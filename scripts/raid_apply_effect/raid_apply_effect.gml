function raid_apply_effect(_effect)
{
    switch (_effect.type)
    {
		case EffectType.HEAL:
		{
			 var member =
				 crew[raid.crew_index];
				 member.hp += _effect.amount;
			//log_add(string(member.name) + " healed for "+ string(_effect.amount));
		}
    }
}
