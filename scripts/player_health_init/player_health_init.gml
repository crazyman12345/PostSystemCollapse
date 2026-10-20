function player_health_init()
{
    health_config = {
        global_base_max: 40,
        hp_chunk: 10,
        vitality_levels_per_chunk: 5,
        vitality_bonus_chunks_max: 4,
        limb_base_hp: [20, 40, 30, 30, 30, 30],
        hit_region_head_end: 0.24,
        hit_region_torso_end: 0.68,
        hit_region_head_head_weight: 1,
        hit_region_torso_chest_weight: 0.60,
        hit_region_torso_left_arm_weight: 0.20,
        hit_region_torso_right_arm_weight: 0.20,
        hit_region_legs_left_leg_weight: 0.50,
        hit_region_legs_right_leg_weight: 0.50,
        fracture_hp_ratio: 0.5,
        fracture_chance: 0.12,
        light_bleed_chance: 0.18,
        heavy_bleed_chance: 0.06,
        bleed_damage: 10,
        light_bleed_interval_seconds: 20,
        heavy_bleed_interval_seconds: 8,
        light_bleed_recovery_seconds: 60,
        wounded_penalty_strength: 0.35,
        fracture_penalty_strength: 0.65,
        blacked_penalty_strength: 1,
        arm_reload_penalty: 0.18,
        arm_recoil_penalty: 0.15,
        leg_move_penalty: 0.18,
        leg_dash_penalty: 0.24,
        core_stamina_penalty: 0.16,
        minimum_move_multiplier: 0.65,
        minimum_dash_multiplier: 0.55,
        minimum_reload_multiplier: 0.70,
        minimum_stamina_multiplier: 0.65,
        painkiller_duration_seconds: 60,
        painkiller_penalty_suppression: 1,
        blacked_repair_hp: 10,
        death_recovery_hp: 10,
        post_raid_recovery_seconds: 300
    };

    raid_player_max_hp = player_health_get_max_hp();
    raid_player_hp = raid_player_max_hp;
    health_painkiller_remaining = 0;
    health_limbs = [];

    var _names = ["HEAD", "CHEST", "LEFT ARM", "RIGHT ARM", "LEFT LEG", "RIGHT LEG"];
    for (var i = 0; i < array_length(_names); i++)
    {
        var _maximum = player_health_get_limb_max_hp(i);
        array_push(health_limbs, {
            name: _names[i],
            hp: _maximum,
            max_hp: _maximum,
            injury: LimbInjuryState.HEALTHY,
            fractured: false,
            bleed: LimbBleedState.NONE,
            bleeds: []
        });
    }
}
