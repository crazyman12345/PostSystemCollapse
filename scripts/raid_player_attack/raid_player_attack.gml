function raid_player_attack()
{
    var member =
        crew[raid.crew_index];

    var damage = 0;


    // ======================================================
    // UNARMED ATTACK
    // ======================================================

    if (member.weapon == "")
    {
        damage =
            irandom_range(
                1,
                5
            );

        raid.enemy_hp -= damage;

        log_add(
            "UNARMED: You punched for "
            + string(damage)
            + " damage."
        );
	
		
    }else{


    // ======================================================
    // GET WEAPON
    // ======================================================

    var weapon =
        item_get(
            member.weapon
        );


    if (is_undefined(weapon))
    {
        log_add(
            "Invalid weapon."
        );

        return false;
    }


    // ======================================================
    // CHECK / USE AMMO
    // ======================================================

    if (variable_struct_exists(
        weapon,
        "ammo_key"
    ))
    {
        var ammo_key =
            weapon.ammo_key;

        var ammo_required = 1;


        // Optional support for weapons that use
        // more than one round per attack
        if (variable_struct_exists(
            weapon,
            "ammo_per_attack"
        ))
        {
            ammo_required =
                weapon.ammo_per_attack;
        }


        var ammo_available =
            raid_bag_get_quantity(
                ammo_key
            );


        if (ammo_available < ammo_required)
        {
            log_add(
                "Out of ammo. CANT ATTACK"
            );

            return false;
        }


        raid_bag_remove(
            ammo_key,
            ammo_required
        );
    }


    // ======================================================
    // WEAPON DAMAGE
    // ======================================================

    damage =
        irandom_range(
            weapon.damage_min,
            weapon.damage_max
        );
		 log_add(
        "You attacked with "+ string(weapon.name) + " for " +
        + string(damage)
        + " damage."
    );
	 raid.enemy_hp -= damage;
	 // Successful firearm hit
		crew_skill_add_xp(
		    raid.crew_index,
		    "marksmanship",
		    2
		);
	}
	
	
	if (raid.enemy_hp <= 0)
	{
	    raid.enemy_hp = 0;

	    raid_combat_win();

	    return;
	}
	
    return true;
}