function raid_resolve_action(_action)
{
    //// --------------------------------
    //// ADD NOISE
    //// --------------------------------

    //if (
    //    variable_struct_exists(
    //        _action,
    //        "noise"
    //    )
    //)
    //{
    //    raid_add_noise(
    //        _action.noise
    //    );
    //}
	
	////APPLY EFFECTS
	//if (
    //    variable_struct_exists(
    //        _action,
    //        "effects"
    //    )
    //)
    //{
    //    raid_apply_effects(
    //        _action.effects
    //    );
    //}

    //// --------------------------------
    //// MARK ONE-TIME ACTION COMPLETE
    //// --------------------------------

    //if (!_action.repeatable)
    //{
    //    raid_complete_action(
    //        _action.action_key
    //    );
    //}


    //// --------------------------------
    //// RESOLVE ACTION TYPE
    //// --------------------------------

    //switch (_action.action_type)
    //{
    //    case RaidActionType.MOVE:
    //    {
	//		if (raid_room_movement_blocked())
	//			{
	//			    log_add("You cannot leave while an enemy is blocking the way.");
	//			    break;
	//			}
    //        raid_enter_junction(
    //            _action.target
    //        );
    //        break;
    //    }


    //    case RaidActionType.SEARCH:
    //    {
    //        raid.last_loot =
    //            loot_roll_table(
    //                _action.loot_table_key
    //            );
				
	//		    // Award Scavenging XP
	//		    crew_skill_add_xp(
	//		        raid.crew_index,
	//		        "scavenging",
	//		        5
	//		    );
				
    //        raid.loot_index =
    //            0;

    //        raid.mode =
    //            RaidMode.LOOT;

    //        break;
    //    }


    //    case RaidActionType.EXTRACT:
    //    {
    //        raid_extract();

    //        break;
    //    }


    //    case RaidActionType.START_COMBAT:
    //    {
    //        raid_set_enemy(
    //            _action.enemy_key
    //        );
	//		raid.combat_source_action = _action;
    //        break;
    //    }


    //    case RaidActionType.REST:
    //    {
    //        raid.mode =
    //            RaidMode.JUNCTION;

    //        break;
    //    }


    //  case RaidActionType.EVENT:
	//	{
	//	    raid.event_text = "";

	//	    if (variable_struct_exists(
	//	        _action,
	//	        "event_text"
	//	    ))
	//	    {
	//	        raid.event_text =
	//	            _action.event_text;
	//	    }

	//	    raid.mode =
	//	        RaidMode.EVENT;

	//	    break;
	//	}
    //}
}