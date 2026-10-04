function raid_spawn_enemy(_type, _x, _y)
{
    var enemy = {
        enemy_type: _type,

        enemy_x: _x,
        enemy_y: _y,

        enemy_hp: 30,
        enemy_max_hp: 30,
        enemy_hit_flash_timer: 0,

        enemy_speed: 1.0,
        enemy_radius: 18,

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
		
		enemy_sprite: -1,
		enemy_frame: 0,
		enemy_image_speed: 0.15,
		enemy_facing: 1,
		enemy_scale: 0.75,
		
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
		enemy_hand2_y: 1
    };


    // ======================================================
    // ENEMY TYPE SETTINGS
    // ======================================================

    switch (_type)
    {
     case RaidEnemyType.BURST_SHOOTER:
		{
		    enemy.enemy_sprite_idle = spr_burst_shooter_idle;
			enemy.enemy_sprite_active = spr_burst_shooter_run;

		    enemy.enemy_has_gun = true;
		    enemy.enemy_gun_sprite = spr_1911;

		    enemy.enemy_gun_offset = 16;

		    enemy.enemy_muzzle_x = 14;
		    enemy.enemy_muzzle_y = 6;

		    enemy.enemy_hp = 20;
		    enemy.enemy_speed = 1.4;
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
		    enemy.enemy_sprite_idle = spr_burst_shooter_idle;
			enemy.enemy_sprite_active = spr_burst_shooter_run;

		    enemy.enemy_has_gun = true;
		    enemy.enemy_gun_sprite = spr_1911;

		    enemy.enemy_gun_offset = 16;

		    enemy.enemy_muzzle_x = 14;
		    enemy.enemy_muzzle_y = 6;

		    enemy.enemy_hp = 24;
		    enemy.enemy_speed = 1.0;
		}
		break;


        case RaidEnemyType.KNIFE_DASHER:
        {
            enemy.enemy_hp = 32;
            enemy.enemy_max_hp = 32;

            enemy.enemy_speed = 0.75;
            enemy.dash_speed = 3.5;

            enemy.enemy_state =
                RaidEnemyState.PAUSE;

            enemy.state_timer = 90;
        }
        break;


        case RaidEnemyType.WALL_RUSHER:
        {
            enemy.enemy_hp = 28;
            enemy.enemy_max_hp = 28;

            enemy.enemy_speed = 0.75;
            enemy.dash_speed = 4.0;

            enemy.enemy_state =
                RaidEnemyState.PAUSE;

            enemy.state_timer = 90;
        }
        break;
    }


    // ======================================================
    // ROOM-BASED HP SCALING
    // ======================================================

    var _hp_mult =
        raid_get_enemy_hp_multiplier();

    enemy.enemy_hp =
        round(
            enemy.enemy_hp
            * _hp_mult
        );

    enemy.enemy_max_hp =
        enemy.enemy_hp;


    // ======================================================
    // ADD ENEMY
    // ======================================================

    array_push(
        raid_enemies,
        enemy
    );
}
