function raid_boss_intro_update()
{
    var _boss_index = -1;

    for (var i = 0; i < array_length(raid_enemies); i++)
    {
        if (
            raid_enemies[i].enemy_boss
            && variable_struct_exists(raid_enemies[i], "boss_intro_active")
            && raid_enemies[i].boss_intro_active
        )
        {
            _boss_index = i;
            break;
        }
    }

    if (_boss_index < 0) return false;

    var e = raid_enemies[_boss_index];
    var _line_1 = e.enemy_type == RaidEnemyType.BONES
        ? "How did you get past all my guys?"
        : "Hey man! Who do u tink u are messin' with Rob Gnarley's rasta operation";
    var _line_2 = e.enemy_type == RaidEnemyType.BONES
        ? "You sure as hell ain't getting past me."
        : "I'm gonna smoke ya like I smoke da herb mon. With me minigun!";

    switch (e.boss_intro_stage)
    {
        case 0:
            if (e.boss_intro_timer > 0)
            {
                e.boss_intro_timer = max(0, e.boss_intro_timer - frame_scale);
                break;
            }

            e.enemy_y = min(e.boss_intro_target_y, e.enemy_y + 6 * frame_scale);

            if (e.enemy_y >= e.boss_intro_target_y)
            {
                e.enemy_y = e.boss_intro_target_y;
                e.boss_intro_stage = 1;
                e.boss_intro_timer = 24;
                smoke_create(e.enemy_x - 45, e.enemy_y - 8, e.enemy_x + 45, e.enemy_y + 8, 24);
                audio_play_sound(smoke_sound, 0, false);
                raid_camera_shake_duration = 24;
                raid_camera_shake_timer = raid_camera_shake_duration;
                raid_camera_shake_strength = 8;
            }
        break;

        case 1:
            e.boss_intro_timer -= frame_scale;
            if (e.boss_intro_timer <= 0)
            {
                e.boss_intro_stage = 2;
                e.boss_intro_character_count = 0;
            }
        break;

        case 2:
            e.boss_intro_character_count = min(string_length(_line_1), e.boss_intro_character_count + 0.5 * frame_scale);
            e.boss_intro_dialogue = string_copy(_line_1, 1, floor(e.boss_intro_character_count));
            if (e.boss_intro_character_count >= string_length(_line_1))
            {
                e.boss_intro_stage = 3;
                e.boss_intro_timer = 75;
            }
        break;

        case 3:
            e.boss_intro_timer -= frame_scale;
            if (e.boss_intro_timer <= 0)
            {
                e.boss_intro_stage = 4;
                e.boss_intro_character_count = 0;
                e.boss_intro_dialogue = "";
            }
        break;

        case 4:
            e.boss_intro_character_count = min(string_length(_line_2), e.boss_intro_character_count + 0.5 * frame_scale);
            e.boss_intro_dialogue = string_copy(_line_2, 1, floor(e.boss_intro_character_count));
            if (e.boss_intro_character_count >= string_length(_line_2))
            {
                e.boss_intro_stage = 5;
                e.boss_intro_timer = 90;
            }
        break;

        case 5:
            e.boss_intro_timer -= frame_scale;
            if (e.boss_intro_timer <= 0)
            {
                e.boss_intro_active = false;
                e.boss_intro_dialogue = "";
                e.enemy_invulnerable = false;
            }
        break;
    }

    raid_enemies[_boss_index] = e;
    return e.boss_intro_active;
}
