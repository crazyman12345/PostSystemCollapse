function combat_training_start(_enemy_key)
{
    var enemy = enemy_get(_enemy_key);
    if (is_undefined(enemy)) return false;

    idle_combat_enemy_key = _enemy_key;
    idle_combat_enemy_hp = enemy.max_hp;

    idle_combat_player_max_hp = 100;
    idle_combat_player_hp = idle_combat_player_max_hp;

    // TEMP PLAYER STATS
    idle_combat_player_min_damage = 4;
    idle_combat_player_max_damage = 8;
    idle_combat_player_accuracy = 72;
    idle_combat_player_crit_chance = 5;
    idle_combat_player_crit_damage = 150;
    idle_combat_player_attack_interval = 1.8;

    // ENEMY
    idle_combat_enemy_attack_interval = enemy.attack_interval;

    // TIMERS
    idle_combat_player_attack_timer = 0;
    idle_combat_enemy_attack_timer = 0;
    idle_combat_respawn_timer = 0;

    // COMBAT
    idle_combat_active = true;

    // UI
    idle_combat_box = IdleCombatBox.MEDS;
    idle_combat_in_box = false;
    idle_combat_med_index = 0;
    idle_combat_equipment_index = 0;
    idle_combat_tactic_index = combat_tactic;

    combat_menu_focus = CombatMenuFocus.COMBAT;

    return true;
}