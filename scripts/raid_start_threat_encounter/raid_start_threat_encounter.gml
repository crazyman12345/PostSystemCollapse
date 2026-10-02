function raid_start_threat_encounter()
{
    var enemies =
    [
        "scavenger",
        "security_guard",
        "raider",
		"prototype_scav"
    ];


    var enemy_key =
        enemies[
            irandom(
                array_length(enemies) - 1
            )
        ];


    log_add(
        "Enemy attracted by the noise!"
    );


    raid_set_enemy(
        enemy_key
    );
}