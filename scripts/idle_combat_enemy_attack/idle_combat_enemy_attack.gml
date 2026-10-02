function idle_combat_enemy_attack()
{
    var enemy = enemy_get(idle_combat_enemy_key);

    // MISS
    if (random(100) >= enemy.accuracy) return;

    var damage = irandom_range(enemy.min_damage, enemy.max_damage);

    idle_combat_player_hp -= damage;
    if (idle_combat_player_hp < 0) idle_combat_player_hp = 0;
}