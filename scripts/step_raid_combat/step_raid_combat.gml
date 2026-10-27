function step_raid_combat()
{
    if (raid_boss_intro_update())
    {
        if (keyboard_check_pressed(vk_escape))
        {
            audio_play_sound(snd_interact, 0, false);
            raid_set_state(RaidState.PAUSED);
        }

        step_raid_camera();
        return;
    }

    var _boss_phase_transition_active = false;
    for (var i = 0; i < array_length(raid_enemies); i++)
    {
        if (
            raid_enemies[i].enemy_boss
            && (
                raid_enemies[i].enemy_state == RaidEnemyState.PHASE_TRANSITION
                || (
                    raid_enemies[i].enemy_type == RaidEnemyType.BONES
                    && raid_enemies[i].boss_phase == 1
                    && raid_enemies[i].enemy_hp <= raid_enemies[i].enemy_max_hp * 0.5
                )
            )
        )
        {
            _boss_phase_transition_active = true;
            break;
        }
    }

    if (_boss_phase_transition_active)
    {
        raid_player_dash_active = false;
        raid_player_dash_timer = 0;
        raid_player_dash_xp_pending = false;
        raid_player_moving = false;
        raid_player_was_moving = false;
        step_raid_enemies();
        step_raid_enemy_death_effects();
        step_raid_camera();
        return;
    }

    player_health_treatment_update();
    var _allow_combat_input = step_raid_combat_input();
    if (raid.state != RaidState.COMBAT) return;

    // Player
    player_health_update();
    if (raid_combat_update_should_stop()) return;
    _allow_combat_input = _allow_combat_input && !player_health_treatment_is_active();
    step_raid_player(_allow_combat_input);
    step_raid_player_damage();
    if (raid_combat_update_should_stop()) return;

    // Combat
    step_raid_shooting(_allow_combat_input);
    step_raid_bullets();
    step_raid_enemy_bullets();
    if (raid_combat_update_should_stop()) return;

    step_raid_ring_hazards();
    if (raid_combat_update_should_stop()) return;

    step_raid_enemies();
    if (raid_combat_update_should_stop()) return;

    step_raid_enemy_death_effects();

    // World updates
    if (_allow_combat_input)
    {
        step_raid_lootables();
        step_raid_ground_items();
    }

    if (_allow_combat_input) step_raid_doors();
    if (raid_combat_update_should_stop()) return;
    if (_allow_combat_input) step_raid_extract();
    if (raid_combat_update_should_stop()) return;
    step_raid_camera();

    // Cleanup
    if (array_length(raid_enemies) <= 0) raid.room_cleared = true;
}
