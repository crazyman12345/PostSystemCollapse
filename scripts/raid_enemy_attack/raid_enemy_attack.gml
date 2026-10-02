function raid_enemy_attack()
{
    var enemy =
        enemy_get(
            raid.enemy_key
        );

    var member =
        crew[raid.crew_index];


    // ========================================================
    // HIT ROLL
    // ========================================================

    if (random(1) > enemy.accuracy)
    {
        log_add(
            enemy.name
            + " missed."
        );

        return true;
    }


    // ========================================================
    // DAMAGE
    // ========================================================

    var damage =
        irandom_range(
            enemy.damage_min,
            enemy.damage_max
        );


    member.hp -=
        damage;
	var _xp = damage * 0.5;
	crew_skill_add_xp(raid.crew_index, "vitality", _xp);

    member.hp =
        max(
            0,
            member.hp
        );


    log_add(
        enemy.name
        + " dealt "
        + string(damage)
        + " damage."
    );


    // ========================================================
    // PLAYER DEAD
    // ========================================================

    if (member.hp <= 0)
    {
        raid_combat_loss();
    }


    return true;
}