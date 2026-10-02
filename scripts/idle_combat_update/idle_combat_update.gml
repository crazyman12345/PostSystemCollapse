function idle_combat_update(_dt)
{
    if (!idle_combat_active) return;

    // ==========================================
    // ENEMY DEAD / RESPAWNING
    // ==========================================

    if (idle_combat_enemy_hp <= 0)
    {
        idle_combat_respawn_timer -= _dt;

        if (idle_combat_respawn_timer <= 0)
        {
            var enemy = enemy_get(idle_combat_enemy_key);

            idle_combat_enemy_hp = enemy.max_hp;

            // Fresh cooldowns for new enemy
            idle_combat_player_attack_timer = 0;
            idle_combat_enemy_attack_timer = 0;
        }

        return;
    }

    // ==========================================
    // PLAYER DEAD
    // ==========================================

    if (idle_combat_player_hp <= 0)
    {
        idle_combat_player_hp = 0;
        idle_combat_active = false;

        log_add("Combat training stopped. You were defeated.");
        return;
    }

    // ==========================================
    // ATTACK TIMERS
    // ==========================================

    idle_combat_player_attack_timer += _dt;
    idle_combat_enemy_attack_timer += _dt;

    // PLAYER
    if (idle_combat_player_attack_timer >= idle_combat_player_attack_interval)
    {
        idle_combat_player_attack_timer -= idle_combat_player_attack_interval;
        idle_combat_player_attack();
    }

    // ENEMY
    if (idle_combat_enemy_attack_timer >= idle_combat_enemy_attack_interval && idle_combat_enemy_hp > 0)
    {
        idle_combat_enemy_attack_timer -= idle_combat_enemy_attack_interval;
        idle_combat_enemy_attack();
    }

    // ==========================================
    // ENEMY JUST DIED
    // ==========================================

    if (idle_combat_enemy_hp <= 0)
    {
        idle_combat_enemy_hp = 0;

        idle_combat_player_attack_timer = 0;
        idle_combat_enemy_attack_timer = 0;

        idle_combat_respawn_timer = 2;

        // XP goes here later
    }
}
