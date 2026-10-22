function raid_combat_loss()
{
    var member = crew[raid.crew_index];

    // ==========================================
    // CRITICALLY INJURE CREW MEMBER
    // ==========================================

    member.status =
        CrewStatus.CRITICALLY_INJURED;

    member.injury_end_time =
        current_time
        + (5 * 60 * 1000);

    member.weapon = "";
    member.weapon_2 = "";
    member.armor_head = "";
    member.armor_chest = "";
    member.bag = "";
    crew[raid.crew_index] = member;


    // ==========================================
    // LOSE RAID LOOT
    // ==========================================

    // A held secure-container item is still protected. Items held from the
    // backpack or a loot container are lost with the raid instead of being
    // left detached from every container.
    if (!is_undefined(raid.inventory_item)
    && raid.inventory_container == stash.secure_container)
    {
        array_push(stash.secure_container.items, raid.inventory_item);
    }

    stash.backpack.items = [];
    stash.backpack.grid_width = 0;
    stash.backpack.grid_height = 0;
    stash.pockets.items = [];
    stash.equipped_bag_item = undefined;
    stash.equipped_weapon_item = undefined;
    stash.equipped_weapon_2_item = undefined;
    stash.equipped_armor_head_item = undefined;
    stash.equipped_armor_chest_item = undefined;
    raid.inventory_item = undefined;
    raid.inventory_container = undefined;
    raid.inventory_rotation = 0;
    raid.active_loot_container = undefined;
    raid_lootables = [];
    raid.last_loot = [];
    raid.loot_index = 0;


    // ==========================================
    // STOP RAID
    // ==========================================

    blood_surface_destroy();
    raid_reset_active_weapon();

    raid.pending_action =
        undefined;

    raid.extract_active =
        false;

    raid.doors_active =
        false;
    raid_enemies = [];
    raid_bullets = [];
    raid_enemy_bullets = [];
    raid_ring_hazards = [];
    raid_enemy_death_effects = [];
    raid_doors = [];
    raid_temporary_lights = [];
    raid_muzzle_flash_light = undefined;


    // ==========================================
    // RESULT SCREEN
    // ==========================================

    raid.result_title =
        "YOU FUCKING SUCK!";

    raid.result_message =
        member.name
        + " was critically injured.\n"
        + "Backpack, pockets, and equipment lost. Secure contents kept.";

    player_health_prepare_death_result();
    onboarding_handle_raid_failure();
    raid_set_state(RaidState.RESULT);
    save_unfinished_raid = false;
    save_mark_dirty();
    save_game();
}

function raid_player_death_start()
{
    raid_set_state(RaidState.DEATH);
}

function step_raid_player_death()
{
    if (raid_player_death_phase == 0)
    {
        raid_player_death_phase = 1;
        raid_player_death_timer = 0;
    }

    var _target_width = raid_player_death_camera_width / 1.95;
    var _target_height = raid_player_death_camera_height / 1.95;
    var _zoom_amount = 1 - power(0.96, frame_scale);
    var _camera_width = lerp(camera_get_view_width(raid_camera), _target_width, _zoom_amount);
    var _camera_height = lerp(camera_get_view_height(raid_camera), _target_height, _zoom_amount);

    camera_set_view_size(raid_camera, _camera_width, _camera_height);
    camera_set_view_pos(
        raid_camera,
        round(raid_player_death_x - (_camera_width * 0.5)),
        round(raid_player_death_y - (_camera_height * 0.5))
    );

    if (raid_player_death_phase == 1)
    {
        raid_player_death_timer += frame_scale;

        if (raid_player_death_timer >= 72)
        {
            raid_player_death_phase = 2;
            raid_player_death_timer = 0;

            if (!raid_player_death_chunks_created)
            {
                raid_player_death_chunks_created = true;
                blood_death_effect(raid_player_death_x, raid_player_death_y, random(360));
                raid_create_enemy_death_effect({
                    enemy_sprite: raid_player_death_sprite,
                    enemy_frame: raid_player_death_frame,
                    enemy_x: raid_player_death_x,
                    enemy_y: raid_player_death_y,
                    enemy_facing: raid_player_death_facing,
                    enemy_boss: false,
                    size_multiplier: 1,
                    enemy_last_hit_direction: undefined,
                    death_effect_scale: raid_player_death_scale,
                    death_effect_columns: 5,
                    death_effect_rows: 6,
                    death_effect_radial_360: true,
                    death_effect_speed_min: 2.6,
                    death_effect_speed_max: 5.2,
                    death_effect_blood_chance: 0.65,
                    death_effect_lifetime: 300,
                    death_effect_fade_time: 120,
                    death_effect_shrink_factor: 0.997
                });
            }
        }
    }
    else
    {
        step_raid_enemy_death_effects();
        raid_player_death_timer += frame_scale;

        if (raid_player_death_phase == 2 && raid_player_death_timer >= 36)
        {
            raid_player_death_phase = 3;
            raid_player_death_timer = 0;
        }

        if (raid_player_death_phase == 3 && keyboard_check_pressed(vk_enter))
        {
            camera_set_view_size(raid_camera, raid_player_death_camera_width, raid_player_death_camera_height);
            step_raid_camera();
            raid_combat_loss();
        }
    }
}
