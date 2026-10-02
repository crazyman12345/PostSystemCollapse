function raid_enter_normal_room(_reward_type)
{
    raid.current_room_type = RaidRoomType.NORMAL;
    raid.current_reward_type = _reward_type;

    raid.room_cleared = false;
    raid.reward_unlocked = false;
    raid.doors_active = false;

    raid_enemies = [];
    raid_bullets = [];
    raid_doors = [];
	raid_enemy_bullets = [];
    raid_player_x = (raid_room_x1 + raid_room_x2) * 0.5;
    raid_player_y = raid_room_y2 - 50;

    raid_spawn_enemies();
}