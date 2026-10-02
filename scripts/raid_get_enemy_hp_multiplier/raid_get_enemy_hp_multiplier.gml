function raid_get_enemy_hp_multiplier()
{
    var _room = raid.rooms_cleared + 1;

    return 1 + ((_room - 1) * 0.025);
}