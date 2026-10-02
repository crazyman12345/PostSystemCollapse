function skill_xp_for_level(_level)
{
    if (_level <= 1) return 0;

    var total = 0;

    for (var lvl = 1; lvl < _level; lvl++)
    {
        total += floor(lvl + 300 * power(2, lvl / 7));
    }

    return floor(total / 4);
}