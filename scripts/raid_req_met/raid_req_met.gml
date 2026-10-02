function raid_req_met(_requirement)
{
    switch (_requirement.type)
    {
        case RequirementType.ITEM:
        {
            var quantity =
                raid_bag_get_quantity(
                    _requirement.item_key
                );
				
				log_add(
			        "REQ "
			        + _requirement.item_key
			        + ": HAVE "
			        + string(quantity)
			        + " NEED "
			        + string(_requirement.quantity)
				);

				return quantity
					>= _requirement.quantity;
        }


        case RequirementType.FLAG:
        {
            return progress_get_flag(
                _requirement.flag_key
            )
            == _requirement.value;
        }


        case RequirementType.CREW_SKILL:
        {
            var member =
                crew[raid.crew_index];

            if (!variable_struct_exists(
                member,
                _requirement.skill_key
            ))
            {
                return false;
            }

            return variable_struct_get(
                member,
                _requirement.skill_key
            )
            >= _requirement.value;
        }


        case RequirementType.PLAYER_SKILL:
        {
            // Replace this with however your
            // permanent skills are stored.
            return player_skill_get_level(
                _requirement.skill_key
            )
            >= _requirement.value;
        }
    }


    return false;
}