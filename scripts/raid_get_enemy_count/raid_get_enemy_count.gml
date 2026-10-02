function raid_get_enemy_count()
{
    var _room = raid.rooms_cleared + 1;

    if (_room <= 5)
        return 3;

    if (_room <= 10)
        return irandom_range(3, 4);

    if (_room <= 15)
        return 4;

    return irandom_range(4, 5);
}