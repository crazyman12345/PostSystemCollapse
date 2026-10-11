function raid_spawn_enemy(_type, _x, _y)
{
    var enemy = {
        enemy_type: _type,
		enemy_boss: false,

        enemy_x: _x,
        enemy_y: _y,

        enemy_hp: 30,
        enemy_max_hp: 30,
        enemy_hit_flash_timer: 0,
        enemy_invulnerable: false,
        enemy_tint: c_white,

        enemy_speed: 1.0,
        lead_strength: 0,

        enemy_state: RaidEnemyState.MOVE,
        state_timer: 0,

        target_x: _x,
        target_y: _y,

        // BURST SHOOTER
        shots_fired: 0,
        shot_timer: 0,

        // SPINNER
        spin_dir: 0,
        spin_shots: 0,

        // DASHERS
        dash_dir: 0,
        dash_speed: 0,
		
		enemy_sprite: spr_knife_stalker_run,
		enemy_frame: 0,
		enemy_image_speed: 0.15,
		enemy_animation_base_speed: 0.15,
		enemy_animation_reference_speed: 1.0,
		enemy_facing: 1,
		enemy_scale: 0.75,
		size_multiplier: 1,
		
		enemy_gun_sprite: -1,
		enemy_gun_offset: 16,
		enemy_gun_x: 0,
		enemy_gun_y: -10,

		enemy_muzzle_x: 10,
		enemy_muzzle_y: 2,

		enemy_gun_angle: 0,
		enemy_gun_recoil: 0,
		enemy_gun_recoil_return: 0.7,

		enemy_has_gun: false,
		enemy_hand_sprite: spr_hand,

		enemy_hand1_x: 2,
		enemy_hand1_y: 1,

		enemy_has_second_hand: false,

		enemy_hand2_x: 8,
		enemy_hand2_y: 1,
        weapon: -1
    };


    // ======================================================
    // ENEMY TYPE SETTINGS
    // ======================================================

    switch (_type)
    {
        case RaidEnemyType.BURST_SHOOTER:
		{
		    enemy.enemy_sprite = spr_burst_shooter_run;
		    enemy.enemy_sprite_idle = spr_burst_shooter_idle;
			enemy.enemy_sprite_active = spr_burst_shooter_run;

		    enemy.enemy_has_gun = true;
		    enemy.weapon = global.items.m1911;

		    enemy.enemy_gun_offset = 16;

		    enemy.enemy_muzzle_x = 14;
		    enemy.enemy_muzzle_y = 6;

		    enemy.enemy_hp = 20;
		    enemy.enemy_speed = 1.4;
		    enemy.lead_strength = 0.5;
		    enemy.shot_timer = randomize_enemy_timer(12, 0.25);
		}
		break;


        case RaidEnemyType.KNIFE_STALKER:
        {
            enemy.enemy_hp = 30;
            enemy.enemy_max_hp = 30;

            enemy.enemy_speed = 0.75;
			enemy.enemy_sprite = spr_knife_stalker_run;
			enemy.enemy_scale = 0.75;
        }
        break;


		   case RaidEnemyType.SPINNER:
		{
		    enemy.enemy_sprite = spr_spinner_run;
		    enemy.enemy_sprite_idle = spr_spinner_idle;
			enemy.enemy_sprite_active = spr_spinner_run;

		    enemy.enemy_has_gun = true;
		    enemy.weapon = global.items.uzi;

		    enemy.enemy_gun_offset = 16;

		    enemy.enemy_muzzle_x = 14;
		    enemy.enemy_muzzle_y = 6;

		    enemy.enemy_hp = 24;
		    enemy.enemy_speed = 1.0;
		    enemy.shot_timer = randomize_enemy_timer(4, 0.25);
		}
		break;


        case RaidEnemyType.KNIFE_DASHER:
        {
            enemy.enemy_sprite = spr_dasher_idle;
            enemy.enemy_sprite_idle = spr_dasher_idle;
            enemy.enemy_sprite_active = spr_dasher_run;
            enemy.enemy_hp = 32;
            enemy.enemy_max_hp = 32;

            enemy.enemy_speed = 0.75;
            enemy.dash_speed = 3.5;

            enemy.enemy_state =
                RaidEnemyState.PAUSE;

            enemy.state_timer = randomize_enemy_timer(90, 0.25);
        }
        break;


		case RaidEnemyType.WALL_RUSHER:
        {
            enemy.enemy_sprite = spr_wallrusher_idle_4;
            enemy.enemy_sprite_idle = spr_wallrusher_idle_4;
            enemy.enemy_sprite_active = spr_wallrusher_run_4;
            enemy.enemy_hp = 28;
            enemy.enemy_max_hp = 28;
			enemy.enemy_scale = 1.25;
            enemy.enemy_speed = 0.75;
            enemy.dash_speed = 4.0;

            enemy.enemy_state =
                RaidEnemyState.PAUSE;

            enemy.state_timer = randomize_enemy_timer(90, 0.25);
        }
        break;


        case RaidEnemyType.BONES:
        {
            enemy.enemy_boss = true;
            enemy.enemy_sprite_idle = spr_bones_idle2;
            enemy.enemy_sprite_active = spr_bones_run2;
            enemy.enemy_sprite = spr_bones_idle2;
            enemy.enemy_scale = 0.48;
            enemy.size_multiplier = 1.7;
            enemy.enemy_has_gun = true;
            enemy.weapon = global.items.uzi;
            enemy.enemy_gun_offset = 18;
            enemy.enemy_muzzle_x = 14;
            enemy.enemy_muzzle_y = 6;
            enemy.enemy_hp = 300;
            enemy.enemy_max_hp = 300;
            enemy.enemy_speed = 0;
            enemy.lead_strength = 0.9;
            enemy.boss_phase = 1;
            enemy.boss_attack = BossAttackType.BONES_ATTACK_SHOOT_DASH_SHOOT;
            enemy.boss_last_attack = -1;
            enemy.boss_attack_state = BossAttackState.SELECT;
            enemy.boss_attack_timer = 0;
            enemy.boss_shots_fired = 0;
            enemy.boss_attack_repeat_count = 0;
            enemy.boss_transition_stage = 0;
            enemy.boss_transition_timer = 0;
            enemy.boss_transition_dialogue = "";
            enemy.boss_transition_transformed = false;
            enemy.boss_pacing_phase1 = {
                dash_speed: 3.5,
                dash_duration: 26,
                attack_windup: 45,
                burst_shot_interval: 12,
                pre_dash_windup: 30,
                post_dash_windup: 24,
                attack_recovery: 60,
                walkdown_speed: 0.7,
                walkdown_windup: 45,
                walkdown_shot_interval: 40,
                shockwave_move_speed: 2.5,
                shockwave_windup: 84
            };
            enemy.boss_pacing_phase2 = {
                dash_speed: 5.46,
                dash_duration: 17,
                attack_windup: 29,
                burst_shot_interval: 8,
                pre_dash_windup: 19,
                post_dash_windup: 15,
                attack_recovery: 38,
                walkdown_speed: 1.09,
                walkdown_windup: 29,
                walkdown_shot_interval: 26,
                shockwave_move_speed: 3.9,
                shockwave_windup: 54
            };
            enemy.boss_dash_speed = enemy.boss_pacing_phase1.dash_speed;
            enemy.boss_shockwave_timer = 0;
            enemy.enemy_animation_reference_speed = enemy.boss_dash_speed;
            enemy.enemy_state = RaidEnemyState.BOSS_ATTACK;
        }
        break;
    }

	if (_type != RaidEnemyType.BONES)
	    enemy.enemy_animation_reference_speed = max(0.001, enemy.enemy_speed);


    // ======================================================
    // ROOM-BASED HP SCALING
    // ======================================================

	
	if enemy.enemy_boss != true{
		
    var _hp_mult =
        raid_get_enemy_hp_multiplier();
		
	    enemy.enemy_hp =
	        round(
	            enemy.enemy_hp
	            * _hp_mult
	        );

	    enemy.enemy_max_hp =
	        enemy.enemy_hp;
	}

    // ======================================================
    // ADD ENEMY
    // ======================================================

    array_push(
        raid_enemies,
        enemy
    );
}

function raid_enemy_get_collision_bbox_at(_enemy, _x, _y)
{
    var _sprite = _enemy.enemy_sprite;
    var _bbox_height = sprite_get_bbox_bottom(_sprite) - sprite_get_bbox_top(_sprite) + 1;
    var _scale = 0.75 * (40 / _bbox_height) * _enemy.size_multiplier;
    var _x_origin = sprite_get_xoffset(_sprite);
    var _y_origin = sprite_get_yoffset(_sprite);
    var _left_offset;
    var _right_offset;

    if (_enemy.enemy_facing < 0)
    {
        _left_offset = (_x_origin - sprite_get_bbox_right(_sprite)) * _scale;
        _right_offset = (_x_origin - sprite_get_bbox_left(_sprite)) * _scale;
    }
    else
    {
        _left_offset = (sprite_get_bbox_left(_sprite) - _x_origin) * _scale;
        _right_offset = (sprite_get_bbox_right(_sprite) - _x_origin) * _scale;
    }

    return {
        left: _x + _left_offset,
        right: _x + _right_offset,
        top: _y + (sprite_get_bbox_top(_sprite) - _y_origin) * _scale,
        bottom: _y + (sprite_get_bbox_bottom(_sprite) - _y_origin) * _scale
    };
}

function raid_enemy_get_collision_bbox(_enemy)
{
    return raid_enemy_get_collision_bbox_at(_enemy, _enemy.enemy_x, _enemy.enemy_y);
}
