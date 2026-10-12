function skill_xp_for_level(_level)
{
    if (_level <= 1) return 0;

    var total = 0;

    for (var lvl = 1; lvl < _level; lvl++)
    {
        total += floor(lvl + 300 * power(2, lvl / 10));
    }

    return floor(total / 6.4);
}

function skill_get_level_from_xp(_xp)
{
    var level = 1;

    while (_xp >= skill_xp_for_level(level + 1))
    {
        level++;
    }

    return level;
}
