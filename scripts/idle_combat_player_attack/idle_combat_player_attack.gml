function idle_combat_player_attack()
{
    // MISS
    if (random(100) >= idle_combat_player_accuracy) return;

    var damage = irandom_range(idle_combat_player_min_damage, idle_combat_player_max_damage);

    // CRITICAL HIT
    if (random(100) < idle_combat_player_crit_chance)
        damage = round(damage * (idle_combat_player_crit_damage / 100));

    idle_combat_enemy_hp -= damage;
    if (idle_combat_enemy_hp < 0) idle_combat_enemy_hp = 0;
}