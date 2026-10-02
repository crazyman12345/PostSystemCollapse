function raid_apply_effect(_effect)
{
    switch (_effect.type)
    {
        case EffectType.GIVE_ITEM:
        {
            inventory_add(
                _effect.item_key,
                _effect.quantity
            );

            break;
        }


        case EffectType.REMOVE_ITEM:
        {
            raid_bag_remove(
                _effect.item_key,
                _effect.quantity
            );

            break;
        }


        case EffectType.SET_FLAG:
        {
            progress_set_flag(
                _effect.flag_key,
                _effect.value
            );

            break;
        }
		
		case EffectType.HEAL:
		{
			 var member =
				 crew[raid.crew_index];
				 member.hp += _effect.amount;
			//log_add(string(member.name) + " healed for "+ string(_effect.amount));
		}
    }
}