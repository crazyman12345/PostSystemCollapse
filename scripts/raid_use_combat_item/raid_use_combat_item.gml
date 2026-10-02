function raid_use_combat_item(_item_key)
{
    var item =
        item_get(
            _item_key
        );


    if (is_undefined(item))
    {
        return false;
    }


    if (
        raid_bag_get_quantity(
            _item_key
        ) <= 0
    )
    {
        return false;
    }


    // ========================================================
    // APPLY EFFECT
    // ========================================================

    if (
        variable_struct_exists(
            item,
            "use_effects"
        )
    )
    {
        raid_apply_effects(
            item.use_effects
        );
    }
	//add xp

	if item.category = ItemCategory.MEDICAL{
		var member = crew[raid.crew_index];
		var heal = item.use_effects[0].amount;
		var xp = heal * 0.3;
		log_add(string(member.name) + " healed for "+ string(heal) + "   medical xp+: " + string(xp));
		crew_skill_add_xp(raid.crew_index,"medical", xp);	
	}

    // ========================================================
    // CONSUME ITEM
    // ========================================================

    raid_bag_remove(
        _item_key,
        1
    );


    log_add(
        "Used "
        + item.name
        + "."
    );


    // ========================================================
    // USING AN ITEM COSTS YOUR TURN
    // ========================================================

    raid_enemy_attack();


    if (!raid.combat_active)
    {
        return true;
    }


    raid.combat_phase =
        CombatPhase.DECISION;

    raid.combat_item_index =
        0;


    return true;
}